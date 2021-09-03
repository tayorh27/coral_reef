import 'dart:io';

import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/shared_screens/tracker_screen_header.dart';
import 'package:coral_reef/tracker_screens/period_tracker/period_tracker_screen.dart';
import 'package:coral_reef/tracker_screens/pregnancy_tracker/pregnancy_tracker_screen.dart';
import 'package:coral_reef/tracker_screens/well_being_tracker/well_being_tracker_screen.dart';
import 'package:coral_reef/wellness/diet_exercise_well_being/diet_exercise_well_being_info.dart';
import 'package:coral_reef/wellness/wellness_tracker_options.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../size_config.dart';
import 'components/tracker_scrolling_options.dart';
import 'diet_tracker_screen/diet_tracker_screen.dart';
import 'exercise_tracker/exercise_tracker_screen.dart';

class TrackerLanding extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TrackerLanding();
}

class _TrackerLanding extends State<TrackerLanding> {

  List<Map<String,dynamic>> screens = [
    {"screen_name": "Period tracker", "screen_route": "period-tracker-screen", "screen_class":PeriodTrackerScreen()},
    {"screen_name": "Pregnancy tracker", "screen_route": "pregnancy-tracker-screen", "screen_class":PregnancyTrackerScreen()},
    {"screen_name": "Diet tracker", "screen_route": "diet-tracker-screen", "screen_class":DietTrackerScreen()},
    {"screen_name": "Exercise tracker", "screen_route": "exercise-tracker-screen", "screen_class":ExerciseTrackerScreen()},
    {"screen_name": "Well-being tracker", "screen_route": "well-being-tracker-screen", "screen_class":WellBeingTrackerScreen()},
  ];

  Widget selectedScreen = DietTrackerScreen();//diet class first

  StorageSystem ss = new StorageSystem();

  String screenRoute = "diet-tracker-screen";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupPhysicalActivityTracking();
  }

  setupPhysicalActivityTracking() async {
    // String startTime = await ss.getItem("startTime");
    // DateTime st = DateTime.parse(startTime);
    if(Platform.isAndroid) {
      if (await Permission.activityRecognition
          .request()
          .isGranted) {
        print("Request granted");
      }
    }else {
      if (await Permission.sensors
          .request()
          .isGranted) {
        print("Request granted");
      }
    }
  }

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
                child: TrackerScrollingOptions(onSelectedMenu: (String selectedMenu, bool hasWellnessRecord, bool hasDewRecord) {
                  getTrackerScreen(selectedMenu, hasWellnessRecord, hasDewRecord);
                },),
              ),
              Container(
                margin: EdgeInsets.only(top: 160.0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView (
                    child: selectedScreen
                    // PageView.builder(
                    //       onPageChanged: (value) {
                    //         Map<String, dynamic> screen = screens[value];
                    //         setState(() {
                    //           screenRoute = screen["screen_route"];
                    //           selectedScreen = screen["screen_class"];
                    //         });
                    //       },
                    //       itemCount: screens.length,
                    //       itemBuilder: (context, index) {
                    //         return selectedScreen;
                    //   }),
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
  void getTrackerScreen(String selectedMenu, bool hasWellnessRecord, bool hasDewRecord) async {
    print(selectedMenu);
    Map<String, dynamic> findScreen = screens.firstWhere((element) => element["screen_name"] == selectedMenu);
    if(findScreen == null) {
      return;
    }
    String route = findScreen["screen_route"];
    print(route);
    if(selectedMenu == "Diet tracker" || selectedMenu == "Exercise tracker" || selectedMenu == "Well-being tracker") {
      if(!hasDewRecord) {
        //go to well-being setup screen
        Navigator.pushNamed(context, DietExerciseWellBeingInfo.routeName);//change to diet info
        return;
      }
    }
    print("ok");
    if(selectedMenu == "Period tracker") {
      String periodRecord = await ss.getItem("periodRecord");
      if(periodRecord == null) {
        //go to well-being setup screen
        new GeneralUtils().showToast(context, "Please setup your period tracker.");
        Navigator.pushNamed(context, WellnessTrackerOptions.routeName);//change to diet info
        return;
      }
    }

    if(selectedMenu == "Pregnancy tracker") {
      String pregnancyRecord = await ss.getItem("pregnancyRecord");
      if(pregnancyRecord == null) {
        //go to well-being setup screen
        new GeneralUtils().showToast(context, "Please setup your pregnancy tracker.");
        Navigator.pushNamed(context, WellnessTrackerOptions.routeName);//change to diet info
        return;
      }
    }
    setState(() {
      selectedScreen = findScreen["screen_class"];
    });
    // Navigator.pushNamed(context, route);
    //select the class
  }
}
