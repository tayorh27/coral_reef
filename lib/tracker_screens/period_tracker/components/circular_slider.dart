
import 'dart:convert';

import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class CircularSlider extends StatefulWidget {
  
  final String periodCount;
  CircularSlider(this.periodCount);
  
  @override
  State<StatefulWidget> createState() => _CircularSlider();
}

class _CircularSlider extends State<CircularSlider> {

  StorageSystem ss = new StorageSystem();

  int lengthPeriod = 0, cyclePeriod = 0;

  bool isPeriodStarted = false;
  String menstrualType = ""; //period or ovulation

  Future<void> determinePeriodAndOvulation() async {
    //update periodRecord data as a service
    String periodRecord = await ss.getItem("periodRecord");
    Map<String, dynamic> record = jsonDecode(periodRecord);
    // record["lastPeriod"] = "2021/4/24";
    List<String> lastPeriod = "${record["lastPeriod"]}".split("/");
    lengthPeriod = int.parse(record["length"]);
    cyclePeriod = int.parse(record["cycle"]);

    final lastP = DateTime(int.parse(lastPeriod[0]), int.parse(lastPeriod[1]), int.parse(lastPeriod[2]));
    final futurePeriodDay = lastP.add(Duration(days: cyclePeriod)); //add the cycle of period to last period's date

    final today = DateTime.now();

    //diff in next period date
    final diffPeriodDays = today.difference(lastP).inDays; // how many days after last period

    int periodRemaining = cyclePeriod - diffPeriodDays;
    int ovulationRemaining = cyclePeriod - 12; // remaining days to next ovulation


//&& diffPeriodDays <= futurePeriodDay
    if(diffPeriodDays >= cyclePeriod ) { // check for the remaining days to next period. if diff (6) > cyclePeriod (28)
      //start period count
      setState(() {
        isPeriodStarted = true;
      });

      //date the period started
      String getPeriodStartDate = await ss.getItem("periodStartDate");
      List<String> periodStartDate = getPeriodStartDate.split("/");
      final periodStartDateTime = DateTime(int.parse(periodStartDate[0]), int.parse(periodStartDate[1]), int.parse(periodStartDate[2]));

      //get what day of period
      final endDateOfPeriod = periodStartDateTime.add(Duration(days: lengthPeriod));
      final today = DateTime.now();
      final currentDay = periodStartDateTime.difference(today).inDays;
    }

    if(ovulationRemaining <= 0) {
      //start period count
      setState(() {
        isPeriodStarted = false;
      });

      //date the period started
      String getPeriodStartDate = await ss.getItem("periodStartDate");
      List<String> periodStartDate = getPeriodStartDate.split("/");
      final periodStartDateTime = DateTime(int.parse(periodStartDate[0]), int.parse(periodStartDate[1]), int.parse(periodStartDate[2]));

      //get what day of period
      final endDateOfOvulation = periodStartDateTime.add(Duration(days: lengthPeriod));
      final today = DateTime.now();
      final currentDay = periodStartDateTime.difference(today).inDays;
    }
    // if(diff > 0) {}

    // print(diff);
    print(lengthPeriod);
    print(cyclePeriod);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    determinePeriodAndOvulation();
    return Container(
      width: 200.0,
      height: 200.0,
      decoration: BoxDecoration(
          color: Color(MyColors.primaryColor),
          borderRadius: BorderRadius.circular(100.0)
      ),
      child: SleekCircularSlider(
          appearance: CircularSliderAppearance(
            angleRange: 360.0,
            customColors: CustomSliderColors(
              progressBarColors: [
                Color(MyColors.stroke1Color),
                Color(MyColors.stroke2Color),
              ],
              trackColor: Color(MyColors.progressSliderColor),
                dynamicGradient: true,
            ),
            customWidths: CustomSliderWidths(
              trackWidth: 15.0
            )
          ),
          initialValue: double.parse(widget.periodCount),
          min: 0,
          max: 35, //max period cycle
          innerWidget: (double value){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text((menstrualType == "period") ? "Period:" : "Period:", style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: Colors.white,
                  fontSize: getProportionateScreenWidth(12),
                )),
                Text("Day ${widget.periodCount}", style: Theme.of(context).textTheme.subtitle1.copyWith(
                    color: Colors.white,
                    fontSize: getProportionateScreenWidth(24),
                    fontWeight: FontWeight.bold
                )),
              ],
            );
          },
          onChange: (double value) {
            print(value);
          }),
    );
  }
}