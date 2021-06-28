import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/ListItem/model_challenge.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/constants.dart';
import 'package:coral_reef/services/step_service.dart';
import 'package:coral_reef/tracker_screens/diet_tracker_screen/components/calories_slider.dart';
import 'package:coral_reef/tracker_screens/diet_tracker_screen/components/diet_summary_card.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/components/exercise_slider.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/components/exercise_summary_card.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/steps.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/track_activities.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/services/exercise_service.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/view_models/step_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:health/health.dart';
import 'package:neat_periodic_task/neat_periodic_task.dart';
import 'package:pedometer/pedometer.dart';
import 'package:stacked/stacked.dart';
import 'dart:async';
import 'dart:io';

import '../../../locator.dart';
import '../../../size_config.dart';

class PopulateExerciseSummary extends StatefulWidget {

  final String stepCount;
  PopulateExerciseSummary({this.stepCount = "0"});
  @override
  State<StatefulWidget> createState() => _PopulateDietSummary();
}

class _PopulateDietSummary extends State<PopulateExerciseSummary> {

  double totalKm = 0.0;
  int totalChallenge = 0;

  String stepsGoal = "0", currentTakenSteps = "0";

  ExerciseService exerciseService;

  StorageSystem ss = new StorageSystem();

  StepService stepService;

  NeatPeriodicTaskScheduler scheduler;

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
        // print("Data point: $x");
        steps += x.value.round();
      });

      String goal = await ss.getItem("stepsGoal") ?? "0";
      new ExerciseService().updateStepsTakenCount(steps, double.parse(goal).ceil(), today);

      // print("Steps: $steps");
    } else {
      print("Authorization not granted");
    }
  }
  //
  // Stream<ActivityEvent> activityStream;
  // ActivityEvent latestActivity = ActivityEvent.empty();
  // List<ActivityEvent> _events = [];
  // ActivityRecognition activityRecognition = ActivityRecognition.instance;
  //
  // void _startTracking() {
  //   activityStream =
  //       activityRecognition.startStream(runForegroundService: true);
  //   activityStream.listen(onData);
  // }
  //
  //
  // void onData(ActivityEvent activityEvent) {
  //   print(activityEvent.toString());
  //   setState(() {
  //     _events.add(activityEvent);
  //     latestActivity = activityEvent;
  //   });
  // }

  setupSteps() {
    scheduler = NeatPeriodicTaskScheduler(
        name: "coral-app-steps-counter",
        interval: Duration(seconds: 10),
        timeout: Duration(seconds: 5),
        task: () async {
          if(Platform.isIOS) {
            fetchData();
          }
          getStepsLocalData();
          return;
        },
        minCycle: Duration(seconds: 5)
    );
    scheduler.start();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(scheduler != null) {
      scheduler.stop();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _startTracking();
    exerciseService = new ExerciseService();
    getStepsLocalData();
    setupSteps();
    getChallenges();
    // stepService = new StepService(stepCallback: (steps) {
    //   print("hello word = $steps");
    //   setState(() {
    //     currentTakenSteps = steps;
    //   });
    // });
  }

  getStepsLocalData() async {
    final date = DateTime.now();
    final months = ["JAN", "FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];

    String formatDate = "${date.year}_${months[date.month - 1]}_${date.day}";

    String goal = await ss.getItem("stepsGoal") ?? "0";
    String current = await ss.getItem("stepsCurrent_$formatDate") ?? "0";

    if(!mounted) return;
    setState(() {
      stepsGoal = goal;
      currentTakenSteps = current;
    });
  }

  getChallenges() async {

    QuerySnapshot query = await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("my-challenges").get();
    if(query.docs.isEmpty) return;

    if(!mounted) return;
    setState(() {
      totalChallenge = query.docs.length;
    });

    query.docs.forEach((chan) {
      Map<String, dynamic> ch = chan.data();
      totalKm += (ch["km_covered"] == null) ? 0.0 : ch["km_covered"];
    });

    if(!mounted) return;
    setState(() {
      totalKm = double.parse(totalKm.toStringAsFixed(2));
    });
  }

  double getPointerValue() {
    return ((double.parse(currentTakenSteps) / double.parse(stepsGoal)) * 100);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StepViewModel>.reactive(
        viewModelBuilder: () => StepViewModel(),
        onModelReady: (viewModel) {
          viewModel.currentStep();
        },
        builder: (context, model, child) {
          if(mounted) {
            model.currentStep();
          }
          return Row(
            children: [
              ExerciseSummaryCard(
                title: 'Steps',
                icon: 'assets/exercise/foot_white.svg',
                title2: '',
                title3: currentTakenSteps, //model.steps,
                title4: "Goal: $stepsGoal",//"Goal: ${model.stepsGoal.floor().toString()}",
                textColor: Colors.white,
                press: () async {
                  //go to well-being setup screen
                  await Navigator.pushNamed(context, Steps.routeName);
                  getStepsLocalData();
                  // Navigator.pushNamed(context, SleepScreen.routeName);
                },
                color: Color(MyColors.primaryColor),
                child: CaloriesSlider(getPointerValue(), icon: "assets/exercise/foot_white.svg", text: "", height: 40.0,), //ExerciseSlider(),
              ),
              SizedBox(width: SizeConfig.screenWidth * 0.03),
              ExerciseSummaryCard(
                title: 'Track activities',
                icon: 'assets/exercise/race_track.svg',
                title2: '',
                title3: 'Activities: $totalChallenge',
                title4: 'Total km: $totalKm',
                textColor: Color(MyColors.primaryColor),
                press: () {
                  // Navigator.pushNamed(context, TrackActivities.routeName);
                },
                color: Colors.purpleAccent.withOpacity(0.1),
                child: SvgPicture.asset(
                  "assets/exercise/race_track.svg",
                  height: 100,
                  color: Color(MyColors.primaryColor),
                ),
              ),
            ],
          );
        });
  }
}
