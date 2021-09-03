
import 'dart:convert';
import 'dart:io';

import 'package:coral_reef/Utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:location/location.dart';

import 'exercise_service.dart';

class MyChallengeService {

  BuildContext context;
  StorageSystem ss;
  String currentTakenSteps = "0";

  MyChallengeService(BuildContext context) {
    ss = new StorageSystem();
    this.context = context;
    initPlatformState();
  }

  List<HealthDataPoint> _healthDataList = [];

  Future<void> fetchData() async {
    /// Get everything from midnight until now
    final today = DateTime.now();
    DateTime startDate = DateTime(today.year, today.month, today.day, 0, 0, 0);
    DateTime endDate = DateTime(today.year, today.month, today.day, 23, 59, 59);

    HealthFactory health = HealthFactory();

    /// Define the types to get.
    List<HealthDataType> types = [
      HealthDataType.STEPS,
      // HealthDataType.WEIGHT,
      // HealthDataType.HEIGHT,
      // HealthDataType.BLOOD_GLUCOSE,
      // HealthDataType.DISTANCE_WALKING_RUNNING,
    ];

    /// You MUST request access to the data types before reading them
    bool accessWasGranted = await health.requestAuthorization(types);

    int steps = 0;

    if (accessWasGranted) {
      try {
        /// Fetch new data
        List<HealthDataPoint> healthData =
        await health.getHealthDataFromTypes(startDate, endDate, types);

        /// Save all the new data points
        _healthDataList.addAll(healthData);
      } catch (e) {
        print("Caught exception in getHealthDataFromTypes: $e");
      }

      /// Filter out duplicates
      _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

      /// Print the results
      _healthDataList.forEach((x) {
        steps += x.value.round();
      });
      // print("Data point: $steps");

      String goal = await ss.getItem("stepsGoal") ?? "0";
      currentTakenSteps = steps.toString();
      // await new ExerciseService()
      //     .updateStepsTakenCount(steps, double.parse(goal).ceil(), today);

      // print("Steps: $steps");
    } else {
      print("Authorization not granted");
    }
  }

  getStepsLocalData() async {
    final date = DateTime.now();
    final months = [
      "JAN",
      "FEB",
      "MAR",
      "APR",
      "MAY",
      "JUN",
      "JUL",
      "AUG",
      "SEP",
      "OCT",
      "NOV",
      "DEC"
    ];

    String formatDate = "${date.year}_${months[date.month - 1]}_${date.day}";

    String goal = await ss.getItem("stepsGoal") ?? "0";
    String current = await ss.getItem("stepsCurrent_$formatDate") ?? "0";
    // String current = await ss.getItem("challengeStepsCurrent_$formatDate") ?? "0";

    currentTakenSteps = current;
  }

  Future<String> initPlatformState() async {
    if (Platform.isIOS) {
      await fetchData();
    }
    await getStepsLocalData();
    return currentTakenSteps;
  }

  //temporary solution
  Future<Map<String, dynamic>> getCurrentSteps() async {
    String startSteps = await ss.getItem("startSteps"); //2000
    String getCurrentSteps = await initPlatformState(); //3000 or 200

    int sss = int.parse(startSteps);
    int gcs = int.parse(getCurrentSteps);

    int calculatedSteps = 0;

    calculatedSteps = gcs - sss;

    // String onPaused = await ss.getItem("pausedSteps") ?? "0";
    // String onResumed = await ss.getItem("resumedSteps") ?? "0";
    //
    // print("calculatedSteps = $calculatedSteps");
    // print("onPaused = $onPaused");
    // print("onResumed = $onResumed");
    //
    // int onP = int.parse(onPaused);
    // int onR = int.parse(onResumed);
    //
    // calculatedSteps = (calculatedSteps - onR) + onP;

    // =======================================================

    // if(gcs > sss) {
    //   calculatedSteps = gcs - sss;
    // }else {
    //   calculatedSteps = gcs + sss;
    // }
    double distance = double.parse(((calculatedSteps.toDouble() * 78) / 100000).toStringAsFixed(2));

    if(distance < 0) {
      distance = distance * -1;
      calculatedSteps = calculatedSteps * -1;
    }

    Map<String, dynamic> data = new Map();
    data["steps"] = calculatedSteps;
    data["distance"] = distance;

    return data;

  }

  Future<double> calculateGPSDistance(LocationData currentLocation) async {

    String cp = await ss.getItem("currentPosition");
    if(cp == null) return 0.00;

    Map<String, dynamic> lastKnownLocation = jsonDecode(cp);
    double lat = lastKnownLocation["latitude"];
    double lng = lastKnownLocation["longitude"];

    String currentKm = await ss.getItem("currentKm") ?? "0.00";
    double dCurrentKm = double.parse(currentKm);

    double distance = ExerciseService.distance(lat, currentLocation.latitude, lng, currentLocation.longitude);

    double total = dCurrentKm + distance;

    await saveCurrentPosition(currentLocation);
    await ss.setPrefItem("currentKm", "$total", isStoreOnline: false);

    return double.parse(total.toStringAsFixed(2));
  }

  Future<void> saveCurrentPosition(LocationData _currentLocation) async {
    Map<String, dynamic> userLocation = new Map();
    userLocation["latitude"] = _currentLocation.latitude;
    userLocation["longitude"] = _currentLocation.longitude;
    await ss.setPrefItem("currentPosition", jsonEncode(userLocation), isStoreOnline: false);
  }


  Future<double> calculateActivityGPSDistance(LocationData currentLocation) async {

    String cp = await ss.getItem("activityCurrentPosition");
    if(cp == null) return 0.00;

    Map<String, dynamic> lastKnownLocation = jsonDecode(cp);
    double lat = lastKnownLocation["latitude"];
    double lng = lastKnownLocation["longitude"];

    String currentKm = await ss.getItem("activityCurrentKm") ?? "0.00";
    double dCurrentKm = double.parse(currentKm);

    double distance = ExerciseService.distance(lat, currentLocation.latitude, lng, currentLocation.longitude);

    double total = dCurrentKm + distance;

    await saveActivityCurrentPosition(currentLocation);
    await ss.setPrefItem("activityCurrentKm", "$total", isStoreOnline: false);

    return double.parse(total.toStringAsFixed(2));
  }

  Future<void> saveActivityCurrentPosition(LocationData _currentLocation) async {
    Map<String, dynamic> userLocation = new Map();
    userLocation["latitude"] = _currentLocation.latitude;
    userLocation["longitude"] = _currentLocation.longitude;
    await ss.setPrefItem("activityCurrentPosition", jsonEncode(userLocation), isStoreOnline: false);
  }
}