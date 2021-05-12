import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/tracker_screens/diet_tracker_screen/components/calories_slider.dart';
import 'package:coral_reef/tracker_screens/diet_tracker_screen/components/diet_summary_card.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/components/exercise_slider.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/components/exercise_summary_card.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/steps.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/track_activities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pedometer/pedometer.dart';
import 'dart:async';

import '../../../size_config.dart';

class PopulateExerciseSummary extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PopulateDietSummary();
}

class _PopulateDietSummary extends State<PopulateExerciseSummary> {
  String formatDate(DateTime d) {
    return d.toString().substring(0, 19);
  }
   Stream<StepCount> _stepCountStream;
   Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ExerciseSummaryCard(
          title: 'Steps',
          icon: 'assets/exercise/foot_white.svg',
          title2: '',
          title3: _steps,
          title4: 'Goal: 10000',
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
  }
}
