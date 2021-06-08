import 'package:coral_reef/tracker_screens/insights/sections/calories_insight.dart';
import 'package:coral_reef/tracker_screens/insights/sections/sleep_insight.dart';
import 'package:coral_reef/tracker_screens/insights/sections/steps_insight.dart';
import 'package:coral_reef/tracker_screens/insights/sections/vitamins_insight.dart';
import 'package:coral_reef/tracker_screens/insights/sections/water_insight.dart';
import 'package:coral_reef/tracker_screens/insights/sections/weight_insight.dart';
import 'package:coral_reef/tracker_screens/well_being_tracker/components/diet_header.dart';
import 'package:flutter/material.dart';

import '../../size_config.dart';
import 'components/insights_header.dart';

class DewInsights extends StatefulWidget {

  static final routeName = "dew-insight";
  @override
  State<StatefulWidget> createState() => _DewInsights();
}

class _DewInsights extends State<DewInsights> {

  String selectedMenu = "Sleep";

  List<Map<String,dynamic>> screens = [
    {"screen_name": "Sleep",  "screen_class":SleepInsight()},
    {"screen_name": "Vitamins",  "screen_class":VitaminsInsight()},
    {"screen_name": "Steps",  "screen_class":StepsInsight()},
    {"screen_name": "Calories",  "screen_class":CaloriesInsight()},
    {"screen_name": "Weight", "screen_class":WeightInsight()},
    {"screen_name": "Water", "screen_class":WaterInsight()},
  ];

  Widget selectedScreen = SleepInsight();

  bool activated = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    selectedMenu = ModalRoute.of(context).settings.arguments.toString();
    if(!activated) {
      activated = true;
      getInsightScreen(selectedMenu);
    }
    // if(selectedMenu.isEmpty) {
    //   selectedMenu = "Sleep";
    // }
    // print("$selectedMenu");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DietHeader("Insights").appBar(context),
      body: SafeArea(
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(30)),
                  child: Container(
                      child: SingleChildScrollView(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                InsightsHeader(currentSelected: selectedMenu, onSelectedMenu: (menu) {
                                  setState(() {
                                    selectedMenu = menu;
                                  });
                                  getInsightScreen(menu);
                                },),
                                SizedBox(height: SizeConfig.screenHeight * 0.03),
                                selectedScreen
                              ]
                          )
                      )
                  )
              )
          )
      ),
    );
  }

  void getInsightScreen(String selectedMenu) async {
    Map<String, dynamic> findScreen = screens.firstWhere((element) => element["screen_name"] == selectedMenu);
    if(findScreen == null) {
      return;
    }
    setState(() {
      selectedScreen = findScreen["screen_class"];
    });
  }

}
