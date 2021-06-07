
import 'dart:convert';

import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/shared_screens/pill_icon.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';

class InsightCard extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _InsightCard();
}

class _InsightCard extends State<InsightCard> {

  StorageSystem ss = new StorageSystem();

  String currentWeight = "", currentHeight = "", goalWeight = "0", weightMetric = "kg", heightMetric = "cm", bmi = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWeightLocalData();
    getExerciseSetupData();
  }

  getExerciseSetupData() async {
    String exercise = await ss.getItem("dewRecord");
    String wMetric = await ss.getItem("weight_metric");
    String hMetric = await ss.getItem("height_metric");
    Map<String, dynamic> json = jsonDecode(exercise);
    setState(() {
      goalWeight = "${json["2"]}";
      currentHeight = "${json["3"]}";
      weightMetric = wMetric;
      heightMetric = hMetric;
      if(currentWeight.isEmpty) {
        currentWeight = "${json["1"]}";
        bmi = calculateBMI();
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
      bmi = list[1];
    });
  }

  String calculateBMI() {
    double bmi = 0;
    if(weightMetric == "kg" && heightMetric == "cm") {
      double heightInMeters = double.parse(currentHeight) / 100;
      bmi = double.parse(currentWeight) / (heightInMeters * heightInMeters);
      return bmi.toStringAsFixed(2);
    }
    if(weightMetric == "lbs" && heightMetric == "ft") {

      bmi = (double.parse(currentWeight) / (double.parse(currentHeight) * (double.parse(currentHeight)))) * 703;
      return bmi.toStringAsFixed(2);
    }
    double weight = (weightMetric == "kg") ? double.parse(currentWeight) : double.parse(currentWeight) * 2.205;
    double height = (heightMetric == "cm") ? (double.parse(currentHeight) / 100) : (double.parse(currentHeight) / 2.54);

    bmi = weight / (height * height);
    return bmi.toStringAsFixed(2);
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, InsightsScreen.routeName);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.purpleAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        width: double.infinity,
        height: 180,
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Insights", textAlign: TextAlign.start, style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: getProportionateScreenWidth(18),
                    color: Color(MyColors.primaryColor)
                ),),
                PillIcon(
                  icon: 'assets/diet/Shape.svg',
                  size: 20,
                  paddingRight: 0.0,
                )
              ],
            ),
            Container(height: 10.0,),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "$currentWeight",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: getProportionateScreenWidth(18),
                            color: Color(MyColors.primaryColor)
                        ),
                      ),
                      TextSpan(
                        text: "$weightMetric\n",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: getProportionateScreenWidth(10),
                            color: Color(MyColors.primaryColor)
                        ),
                      ),
                      TextSpan(text: "Current Weight\n", style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Color(MyColors.titleTextColor)
                      ),),
                      TextSpan(text: "BMI $bmi", style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Colors.grey
                      ),)
                    ],
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "$goalWeight",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: getProportionateScreenWidth(18),
                            color: Color(MyColors.primaryColor)
                        ),
                      ),
                      TextSpan(
                        text: "$weightMetric\n",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: getProportionateScreenWidth(10),
                            color: Color(MyColors.primaryColor)
                        ),
                      ),
                      TextSpan(text: "Weight Goal", style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Color(MyColors.titleTextColor)
                      ),),
                    ],
                  ),textAlign: TextAlign.right,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}