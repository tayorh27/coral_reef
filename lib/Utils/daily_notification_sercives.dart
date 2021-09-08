
import 'dart:convert';

import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/tracker_screens/pregnancy_tracker/services/pregnancy_services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class DailyNotificationServices {

  StorageSystem ss;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String username;
  String currentTimeZone;

  DailyNotificationServices(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
    ss = new StorageSystem();
    this.flutterLocalNotificationsPlugin = flutterLocalNotificationsPlugin;
    tz.initializeTimeZones();
    getUserDetails();
  }

  Future<void> getUserDetails() async {
    String user = await ss.getItem("user");
    dynamic json = jsonDecode(user);
    username = (json["firstname"] == "") ? json["lastname"] : json["firstname"];
    currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
  }

  Future<void> displayDailySleepNotification(bool value) async {
    String sleepNotificationAllowed = await ss.getItem("sleepNotificationAllowed") ?? "false";
    String isGeneralNotificationAllowed = await ss.getItem("generalNotificationAllowed") ?? "false";
    if(sleepNotificationAllowed == "false" || isGeneralNotificationAllowed == "false") return;

    String bedtime = "N/A", wakeup = "N/A", sleepingTime = "N/A";

    final date = DateTime.now();
    final months = ["JAN", "FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];

    String formatDate = "${date.year}_${months[date.month - 1]}_${date.day - 1}"; //get the previous record

    String current = await ss.getItem("sleepCurrent_$formatDate") ?? "";

    // final notificationDate = DateTime(date.year, date.month, date.day, 11, 0, 0);
    final notificationDate = new tz.TZDateTime(tz.getLocation(currentTimeZone), date.year, date.month, date.day, 11, 0, 0);


    if(current.isEmpty) {
      _showDailyAtTime(111, "Sleep Reminder", "Hope you slept well last night? Record your sleep time today.", notificationDate, "sleep");
      return;
    }

    List<String> list = current.split("/");

    bedtime = list[0];
    wakeup = list[1];
    sleepingTime = list[2];

    _showDailyAtTime(112, "Sleep Reminder", "Do not forget to record your sleep time for yesterday.", notificationDate, "sleep");

  }

  Future<void> displayDailyVitaminsNotification(bool value) async {
    String vitaminsNotificationAllowed = await ss.getItem("vitaminsNotificationAllowed") ?? "false";
    String isGeneralNotificationAllowed = await ss.getItem("generalNotificationAllowed") ?? "false";
    if(vitaminsNotificationAllowed == "false" || isGeneralNotificationAllowed == "false") return;

    final date = DateTime.now();
    final months = ["JAN", "FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];

    String formatDate = "${date.year}_${months[date.month - 1]}_${date.day}";

    String vitaminsGoal = await ss.getItem("vitaminGoal") ?? "0";
    String currentTakenVitamins = await ss.getItem("vitaminCurrent_$formatDate") ?? "0";

    if(vitaminsGoal == "0") return;

    // final notificationDate1 = DateTime(date.year, date.month, date.day, 9, 0, 0);
    final notificationDate1 = new tz.TZDateTime(tz.getLocation(currentTimeZone), date.year, date.month, date.day, 9, 0, 0);

    _showDailyAtTime(222, "My Vitamins", "Start your day in a healthy way. Remember to take your vitamins", notificationDate1, "vitamins");

    int percent = ((double.parse(currentTakenVitamins) / double.parse(vitaminsGoal)) * 100).ceil();

    String message = (percent < 100) ? "You have taken $percent% ($currentTakenVitamins/$vitaminsGoal) of your vitamins intake today. Remember to takes your vitamins and record it." : "What a great day for you $username. You completed your vitamins today. Let's do this again tomorrow.";

    // final notificationDate = DateTime(date.year, date.month, date.day, 15, 0, 0);
    final notificationDate = new tz.TZDateTime(tz.getLocation(currentTimeZone), date.year, date.month, date.day, 15, 0, 0);

    _showDailyAtTime(223, "Vitamins Intake", message, notificationDate, "vitamins");
  }

  Future<void> displayDailyWaterNotification(bool value) async {
    String waterNotificationAllowed = await ss.getItem("waterNotificationAllowed") ?? "false";
    String isGeneralNotificationAllowed = await ss.getItem("generalNotificationAllowed") ?? "false";
    if(waterNotificationAllowed == "false" || isGeneralNotificationAllowed == "false") return;

    final date = DateTime.now();
    final months = ["JAN", "FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];

    String formatDate = "${date.year}_${months[date.month - 1]}_${date.day}";

    String waterGoal = await ss.getItem("waterGoal") ?? "0";
    String currentTakenWater = await ss.getItem("waterCurrent_$formatDate") ?? "0";

    if(waterGoal == "0") return;

    // final notificationDate1 = DateTime(date.year, date.month, date.day, 6, 0, 0);
    final notificationDate1 = new tz.TZDateTime(tz.getLocation(currentTimeZone), date.year, date.month, date.day, 6, 0, 0);

    _showDailyAtTime(333, "Morning Glass of Water", "Remember to drink a glass of water this morning. Stay hydrated.", notificationDate1, "water");

    int percent = ((double.parse(currentTakenWater) / double.parse(waterGoal)) * 100).ceil();

    String message = (percent < 100) ? "You have taken $percent% ($currentTakenWater/$waterGoal) of the total glasses of water you recorded as your goal." : "Congratulations, you completed 100% of your water intake today. Water is life.";

    // final notificationDate = DateTime(date.year, date.month, date.day, 14, 0, 0);
    final notificationDate = new tz.TZDateTime(tz.getLocation(currentTimeZone), date.year, date.month, date.day, 14, 0, 0);

    _showDailyAtTime(334, "Staying Hydrated", message, notificationDate, "water");
  }

  Future<void> displayDailyCaloriesNotification(bool value) async {
    String caloriesNotificationAllowed = await ss.getItem("caloriesNotificationAllowed") ?? "false";
    String isGeneralNotificationAllowed = await ss.getItem("generalNotificationAllowed") ?? "false";
    if(caloriesNotificationAllowed == "false" || isGeneralNotificationAllowed == "false") return;

    final date = DateTime.now();
    final months = ["JAN", "FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];

    String formatDate = "${date.year}_${months[date.month - 1]}_${date.day}";

    String caloriesGoal = await ss.getItem("caloriesGoal") ?? "0";
    String currentTakenCalories = await ss.getItem("caloriesCurrent_$formatDate") ?? "0";

    if(caloriesGoal == "0") return;

    // final notificationDate1 = DateTime(date.year, date.month, date.day, 9, 0, 0);
    final notificationDate1 = new tz.TZDateTime(tz.getLocation(currentTimeZone), date.year, date.month, date.day, 9, 0, 0);

    _showDailyAtTime(444, "Build Those Calories", "Good morning $username, what meal are you having this morning to build your calories?.", notificationDate1, "calories");

    int percent = ((double.parse(currentTakenCalories) / double.parse(caloriesGoal)) * 100).ceil();

    String message = (percent < 100) ? "You have completed $percent% ($currentTakenCalories/$caloriesGoal) of your daily calories goal." : "Reaching your daily goal is our priority. Congratulations $username.";

    // final notificationDate = DateTime(date.year, date.month, date.day, 17, 0, 0);
    final notificationDate = new tz.TZDateTime(tz.getLocation(currentTimeZone), date.year, date.month, date.day, 17, 0, 0);

    _showDailyAtTime(445, "Calories Intake", message, notificationDate, "calories");
  }

  Future<void> displayDailyStepsNotification(bool value) async {
    String stepsNotificationAllowed = await ss.getItem("stepsNotificationAllowed") ?? "false";
    String isGeneralNotificationAllowed = await ss.getItem("generalNotificationAllowed") ?? "false";
    if(stepsNotificationAllowed == "false" || isGeneralNotificationAllowed == "false") return;

    final date = DateTime.now();
    final months = ["JAN", "FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];

    String formatDate = "${date.year}_${months[date.month - 1]}_${date.day}";

    String stepsGoal = await ss.getItem("stepsGoal") ?? "0";
    String currentTakenSteps = await ss.getItem("stepsCurrent_$formatDate") ?? "0";

    if(stepsGoal == "0") return;

    int percent = ((double.parse(currentTakenSteps) / double.parse(stepsGoal)) * 100).ceil();

    String message = (percent < 100) ? "Increase your step count today!" : "Congratulations, you have reach 100% of your daily steps.";

    // final notificationDate1 = DateTime(date.year, date.month, date.day, 10, 0, 0);
    final notificationDate1 = new tz.TZDateTime(tz.getLocation(currentTimeZone), date.year, date.month, date.day, 10, 0, 0);
    final notificationDate2 = new tz.TZDateTime(tz.getLocation(currentTimeZone), date.year, date.month, date.day, 12, 0, 0);
    final notificationDate3 = new tz.TZDateTime(tz.getLocation(currentTimeZone), date.year, date.month, date.day, 18, 0, 0);
    // final notificationDate2 = DateTime(date.year, date.month, date.day, 12, 0, 0);
    // final notificationDate3 = DateTime(date.year, date.month, date.day, 18, 0, 0);

    _showDailyAtTime(555, "$currentTakenSteps steps", message, notificationDate1, "steps");
    _showDailyAtTime(555, "$currentTakenSteps steps", message, notificationDate2, "steps");
    _showDailyAtTime(555, "$currentTakenSteps steps", message, notificationDate3, "steps");
  }

  Future<void> displayDailyPeriodNotification(bool value) async {
    String periodNotificationAllowed = await ss.getItem(
        "periodNotificationAllowed") ?? "false";
    String isGeneralNotificationAllowed = await ss.getItem(
        "generalNotificationAllowed") ?? "false";
    if (periodNotificationAllowed == "false" ||
        isGeneralNotificationAllowed == "false") return;
  }

  Future<void> displayWeeklyPregnancyNotification(bool value) async {
    String pregnancyNotificationAllowed = await ss.getItem("pregnancyNotificationAllowed") ?? "false";
    String isGeneralNotificationAllowed = await ss.getItem("generalNotificationAllowed") ?? "false";
    if(pregnancyNotificationAllowed == "false" || isGeneralNotificationAllowed == "false") return;

    String value = await ss.getItem("pregnancyCalculatorDate");

    if(value == null) return;

    final today = DateTime.now();

    final calculatorDate = DateTime.parse(value);

    final dueDateInWeeks = calculatorDate.add(Duration(days: 252)); ///adding 36weeks to the last period date

    final currentDueDateInWeeks = dueDateInWeeks.difference(today).inDays;

    int remainder = 252 - currentDueDateInWeeks;

    int weekNumber = (double.parse("$remainder") / 7.0).ceil();

    String message = "";
    if(weekNumber < 10) {
      message = new PregnancyServices().getPregnancyInfoData().firstWhere((element) => element.week == weekNumber).bodyText;
    }else {
      message = new PregnancyServices().getPregnancyInfoData().firstWhere((element) => element.week == weekNumber).babyText;
    }

    // final notificationDate = DateTime(today.year, today.month, 1, 10, 0, 0);
    final notificationDate = new tz.TZDateTime(tz.getLocation(currentTimeZone), today.year, today.month, 1, 10, 0, 0);

    _showWeeklyAtTime(666, "Week $weekNumber", message, notificationDate, "pregnancy");
  }


  Future<void> _showDailyAtTime(int id, String title, String body, tz.TZDateTime timestamp, String activity) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        'This channel is used for important notifications.');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(id, title, body, timestamp, platformChannelSpecifics, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime, androidAllowWhileIdle: true, matchDateTimeComponents: DateTimeComponents.time, payload: activity);
  }

  Future<void> _showWeeklyAtTime(int id, String title, String body, tz.TZDateTime timestamp, String activity) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        'This channel is used for important notifications.',
      importance: Importance.high,);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(id, title, body, timestamp, platformChannelSpecifics, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime, androidAllowWhileIdle: true, matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime, payload: activity);
  }
}