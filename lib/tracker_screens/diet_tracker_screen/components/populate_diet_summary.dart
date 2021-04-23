import 'package:coral_reef/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../size_config.dart';
import 'calories_slider.dart';
import 'diet_summary_card.dart';

class PopulateDietSummary extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PopulateDietSummary();
}

class _PopulateDietSummary extends State<PopulateDietSummary> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DietSummaryCard(
            title: 'Calories',
            icon: 'assets/well_being/arc.svg',
            title2: '',
            title3: '1,400 kcal',
            title4: 'Goal: 2,230 kcal',
            textColor: Colors.white,
            press: () {
              // Navigator.pushNamed(context, SleepScreen.routeName);
            },
            color: Color(MyColors.primaryColor),
            child: CaloriesSlider(),
        ),
        SizedBox(width: SizeConfig.screenWidth * 0.03),
        DietSummaryCard(
            title: 'Weight',
            icon: 'assets/diet/Shape.svg',
            title2: '',
            title3: '70 kg',
            title4: 'Goal: 60 kg',
            textColor: Color(MyColors.primaryColor),
            press: () {
              // Navigator.pushNamed(context, MoodScreen.routeName);
            },
            color: Colors.purpleAccent.withOpacity(0.1),
          child: SvgPicture.asset("assets/diet/Shape.svg", height: 100,color: Color(MyColors.primaryColor),),
        ),

      ],
    );
  }
}