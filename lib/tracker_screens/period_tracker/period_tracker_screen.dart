import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/tracker_screens/period_tracker/components/borderless_card.dart';
import 'package:coral_reef/tracker_screens/period_tracker/sections/login_symptoms.dart';
import 'package:coral_reef/tracker_screens/period_tracker/services/period_service.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import '../../constants.dart';
import '../../size_config.dart';
import 'components/border_filled_card.dart';
import 'components/call_to_action.dart';
import 'components/circular_slider.dart';
import 'components/symptoms_grid_options.dart';

class PeriodTrackerScreen extends StatefulWidget {
  static final routeName = "period-tracker-screen";

  @override
  State<StatefulWidget> createState() => _PeriodTrackerScreen();
}

class _PeriodTrackerScreen extends State<PeriodTrackerScreen> {

  PeriodServices periodServices;

  Map<String, dynamic> lastPeriodData = new Map();
  List<String> symptomsData = [];
  String symptomsDataNote = "";

  StorageSystem ss = new StorageSystem();

  String nextPeriodDays = "", nextOvulationDays = "", periodCurrentDay = "0";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    periodServices = new PeriodServices();

    resolvePeriodCalculation();

    getLastPeriodData();
    getSymptoms(DateTime.now());
  }

  getLastPeriodData() async {
    Map<String, dynamic> _get = await periodServices.getLastPeriodData();
    setState(() {
      lastPeriodData = _get;
    });
  }

  getSymptoms(DateTime date) async {
    Map<String, dynamic> _get = await periodServices.getSymptomsByDate(date);
    if(_get.isEmpty) {
      setState(() {
        symptomsData = [];
        symptomsDataNote = "";
      });
      return;
    }
    _get["msd"].forEach((element) {
      setState(() {
        symptomsData.add("$element");
      });
    });
    setState(() {
      symptomsDataNote = "${_get["note"]}";
    });
  }

  resolvePeriodCalculation() async {

    String periodRecord = await ss.getItem("periodRecord");
    Map<String, dynamic> record = jsonDecode(periodRecord);

    List<String> lastPeriod = "${record["lastPeriod"]}".split("/");
    //length this is how long the user bleeds for
    int length = int.parse(record["length"]);
    //user's cycle i.e how long it takes till next period
    int cycle = int.parse(record["cycle"]);

    //date of the user's last period
    final lastperiod = DateTime(int.parse(lastPeriod[0]), int.parse(lastPeriod[1]), int.parse(lastPeriod[2]));

    //This calculation adds the cycle to the last period to get the next period date
    DateTime nextperiod = lastperiod.add(new Duration(days: cycle));
    String nextp = nextperiod.toString();
    //to fetch today's date
    final today = DateTime.now();
    //Count down is the count down till the next period, it gets updated everyday
    final countdown = nextperiod.difference(today).inDays;
    String countp = countdown.toString();
    // period count is the count down timer when the user begins her period, every day it let's her know what period day she's on
    DateTime periodcount = nextperiod.add(new Duration(days: length));
    final periodcountnum = periodcount.difference(nextperiod).inDays;
    String periodc = periodcount.toString();

    print(nextperiod);
    print(countdown);
    print(periodcount);

    setState(() {
      nextPeriodDays = countdown.toString();
      nextOvulationDays = (countdown + 12).toString();
      periodCurrentDay = periodcountnum.toString();
    });

  }


  @override
  Widget build(BuildContext context) {
    // return StreamBuilder<Object>(
    //     stream: FirebaseFirestore.instance
    //         .collection("perioddetails")
    //         .doc(user.uid)
    //         .snapshots(),
    //     builder: (context, snapshot) {
    //       if (!snapshot.hasData) {
    //         return Text(
    //           'No Data...',
    //         );
    //       } else {
    //         DocumentSnapshot perioddetails = snapshot.data;
    //         final lastp = DateTime.parse(perioddetails["lastPeriod"]);
    //         final today = DateTime.now();
    //         final diff = today.difference(lastp).inDays;
    //         return Padding(
    //             padding: EdgeInsets.symmetric(
    //                 horizontal: getProportionateScreenWidth(10)),
    //             child: Column(
    //               children: [
    //                 SizedBox(
    //                   height: 20.0,
    //                 ),
    //                 DatePicker(
    //                   DateTime.now(),
    //                   height: 95.0,
    //                   initialSelectedDate: DateTime.now(),
    //                   selectionColor: Color(MyColors.primaryColor),
    //                   selectedTextColor: Colors.white,
    //                   dateTextStyle: Theme.of(context)
    //                       .textTheme
    //                       .headline2
    //                       .copyWith(
    //                       fontSize: getProportionateScreenWidth(15),
    //                       color: Color(MyColors.titleTextColor)),
    //                   monthTextStyle: Theme.of(context)
    //                       .textTheme
    //                       .subtitle1
    //                       .copyWith(
    //                       fontSize: getProportionateScreenWidth(10),
    //                       color: Color(MyColors.titleTextColor)),
    //                   dayTextStyle: Theme.of(context)
    //                       .textTheme
    //                       .subtitle1
    //                       .copyWith(
    //                       fontSize: getProportionateScreenWidth(10),
    //                       color: Color(MyColors.titleTextColor)),
    //                   onDateChange: (date) {
    //                     // New date selected
    //                     setState(() {
    //                       // _selectedValue = date;
    //                     });
    //                   },
    //                 ),
    //                 SizedBox(
    //                   height: 20.0,
    //                 ),
    //                 CircularSlider(diff),
    //                 SizedBox(
    //                   height: 20.0,
    //                 ),
    //                 Row(
    //                   mainAxisSize: MainAxisSize.max,
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     BorderlessCard(
    //                       borderColor: Color(MyColors.stroke1Color),
    //                       image: "assets/icons/period_card1.svg",
    //                       text: (perioddetails['length']),
    //                     ),
    //                     BorderlessCard(
    //                       borderColor: Color(MyColors.stroke2Color),
    //                       image: "assets/icons/period_card2.svg",
    //                       text: perioddetails['cycle'],
    //                     ),
    //                     BorderlessCard(
    //                       borderColor: Color(MyColors.stroke3Color),
    //                       image: "assets/icons/period_card3.svg",
    //                       text: "Low",
    //                     ),
    //                   ],
    //                 ),
    //                 SizedBox(
    //                   height: 20.0,
    //                 ),
    //                 CallToAction(
    //                   onPress: () {
    //                     Navigator.pushNamed(context, LoginSymptoms.routeName);
    //                   },
    //                 ),
    //                 SizedBox(
    //                   height: 10.0,
    //                 ),
    //                 Row(
    //                   children: [
    //                     Text("Your cycles",
    //                         style: Theme.of(context)
    //                             .textTheme
    //                             .bodyText1
    //                             .copyWith(
    //                             color: Color(MyColors.primaryColor),
    //                             fontSize: getProportionateScreenWidth(15))),
    //                   ],
    //                 ),
    //                 SizedBox(
    //                   height: 10.0,
    //                 ),
    //                 Row(
    //                     mainAxisSize: MainAxisSize.max,
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       BorderFilledCard(
    //                         title: "Previous cycle length",
    //                         subtitle: "14 days",
    //                         textNearIcon: "Abnormal",
    //                         fillColor: Color(MyColors.stroke1Color),
    //                         borderColor: Color(MyColors.stroke1Color),
    //                         textColor: Colors.white,
    //                         icon: Icon(
    //                           Icons.warning_rounded,
    //                           size: 12.0,
    //                           color: Colors.yellow,
    //                         ),
    //                       ),
    //                       BorderFilledCard(
    //                         title: "Previous cycle length",
    //                         subtitle: "14 days",
    //                         textNearIcon: "Normal",
    //                         fillColor: Colors.white,
    //                         borderColor: Colors.grey,
    //                         textColor: Color(MyColors.primaryColor),
    //                         icon: Icon(
    //                           Icons.check_circle,
    //                           size: 12.0,
    //                           color: Colors.green,
    //                         ),
    //                       )
    //                     ]),
    //                 SizedBox(
    //                   height: 50.0,
    //                 ),
    //               ],
    //             ));
    //       }
    //     });

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
                print("my date is $date");
                getSymptoms(date);
                setState(() {
                  // _selectedValue = date;
                });
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            CircularSlider(periodCurrentDay),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BorderlessCard(
                  borderColor: Color(MyColors.stroke1Color),
                  image: "assets/icons/period_card1.svg",
                  text: "$nextPeriodDays days",
                  bottomText: "Next Period",
                ),
                SizedBox(width: 20.0,),
                BorderlessCard(
                  borderColor: Color(MyColors.stroke2Color),
                  image: "assets/icons/period_card2.svg",
                  text: "$nextOvulationDays days",
                  bottomText: "Next Ovulation",
                ),
                SizedBox(width: 20.0,),
                BorderlessCard(
                  borderColor: Color(MyColors.stroke3Color),
                  image: "assets/icons/period_card3.svg",
                  text: "Low",
                  bottomText: "Pregnancy Chance",
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
              height: 20.0,
            ),
            (symptomsData.isNotEmpty) ? Row(
              children: [
                Text("Your recorded symptoms",
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Color(MyColors.primaryColor),
                        fontSize: getProportionateScreenWidth(15))),
              ],
            ) : SizedBox(),
            (symptomsDataNote.isNotEmpty) ? Container(
              margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: ReadMoreText(
                symptomsDataNote,
                trimLines: 2,
                colorClickableText: Color(MyColors.primaryColor),
                trimMode: TrimMode.Line,
                trimCollapsedText: 'more',
                trimExpandedText: 'less',
                style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 14.0, color: Color(MyColors.titleTextColor)),
                moreStyle: Theme.of(context).textTheme.headline2.copyWith(fontSize: 14.0, color: Color(MyColors.primaryColor)),
                lessStyle: Theme.of(context).textTheme.headline2.copyWith(fontSize: 14.0, color: Color(MyColors.primaryColor)),
              ),
            ) : SizedBox(),
            SizedBox(
              height: 10.0,
            ),
            (symptomsData.isNotEmpty) ? Container(
              height: 100.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: symptomsData
                    .map((opt) => SymptomsGridOptions(
                  backgroundColor: Color(MyColors.stroke1Color),
                  title: opt,
                  image:
                  "assets/symptoms/${opt.toLowerCase().replaceAll(" ", "-")}.svg",
                  selected: false,
                  marginRight: true,
                )).toList(),
              ),
            ) :  SizedBox(),
            SizedBox(
              height: 10.0,
            ),
            (lastPeriodData.isNotEmpty) ? Row(
              children: [
                Text("Your cycles",
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Color(MyColors.primaryColor),
                        fontSize: getProportionateScreenWidth(15))),
              ],
            ) : SizedBox(),
            SizedBox(
              height: (lastPeriodData.isNotEmpty) ? 10.0 : 0.0,
            ),
            (lastPeriodData.isNotEmpty) ? Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BorderFilledCard(
                    title: "Previous cycle length",
                    subtitle: "${lastPeriodData["cycle"]} days",
                    textNearIcon: (int.parse("${lastPeriodData["cycle"]}") < 21) ? "Abnormal" : "Normal",
                    fillColor: Color(MyColors.stroke1Color),
                    borderColor: Color(MyColors.stroke1Color),
                    textColor: Colors.white,
                    icon: (int.parse("${lastPeriodData["cycle"]}") < 21) ? Icon(
                      Icons.warning_rounded,
                      size: 12.0,
                      color: Colors.yellow,
                    ) : Icon(
                      Icons.check_circle,
                      size: 12.0,
                      color: Colors.green,
                    ),
                  ),
                  BorderFilledCard(
                    title: "Previous period length",
                    subtitle: "${lastPeriodData["length"]} days",
                    textNearIcon: (int.parse("${lastPeriodData["length"]}") > 7) ? "Abnormal" : "Normal",
                    fillColor: Colors.white,
                    borderColor: Colors.grey,
                    textColor: Color(MyColors.primaryColor),
                    icon: (int.parse("${lastPeriodData["length"]}") > 7) ? Icon(
                      Icons.warning_rounded,
                      size: 12.0,
                      color: Colors.yellow,
                    ) : Icon(
                      Icons.check_circle,
                      size: 12.0,
                      color: Colors.green,
                    ),
                  )
                ]) : SizedBox(),
            SizedBox(
              height: 50.0,
            ),
          ],
        ));
  }
}
