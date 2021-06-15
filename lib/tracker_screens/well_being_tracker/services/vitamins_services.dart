import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/ListItem/model_vitamins_data.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:jiffy/jiffy.dart';

class WellBeingServices {
  String year, month, day, week, hour, min;
  final date = DateTime.now();
  final months = [
    "JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG", "SEP","OCT","NOV","DEC"
  ];

  StorageSystem ss;
  WellBeingServices() {
    ss = new StorageSystem();
    year = date.year.toString();
    month = months[date.month - 1];
  }

  rewriteTimeValue(int value) {
    return value < 10 ? "0$value" : "$value";
  }

  Future<void> saveVitaminGoal(String goal) async {
    await ss.setPrefItem("vitaminGoal", goal);
  }

  Future<void> updateVitaminTakenCount(int value, int goal) async {

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

    VitaminsData vd = new VitaminsData(id, year, month, day, week, weekValue, hour, min, date.toString(), "$value", "$goal", FieldValue.serverTimestamp());

    await ss.setPrefItem("vitaminCurrent_$formatDate", "$value", isStoreOnline: false);

    await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("vitamins").doc(id).set(vd.toJSON());

  }

  Future<void> updateMoodData(String mood) async {

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

    MoodData vd = new MoodData(id, year, month, day, week, weekValue, hour, min, date.toString(), mood, FieldValue.serverTimestamp());

    await ss.setPrefItem("moodCurrent_$formatDate", mood, isStoreOnline: false);

    await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("moods").doc(id).set(vd.toJSON());

  }

  Future<void> updateSleepData(String bedtime, String wakeup, String sleepingTime) async {

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

    SleepData sd = new SleepData(id, year, month, day, week, weekValue, hour, min, date.toString(), bedtime, wakeup, sleepingTime, FieldValue.serverTimestamp());

    await ss.setPrefItem("sleepCurrent_$formatDate", "$bedtime/$wakeup/$sleepingTime", isStoreOnline: false);
    await ss.setPrefItem("generalSleepCurrent", "$bedtime/$wakeup/$sleepingTime", isStoreOnline: false);

    await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("sleep").doc(id).set(sd.toJSON());

  }

  Map<String, dynamic> manipulateVitaminsMonthData(List<VitaminsData> vitaminsData) {
    Map<String, dynamic> storage = new Map();

    vitaminsData.forEach((element) {
      String value = months.indexWhere((mth) => mth == element.month).toString();
      if(storage[value] == null) {
        storage[value] = int.parse(element.vitamin_count);
      }
      else {
        dynamic sum = storage[value];
        storage[value] = sum + int.parse(element.vitamin_count);
      }
    });

    return storage;
  }

  List<Map<String, dynamic>> manipulateVitaminsWeekData(List<VitaminsData> mVitaminsData) {
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
          startDay = endDay; //+1
          weekNumber = weekNumber + 1; //go to the next week
        }
      }
      List<VitaminsData> sd = mVitaminsData.where((element) => element.day == "$i").toList();
      if(sd.isNotEmpty) {
        if(storage["$weekNumber"] == null) {
          storage["$weekNumber"] = int.parse(sd[0].vitamin_count);
        }else {
          dynamic sum = storage["$weekNumber"];
          storage["$weekNumber"] = sum + int.parse(sd[0].vitamin_count);
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
