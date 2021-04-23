import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/tracker_screens/well_being_tracker/components/sleep_mood_cards.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';

class PopulateCardTiles extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PopulateCardTiles();
}

class _PopulateCardTiles extends State<PopulateCardTiles> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SleepMoodCard(
            title: 'Sleep',
            icon: 'assets/well_being/arc.svg',
            title2: '',
            title3: '',
            title4: '6hrs',
            press: () {
              // Navigator.pushNamed(context, SleepScreen.routeName);
            },
            color: Color(MyColors.primaryColor)),
        SizedBox(width: SizeConfig.screenWidth * 0.03),
        SleepMoodCard(
            title: 'Mood',
            icon: 'assets/well_being/happy.svg',
            title2: '',
            title3: 'Current Mood',
            title4: 'Happy',
            press: () {
              // Navigator.pushNamed(context, MoodScreen.routeName);
            },
            color: Color(MyColors.stroke1Color)),

      ],
    );
  }
}