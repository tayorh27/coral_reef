import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/size_config.dart';
import 'package:coral_reef/tracker_screens/period_tracker/components/border_filled_card.dart';
import 'package:coral_reef/tracker_screens/period_tracker/components/call_to_action.dart';
import 'package:coral_reef/tracker_screens/period_tracker/sections/login_symptoms.dart';
import 'package:coral_reef/tracker_screens/pregnancy_tracker/components/appbar.dart';
import 'package:coral_reef/tracker_screens/pregnancy_tracker/components/borderless_card.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TipsScreen extends StatefulWidget {
  static final routeName = "tipsscreen";
  @override
  _TipsScreenState createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appbar(context),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
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
                    print("my date is $date");
                    setState(() {
                      // _selectedValue = date;
                    });
                  },
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                Stack(children: [
                  Image.asset(
                    "assets/images/pregback.png",
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 200),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            "Pregnancy",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(5),
                          ),
                          Text(
                            "17 Weeks",
                            style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BorderlessCard(
                      borderColor: Color(MyColors.stroke1Color),
                      image: "assets/icons/vback.svg",
                      text: ("Previous \n Week"),
                    ),
                    BorderlessCard(
                      borderColor: Color(MyColors.stroke2Color),
                      image: "assets/icons/blog.svg",
                      text: ("Blog"),
                    ),
                    BorderlessCard(
                      borderColor: Color(MyColors.stroke2Color),
                      image: "assets/icons/vfront.svg",
                      text: ("Next week"),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
                CallToAction(
                  onPress: () {
                    Navigator.pushNamed(context, LoginSymptoms.routeName);
                  },
                ),
                SizedBox(
                  height: 40.0,
                ),
                Row(
                  children: [
                    Text("Your cycles",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Color(MyColors.primaryColor),
                            fontWeight: FontWeight.w600,
                            fontSize: getProportionateScreenWidth(16))),
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
                        title: "Previous period length",
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
                      ),
                    ]),
                SizedBox(
                  height: 60.0,
                ),
              ],
            ),
          ),
        ));
  }
}