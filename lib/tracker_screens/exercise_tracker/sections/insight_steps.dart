import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/size_config.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/components/insight_card.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/all_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class InsightSteps extends StatefulWidget {
  static final routeName = "insightSteps";
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<InsightSteps> {
  double steps = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            padding: EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ToggleSwitch(
                        minWidth: 90.0,
                        minHeight: 40.0,
                        fontSize: 16.0,
                        initialLabelIndex: 1,
                        activeBgColor: Color(MyColors.primaryColor),
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.white,
                        inactiveFgColor: Color(MyColors.primaryColor),
                        labels: ['7 days', '1 Month', '1 Year'],
                        onToggle: (index) {
                          print('switched to: $index');
                        },
                      ),
                      SizedBox(
                        height: 80,
                      ),
                      ExerciseInsightCard(),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                          width: 150,
                          child: Button2(
                            text: 'See all data',
                            press: () {
                              Navigator.pushNamed(context, AllData.routeName);
                            },
                          ))
                    ],
                  )
                ])));
  }
}
