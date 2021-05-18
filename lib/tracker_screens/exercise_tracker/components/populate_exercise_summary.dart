import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/services/step_service.dart';
import 'package:coral_reef/tracker_screens/diet_tracker_screen/components/calories_slider.dart';
import 'package:coral_reef/tracker_screens/diet_tracker_screen/components/diet_summary_card.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/components/exercise_slider.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/components/exercise_summary_card.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/steps.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/track_activities.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/view%20models/step_view_model.dart';
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
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StepViewModel>.reactive(
        viewModelBuilder: () => StepViewModel(),
        onModelReady: (viewModel) {
          viewModel.currentStep();
        },
        builder: (context, model, child) {
          model.currentStep();
          return Row(
            children: [
              ExerciseSummaryCard(
                title: 'Steps',
                icon: 'assets/exercise/foot_white.svg',
                title2: '',
                title3: model.steps,
                title4: model.stepsGoal.floor().toString(),
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
                title3: 'Activities: 3',
                title4: 'Total km: 16.09',
                textColor: Color(MyColors.primaryColor),
                press: () {
                  Navigator.pushNamed(context, TrackActivities.routeName);
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
