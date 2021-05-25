
import 'dart:async';
import 'dart:convert';

import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

class TrackStepService {

  BuildContext context;
  Stream<StepCount> _stepCountStream;
  Stream<PedestrianStatus> _pedestrianStatusStream;

  StreamSubscription<StepCount> stepStreamSubscription;
  StreamSubscription<PedestrianStatus> statusStreamSubscription;

  final Function(int stepCount, double km, DateTime timeStamp) onStepChange;

  StorageSystem ss;

  TrackStepService(BuildContext context, {this.onStepChange}) {
    ss = new StorageSystem();
    this.context = context;
    initPlatformState();
  }

  void stopCounting() {
    stepStreamSubscription.cancel();
    statusStreamSubscription.cancel();
  }

  void pauseCounting() {
    stepStreamSubscription.pause();
    statusStreamSubscription.pause();
  }

  void resumeCounting() {
    stepStreamSubscription.resume();
    statusStreamSubscription.resume();
  }

  void onStepCount(StepCount event) {
    /// Handle step count changed
    int steps = event.steps;
    DateTime timeStamp = event.timeStamp;

    // print("onStep number: $steps");
    // new GeneralUtils().showToast(context, "onStep number: $steps");
    //calculate km based on steps
    double distance = double.parse(((steps.toDouble() * 78) / 100000).toStringAsFixed(2));

    onStepChange(steps, distance, timeStamp);
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    /// Handle status changed
    String status = event.status;
    DateTime timeStamp = event.timeStamp;

    print("onPedestrianStatusChanged status: $status");
  }

  void onPedestrianStatusError(error) {
    /// Handle the error
    print("status error: $error");
  }

  void onStepCountError(error) {
    /// Handle the error
    print("step count error: $error");
  }

  void initPlatformState() {
    print("initPlatformState for steps");
    /// Init streams
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _stepCountStream = Pedometer.stepCountStream;

    /// Listen to streams and handle errors
    stepStreamSubscription = _stepCountStream.listen(onStepCount);
    stepStreamSubscription.onError(onStepCountError);

    statusStreamSubscription = _pedestrianStatusStream.listen(onPedestrianStatusChanged);
    statusStreamSubscription.onError(onPedestrianStatusError);
  }

  Future<String> calculateDistance(int steps) async {
    String dewRecord = await ss.getItem("dewRecord");
    String heightMetric = await ss.getItem("height_metric");

    double heightValue = (heightMetric == "ft") ? 0.3937007871 : 1.0;

    Map<String, dynamic> json = jsonDecode(dewRecord);
    double height = json["3"];
    print("height is $height");

    double heightCalc = height / heightValue;

    double heightCalcFinal = 0;

    if(heightCalc < 120) {
      heightCalcFinal = heightCalc;
    }
    if(heightCalc >= 120) {
      heightCalcFinal = heightCalc * 0.414;
    }

    // double distance = steps.toDouble() *;
    return "";
  }
}