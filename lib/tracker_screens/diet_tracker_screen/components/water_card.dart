
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/shared_screens/pill_icon.dart';
import 'package:coral_reef/tracker_screens/diet_tracker_screen/sections/water_goal.dart';
import 'package:coral_reef/tracker_screens/diet_tracker_screen/services/diet_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../size_config.dart';

class WaterCard extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _WaterCard();
}

class _WaterCard extends State<WaterCard> {

  String waterGoal = "0", currentTakenWater = "0";

  DietServices dietServices;

  StorageSystem ss = new StorageSystem();

  Color waterCardColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dietServices = new DietServices();
    getWaterLocalData();
  }

  getWaterLocalData() async {
    final date = DateTime.now();
    final months = ["JAN", "FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];

    String formatDate = "${date.year}_${months[date.month - 1]}_${date.day}";

    String goal = await ss.getItem("waterGoal") ?? "0";
    String current = await ss.getItem("waterCurrent_$formatDate") ?? "0";

    setState(() {
      waterGoal = goal;
      currentTakenWater = current;
      waterCardColor = getWaterState();
    });
  }

  Color getWaterState() {
    Color state = Color(MyColors.stroke3Color);

    double goal = double.parse(waterGoal);
    double current = double.parse(currentTakenWater);

    if(current == 0 || current < (goal / current)) {
      state = Color(MyColors.stroke1Color);
    }

    if(current >= (goal / current) && current < goal) {
      state = Color(MyColors.stroke2Color);
    }

    return state;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.pushNamed(context, WaterGoal.routeName);
        getWaterLocalData();
      },
      child: Container(
          decoration: BoxDecoration(
            color: waterCardColor, //Color(MyColors.other2),
            borderRadius: BorderRadius.circular(10),
          ),
          width: double.infinity,
          padding: EdgeInsets.all(20.0),
          height: 130,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Water", textAlign: TextAlign.start, style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: getProportionateScreenWidth(18),
                      color: Colors.white
                  ),),
                  Container(height: 20.0,),
                  Row(
                    children: [
                      InkWell(
                        onTap: (){
                          int goal = int.parse(waterGoal);
                          int currentV = int.parse(currentTakenWater);
                          if(goal <= 0 || (currentV - 1) < 0) {
                            return;
                          }
                          setState(() {
                            currentTakenWater = "${currentV - 1}";
                          });
                          dietServices.updateWaterTakenCount(currentV - 1, goal);
                        },
                        child: PillIcon(
                          icon: 'assets/well_being/Subtract.svg',
                          size: 25,
                          svgColor: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: Container(
                          height: getProportionateScreenWidth(30),
                          width: getProportionateScreenWidth(30),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset("assets/diet/glass.svg",),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          int goal = int.parse(waterGoal);
                          if(goal <= 0) {
                            return;
                          }
                          int currentV = int.parse(currentTakenWater);
                          setState(() {
                            currentTakenWater = "${currentV + 1}";
                          });
                          dietServices.updateWaterTakenCount(currentV + 1, goal);
                        },
                        child: PillIcon(
                          icon: 'assets/well_being/add.svg',
                          size: 25,
                          svgColor: Colors.white,
                        ),
                      )
                    ],)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 20.0,),
                  Text('$currentTakenWater/$waterGoal',
                    style: Theme.of(context).textTheme.headline2.copyWith(
                      color: Colors.white,
                      fontSize: getProportionateScreenWidth(18),
                    ),),
                  Text((waterGoal == "0") ? 'CLICK TO SETUP' : 'TODAY',
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Colors.white,
                      fontSize: getProportionateScreenWidth(13),
                    ),),
                ],
              )
            ],
          )
      ),
    );
  }
}