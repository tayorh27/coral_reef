import 'dart:convert';

import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CircularSlider extends StatefulWidget {
  final String periodCount;
  CircularSlider(this.periodCount);

  @override
  State<StatefulWidget> createState() => _CircularSlider();
}

class _CircularSlider extends State<CircularSlider> {
  //waiting for your next period
  StorageSystem ss = new StorageSystem();

  int lengthPeriod = 0, cyclePeriod = 1;

  bool isOnPeriod = false;

  String menstrualType = "Period";

  int diffTodayAndStartDate = 0;
  int diffTodayAndEndDate = 0;

  int totalDaysRemaining = 0;

  int diffRemainingDays = 0;

  Future<void> determinePeriod() async {
    String periodRecord = await ss.getItem("periodRecord");
    Map<String, dynamic> record = jsonDecode(periodRecord);
    // record["lastPeriod"] = "2021/4/24";
    List<String> lastPeriod = "${record["lastPeriod"]}".split("/");
    lengthPeriod = int.parse(record["length"]);
    cyclePeriod = int.parse(record["cycle"]);

    final lastP = DateTime(int.parse(lastPeriod[0]), int.parse(lastPeriod[1]),int.parse(lastPeriod[2])); //convert string to date object of last period date

    final futurePeriodStartDate = lastP.add(Duration(days: cyclePeriod)); //add period cycle days to last period date to get the next period date

    final futurePeriodEndDate = futurePeriodStartDate.add(Duration(days: (lengthPeriod-1))); //add length of period to period start date to get when the period will end

    final today = DateTime.now(); //(2021, 6, 19); get current date

    diffTodayAndStartDate = today.difference(futurePeriodStartDate).inDays; //get the difference between today and the start date
    diffTodayAndEndDate = futurePeriodEndDate.difference(today).inDays; // get the difference between the end start and today

    // print(diffTodayAndStartDate);
    // print(diffTodayAndEndDate);


    if(diffTodayAndStartDate >= 0 && diffTodayAndStartDate < cyclePeriod) { //check if the day is within the period cycle
      if(!mounted) return;
      setState(() {
        menstrualType = "Period Cycle";
        isOnPeriod = true;
      });
      // if(diffTodayAndStartDate >= 0) { //&& diffTodayAndStartDate <= diffTodayAndEndDate
      //   setState(() {
      //
      //   });
      // }
      //ovulation
      if(diffTodayAndStartDate >= 12 && diffTodayAndStartDate <= 17) { //check if current date is within the ovulation period
        if(!mounted) return;
        setState(() {
          isOnPeriod = true;
          menstrualType = "Ovulation";
        });
        print("ovulation");
      }
    }else {
      //waiting for next period cycle
      if(!mounted) return;
      setState(() {
        menstrualType = "";
        isOnPeriod = false;
        diffRemainingDays = (diffTodayAndStartDate < 0) ? diffTodayAndStartDate * (-1) : diffTodayAndStartDate; // futurePeriodStartDate.difference(today).inDays;
      });
      print("me = $diffRemainingDays");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    determinePeriod();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // determinePeriod();
    return Container(
      width: 300.0,
      height: 300.0,
      decoration: BoxDecoration(
          // color: Color(MyColors.primaryColor),
          borderRadius: BorderRadius.circular(100.0)),
      child: SfRadialGauge(
          enableLoadingAnimation: true,
          animationDuration: 4500,
          title: (!isOnPeriod) ? GaugeTitle(
              text: "", //Waiting for your next period cycle
              alignment: GaugeAlignment.center,
              textStyle: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(color: Color(MyColors.titleTextColor))) : GaugeTitle(text: ""),
          axes: <RadialAxis>[
            RadialAxis(
                minimum: 0,
                maximum: double.parse("$cyclePeriod"),
                ranges: <GaugeRange>[
                  GaugeRange(
                      startValue: 1,
                      endValue: double.parse("$lengthPeriod"),
                      color: Color(MyColors.stroke1Color)),
                  GaugeRange(
                      startValue: 12,
                      endValue: 17,
                      color: Color(MyColors.stroke2Color)),
                  GaugeRange(
                      startValue: 17,
                      endValue: double.parse("$cyclePeriod"),
                      color: Color(MyColors.lightBackground)),
                ],
                pointers: <GaugePointer>[
                  NeedlePointer(
                      value: (isOnPeriod) ? double.parse("${(diffTodayAndStartDate + 1)}") : 0,
                      enableAnimation: true,
                      animationDuration: 4500,
                      needleColor: (diffTodayAndStartDate >= 12 && diffTodayAndStartDate <= 17) ? Color(MyColors.stroke2Color) : Color(MyColors.stroke1Color),
                      knobStyle:
                          KnobStyle(color: Color(MyColors.lightBackground)))
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                      widget: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 30.0,
                          ),
                          Text(menstrualType,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                    color: Color(MyColors.titleTextColor),
                                    fontSize: getProportionateScreenWidth(12),
                                  )),
                          Text((isOnPeriod) ? "Day ${(diffTodayAndStartDate + 1)}" : "  Awaiting Next Cycle", // - $diffRemainingDays
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                      color: Color(MyColors.titleTextColor),
                                      fontSize: getProportionateScreenWidth(11),
                                      fontWeight: FontWeight.bold)),
                        ],
                      ),
                      angle: 90,
                      positionFactor: 0.5)
                ])
          ]),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   // TODO: implement build
  //   determinePeriodAndOvulation();
  //   return Container(
  //     width: 200.0,
  //     height: 200.0,
  //     decoration: BoxDecoration(
  //         color: Color(MyColors.primaryColor),
  //         borderRadius: BorderRadius.circular(100.0)
  //     ),
  //     child: SleekCircularSlider(
  //         appearance: CircularSliderAppearance(
  //           angleRange: 360.0,
  //           customColors: CustomSliderColors(
  //             progressBarColors: [
  //               Color(MyColors.stroke1Color),
  //               Color(MyColors.stroke2Color),
  //             ],
  //             trackColor: Color(MyColors.progressSliderColor),
  //               dynamicGradient: true,
  //           ),
  //           customWidths: CustomSliderWidths(
  //             trackWidth: 15.0
  //           )
  //         ),
  //         initialValue: double.parse(widget.periodCount),
  //         min: 0,
  //         max: double.parse("$cyclePeriod"), //max period cycle
  //         innerWidget: (double value){
  //           return Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text((menstrualType == "period") ? "Period:" : "Period:", style: Theme.of(context).textTheme.subtitle1.copyWith(
  //                 color: Colors.white,
  //                 fontSize: getProportionateScreenWidth(12),
  //               )),
  //               Text("Day ${widget.periodCount}", style: Theme.of(context).textTheme.subtitle1.copyWith(
  //                   color: Colors.white,
  //                   fontSize: getProportionateScreenWidth(24),
  //                   fontWeight: FontWeight.bold
  //               )),
  //             ],
  //           );
  //         },
  //         onChange: (double value) {
  //           print(value);
  //         }),
  //   );
  // }

//   Future<void> determinePeriodAndOvulation() async {
//     //update periodRecord data as a service
//     String periodRecord = await ss.getItem("periodRecord");
//     Map<String, dynamic> record = jsonDecode(periodRecord);
//     // record["lastPeriod"] = "2021/4/24";
//     List<String> lastPeriod = "${record["lastPeriod"]}".split("/");
//     lengthPeriod = int.parse(record["length"]);
//     cyclePeriod = int.parse(record["cycle"]);
//
//     final lastP = DateTime(int.parse(lastPeriod[0]), int.parse(lastPeriod[1]),
//         int.parse(lastPeriod[2]));
//     final futurePeriodDay = lastP.add(Duration(
//         days: cyclePeriod)); //add the cycle of period to last period's date
//
//     final today = DateTime.now();
//
//     //diff in next period date
//     final diffPeriodDays =
//         today.difference(lastP).inDays; // how many days after last period
//
//     int periodRemaining = cyclePeriod - diffPeriodDays;
//     int ovulationRemaining =
//         cyclePeriod - 12; // remaining days to next ovulation
//
// //&& diffPeriodDays <= futurePeriodDay
//     if (diffPeriodDays >= cyclePeriod) {
//       // check for the remaining days to next period. if diff (6) > cyclePeriod (28)
//       //start period count
//       setState(() {
//         isPeriodStarted = true;
//       });
//
//       //date the period started
//       String getPeriodStartDate = await ss.getItem("periodStartDate");
//       List<String> periodStartDate = getPeriodStartDate.split("/");
//       final periodStartDateTime = DateTime(int.parse(periodStartDate[0]),
//           int.parse(periodStartDate[1]), int.parse(periodStartDate[2]));
//
//       //get what day of period
//       final endDateOfPeriod =
//       periodStartDateTime.add(Duration(days: lengthPeriod));
//       final today = DateTime.now();
//       final currentDay = periodStartDateTime.difference(today).inDays;
//     }
//
//     if (ovulationRemaining <= 0) {
//       //start period count
//       setState(() {
//         isPeriodStarted = false;
//       });
//
//       //date the period started
//       String getPeriodStartDate = await ss.getItem("periodStartDate");
//       List<String> periodStartDate = getPeriodStartDate.split("/");
//       final periodStartDateTime = DateTime(int.parse(periodStartDate[0]),
//           int.parse(periodStartDate[1]), int.parse(periodStartDate[2]));
//
//       //get what day of period
//       final endDateOfOvulation =
//       periodStartDateTime.add(Duration(days: lengthPeriod));
//       final today = DateTime.now();
//       final currentDay = periodStartDateTime.difference(today).inDays;
//     }
//     // if(diff > 0) {}
//
//     // print(diff);
//     print(lengthPeriod);
//     print(cyclePeriod);
//   }
}
