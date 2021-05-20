import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/size_config.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/components/exercise_scrolling_options.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/insight_steps.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/steps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class ExerciseInsight extends StatefulWidget {
  static final routeName = "exerciseInsight";
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<ExerciseInsight> {
  List<Map<String, dynamic>> screens = [
    {
      "screen_name": "Steps",
      "screen_route": "insightSteps",
      "screen_class": InsightSteps()
    },
    {
      "screen_name": "Pregnancy tracker",
      "screen_route": "pregnancy-tracker-screen",
      "screen_class": InsightSteps()
    },
    {
      "screen_name": "Diet tracker",
      "screen_route": "diet-tracker-screen",
      "screen_class": InsightSteps()
    },
    {
      "screen_name": "Exercise tracker",
      "screen_route": "exercise-tracker-screen",
      "screen_class": InsightSteps()
    },
    {
      "screen_name": "Well-being tracker",
      "screen_route": "well-being-tracker-screen",
      "screen_class": InsightSteps()
    },
  ];

  Widget selectedScreen = InsightSteps(); //diet class first

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios)),
              Text(
                'Insights',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: getProportionateScreenWidth(15),
                    ),
              ),
              Text('')
            ],
          ),
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(10)),
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: ExerciseScrollingOptions(
                    onSelectedMenu: (String selectedMenu) {
                      getTrackerScreen(selectedMenu);
                    },
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 100.0), child: selectedScreen),
              ],
            )));
  }

  void getTrackerScreen(String selectedMenu) {
    print(selectedMenu);
    Map<String, dynamic> findScreen =
        screens.firstWhere((element) => element["screen_name"] == selectedMenu);
    if (findScreen == null) {
      return;
    }
    String route = findScreen["screen_route"];
    print(route);
    if (selectedMenu == "insightSteps" ||
        selectedMenu == "Exercise tracker" ||
        selectedMenu == "Well-being tracker") {}
    print("ok");
    setState(() {
      selectedScreen = findScreen["screen_class"];
    });
    // Navigator.pushNamed(context, route);
    //select the class
  }
}
