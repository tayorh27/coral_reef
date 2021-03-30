import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/shared_screens/tracker_screen_header.dart';
import 'package:coral_reef/tracker_screens/period_tracker/period_tracker_screen.dart';
import 'package:flutter/material.dart';

import '../size_config.dart';
import 'components/tracker_scrolling_options.dart';

class TrackerLanding extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TrackerLanding();
}

class _TrackerLanding extends State<TrackerLanding> {

  List<Map<String,dynamic>> screens = [
    {"screen_name": "Period tracker", "screen_route": "period-tracker-screen", "screen_class":PeriodTrackerScreen()},
    {"screen_name": "Pregnancy tracker", "screen_route": "pregnancy-tracker-screen", "screen_class":PeriodTrackerScreen()},
    {"screen_name": "Diet tracker", "screen_route": "diet-tracker-screen", "screen_class":PeriodTrackerScreen()},
    {"screen_name": "Exercise tracker", "screen_route": "exercise-tracker-screen", "screen_class":PeriodTrackerScreen()},
    {"screen_name": "Well-being tracker", "screen_route": "well-being-tracker-screen", "screen_class":PeriodTrackerScreen()},
  ];

  Widget selectedScreen = Text("");//diet class first

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Text(''),
          toolbarHeight: 20.0,
        ),
        body: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
          child: Stack(
            children: [
              TrackerScreenHeader(),
              Container(
                margin: EdgeInsets.only(top: 100.0),
                child: TrackerScrollingOptions(onSelectedMenu: (String selectedMenu, bool hasWellnessRecord) {
                  getTrackerScreen(selectedMenu, hasWellnessRecord);
                },),
              ),
              Container(
                margin: EdgeInsets.only(top: 160.0),
                child: SingleChildScrollView(
                    child: selectedScreen
                ),
              )
            ],
          ),
        ));
  }

  /*
   * get the tracker screen to display once the user selects a tracker item
   * if no wellness record found, user goes to wellness setup screen
   */
  getTrackerScreen(String selectedMenu, bool hasWellnessRecord) {
    print(selectedMenu);
    Map<String, dynamic> findScreen = screens.firstWhere((element) => element["screen_name"] == selectedMenu);
    if(findScreen == null) {
      return;
    }
    String route = findScreen["screen_route"];
    print(route);
    // if(selectedMenu != "Period tracker" || selectedMenu != "Pregnancy tracker") {
    //   print("nott");
    //   if(!hasWellnessRecord) {
    //     //go to well-being setup screen
    //     return;
    //   }
    // }
    setState(() {
      selectedScreen = findScreen["screen_class"];
    });
    // Navigator.pushNamed(context, route);
    //select the class
  }
}
