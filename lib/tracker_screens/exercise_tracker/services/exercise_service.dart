import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/ListItem/model_challenge.dart';
import 'package:coral_reef/ListItem/model_diet_data.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';
import 'package:location/location.dart';

import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart' as Vector;

class ExerciseService {
  StorageSystem ss = new StorageSystem();

  String year, month, day, week, hour, min;
  final date = DateTime.now();
  final months = [
    "JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG", "SEP","OCT","NOV","DEC"
  ];

  ExerciseService() {
    year = date.year.toString();
    month = months[date.month - 1];
  }

   static double ONE_SECOND = 1000;
   static double SECONDS = 60;
   static double ONE_MINUTE = ONE_SECOND * 60;
   static double MINUTES = 60;
   static double ONE_HOUR = ONE_MINUTE * 60;
   static double HOURS = 24;
   static double ONE_DAY = ONE_HOUR * 24;
   static double ONE_WEEK = ONE_DAY * 7;
   static double ONE_MONTH = ONE_WEEK * 4;
   static double ONE_YEAR = ONE_MONTH * 12;

  updateUserChallengeData(VirtualChallenge ch, double km) async {
    String user_ch_id = await ss.getItem("user_ch_id") ?? "-MaB74f3xFrYfQk1w-ep";

    //update personal user record
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("my-challenges")
        .doc(ch.id)
        .update({
      "km_covered": km,
    });

    //update general record for public view
    await FirebaseFirestore.instance
        .collection("challenges")
        .doc(ch.id)
        .collection("joined-users")
        .doc(user_ch_id)
        .update({
      "km_covered": km,
    });
  }

  updateUserChallengeDataTime(VirtualChallenge ch, int time) async {
    String user_ch_id = await ss.getItem("user_ch_id") ?? "-MaB74f3xFrYfQk1w-ep";

    //update personal user record
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("my-challenges")
        .doc(ch.id)
        .update({
      "time_taken": time,
    });

    //update general record for public view
    await FirebaseFirestore.instance
        .collection("challenges")
        .doc(ch.id)
        .collection("joined-users")
        .doc(user_ch_id)
        .update({
      "time_taken": time,
    });
  }

  static double distance(double lat1, double lat2, double lon1, double lon2) {
    // The math module contains a function
    // named toRadians which converts from
    // degrees to radians.
    lon1 = Vector.radians(lon1);
    lon2 = Vector.radians(lon2);
    lat1 = Vector.radians(lat1);
    lat2 = Vector.radians(lat2);

    // Haversine formula
    double dlon = lon2 - lon1;
    double dlat = lat2 - lat1;
    double a = Math.pow(Math.sin(dlat / 2), 2) +
        Math.cos(lat1) * Math.cos(lat2) * Math.pow(Math.sin(dlon / 2), 2);

    double c = 2 * Math.asin(Math.sqrt(a));

    // Radius of earth in kilometers. Use 3956
    // for miles
    double r = 6371;

    // calculate the result
    String km = (c * r).toStringAsFixed(2);
    return double.parse(km);
  }

  static String formatTimeCovered(DateTime startTime, DateTime endTime) {
    // DateTime today = DateTime.now();

    double diff = endTime.difference(startTime).inMilliseconds.toDouble();

    int days =  (diff / ONE_DAY).floor();
    int hours = ((diff % ONE_DAY) / ONE_HOUR).floor();
    int minutes = ((diff % ONE_HOUR) / ONE_MINUTE).floor();
    int seconds = ((diff % ONE_MINUTE) / ONE_SECOND).floor();


    // return "${dur.inDays}D:${dur.inHours}H:${dur.inMinutes}M:${dur.inSeconds}S";
    return "${days}D:${hours}H:${minutes}M:${seconds}S";



    int diffS = endTime.difference(startTime).inSeconds;
    int diffM = endTime.difference(startTime).inMinutes;
    int diffH = endTime.difference(startTime).inHours;
    int diffD = endTime.difference(startTime).inDays;

    if(diffD > 0) {
      return "${diffD}D:${diffH}H:${diffM}M:${diffS}S"; //""+diffD+"D:$diffH"+"H:$diffM"+"M:$diffS";
    }
    if(diffH > 0) {
      return "0D:${diffH}H:${diffM}M:${diffS}S"; //""+diffD+"D:$diffH"+"H:$diffM"+"M:$diffS";
    }
    if(diffM > 0) {
      return "0D:0H:${diffM}M:${diffS/60}S"; //""+diffD+"D:$diffH"+"H:$diffM"+"M:$diffS";
    }
    if(diffS > 0) {
      return "0D:0H:0M:${diffS}S"; //""+diffD+"D:$diffH"+"H:$diffM"+"M:$diffS";
    }

    return "0D:0H:0M:0S";
  }

  static String formatTimeCoveredBySeconds(double diffInSeconds) {

    diffInSeconds = diffInSeconds * 1000.0;

    int days =  (diffInSeconds / ONE_DAY).floor();
    int hours = ((diffInSeconds % ONE_DAY) / ONE_HOUR).floor();
    int minutes = ((diffInSeconds % ONE_HOUR) / ONE_MINUTE).floor();
    int seconds = ((diffInSeconds % ONE_MINUTE) / ONE_SECOND).floor();

    return "${days}D:${hours}H:${minutes}M:${seconds}S";
  }

  getRequiredTime(LocationData startLocation, VirtualChallenge ch) async { //least_seconds_time_completion

    String user_ch_id = await ss.getItem("user_ch_id");// ?? "-MaB74f3xFrYfQk1w-ep";

    double distanceInMeters = double.parse(ch.distance) * 1000;
    double earth = 6371;  //radius of the earth in kilometer
    double pi = Math.pi;
    double m = (1 / ((2 * pi / 360) * earth)) / 1000;  //1 meter in degree

    double endLatitude = startLocation.latitude + (distanceInMeters * m);

    double endLongitude = startLocation.longitude + (distanceInMeters * m) / Math.cos(startLocation.latitude * (pi / 180));

    String url = "https://us-central1-coraltrackerapp.cloudfunctions.net/getrequiredtime?start_lat=${startLocation.latitude}&start_lng=${startLocation.longitude}&end_lat=$endLatitude&end_lng=$endLongitude";

    http.Response res = await http.get(Uri.parse(url));

    Map<String, dynamic> resp = jsonDecode(res.body);

    dynamic status = resp['status'];

    if(status != null && status == "OK") {
      dynamic result = resp['rows'][0];
      dynamic element = result['elements'][0];
      dynamic _dist = element['distance'];
      dynamic _dur = element['duration'];

      dynamic distance = _dist['value'];
      dynamic duration = _dur['value'];

      //update personal user record
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("my-challenges")
          .doc(ch.id)
          .update({
        "least_seconds_time_completion": duration,
        "least_meters_distance_completion": distance,
      });

      // //update general record for public view
      // await FirebaseFirestore.instance
      //     .collection("challenges")
      //     .doc(ch.id)
      //     .collection("joined-users")
      //     .doc(user_ch_id)
      //     .update({
      //   "least_seconds_time_completion": duration,
      //   "least_meters_distance_completion": distance,
      // });

    }


  }

  logActivity(VirtualChallenge ch, String text) async {

    //get user data
    String localUser = await ss.getItem('user');
    Map<String, dynamic> json = jsonDecode(localUser);

    String image = (json["picture"] == "") ? "https://firebasestorage.googleapis.com/v0/b/coraltrackerapp.appspot.com/o/default_avatar.png?alt=media&token=f7fcf422-1853-4c7c-9b3a-bb5204c3a94f" : json["picture"];

    String id = FirebaseDatabase.instance.reference().push().key;
    VirtualChallengeActivities vca = new VirtualChallengeActivities(id, user.uid, "stat", "${json["firstname"]} ${json["lastname"]} $text", image, new DateTime.now().toString(), FieldValue.serverTimestamp(), ch.msgId);
    await FirebaseFirestore.instance.collection("challenges").doc(ch.id).collection("activities").doc(id).set(vca.toJSON());

  }

  Future<void> saveStepsGoal(String goal) async {
    await ss.setPrefItem("stepsGoal", goal);
  }

  Future<void> updateStepsTakenCount(int value, int goal) async {

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

    await ss.setPrefItem("stepsCurrent_$formatDate", "$value");

    await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("steps").doc(id).set(wd.toJSON());

  }

  Map<String, dynamic> manipulateStepsMonthData(List<WaterData> waterData) {
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

  List<Map<String, dynamic>> manipulateStepsWeekData(List<WaterData> mWaterData) {
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