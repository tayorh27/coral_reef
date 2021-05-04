import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/tracker_screens/diet_tracker_screen/components/calories_slider.dart';
import 'package:coral_reef/tracker_screens/diet_tracker_screen/components/diet_summary_card.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/components/exercise_slider.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/components/exercise_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../size_config.dart';


class PopulateExerciseSummary extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PopulateDietSummary();
}

class _PopulateDietSummary extends State<PopulateExerciseSummary> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ExerciseSummaryCard(
            title: 'Steps',
            icon: 'assets/exercise/foot_white.svg',
            title2: '',
            title3: '6,400',
            title4: 'Goal: 10000',
            textColor: Colors.white,
            press: () {
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
              // Navigator.pushNamed(context, MoodScreen.routeName);
            },
            color: Colors.purpleAccent.withOpacity(0.1),
          child: SvgPicture.asset("assets/exercise/race_track.svg", height: 100,color: Color(MyColors.primaryColor),),
        ),

      ],
    );
  }
}