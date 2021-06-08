
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/shared_screens/pill_icon.dart';
import 'package:coral_reef/tracker_screens/well_being_tracker/sections/vitamin_goal.dart';
import 'package:coral_reef/tracker_screens/well_being_tracker/services/vitamins_services.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';

class VitaminCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _VitaminCard();
}

class _VitaminCard extends State<VitaminCard> {

  String vitaminsGoal = "0", currentTakenVitamins = "0";

  WellBeingServices vitaminServices;

  StorageSystem ss = new StorageSystem();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vitaminServices = new WellBeingServices();
    getVitaminsLocalData();
  }

  getVitaminsLocalData() async {
    final date = DateTime.now();
    final months = ["JAN", "FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];

    String formatDate = "${date.year}_${months[date.month - 1]}_${date.day}";

    String goal = await ss.getItem("vitaminGoal") ?? "0";
    String current = await ss.getItem("vitaminCurrent_$formatDate") ?? "0";

    setState(() {
      vitaminsGoal = goal;
      currentTakenVitamins = current;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.pushNamed(context, VitaminGoal.routeName);
        getVitaminsLocalData();
      },
      child: Container(
          decoration: BoxDecoration(
            color: Colors.purpleAccent.withOpacity(0.1),
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
                  Text("Vitamins", textAlign: TextAlign.start, style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: getProportionateScreenWidth(18),
                      color: Color(MyColors.primaryColor)
                  ),),
                  Container(height: 20.0,),
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          int goal = int.parse(vitaminsGoal);
                          int currentV = int.parse(currentTakenVitamins);
                          if(goal <= 0 || (currentV - 1) < 0) {
                            return;
                          }
                          setState(() {
                            currentTakenVitamins = "${currentV - 1}";
                          });
                          await vitaminServices.updateVitaminTakenCount(currentV - 1, goal);
                        },
                        child: PillIcon(
                          icon: 'assets/well_being/Subtract.svg',
                          size: 20,
                        ),
                      ),
                      PillIcon(
                        icon: 'assets/well_being/pill.svg',
                        size: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          int goal = int.parse(vitaminsGoal);
                          if(goal <= 0) {
                            return;
                          }
                          int currentV = int.parse(currentTakenVitamins);
                          setState(() {
                            currentTakenVitamins = "${currentV + 1}";
                          });
                          await vitaminServices.updateVitaminTakenCount(currentV + 1, goal);
                        },
                        child: PillIcon(
                          icon: 'assets/well_being/add.svg',
                          size: 20,
                        ),
                      )
                    ],)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 20.0,),
                  Text('$currentTakenVitamins/$vitaminsGoal',
                    style: Theme.of(context).textTheme.headline2.copyWith(
                      color: Color(MyColors.primaryColor),
                      fontSize: getProportionateScreenWidth(18),
                    ),),
                  Text((vitaminsGoal == "0") ? 'CLICK TO SETUP' : 'TODAY',
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Color(MyColors.titleTextColor),
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