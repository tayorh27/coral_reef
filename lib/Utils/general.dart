import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../size_config.dart';
import 'colors.dart';

class GeneralUtils {

  // String userCurrentTimeZone;

  GeneralUtils() {
    // currentTimeZone();
  }

  isNumberFormatted(String value) {
    // List<String> startValues = "0,1,2,3,4,5,6,7,8,9".split(",");
    if(value.startsWith(".")) {
      return false;
    }
    double val = double.tryParse(value);
    if(val == null) {
      return false;
    }
    if(val <= 0){
      return false;
    }
    return true;
  }

  // String formattedMoney(double price, String currency) {
  //   MoneyFormatterOutput mfo = FlutterMoneyFormatter(
  //           amount: price,
  //           settings: MoneyFormatterSettings(
  //               symbol: currency,
  //               thousandSeparator: ',',
  //               decimalSeparator: '.',
  //               symbolAndNumberSeparator: '',
  //               fractionDigits: 2,
  //               compactFormatType: CompactFormatType.short))
  //       .output;
  //   return mfo.symbolOnLeft;
  // }

  Future<Null> displayAlertDialog(
      BuildContext context, String _title, String _body) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(_title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Color(MyColors.titleTextColor),
              fontSize: getProportionateScreenWidth(20),),),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                Container(
                  height: getProportionateScreenHeight(50),
                  width: getProportionateScreenWidth(50),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F6F9),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset('assets/images/logo2.png'),
                ),
                Padding(
                    padding: const EdgeInsets.only(left:30.0, right: 30.0, top: 30.0),
                    child: new Text(
                      _body,textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Color(MyColors.titleTextColor),
                          fontSize: getProportionateScreenWidth(15),),
                    )),
              ],
            ),
          ),
          actions: <Widget>[
            new TextButton(
              child: new Text('OK', style: TextStyle(color: Color(MyColors.primaryColor)),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> displayReturnedValueAlertDialog(
      BuildContext context, String _title, String _body, {String confirmText = "OK"}) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(_title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText1.copyWith(
            color: Color(MyColors.titleTextColor),
            fontSize: getProportionateScreenWidth(20),),),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                Container(
                  height: getProportionateScreenHeight(50),
                  width: getProportionateScreenWidth(50),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F6F9),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset('assets/images/logo2.png'),
                ),
                Padding(
                    padding: const EdgeInsets.only(left:30.0, right: 30.0, top: 30.0),
                    child: new Text(
                      _body,textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Color(MyColors.titleTextColor),
                        fontSize: getProportionateScreenWidth(15),),
                    )),
              ],
            ),
          ),
          actions: <Widget>[
            new TextButton(
              child: new Text('CANCEL', style: TextStyle(color: Colors.redAccent),),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            new TextButton(
              child: new Text(confirmText, style: TextStyle(color: Color(MyColors.primaryColor)),),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  void showToast(BuildContext context, String msg) {
    Fluttertoast.showToast(
        msg: "$msg",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: Color(MyColors.primaryColor),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  getCurrentDateTime() {
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    DateTime date = DateTime.now();
    return "${rewriteTimeValue(date.day)} ${months[date.month - 1]} ${date.year}, ${rewriteTimeValue(date.hour)}:${rewriteTimeValue(date.minute)}";
  }

  rewriteTimeValue(int value) {
    return value < 10 ? "0$value" : "$value";
  }

  Future<void> saveNotification(String title, String message) async {
    List<String> months = ["January", "February", "March", "April", "May","June","July","August","September","October","November","December"];
    List<String> days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
    final date = DateTime.now();

    String id = FirebaseDatabase.instance.reference().push().key;
    await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("notifications").doc(id).set(
        {
          "id": id,
          "title": title,
          "message": message,
          "created_date": getCurrentDateTime(),
          "timestamp": FieldValue.serverTimestamp(),
          "header": "${days[date.weekday - 1]} - ${date.day} ${months[date.month - 1]}, ${date.year}"
        });
  }

  tz.TZDateTime convertFireBaseTimeToLocal(tz.TZDateTime tzDateTime, String locationLocal) {
    tz.TZDateTime nowLocal = new tz.TZDateTime.now(tz.getLocation(locationLocal));
    int difference = nowLocal.timeZoneOffset.inHours;
    // print(difference);
    tz.TZDateTime newTzDateTime;
    newTzDateTime = tzDateTime.add(Duration(hours: difference));
    return newTzDateTime;
  }

  int getFireBaseTimeToLocalHours(tz.TZDateTime tzDateTime, String locationLocal) {
    tz.TZDateTime nowLocal = new tz.TZDateTime.now(tz.getLocation(locationLocal));
    int difference = nowLocal.timeZoneOffset.inHours;
    return difference;
  }

  Future<String> currentTimeZone() async {
    final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    // userCurrentTimeZone = currentTimeZone;
    return currentTimeZone;
  }

  Future<void> sendAndRetrieveMessage(String _body, String _title, List<dynamic> _ids) async {

    // _ids.forEach((id) async {
    //   http.Response r = await http.post(
    //     'https://fcm.googleapis.com/fcm/send',
    //     headers: <String, String>{
    //       'Content-Type': 'application/json',
    //       'Authorization': 'key=$serverToken',
    //     },
    //     body: jsonEncode(
    //       <String, dynamic>{
    //         'notification': <String, dynamic>{
    //           'body': _body,
    //           'title': _title
    //         },
    //         'priority': 'high',
    //         // 'data': <String, dynamic>{
    //         //   'click_action': 'FLUTTER_NOTIFICATION_CLICK',
    //         //   'id': '1',
    //         //   'status': 'done'
    //         // },
    //         'to': id,
    //       },
    //     ),
    //   );
    //   print(r.body);
    // });

    http.Response r = await http.post(
      Uri.parse('https://us-central1-coraltrackerapp.cloudfunctions.net/sendnt?title=$_title&message=$_body'),
      body: jsonEncode(
        <String, dynamic>{
          'id': _ids,
        },
      ),
    );
    print(r.body);
  }

  Future<void> sendNotificationToTopic(String _body, String _title, String topic) async {
    http.Response r = await http.get(
        Uri.parse('https://us-central1-coraltrackerapp.cloudfunctions.net/sendtopic?topic=$topic&title=$_title&message=$_body'),
    );
    print(r.body);
  }

  Future<void> subscribeToTopic(String _topic, List<dynamic> _ids) async {

    await FirebaseMessaging.instance.subscribeToTopic(_topic);
    // http.Response r = await http.post(
    //     Uri.parse('https://us-central1-coraltrackerapp.cloudfunctions.net/subtopic?topic=$_topic'),
    //   body: jsonEncode(
    //     <String, dynamic>{
    //       'id': _ids,
    //     },
    //   ),
    // );
    // print(r.body);
  }

  String returnFormattedDate(String createdDate, String timeZone, {bool returnAgo = true}) {

    if(timeZone == null) {
      return returnFormattedDateWithoutTimeZone(createdDate);
    }
    if(timeZone == "") {
      return returnFormattedDateWithoutTimeZone(createdDate);
    }
    if(timeZone == "null") {
      return returnFormattedDateWithoutTimeZone(createdDate);
    }

    if(timeZone == userCurrentTimeZone.last) {
      if(returnAgo) {
        return returnFormattedDateWithoutTimeZone(createdDate);
      }
    }

    // print(userCurrentTimeZone.last);

    tz.initializeTimeZones();
    DateTime myDT = DateTime.parse(createdDate);

    tz.TZDateTime cDT = new tz.TZDateTime(tz.getLocation(timeZone), myDT.year, myDT.month, myDT.day, myDT.hour, myDT.minute, myDT.second, myDT.millisecond, myDT.microsecond);
    // print("cdt = ${cDT.toString()}");
    tz.TZDateTime newDT = convertFireBaseTimeToLocal(cDT, userCurrentTimeZone.last); //"Asia/Singapore"
    // print(newDT.toString());
    int diff = getFireBaseTimeToLocalHours(cDT, userCurrentTimeZone.last);
    tz.TZDateTime newDT2;
    if(diff < 0) {
      newDT2 = newDT.add(Duration(hours: (diff * -1)));
    }else {
      newDT2 = newDT.subtract(Duration(hours: diff));
    }
    // print(newDT2.toString());

    if(!returnAgo) {
      return newDT.toString();
    }
    return returnFormattedDateWithoutTimeZone(newDT2.toString());
  }

  String returnFormattedDateWithoutTimeZone(String createdDate) {
    var secs = DateTime.now().difference(DateTime.parse(createdDate)).inSeconds;
    if (secs > 60) {
      var mins =
          DateTime.now().difference(DateTime.parse(createdDate)).inMinutes;
      if (mins > 60) {
        var hrs =
            DateTime.now().difference(DateTime.parse(createdDate)).inHours;
        if (hrs > 24) {
          var days =
              DateTime.now().difference(DateTime.parse(createdDate)).inDays;
          return (days > 1) ? '$days days ago' : '$days day ago';
        } else {
          return (hrs > 1) ? '$hrs hrs ago' : '$hrs hr ago';
        }
      } else {
        return '$mins mins ago';
      }
    } else {
      return '$secs secs ago';
    }
  }

  Future<bool> requestPermission(
      BuildContext context, String _title, String _body) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("Permission Request - $_title", textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText1.copyWith(
            color: Color(MyColors.titleTextColor),
            fontSize: getProportionateScreenWidth(20),),),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                Container(
                  height: getProportionateScreenHeight(50),
                  width: getProportionateScreenWidth(50),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F6F9),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset('assets/images/logo2.png'),
                ),
                Padding(
                    padding: const EdgeInsets.only(left:30.0, right: 30.0, top: 30.0),
                    child: new Text(
                      _body,textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Color(MyColors.titleTextColor),
                        fontSize: getProportionateScreenWidth(15),),
                    )),
              ],
            ),
          ),
          actions: <Widget>[
            new TextButton(
              child: new Text('DENY', style: TextStyle(color: Colors.redAccent),),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            new TextButton(
              child: new Text('ALLOW', style: TextStyle(color: Color(MyColors.primaryColor)),),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  showFlutterLocalNotification(String title, String body) {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        platformChannelSpecifics
    );
  }
}
