import 'dart:async';

import 'package:coral_reef/Utils/helpers.dart';
import 'package:coral_reef/baseModel.dart';
import 'package:coral_reef/locator.dart';
import 'package:coral_reef/models/step_goal_model.dart';
import 'package:coral_reef/services/step_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';

import '../../../Utils/colors.dart';
import '../../../Utils/storage.dart';
import '../../../services/step_service.dart';

class StepViewModel extends BaseModel {
  final StepService _stepService = locator<StepService>();

  double stepsGoal = 0;
  String steps = '0';
  var status;
  int selectedIndex = 0;
  StorageSystem ss = new StorageSystem();

  //final User user = auth.currentUser;
  String formatDate(DateTime d) {
    return d.toString().substring(0, 19);
  }

  final elements = [
    "5000",
    "6000",
    "7000",
    "8000",
    "9000",
    "10000",
    "11000",
    "12000",
    "13000",
    "14000",
    "15000",
    "16000",
    "17000",
    "18000",
    "19000",
    "20000",
    "22000",
    "25000",
    "28000",
    "30000",
    "33000",
    "35000",
    "38000",
    "40000",
  ];

  Stream<StepCount> _stepCountStream;
  Stream<PedestrianStatus> _pedestrianStatusStream;

  StreamSubscription<StepCount> stepStreamSubscription;
  StreamSubscription<PedestrianStatus> statusStreamSubscription;

  //final Function(int stepCount, double km, DateTime timeStamp) onStepChange;

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

  onStepCount(StepCount event) {
    /// Handle step count changed
    //int steps = event.steps;

    steps = event.steps.toString();
    DateTime timeStamp = event.timeStamp;

    // print("onStep number: $steps");
    // new GeneralUtils().showToast(context, "onStep number: $steps");
    //calculate km based on steps
    double distance =
        double.parse(((double.parse(steps) * 78) / 100000).toStringAsFixed(2));

    //onStepChange(steps, distance, timeStamp);
    return event;
  }

  getSt(){
    _stepService.initPlatformState();
 steps =   _stepService.steps;
 print('PRINT:::::::::::::::::::::::::::::::::::::::');
 print(steps);
 notifyListeners();
 return steps;
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

    statusStreamSubscription =
        _pedestrianStatusStream.listen(onPedestrianStatusChanged);
    statusStreamSubscription.onError(onPedestrianStatusError);
  }

  currentStep() {
    getStepsGoal();
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    //notifyListeners();
  }

  var outputFormat = DateFormat('dd MMM yyyy hh:mm a');

  List<Widget> buildItems1() {
    return elements
        .map((val) => MySelectionItem(
              title: val,
            ))
        .toList();
  }

  setStepGoal(StepGoalModel stepGoalModel, String step) async {
    bool result = await _stepService.saveSteps(stepGoalModel.toJson());
    if (result == false) {
      showToast('Failed to save, kindly try again');
      print(result);
      //notifyListeners();
      return false;
    }
    if (result == true) {
      print(result);
      showToast('Successfully saved');
      ss.setPrefItem('stepGoal', step);
      currentStep();
      getStepsGoal();
      //notifyListeners();
      return true;
    }
  }

  getStepsGoal() async {
    var stepStorage = await ss.getItem('stepGoal');
    if (stepStorage != null) {
      stepsGoal = double.parse(stepStorage);
      notifyListeners();
      return stepsGoal;
    } else {
      var goal = await _stepService.getSteps();
      if (goal != null) {
        stepsGoal = double.parse(goal);
      } else {
        stepsGoal = 0;
        notifyListeners();
      }
      //
      return stepsGoal;
    }
  }
}

class MySelectionItem extends StatelessWidget {
  final String title;
  final bool isForList;

  const MySelectionItem({Key key, this.title, this.isForList = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child: isForList
          ? Padding(
              child: _buildItem(context),
              padding: EdgeInsets.all(10.0),
            )
          : Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: Stack(
                children: <Widget>[
                  _buildItem(context),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.arrow_drop_down),
                  )
                ],
              ),
            ),
    );
  }

  Widget _buildItem(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: FittedBox(
          child: Text(
        title,
        style: TextStyle(
            color: Color(MyColors.primaryColor).withOpacity(0.8),
            fontWeight: FontWeight.w500,
            fontSize: 30),
      )),
    );
  }
}
