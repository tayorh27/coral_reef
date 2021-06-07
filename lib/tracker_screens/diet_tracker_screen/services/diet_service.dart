
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/ListItem/model_diet_data.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../constants.dart';

class DietServices {

  StorageSystem ss;

  DietServices(){
    ss = new StorageSystem();
  }

  rewriteTimeValue(int value) {
    return value < 10 ? "0$value" : "$value";
  }

  Future<void> saveWaterGoal(String goal) async {
    await ss.setPrefItem("waterGoal", goal);
  }

  Future<void> saveCaloriesGoal(String goal) async {
    await ss.setPrefItem("caloriesGoal", goal);
  }

  Future<void> updateWaterTakenCount(int value) async {

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

    WaterData wd = new WaterData(id, year, month, day, week, hour, min, date.toString(), "$value", FieldValue.serverTimestamp());

    await ss.setPrefItem("waterCurrent_$formatDate", "$value");

    await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("water").doc(id).set(wd.toJSON());

  }

  Future<void> updateWeightData(String weight, String bmi, String height) async {

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

    WeightData wd = new WeightData(id, year, month, day, week, hour, min, date.toString(), weight, bmi, height, FieldValue.serverTimestamp());

    await ss.setPrefItem("weightCurrent_$formatDate", "$weight/$bmi/$height");

    await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("weights").doc(id).set(wd.toJSON());

  }


  Future<void> updateCaloriesTakenCount(String value) async {

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

    WaterData wd = new WaterData(id, year, month, day, week, hour, min, date.toString(), value, FieldValue.serverTimestamp());

    await ss.setPrefItem("caloriesCurrent_$formatDate", value);

    await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("calories").doc(id).set(wd.toJSON());

  }
}