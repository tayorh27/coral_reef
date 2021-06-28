import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/ListItem/model_diet_data.dart';
import 'package:coral_reef/ListItem/model_vitamins_data.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/constants.dart';
import 'package:coral_reef/tracker_screens/diet_tracker_screen/services/diet_service.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/services/exercise_service.dart';
import 'package:coral_reef/tracker_screens/well_being_tracker/services/vitamins_services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

enum TrackerType {
  Vitamins,
  Steps,
  Calories,
  Weight,
  Water
}

class DewServices {
  StorageSystem ss;
  BuildContext context;
  String year, month, day, week, hour, min;

  final date = DateTime.now();
  final months = [
    "JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG", "SEP","OCT","NOV","DEC"
  ];
  final days = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"];

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        y: y1,
        colors: [Color(MyColors.primaryColor)],
        width: 10,
      ),
      BarChartRodData(
        y: y2,
        colors: [Color(MyColors.primaryColor)],
        width: 10,
      ),
    ]);
  }

  WellBeingServices wellBeingServices;
  DietServices dietServices;
  ExerciseService exerciseService;

  DewServices(BuildContext context) {
    this.context = context;
    wellBeingServices = new WellBeingServices();
    dietServices = new DietServices();
    exerciseService = new ExerciseService();
    ss = new StorageSystem();
    setupTodayDate();
  }

  setupTodayDate() {
    year = date.year.toString();
    month = months[date.month - 1];
    day = "${date.day}";
    week = days[date.weekday - 1];
    hour = "${date.hour}";
    min = "${date.minute}";
  }

  QuerySnapshot queryDay,queryWeek,queryMonth;

  Future<Map<String, dynamic>> getSleepDataInsight(String dataByType) async { //days,weeks,months

    Map<String, dynamic> returnData = new Map();

    List<BarChartGroupData> chartData = [];

    List<SleepData> sleepData = [];

    if(dataByType == "Days") {

      if(queryDay == null){ queryDay = await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("sleep").where("month", isEqualTo: month).get();}

      if(queryDay.docs.isEmpty) {
        returnData["sleep"] = sleepData;
        returnData["chart"] = [makeGroupData(0, 0, 0)];
        return returnData;
      }

      queryDay.docs.forEach((element) {
        SleepData sd = SleepData.fromSnapshot(element.data());
        sleepData.add(sd);
        // Map<String, dynamic> data = new Map();
        // final barGroup = makeGroupData(int.parse(sd.day), double.parse(sd.bed_time.split(":")[0]), double.parse(sd.wake_up.split(":")[0]));

        final barGroup = makeGroupData(int.parse(sd.day), 0, double.parse(sd.sleeping_time.split(" ")[0]));
        // data[sd.day] = "${sd.bed_time}/${sd.wake_up}/${sd.sleeping_time}";
        chartData.add(barGroup);
      });

      returnData["sleep"] = sleepData;
      returnData["chart"] = chartData;

    }

    if(dataByType == "Weeks") {

      if(queryWeek == null){  queryWeek = await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("sleep").where("month", isEqualTo: month).orderBy("timestamp", descending: false).get();}

      if(queryWeek.docs.isEmpty) {
        returnData["sleep"] = sleepData;
        returnData["chart"] = [makeGroupData(0, 0, 0)];
        return returnData;
      }

      List<SleepData> mSleepData = [];

      queryWeek.docs.forEach((element) {
        SleepData sd = SleepData.fromSnapshot(element.data());
        mSleepData.add(sd);
      });

      List<Map<String, dynamic>> result = manipulateSleepWeekData(mSleepData);

      Map<String, dynamic> storage = result[0];
      Map<String, dynamic> weekStorage = result[1];
      Map<String, dynamic> storageCount = result[2];

      storage.entries.forEach((element) {
        final barGroup = makeGroupData(int.parse(element.key), 0, returnDoubleInTwoDecimals((double.parse("${element.value}") / storageCount[element.key])));
        List<String> daysRange = weekStorage[element.key].toString().split(" ");
        String bedtime = getHighestOccurrenceByWeek(mSleepData, "bedtime", int.parse(daysRange[1]), int.parse(daysRange[3]));
        String wakeup = getHighestOccurrenceByWeek(mSleepData, "wakeup", int.parse(daysRange[1]), int.parse(daysRange[3]));
        final sleepD = new SleepData("id", year, month, day, week, "weekValue", hour, min, weekStorage[element.key], bedtime, wakeup, "${(element.value / storageCount[element.key]).ceil()} hrs", null);
        sleepData.add(sleepD);
        chartData.add(barGroup);
      });



      returnData["sleep"] = sleepData;
      returnData["chart"] = chartData;
    }

    if(dataByType == "Months") {

      if(queryMonth == null){  queryMonth = await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("sleep").orderBy("timestamp", descending: false).get();}

      if(queryMonth.docs.isEmpty) {
        returnData["sleep"] = sleepData;
        returnData["chart"] = [makeGroupData(0, 0, 0)];
        return returnData;
      }

      List<SleepData> mSleepData = [];

      queryMonth.docs.forEach((element) {
        SleepData sd = SleepData.fromSnapshot(element.data());
        mSleepData.add(sd);
      });

      Map<String, dynamic> storage = manipulateSleepMonthData(mSleepData);

      storage.entries.forEach((element) {
        //find the length of data in a particular month
        List<SleepData> len = mSleepData.where((sleepD) => sleepD.month == months[int.parse(element.key)]).toList();
        final barGroup = makeGroupData(int.parse(element.key), 0, returnDoubleInTwoDecimals((double.parse("${element.value}")/len.length)));
        String bedtime = getHighestOccurrence(mSleepData, "bedtime", months[int.parse(element.key)]);
        String wakeup = getHighestOccurrence(mSleepData, "wakeup", months[int.parse(element.key)]);
        final sleepD = new SleepData("id", year, month, day, week, "weekValue", hour, min, months[int.parse(element.key)], bedtime, wakeup, "${(element.value / len.length).ceil()} hrs", null);
        sleepData.add(sleepD);
        chartData.add(barGroup);
      });

      returnData["sleep"] = sleepData;
      returnData["chart"] = chartData;


    }

    return returnData;

  }

  Map<String, dynamic> manipulateSleepMonthData(List<SleepData> sleepData) {
    Map<String, dynamic> storage = new Map();

    sleepData.forEach((element) {
      String value = months.indexWhere((mth) => mth == element.month).toString();
      if(storage[value] == null) {
        storage[value] = int.parse(element.sleeping_time.split(" ")[0]);
      }
      else {
        dynamic sum = storage[value];
        storage[value] = sum + int.parse(element.sleeping_time.split(" ")[0]);
      }
    });

    return storage;
  }

  // List<Map<String, dynamic>> manipulateSleepWeekData(List<SleepData> sleepData) {
  //   final mDays = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"];
  //   DateTime monthDateTime = new DateTime(int.parse(year), date.month, 1); //the start day of the current month
  //   DateTime nextDateTime;
  //
  //   List<Map<String, dynamic>> result = [];
  //
  //   int index = 1;
  //
  //   while(month == months[monthDateTime.month - 1]) {
  //     if(mDays[monthDateTime.weekday - 1] == "SUN") {
  //       nextDateTime = monthDateTime.add(Duration(days: 6));
  //     }else if(mDays[monthDateTime.weekday - 1] == "SAT") {
  //       nextDateTime = monthDateTime;
  //     }else {
  //       int addDays = 6 - monthDateTime.weekday;
  //       nextDateTime = monthDateTime.add(Duration(days: addDays));
  //     }
  //
  //
  //     String title = "$month/${monthDateTime.day}-${nextDateTime.day}";
  //
  //     Map<String, dynamic> response = new Map();
  //
  //     response["index"] = index;
  //     response["header"] = title;
  //     response["data"] = getSumAndAverageSleepData(sleepData, monthDateTime, nextDateTime);
  //
  //     monthDateTime = nextDateTime;
  //     index = index + 1;
  //
  //     result.add(response);
  //   }
  //
  //   return result;
  // }

  List<Map<String, dynamic>> manipulateSleepWeekData(List<SleepData> mSleepData) {
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
      List<SleepData> sd = mSleepData.where((element) => element.day == "$i").toList();
      if(sd.isNotEmpty) {
        if(storage["$weekNumber"] == null) {
          storage["$weekNumber"] = int.parse(sd[0].sleeping_time.split(" ")[0]);
        }else {
          dynamic sum = storage["$weekNumber"];
          storage["$weekNumber"] = sum + int.parse(sd[0].sleeping_time.split(" ")[0]);
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
    // if(count) {
    //   return storageCount;
    // }
    // return (returnWeek) ? weekStorage : storage;
  }

  //sum up the number sleeping hours within a date range ****not used
  String getSumAndAverageSleepData(List<SleepData> sleepData, DateTime start, DateTime end) {

    List<int> range = [];

    int sleepingTime = 0;
    String bedtime = "";
    String wakeup = "";

    for(int i = start.day; i <= end.day; i++) {
      range.add(i);
    }

    List<SleepData> res = sleepData.where((sleep) => range.contains(int.parse(sleep.day))).toList();

    if(res.isNotEmpty) {
      res.forEach((element) {
        sleepingTime += int.parse(element.sleeping_time.split(" ")[0]);
      });
      sleepingTime = (sleepingTime / res.length).ceil();
      bedtime = getHighestOccurrence(res, "bedtime","");
      wakeup = getHighestOccurrence(res, "wakeup","");
    }

    return "$sleepingTime/$bedtime/$wakeup";

  }

  //get the mean value of a list of data for a particular month
  String getHighestOccurrence(List<SleepData> sleepData, String dataCheck, String month) {

    String highestKey = "";
    int highestValue = 0;

    Map<String, dynamic> storage = new Map();

    sleepData.where((element) => element.month == month).toList().forEach((element) {
      String value = (dataCheck == "bedtime") ? element.bed_time.replaceAll(" ", "_").replaceAll(":", "-") : element.wake_up.replaceAll(" ", "_").replaceAll(":", "-");

      if(storage[value] == null) {
        storage[value] = 1;
      }
      else {
        dynamic sum = storage[value];
        storage[value] = sum + 1;
      }
    });

    //get the highest value
    storage.entries.forEach((element) {
      if(element.value > highestValue) {
        highestValue = element.value;
        highestKey = element.key.replaceAll("_", " ").replaceAll("-", ":");
      }
    });

    return highestKey;

  }

  //get the mean value of a list of data for a particular week range. e.g jun 1 - 6
  String getHighestOccurrenceByWeek(List<SleepData> sleepData, String dataCheck, int start, int end) {

    List<String> range = [];

    for(int i = start; i <= end; i++) {
      range.add(i.toString());
    }

    String highestKey = "";
    int highestValue = 0;

    Map<String, dynamic> storage = new Map();

    sleepData.where((element) => range.contains(element.day)).toList().forEach((element) {
      String value = (dataCheck == "bedtime") ? element.bed_time.replaceAll(" ", "_").replaceAll(":", "-") : element.wake_up.replaceAll(" ", "_").replaceAll(":", "-");

      if(storage[value] == null) {
        storage[value] = 1;
      }
      else {
        dynamic sum = storage[value];
        storage[value] = sum + 1;
      }
    });

    //get the highest value
    storage.entries.forEach((element) {
      if(element.value > highestValue) {
        highestValue = element.value;
        highestKey = element.key.replaceAll("_", " ").replaceAll("-", ":");
      }
    });

    return highestKey;

  }


  Future<Map<String, dynamic>> getVitaminsDataInsight(String dataByType) async { //days,weeks,months

    Map<String, dynamic> returnData = new Map();

    List<BarChartGroupData> chartData = [];

    List<VitaminsData> vitaminsData = [];

    if(dataByType == "Days") {

      if(queryDay == null){ queryDay = await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("vitamins").where("month", isEqualTo: month).get();}

      if(queryDay.docs.isEmpty) {
        returnData["data"] = vitaminsData;
        returnData["chart"] = [makeGroupData(0, 0, 0)];
        return returnData;
      }

      queryDay.docs.forEach((element) {
        VitaminsData vd = VitaminsData.fromSnapshot(element.data());
        vitaminsData.add(vd);
        final barGroup = makeGroupData(int.parse(vd.day), 0, double.parse(vd.vitamin_count));
        chartData.add(barGroup);
      });

      returnData["data"] = vitaminsData;
      returnData["chart"] = chartData;

    }

    if(dataByType == "Weeks") {

      if(queryWeek == null){  queryWeek = await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("vitamins").where("month", isEqualTo: month).orderBy("timestamp", descending: false).get();}

      if(queryWeek.docs.isEmpty) {
        returnData["data"] = vitaminsData;
        returnData["chart"] = [makeGroupData(0, 0, 0)];
        return returnData;
      }

      List<VitaminsData> mVitaminsData = [];

      queryWeek.docs.forEach((element) {
        VitaminsData vd = VitaminsData.fromSnapshot(element.data());
        mVitaminsData.add(vd);
      });

      List<Map<String, dynamic>> result = wellBeingServices.manipulateVitaminsWeekData(mVitaminsData);

      Map<String, dynamic> storage = result[0];
      Map<String, dynamic> weekStorage = result[1];
      Map<String, dynamic> storageCount = result[2];

      storage.entries.forEach((element) {
        final barGroup = makeGroupData(int.parse(element.key), 0, returnDoubleInTwoDecimals((double.parse("${element.value}") / storageCount[element.key])));
        final vitaminD = new VitaminsData("id", year, month, day, week, "weekValue", hour, min, weekStorage[element.key], "${(element.value / storageCount[element.key]).ceil()}", "", null);
        vitaminsData.add(vitaminD);
        chartData.add(barGroup);
      });



      returnData["data"] = vitaminsData;
      returnData["chart"] = chartData;
    }

    if(dataByType == "Months") {

      if(queryMonth == null){  queryMonth = await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("vitamins").orderBy("timestamp", descending: false).get();}

      if(queryMonth.docs.isEmpty) {
        returnData["data"] = vitaminsData;
        returnData["chart"] = [makeGroupData(0, 0, 0)];
        return returnData;
      }

      List<VitaminsData> mVitaminsData = [];

      queryMonth.docs.forEach((element) {
        VitaminsData vd = VitaminsData.fromSnapshot(element.data());
        mVitaminsData.add(vd);
      });

      Map<String, dynamic> storage = wellBeingServices.manipulateVitaminsMonthData(mVitaminsData);

      storage.entries.forEach((element) {
        //find the length of data in a particular month
        List<VitaminsData> len = mVitaminsData.where((vitaminD) => vitaminD.month == months[int.parse(element.key)]).toList();
        final barGroup = makeGroupData(int.parse(element.key), 0, returnDoubleInTwoDecimals((double.parse("${element.value}") / len.length)));
        final vitaminD = new VitaminsData("id", year, month, day, week, "weekValue", hour, min, months[int.parse(element.key)], "${(element.value / len.length).ceil()}", "", null);
        vitaminsData.add(vitaminD);
        chartData.add(barGroup);
      });

      returnData["data"] = vitaminsData;
      returnData["chart"] = chartData;


    }

    return returnData;

  }

  Future<Map<String, dynamic>> getCaloriesDataInsight(String dataByType) async { //days,weeks,months

    Map<String, dynamic> returnData = new Map();

    List<BarChartGroupData> chartData = [];

    List<WaterData> waterData = [];

    if(dataByType == "Days") {

      if(queryDay == null){ queryDay = await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("calories").where("month", isEqualTo: month).get();}

      if(queryDay.docs.isEmpty) {
        returnData["data"] = waterData;
        returnData["chart"] = [makeGroupData(0, 0, 0)];
        return returnData;
      }

      queryDay.docs.forEach((element) {
        WaterData wd = WaterData.fromSnapshot(element.data());
        waterData.add(wd);
        final barGroup = makeGroupData(int.parse(wd.day), 0, double.parse(wd.glasses_count));
        chartData.add(barGroup);
      });

      returnData["data"] = waterData;
      returnData["chart"] = chartData;

    }

    if(dataByType == "Weeks") {

      if(queryWeek == null){  queryWeek = await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("calories").where("month", isEqualTo: month).orderBy("timestamp", descending: false).get();}

      if(queryWeek.docs.isEmpty) {
        returnData["data"] = waterData;
        returnData["chart"] = [makeGroupData(0, 0, 0)];
        return returnData;
      }

      List<WaterData> mWaterData = [];

      queryWeek.docs.forEach((element) {
        WaterData wd = WaterData.fromSnapshot(element.data());
        mWaterData.add(wd);
      });

      List<Map<String, dynamic>> result = dietServices.manipulateCaloriesWeekData(mWaterData);

      Map<String, dynamic> storage = result[0];
      Map<String, dynamic> weekStorage = result[1];
      Map<String, dynamic> storageCount = result[2];

      storage.entries.forEach((element) {
        final barGroup = makeGroupData(int.parse(element.key), 0, returnDoubleInTwoDecimals((double.parse("${element.value}") / storageCount[element.key])));
        final waterD = new WaterData("id", year, month, day, week, "weekValue", hour, min, weekStorage[element.key], "${(element.value / storageCount[element.key]).ceil()}", "", null);
        waterData.add(waterD);
        chartData.add(barGroup);
      });



      returnData["data"] = waterData;
      returnData["chart"] = chartData;
    }

    if(dataByType == "Months") {

      if(queryMonth == null){  queryMonth = await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("calories").orderBy("timestamp", descending: false).get();}

      if(queryMonth.docs.isEmpty) {
        returnData["data"] = waterData;
        returnData["chart"] = [makeGroupData(0, 0, 0)];
        return returnData;
      }

      List<WaterData> mWaterData = [];

      queryMonth.docs.forEach((element) {
        WaterData wd = WaterData.fromSnapshot(element.data());
        mWaterData.add(wd);
      });

      Map<String, dynamic> storage = dietServices.manipulateCaloriesMonthData(mWaterData);

      storage.entries.forEach((element) {
        //find the length of data in a particular month
        List<WaterData> len = mWaterData.where((waterD) => waterD.month == months[int.parse(element.key)]).toList();
        final barGroup = makeGroupData(int.parse(element.key), 0, returnDoubleInTwoDecimals((double.parse("${element.value}") / len.length)));
        final waterD = new WaterData("id", year, month, day, week, "weekValue", hour, min, months[int.parse(element.key)], "${(element.value / len.length).ceil()}", "", null);
        waterData.add(waterD);
        chartData.add(barGroup);
      });

      returnData["data"] = waterData;
      returnData["chart"] = chartData;

    }

    return returnData;

  }

  Future<Map<String, dynamic>> getWeightDataInsight(String dataByType) async { //days,weeks,months

    Map<String, dynamic> returnData = new Map();

    List<BarChartGroupData> chartData = [];

    List<WeightData> weightData = [];

    if(dataByType == "Days") {

      if(queryDay == null){ queryDay = await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("weights").where("month", isEqualTo: month).get();}

      if(queryDay.docs.isEmpty) {
        returnData["data"] = weightData;
        returnData["chart"] = [makeGroupData(0, 0, 0)];
        return returnData;
      }

      queryDay.docs.forEach((element) {
        WeightData wd = WeightData.fromSnapshot(element.data());
        weightData.add(wd);
        final barGroup = makeGroupData(int.parse(wd.day), 0, double.parse(wd.weight));
        chartData.add(barGroup);
      });

      returnData["data"] = weightData;
      returnData["chart"] = chartData;

    }

    if(dataByType == "Weeks") {

      if(queryWeek == null){  queryWeek = await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("weights").where("month", isEqualTo: month).orderBy("timestamp", descending: false).get();}

      if(queryWeek.docs.isEmpty) {
        returnData["data"] = weightData;
        returnData["chart"] = [makeGroupData(0, 0, 0)];
        return returnData;
      }

      List<WeightData> mWeightData = [];

      queryWeek.docs.forEach((element) {
        WeightData wd = WeightData.fromSnapshot(element.data());
        mWeightData.add(wd);
      });

      List<Map<String, dynamic>> result = dietServices.manipulateWeightWeekData(mWeightData);

      Map<String, dynamic> storage = result[0];
      Map<String, dynamic> weekStorage = result[1];
      Map<String, dynamic> storageCount = result[2];

      storage.entries.forEach((element) {
        final barGroup = makeGroupData(int.parse(element.key), 0, returnDoubleInTwoDecimals((double.parse("${element.value}") / storageCount[element.key])));
        final weightD = new WeightData("id", year, month, day, week, "weekValue", hour, min, weekStorage[element.key], "${(element.value / storageCount[element.key]).ceil()}", "", "", "", null);
        weightData.add(weightD);
        chartData.add(barGroup);
      });



      returnData["data"] = weightData;
      returnData["chart"] = chartData;
    }

    if(dataByType == "Months") {

      if(queryMonth == null){  queryMonth = await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("weights").orderBy("timestamp", descending: false).get();}

      if(queryMonth.docs.isEmpty) {
        returnData["data"] = weightData;
        returnData["chart"] = [makeGroupData(0, 0, 0)];
        return returnData;
      }

      List<WeightData> mWeightData = [];

      queryMonth.docs.forEach((element) {
        WeightData wd = WeightData.fromSnapshot(element.data());
        mWeightData.add(wd);
      });

      Map<String, dynamic> storage = dietServices.manipulateWeightMonthData(mWeightData);

      storage.entries.forEach((element) {
        //find the length of data in a particular month
        List<WeightData> len = mWeightData.where((weightD) => weightD.month == months[int.parse(element.key)]).toList();
        final barGroup = makeGroupData(int.parse(element.key), 0, returnDoubleInTwoDecimals((double.parse("${element.value}") / len.length)));
        final weightD = new WeightData("id", year, month, day, week, "weekValue", hour, min, months[int.parse(element.key)], "${(element.value / len.length).ceil()}", "", "", "", null);
        weightData.add(weightD);
        chartData.add(barGroup);
      });

      returnData["data"] = weightData;
      returnData["chart"] = chartData;


    }

    return returnData;

  }

  Future<Map<String, dynamic>> getWaterDataInsight(String dataByType) async { //days,weeks,months

    Map<String, dynamic> returnData = new Map();

    List<BarChartGroupData> chartData = [];

    List<WaterData> waterData = [];

    if(dataByType == "Days") {

      if(queryDay == null){ queryDay = await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("water").where("month", isEqualTo: month).get();}

      if(queryDay.docs.isEmpty) {
        returnData["data"] = [];
        returnData["chart"] = [makeGroupData(0, 0, 0)];
        return returnData;
      }

      queryDay.docs.forEach((element) {
        WaterData wd = WaterData.fromSnapshot(element.data());
        waterData.add(wd);
        final barGroup = makeGroupData(int.parse(wd.day), 0, double.parse(wd.glasses_count));
        chartData.add(barGroup);
      });

      returnData["data"] = waterData;
      returnData["chart"] = chartData;

    }

    if(dataByType == "Weeks") {

      if(queryWeek == null){  queryWeek = await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("water").where("month", isEqualTo: month).orderBy("timestamp", descending: false).get();}

      if(queryWeek.docs.isEmpty) {
        returnData["data"] = waterData;
        returnData["chart"] = [makeGroupData(0, 0, 0)];
        return returnData;
      }

      List<WaterData> mWaterData = [];

      queryWeek.docs.forEach((element) {
        WaterData wd = WaterData.fromSnapshot(element.data());
        mWaterData.add(wd);
      });

      List<Map<String, dynamic>> result = dietServices.manipulateWaterWeekData(mWaterData);

      Map<String, dynamic> storage = result[0];
      Map<String, dynamic> weekStorage = result[1];
      Map<String, dynamic> storageCount = result[2];

      storage.entries.forEach((element) {
        final barGroup = makeGroupData(int.parse(element.key), 0, returnDoubleInTwoDecimals((double.parse("${element.value}") / storageCount[element.key])));
        final waterD = new WaterData("id", year, month, day, week, "weekValue", hour, min, weekStorage[element.key], "${(element.value / storageCount[element.key]).ceil()}", "", null);
        waterData.add(waterD);
        chartData.add(barGroup);
      });



      returnData["data"] = waterData;
      returnData["chart"] = chartData;
    }

    if(dataByType == "Months") {

      if(queryMonth == null){  queryMonth = await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("water").orderBy("timestamp", descending: false).get();}

      if(queryMonth.docs.isEmpty) {
        returnData["data"] = waterData;
        returnData["chart"] = [makeGroupData(0, 0, 0)];
        return returnData;
      }

      List<WaterData> mWaterData = [];

      queryMonth.docs.forEach((element) {
        WaterData wd = WaterData.fromSnapshot(element.data());
        mWaterData.add(wd);
      });

      Map<String, dynamic> storage = dietServices.manipulateWaterMonthData(mWaterData);

      storage.entries.forEach((element) {
        //find the length of data in a particular month
        List<WaterData> len = mWaterData.where((waterD) => waterD.month == months[int.parse(element.key)]).toList();
        final barGroup = makeGroupData(int.parse(element.key), 0, returnDoubleInTwoDecimals((double.parse("${element.value}") / len.length)));
        final waterD = new WaterData("id", year, month, day, week, "weekValue", hour, min, months[int.parse(element.key)], "${(element.value / len.length).ceil()}", "", null);
        waterData.add(waterD);
        chartData.add(barGroup);
      });

      returnData["data"] = waterData;
      returnData["chart"] = chartData;

    }

    return returnData;

  }

  double returnDoubleInTwoDecimals(double value) {
    return double.parse(value.toStringAsFixed(2)).ceilToDouble();
  }

  Future<Map<String, dynamic>> getStepsDataInsight(String dataByType) async { //days,weeks,months

    Map<String, dynamic> returnData = new Map();

    List<BarChartGroupData> chartData = [];

    List<WaterData> waterData = [];

    if(dataByType == "Days") {

      if(queryDay == null){ queryDay = await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("steps").where("month", isEqualTo: month).get();}

      if(queryDay.docs.isEmpty) {
        returnData["data"] = [];
        returnData["chart"] = [makeGroupData(0, 0, 0)];
        return returnData;
      }

      queryDay.docs.forEach((element) {
        WaterData wd = WaterData.fromSnapshot(element.data());
        waterData.add(wd);
        final barGroup = makeGroupData(int.parse(wd.day), 0, double.parse(wd.glasses_count));
        chartData.add(barGroup);
      });

      returnData["data"] = waterData;
      returnData["chart"] = chartData;

    }

    if(dataByType == "Weeks") {

      if(queryWeek == null){  queryWeek = await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("steps").where("month", isEqualTo: month).orderBy("timestamp", descending: false).get();}

      if(queryWeek.docs.isEmpty) {
        returnData["data"] = waterData;
        returnData["chart"] = [makeGroupData(0, 0, 0)];
        return returnData;
      }

      List<WaterData> mWaterData = [];

      queryWeek.docs.forEach((element) {
        WaterData wd = WaterData.fromSnapshot(element.data());
        mWaterData.add(wd);
      });

      List<Map<String, dynamic>> result = exerciseService.manipulateStepsWeekData(mWaterData);

      Map<String, dynamic> storage = result[0];
      Map<String, dynamic> weekStorage = result[1];
      Map<String, dynamic> storageCount = result[2];

      storage.entries.forEach((element) {
        final barGroup = makeGroupData(int.parse(element.key), 0, returnDoubleInTwoDecimals((double.parse("${element.value}") / storageCount[element.key])));
        final waterD = new WaterData("id", year, month, day, week, "weekValue", hour, min, weekStorage[element.key], "${(element.value / storageCount[element.key]).ceil()}", "", null);
        waterData.add(waterD);
        chartData.add(barGroup);
      });



      returnData["data"] = waterData;
      returnData["chart"] = chartData;
    }

    if(dataByType == "Months") {

      if(queryMonth == null){  queryMonth = await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("steps").orderBy("timestamp", descending: false).get();}

      if(queryMonth.docs.isEmpty) {
        returnData["data"] = waterData;
        returnData["chart"] = [makeGroupData(0, 0, 0)];
        return returnData;
      }

      List<WaterData> mWaterData = [];

      queryMonth.docs.forEach((element) {
        WaterData wd = WaterData.fromSnapshot(element.data());
        mWaterData.add(wd);
      });

      Map<String, dynamic> storage = exerciseService.manipulateStepsMonthData(mWaterData);

      storage.entries.forEach((element) {
        //find the length of data in a particular month
        List<WaterData> len = mWaterData.where((waterD) => waterD.month == months[int.parse(element.key)]).toList();
        final barGroup = makeGroupData(int.parse(element.key), 0, returnDoubleInTwoDecimals((double.parse("${element.value}") / len.length)));
        final waterD = new WaterData("id", year, month, day, week, "weekValue", hour, min, months[int.parse(element.key)], "${(element.value / len.length).ceil()}", "", null);
        waterData.add(waterD);
        chartData.add(barGroup);
      });

      returnData["data"] = waterData;
      returnData["chart"] = chartData;

    }

    return returnData;

  }

  // convertTimeFormatTo24Hrs(String time, SleepData sleepData) {
  //
  //   List<String> times = time.split(" ");
  //   String ampm = times[1];
  //
  //   List<String> clock = times[0].split(":");
  //
  //   int hour = int.parse(clock[0]);
  //   int min = int.parse(clock[1]);
  //
  //   if(ampm == "PM") {
  //     hour = hour + 12;
  //   }
  //
  //   int mthIndex = months.indexWhere((element) => element == sleepData.month);
  //
  //   DateTime dateTime = new DateTime(int.parse(sleepData.year), (mthIndex + 1), int.parse(sleepData.day),hour, min);
  //   return dateTime;
  // }
}

/*
res.forEach((element) {
        int index = element["index"];
        List<String> data = "${element["data"]}".split("/");
        String title = "${element["title"]}".replaceAll("/", " ").replaceAll("-", " - ");
        String sleepingTime = data[0];
        String bedTime = data[1];
        String wakeupTime = data[2];

        final barGroup = makeGroupData(index, 0, double.parse(sleepingTime));
        chartData.add(barGroup);

        SleepData sd = new SleepData("id", year, month, day, week, "", hour, min, title, bedTime, wakeupTime, "$sleepingTime hrs", null);
        aggregatedSleepData.add(sd);
      });
* */
