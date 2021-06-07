import 'dart:convert';

import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/tracker_screens/diet_tracker_screen/sections/calories_goal.dart';
import 'package:coral_reef/tracker_screens/diet_tracker_screen/sections/weight_goal.dart';
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

  StorageSystem ss = new StorageSystem();

  String currentWeight = "", goalWeight = "0", weightMetric = "kg";

  String caloriesGoal = "0", currentTakenCalories = "0";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWeightLocalData();
    getExerciseSetupData();
    getCaloriesLocalData();
  }

  getExerciseSetupData() async {
    String exercise = await ss.getItem("dewRecord");
    String wMetric = await ss.getItem("weight_metric");
    // String hMetric = await ss.getItem("height_metric");
    Map<String, dynamic> json = jsonDecode(exercise);
    setState(() {
      goalWeight = "${json["2"]}";
      weightMetric = wMetric;
      if(currentWeight.isEmpty) {
        currentWeight = "${json["1"]}";
      }
    });
  }

  getWeightLocalData() async {
    final date = DateTime.now();
    final months = ["JAN", "FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];

    String formatDate = "${date.year}_${months[date.month - 1]}_${date.day}";

    String current = await ss.getItem("weightCurrent_$formatDate") ?? "";

    if(current.isEmpty) return;

    List<String> list = current.split("/");

    setState(() {
      currentWeight = list[0];
    });
  }

  getCaloriesLocalData() async {
    final date = DateTime.now();
    final months = ["JAN", "FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];

    String formatDate = "${date.year}_${months[date.month - 1]}_${date.day}";

    String goal = await ss.getItem("caloriesGoal") ?? "0";
    String current = await ss.getItem("caloriesCurrent_$formatDate") ?? "0";

    setState(() {
      caloriesGoal = goal;
      currentTakenCalories = current;
    });
  }

  double getPointerValue() {
    return ((double.parse(currentTakenCalories) / double.parse(caloriesGoal)) * 100);
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DietSummaryCard(
            title: 'Calories',
            icon: 'assets/well_being/arc.svg',
            title2: '',
            title3: '$currentTakenCalories kcal',
            title4: 'Goal: $caloriesGoal kcal',
            textColor: Colors.white,
            press: () async {
              await Navigator.pushNamed(context, CaloriesGoal.routeName);
              getCaloriesLocalData();
            },
            color: Color(MyColors.primaryColor),
            child: CaloriesSlider(getPointerValue()),
        ),
        SizedBox(width: SizeConfig.screenWidth * 0.03),
        DietSummaryCard(
            title: 'Weight',
            icon: 'assets/diet/Shape.svg',
            title2: '',
            title3: '$currentWeight $weightMetric',
            title4: 'Goal: $goalWeight $weightMetric',
            textColor: Color(MyColors.primaryColor),
            press: () async {
              await Navigator.pushNamed(context, WeightGoal.routeName);
              getWeightLocalData();
              getExerciseSetupData();
            },
            color: Colors.purpleAccent.withOpacity(0.1),
          child: SvgPicture.asset("assets/diet/Shape.svg", height: 100,color: Color(MyColors.primaryColor),),
        ),

      ],
    );
  }
}