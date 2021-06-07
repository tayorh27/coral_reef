import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/ListItem/model_vitamins_data.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/constants.dart';
import 'package:firebase_database/firebase_database.dart';

class WellBeingServices {
  StorageSystem ss;
  WellBeingServices() {
    ss = new StorageSystem();
  }

  rewriteTimeValue(int value) {
    return value < 10 ? "0$value" : "$value";
  }

  Future<void> saveVitaminGoal(String goal) async {
    await ss.setPrefItem("vitaminGoal", goal);
  }

  Future<void> updateVitaminTakenCount(int value) async {

    final date = DateTime.now();
    final months = ["JAN", "FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];
    final days = ["MON","TUE","WED","THU","FRI","SAT","SUN"];

    String formatDate = "${date.year}_${months[date.month - 1]}_${date.day}";

    String year = date.year.toString();
    String month = months[date.month - 1];
    String day = "${date.day}";
    String week = days[date.weekday - 1];
    String hour = "${date.hour}";
    String min = "${date.minute}";

    String id = FirebaseDatabase.instance.reference().push().key;

    VitaminsData vd = new VitaminsData(id, year, month, day, week, hour, min, date.toString(), "$value", FieldValue.serverTimestamp());

    await ss.setPrefItem("vitaminCurrent_$formatDate", "$value");

    await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("vitamins").doc(id).set(vd.toJSON());

  }

  Future<void> updateMoodData(String mood) async {

    final date = DateTime.now();
    final months = ["JAN", "FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];
    final days = ["MON","TUE","WED","THU","FRI","SAT","SUN"];

    String formatDate = "${date.year}_${months[date.month - 1]}_${date.day}";

    String year = date.year.toString();
    String month = months[date.month - 1];
    String day = "${date.day}";
    String week = days[date.weekday - 1];
    String hour = "${date.hour}";
    String min = "${date.minute}";

    String id = FirebaseDatabase.instance.reference().push().key;

    MoodData vd = new MoodData(id, year, month, day, week, hour, min, date.toString(), mood, FieldValue.serverTimestamp());

    await ss.setPrefItem("moodCurrent_$formatDate", mood);

    await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("moods").doc(id).set(vd.toJSON());

  }

  Future<void> updateSleepData(String bedtime, String wakeup, String sleepingTime) async {

    final date = DateTime.now();
    final months = ["JAN", "FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];
    final days = ["MON","TUE","WED","THU","FRI","SAT","SUN"];

    String formatDate = "${date.year}_${months[date.month - 1]}_${date.day}";

    String year = date.year.toString();
    String month = months[date.month - 1];
    String day = "${date.day}";
    String week = days[date.weekday - 1];
    String hour = "${date.hour}";
    String min = "${date.minute}";

    String id = FirebaseDatabase.instance.reference().push().key;

    SleepData sd = new SleepData(id, year, month, day, week, hour, min, date.toString(), bedtime, wakeup, sleepingTime, FieldValue.serverTimestamp());

    await ss.setPrefItem("sleepCurrent_$formatDate", "$bedtime/$wakeup/$sleepingTime");

    await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("sleep").doc(id).set(sd.toJSON());

  }
}
