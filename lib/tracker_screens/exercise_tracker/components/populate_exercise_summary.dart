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
import 'package:pedometer/pedometer.dart';
import 'package:stacked/stacked.dart';
import 'dart:async';

import '../../../locator.dart';
import '../../../size_config.dart';

class PopulateExerciseSummary extends StatefulWidget {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    exerciseService = new ExerciseService();
    getStepsLocalData();
    getChallenges();
    stepService = new StepService(stepCallback: (steps) {
      print("hello word = $steps");
      setState(() {
        currentTakenSteps = steps;
      });
    });
  }

  getStepsLocalData() async {
    final date = DateTime.now();
    final months = ["JAN", "FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];

    String formatDate = "${date.year}_${months[date.month - 1]}_${date.day}";

    String goal = await ss.getItem("stepsGoal") ?? "0";
    String current = await ss.getItem("stepsCurrent_$formatDate") ?? "0";

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
      setState(() {
        totalKm += (ch["km_covered"] == null) ? 0.0 : ch["km_covered"];
      });
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
                title3: currentTakenSteps, //model.steps
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
