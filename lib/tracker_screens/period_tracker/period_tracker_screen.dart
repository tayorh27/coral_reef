import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/tracker_screens/period_tracker/components/borderless_card.dart';
import 'package:coral_reef/tracker_screens/period_tracker/sections/login_symptoms.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';

import '../../size_config.dart';
import 'components/border_filled_card.dart';
import 'components/call_to_action.dart';
import 'components/circular_slider.dart';

class PeriodTrackerScreen extends StatefulWidget {
  static final routeName = "period-tracker-screen";

  @override
  State<StatefulWidget> createState() => _PeriodTrackerScreen();
}

class _PeriodTrackerScreen extends State<PeriodTrackerScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            DatePicker(
              DateTime.now(),
              height: 95.0,
              initialSelectedDate: DateTime.now(),
              selectionColor: Color(MyColors.primaryColor),
              selectedTextColor: Colors.white,
              dateTextStyle: Theme.of(context).textTheme.headline2.copyWith(
                  fontSize: getProportionateScreenWidth(15),
                  color: Color(MyColors.titleTextColor)),
              monthTextStyle: Theme.of(context).textTheme.subtitle1.copyWith(
                  fontSize: getProportionateScreenWidth(10),
                  color: Color(MyColors.titleTextColor)),
              dayTextStyle: Theme.of(context).textTheme.subtitle1.copyWith(
                  fontSize: getProportionateScreenWidth(10),
                  color: Color(MyColors.titleTextColor)),
              onDateChange: (date) {
                // New date selected
                setState(() {
                  // _selectedValue = date;
                });
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            CircularSlider(),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BorderlessCard(
                  borderColor: Color(MyColors.stroke1Color),
                  image: "assets/icons/period_card1.svg",
                  text: "4 days",
                ),
                BorderlessCard(
                  borderColor: Color(MyColors.stroke2Color),
                  image: "assets/icons/period_card2.svg",
                  text: "4days",
                ),
                BorderlessCard(
                  borderColor: Color(MyColors.stroke3Color),
                  image: "assets/icons/period_card3.svg",
                  text: "Low",
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            CallToAction(
              onPress: () {
                Navigator.pushNamed(context, LoginSymptoms.routeName);
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Text("Your cycles",
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Color(MyColors.primaryColor),
                        fontSize: getProportionateScreenWidth(15))),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BorderFilledCard(
                    title: "Previous cycle length",
                    subtitle: "14 days",
                    textNearIcon: "Abnormal",
                    fillColor: Color(MyColors.stroke1Color),
                    borderColor: Color(MyColors.stroke1Color),
                    textColor: Colors.white,
                    icon: Icon(
                      Icons.warning_rounded,
                      size: 12.0,
                      color: Colors.yellow,
                    ),
                  ),
                  BorderFilledCard(
                    title: "Previous cycle length",
                    subtitle: "14 days",
                    textNearIcon: "Normal",
                    fillColor: Colors.white,
                    borderColor: Colors.grey,
                    textColor: Color(MyColors.primaryColor),
                    icon: Icon(
                      Icons.check_circle,
                      size: 12.0,
                      color: Colors.green,
                    ),
                  )
                ]),
            SizedBox(
              height: 50.0,
            ),
          ],
        ));
  }
}
