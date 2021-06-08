
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/ListItem/model_diet_data.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:jiffy/jiffy.dart';

import '../../../constants.dart';

class DietServices {

  StorageSystem ss;
  String year, month, day, week, hour, min;
  final date = DateTime.now();
  final months = [
    "JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG", "SEP","OCT","NOV","DEC"
  ];

  DietServices(){
    ss = new StorageSystem();
    year = date.year.toString();
    month = months[date.month - 1];
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

  Future<void> updateWaterTakenCount(int value, int goal) async {

    final date = DateTime.now();
    final months = ["JAN", "FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];
    final days = ["MON","TUE","WED","THU","FRI","SAT","SUN"];

    String weekValue = Jiffy(date).week.toString();

    String formatDate = "${date.year}_${months[date.month - 1]}_${date.day}";

    String year = date.year.toString();
    String month = months[date.month - 1];
    String day = "${date.day}";
    String week = days[date.weekday - 1];
    String hour = "${date.hour}";
    String min = "${date.minute}";

    String id = "${date.year}-${months[date.month - 1]}-${date.day}"; //FirebaseDatabase.instance.reference().push().key;

    WaterData wd = new WaterData(id, year, month, day, week, weekValue, hour, min, date.toString(), "$value", "$goal", FieldValue.serverTimestamp());

    await ss.setPrefItem("waterCurrent_$formatDate", "$value");

    await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("water").doc(id).set(wd.toJSON());

  }

  Future<void> updateWeightData(String weight, String bmi, String height, String goal) async {

    final date = DateTime.now();
    final months = ["JAN", "FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];
    final days = ["MON","TUE","WED","THU","FRI","SAT","SUN"];

    String weekValue = Jiffy(date).week.toString();

    String formatDate = "${date.year}_${months[date.month - 1]}_${date.day}";

    String year = date.year.toString();
    String month = months[date.month - 1];
    String day = "${date.day}";
    String week = days[date.weekday - 1];
    String hour = "${date.hour}";
    String min = "${date.minute}";

    String id = "${date.year}-${months[date.month - 1]}-${date.day}"; //FirebaseDatabase.instance.reference().push().key;

    WeightData wd = new WeightData(id, year, month, day, week, weekValue, hour, min, date.toString(), weight, bmi, height, goal, FieldValue.serverTimestamp());

    await ss.setPrefItem("weightCurrent_$formatDate", "$weight/$bmi/$height");

    await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("weights").doc(id).set(wd.toJSON());

  }


  Future<void> updateCaloriesTakenCount(String value, String goal) async {

    final date = DateTime.now();
    final months = ["JAN", "FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];
    final days = ["MON","TUE","WED","THU","FRI","SAT","SUN"];

    String weekValue = Jiffy(date).week.toString();

    String formatDate = "${date.year}_${months[date.month - 1]}_${date.day}";

    String year = date.year.toString();
    String month = months[date.month - 1];
    String day = "${date.day}";
    String week = days[date.weekday - 1];
    String hour = "${date.hour}";
    String min = "${date.minute}";

    String id = "${date.year}-${months[date.month - 1]}-${date.day}"; //FirebaseDatabase.instance.reference().push().key;

    WaterData wd = new WaterData(id, year, month, day, week, weekValue, hour, min, date.toString(), value, goal, FieldValue.serverTimestamp());

    await ss.setPrefItem("caloriesCurrent_$formatDate", value);

    await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("calories").doc(id).set(wd.toJSON());

  }

  Map<String, dynamic> manipulateCaloriesMonthData(List<WaterData> waterData) {
    Map<String, dynamic> storage = new Map();

    waterData.forEach((element) {
      String value = months.indexWhere((mth) => mth == element.month).toString();
      if(storage[value] == null) {
        storage[value] = double.parse(element.glasses_count).ceil();
      }
      else {
        dynamic sum = storage[value];
        storage[value] = sum + double.parse(element.glasses_count).ceil();
      }
    });

    return storage;
  }

  List<Map<String, dynamic>> manipulateCaloriesWeekData(List<WaterData> mWaterData) {
    Map<String, dynamic> storage = new Map();
    Map<String, dynamic> weekRangeStorage = new Map();
    Map<String, dynamic> storageCount = new Map();

    int numberOfMonths = (month == "SEP" || month == "APR" || month == "JUN" || month == "NOV") ? 30 : (month == "FEB") ? 28 : 31;
    int weekNumber = 1;
    int startDay = 1, endDay = 1;
    for (int i = 1; i <= numberOfMonths; i++) {
      endDay = i;
      DateTime dt = DateTime(int.parse(year), date.month, i);
      if(dt.weekday == DateTime.monday) {
        if (i != 1) {
          weekRangeStorage["$weekNumber"] = "$month $startDay - ${endDay - 1}";
          startDay = endDay;
          weekNumber = weekNumber + 1; //go to the next week
        }
      }
      List<WaterData> sd = mWaterData.where((element) => element.day == "$i").toList();
      if(sd.isNotEmpty) {
        if(storage["$weekNumber"] == null) {
          storage["$weekNumber"] = double.parse(sd[0].glasses_count).ceil();
        }else {
          dynamic sum = storage["$weekNumber"];
          storage["$weekNumber"] = sum + double.parse(sd[0].glasses_count).ceil();
        }

        //for storage count
        if(storageCount["$weekNumber"] == null) {
          storageCount["$weekNumber"] = 1;
        }else {
          dynamic sum = storageCount["$weekNumber"];
          storageCount["$weekNumber"] = sum + 1;
        }
      }
    }
    return [
      storage,weekRangeStorage,storageCount
    ];
  }


  Map<String, dynamic> manipulateWeightMonthData(List<WeightData> weightData) {
    Map<String, dynamic> storage = new Map();

    weightData.forEach((element) {
      String value = months.indexWhere((mth) => mth == element.month).toString();
      if(storage[value] == null) {
        storage[value] = double.parse(element.weight);
      }
      else {
        dynamic sum = storage[value];
        storage[value] = sum + double.parse(element.weight);
      }
    });

    return storage;
  }

  List<Map<String, dynamic>> manipulateWeightWeekData(List<WeightData> mWeightData) {
    Map<String, dynamic> storage = new Map();
    Map<String, dynamic> weekRangeStorage = new Map();
    Map<String, dynamic> storageCount = new Map();

    int numberOfMonths = (month == "SEP" || month == "APR" || month == "JUN" || month == "NOV") ? 30 : (month == "FEB") ? 28 : 31;
    int weekNumber = 1;
    int startDay = 1, endDay = 1;
    for (int i = 1; i <= numberOfMonths; i++) {
      endDay = i;
      DateTime dt = DateTime(int.parse(year), date.month, i);
      if(dt.weekday == DateTime.monday) {
        if (i != 1) {
          weekRangeStorage["$weekNumber"] = "$month $startDay - ${endDay - 1}";
          startDay = endDay;
          weekNumber = weekNumber + 1; //go to the next week
        }
      }
      List<WeightData> sd = mWeightData.where((element) => element.day == "$i").toList();
      if(sd.isNotEmpty) {
        if(storage["$weekNumber"] == null) {
          storage["$weekNumber"] = double.parse(sd[0].weight);
        }else {
          dynamic sum = storage["$weekNumber"];
          storage["$weekNumber"] = sum + double.parse(sd[0].weight);
        }

        //for storage count
        if(storageCount["$weekNumber"] == null) {
          storageCount["$weekNumber"] = 1;
        }else {
          dynamic sum = storageCount["$weekNumber"];
          storageCount["$weekNumber"] = sum + 1;
        }
      }
    }
    return [
      storage,weekRangeStorage,storageCount
    ];
  }


  Map<String, dynamic> manipulateWaterMonthData(List<WaterData> waterData) {
    Map<String, dynamic> storage = new Map();

    waterData.forEach((element) {
      String value = months.indexWhere((mth) => mth == element.month).toString();
      if(storage[value] == null) {
        storage[value] = int.parse(element.glasses_count);
      }
      else {
        dynamic sum = storage[value];
        storage[value] = sum + int.parse(element.glasses_count);
      }
    });

    return storage;
  }

  List<Map<String, dynamic>> manipulateWaterWeekData(List<WaterData> mWaterData) {
    Map<String, dynamic> storage = new Map();
    Map<String, dynamic> weekRangeStorage = new Map();
    Map<String, dynamic> storageCount = new Map();

    int numberOfMonths = (month == "SEP" || month == "APR" || month == "JUN" || month == "NOV") ? 30 : (month == "FEB") ? 28 : 31;
    int weekNumber = 1;
    int startDay = 1, endDay = 1;
    for (int i = 1; i <= numberOfMonths; i++) {
      endDay = i;
      DateTime dt = DateTime(int.parse(year), date.month, i);
      if(dt.weekday == DateTime.monday) {
        if (i != 1) {
          weekRangeStorage["$weekNumber"] = "$month $startDay - ${endDay - 1}";
          startDay = endDay;
          weekNumber = weekNumber + 1; //go to the next week
        }
      }
      List<WaterData> sd = mWaterData.where((element) => element.day == "$i").toList();
      if(sd.isNotEmpty) {
        if(storage["$weekNumber"] == null) {
          storage["$weekNumber"] = int.parse(sd[0].glasses_count);
        }else {
          dynamic sum = storage["$weekNumber"];
          storage["$weekNumber"] = sum + int.parse(sd[0].glasses_count);
        }

        //for storage count
        if(storageCount["$weekNumber"] == null) {
          storageCount["$weekNumber"] = 1;
        }else {
          dynamic sum = storageCount["$weekNumber"];
          storageCount["$weekNumber"] = sum + 1;
        }
      }
    }
    return [
      storage,weekRangeStorage,storageCount
    ];
  }
}