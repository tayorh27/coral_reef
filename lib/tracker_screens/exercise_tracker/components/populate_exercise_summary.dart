import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/ListItem/model_challenge.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/constants.dart';
import 'package:coral_reef/services/step_service.dart';
import 'package:coral_reef/tracker_screens/diet_tracker_screen/components/calories_slider.dart';
import 'package:coral_reef/tracker_screens/diet_tracker_screen/components/diet_summary_card.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/components/exercise_slider.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/components/exercise_summary_card.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/steps.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/track_a.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/track_activities.dart';
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
  final StepService _stepService = locator<StepService>();
  double totalKm = 0.0;
  int totalChallenge = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChallenges();
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
                title3: model.getSt(),
                title4: "Goal: ${model.stepsGoal.floor().toString()}",
                textColor: Colors.white,
                press: () {
                  //go to well-being setup screen
                  Navigator.pushNamed(context, Steps.routeName);
                  // Navigator.pushNamed(context, SleepScreen.routeName);
                },
                color: Color(MyColors.primaryColor),
                child: ExerciseSlider(),
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
                  Navigator.pushNamed(context, TrackActivity.routeName);
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
