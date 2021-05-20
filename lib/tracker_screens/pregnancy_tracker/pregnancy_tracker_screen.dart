import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/shared_screens/header_name.dart';
import 'package:coral_reef/shared_screens/special_offer_card.dart';
import 'package:coral_reef/tracker_screens/pregnancy_tracker/sections/birth_calculator.dart';
import 'package:coral_reef/tracker_screens/pregnancy_tracker/sections/your_baby.dart';
import 'package:coral_reef/tracker_screens/pregnancy_tracker/sections/your_tips.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../size_config.dart';
import 'components/list_card.dart';
import 'sections/tips.dart';
import 'sections/your_body.dart';

class PregnancyTrackerScreen extends StatefulWidget {
  static final routeName = "period-tracker-screen";

  @override
  State<StatefulWidget> createState() => _PregnancyTrackerScreen();
}

class _PregnancyTrackerScreen extends State<PregnancyTrackerScreen> {

  StorageSystem ss = new StorageSystem();

  String currentWeekNumber = "N/A", birthDueDate = "N/A";

  String weekNumber = "", weekNumberWithSuffix = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupSummaryData();
  }

  setupSummaryData() {
    List<String> months = ["Jan", "Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
    ss.getItem("pregnancyCalculatorDate").then((value) {
      if(value == null) return;

      final today = DateTime.now();

      final calculatorDate = DateTime.parse(value);

      final dueDateInWeeks = calculatorDate.add(Duration(days: 252)); ///adding 36weeks to the last period date

      final currentDueDateInWeeks = dueDateInWeeks.difference(today).inDays;

      print("week = $currentDueDateInWeeks");

      setState(() {
        birthDueDate = "${months[dueDateInWeeks.month]} ${dueDateInWeeks.day}, ${dueDateInWeeks.year}";
      });

      int remainder = 252 - currentDueDateInWeeks;

      int val = (double.parse("$remainder") / 7.0).ceil();

      print("val = $val");

      String dateSuffix = "th";
      if(val <= 12) {
        if(val == 1) {
          dateSuffix = "st";
        }
        if(val == 2) {
          dateSuffix = "nd";
        }
        if(val == 3) {
          dateSuffix = "rd";
        }
      }else {
        String lastDigit = val.toString().characters.last;
        if(lastDigit == "2") {
          dateSuffix = "nd";
        }
        if(lastDigit == "3") {
          dateSuffix = "rd";
        }
      }

      setState(() {
        weekNumber = val.toString();
        currentWeekNumber = "$val$dateSuffix Week";
        weekNumberWithSuffix = "$val$dateSuffix";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
        EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: SizeConfig.screenHeight * 0.03),
            Heading(body: "Select a card to get started.",),
            SizedBox(height: SizeConfig.screenHeight * 0.03),
            Row(
              children: [
                SpecialOfferCard(
                  image: "assets/images/pland1.png",
                  title: "Week of Pregnancy",
                  title2: currentWeekNumber,
                  press: () async {
                    if(currentWeekNumber == "N/A") {
                      goToCalculator();
                      return;
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TipsScreen(currentWeek: weekNumber,)));
                    // Navigator.pushNamed(context, TipsScreen.routeName, arguments: weekNumber);
                  },
                ),
                SpecialOfferCard(
                  image: "assets/images/pland2.png",
                  title: "Due Date of Birth",
                  title2: birthDueDate,
                  press: () async {
                    bool result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BirthCalculator()),
                    );
                    if(result) {
                      setupSummaryData();
                    }
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                if(currentWeekNumber == "N/A") {
                  goToCalculator();
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => YourBody(week: weekNumberWithSuffix, weekNumber: int.parse(weekNumber))),
                );
                // Navigator.pushNamed(context, YourBody.routeName, arguments: weekNumberWithSuffix);
              },
              child: PregListCard(
                title: "Your Body",
                title2: "Learn about your body",
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              thickness: 2,
            ),
            InkWell(
                onTap: () {
                  if(currentWeekNumber == "N/A") {
                    goToCalculator();
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => YourBaby(week: weekNumberWithSuffix, weekNumber: int.parse(weekNumber),)),
                  );
                  // Navigator.pushNamed(context, YourBaby.routeName, arguments: weekNumberWithSuffix);
                },
                child: PregListCard(
                  title: "Your Baby",
                  title2: "Learn about your baby",
                )),
            SizedBox(
              height: 10,
            ),
            Divider(
              thickness: 2,
            ),
            InkWell(
              onTap: () {
                if(currentWeekNumber == "N/A") {
                  goToCalculator();
                  return;
                }
                Navigator.pushNamed(context, YourTips.routeName, arguments: weekNumberWithSuffix);
              },
              child: PregListCard(
                title: "Tips",
                title2: "Get helpful tips",
              ),
            ),
            Divider(
              thickness: 2,
            ),
          ],
        ));
  }

  goToCalculator() async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BirthCalculator()),
    );
    if(result) {
      setupSummaryData();
    }
  }
}