import 'dart:async';
import 'dart:convert';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/Utils/constants.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/onboarding/sign_in/sign_in_screen.dart';
import 'package:coral_reef/services/step_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:coral_reef/routes.dart';
import 'package:coral_reef/onboarding/splash/splash_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:neat_periodic_task/neat_periodic_task.dart';
import 'package:rxdart/rxdart.dart';

import 'ListItem/model_challenge.dart';
import 'Utils/colors.dart';
import 'Utils/daily_notification_sercives.dart';
import 'constants.dart';
import 'locator.dart';

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  if (message.data.isEmpty) {
    print("data is null");
    return;
  }
  flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      message.data["title"],
      message.data["body"],
      NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channel.description,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            // icon: message.notification.android?.smallIcon,
          ),
          iOS: IOSNotificationDetails(
              presentAlert: true, presentBadge: true, presentSound: true)));
  new GeneralUtils()
      .saveNotification(message.data["title"], message.data["body"]);
}

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  await Firebase.initializeApp();
  await AndroidAlarmManager.initialize();
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  // This widget is the root of your application.

  StorageSystem ss = new StorageSystem();

  DailyNotificationServices dailyNotificationServices;

  checkIfCurrentChallengeHasEnded() async {
    String check = await ss.getItem("vitaminsNotificationAllowed");
    if(check == null) {
      await ss.setPrefItem("vitaminsNotificationAllowed", "true");
      await ss.setPrefItem("waterNotificationAllowed", "true");
      await ss.setPrefItem("caloriesNotificationAllowed", "true");
      await ss.setPrefItem("stepsNotificationAllowed", "true");
      await ss.setPrefItem("pregnancyNotificationAllowed", "true");
      await ss.setPrefItem("periodNotificationAllowed", "true");
    }
    String currentCH = await ss.getItem("currentChallenge");
    if (currentCH == null) return;

    Map<String, dynamic> ch = jsonDecode(currentCH);

    VirtualChallenge vc = VirtualChallenge.fromSnapshot(ch);

    bool hasEnded = false;

    DateTime today = DateTime.now();
    DateTime end = DateTime.parse(vc.end_date);

    int diffEnd = today.difference(end).inMilliseconds;

    hasEnded = diffEnd < 0;

    if (hasEnded) {
      await ss.deletePref("currentChallenge");
      await ss.deletePref("running");
      await ss.deletePref("statusCH");
      await ss.deletePref("startPosition");
      await ss.deletePref("currentPosition");
      await ss.deletePref("startTime");
      await ss.deletePref("currentTime");
      await ss.deletePref("init_step_count");
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("setups")
          .doc("user-data")
          .update({
        "currentChallenge": FieldValue.delete(),
        "running": FieldValue.delete(),
        "statusCH": FieldValue.delete(),
        "startPosition": FieldValue.delete(),
        "currentPosition": FieldValue.delete(),
        "startTime": FieldValue.delete(),
        "currentTime": FieldValue.delete(),
        "init_step_count": FieldValue.delete(),
      });
    }
  }

  // setupSteps() {
  //   final scheduler = NeatPeriodicTaskScheduler(
  //       name: "coral-app-steps",
  //       interval: Duration(seconds: 10),
  //       timeout: Duration(seconds: 5),
  //       task: () async {
  //         String value = await ss.getItem("scheduler") ?? "0";
  //         int newV = int.parse(value) + 1;
  //         await ss.setPrefItem("scheduler", "$newV");
  //         print("new value = $value");
  //         return;
  //       },
  //       minCycle: Duration(seconds: 5)
  //   );
  //   scheduler.start();
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dailyNotificationServices =
        new DailyNotificationServices(flutterLocalNotificationsPlugin);
    // setupSteps();
    checkIfCurrentChallengeHasEnded();
    setupLocator().then((value) {
      final StepService stepService = locator<StepService>();
      stepService.initPlatformState();
    });

    var initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_coral_reef_cover");
    // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
    // of the `IOSFlutterLocalNotificationsPlugin` class
    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        await new GeneralUtils().saveNotification(title, body);
        displayDialog(title, body);
      },
    );
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // FirebaseMessaging.instance
    //     .getInitialMessage()
    //     .then((RemoteMessage message) {
    //   if (message != null) {
    //     Navigator.pushNamed(context, '/message',
    //         arguments: MessageArguments(message, true));
    //   }
    // });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // print("small icon = ${message.notification.android?.smallIcon}");
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        // if(message)
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: message.notification.android?.smallIcon,
              ),
            ));
        new GeneralUtils()
            .saveNotification(notification.title, notification.body);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // Navigator.pushNamed(context, '/message',
      //     arguments: MessageArguments(message, true));
    });

    // getToken();
  }

  getToken() {
    FirebaseMessaging.instance.getToken().then((token) {
      print(token);
    });
  }

  displayDialog(String title, String body) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              // await Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => SecondScreen(payload),
              //   ),
              // );
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics analytics = FirebaseAnalytics();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    //initialize notifications
    dailyNotificationServices.displayDailyCaloriesNotification();
    dailyNotificationServices.displayDailySleepNotification();
    dailyNotificationServices.displayDailyStepsNotification();
    dailyNotificationServices.displayDailyVitaminsNotification();
    dailyNotificationServices.displayWeeklyPregnancyNotification();
    dailyNotificationServices.displayDailyWaterNotification();
    dailyNotificationServices.displayDailyPeriodNotification();

    return MaterialApp(
      title: 'Coral Reef',
      theme: Constant.lightTheme,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: routes,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> _showDailyAtTime() async {
    var time = Time(0, 32, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        'This channel is used for important notifications.');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.periodicallyShow(1, 'Morning Refresh',
        'Hello World', RepeatInterval.everyMinute, platformChannelSpecifics);
    DateTime.now().timeZoneName;
    // await flutterLocalNotificationsPlugin.zonedSchedule(id, title, body, scheduledDate, notificationDetails, uiLocalNotificationDateInterpretation: uiLocalNotificationDateInterpretation, androidAllowWhileIdle: androidAllowWhileIdle).showDailyAtTime(
    //     0, 'Morning Refresh', 'Hello World', time, platformChannelSpecifics);
  }
}
