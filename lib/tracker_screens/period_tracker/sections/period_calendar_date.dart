import 'dart:convert';

import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/coral_back_button.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../size_config.dart';

class PeriodCalendarDate extends StatefulWidget {
  static final routeName = "period-calendar-date";

  @override
  State<StatefulWidget> createState() => _PeriodCalendarDate();
}

class _PeriodCalendarDate extends State<PeriodCalendarDate> {

  StorageSystem ss = new StorageSystem();

  DateRangePickerController _datePickerController = DateRangePickerController();

  int lengthPeriod = 0, cyclePeriod = 0;

  bool isOnPeriod = false;

  String menstrualType = "Period";

  int diffTodayAndStartDate = 0;
  int diffTodayAndEndDate = 0;

  int totalDaysRemaining = 0;

  int diffRemainingDays = 0;

  DateTime min = DateTime.now();
  DateTime max = DateTime.now();

  Future<void> determinePeriod() async {
    String periodRecord = await ss.getItem("periodRecord");
    Map<String, dynamic> record = jsonDecode(periodRecord);
    print(record);
    // record["lastPeriod"] = "2021/4/24";
    List<String> lastPeriod = "${record["lastPeriod"]}".split("/");
    lengthPeriod = int.parse(record["length"]);
    cyclePeriod = int.parse(record["cycle"]);

    final lastP = DateTime(int.parse(lastPeriod[0]), int.parse(lastPeriod[1]),int.parse(lastPeriod[2])); //convert string to date object of last period date

    final futurePeriodStartDate = lastP.add(Duration(days: cyclePeriod)); //add period cycle days to last period date to get the next period date

    final futurePeriodEndDate = futurePeriodStartDate.add(Duration(days: (lengthPeriod-1))); //add length of period to period start date to get when the period will end

    if(!mounted) return;
    setState(() {
      _datePickerController.selectedRange =
          PickerDateRange(futurePeriodStartDate, futurePeriodEndDate);
      min = futurePeriodStartDate;
      max = futurePeriodEndDate;
    });

    final today = DateTime.now(); //(2021, 6, 23); //get current date

    diffTodayAndStartDate = today.difference(futurePeriodStartDate).inDays; //get the difference between today and the start date
    diffTodayAndEndDate = futurePeriodEndDate.difference(today).inDays; // get the difference between the end start and today

    if(diffTodayAndStartDate >= 0 && diffTodayAndStartDate < cyclePeriod) { //check if the day is within the period cycle
      if(!mounted) return;
      setState(() {
        menstrualType = "Period Cycle";
        isOnPeriod = true;
      });
      //ovulation
      if(diffTodayAndStartDate >= 12 && diffTodayAndStartDate <= 17) { //check if current date is within the ovulation period
        if(!mounted) return;
        setState(() {
          isOnPeriod = true;
          menstrualType = "Ovulation";
        });
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
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CoralBackButton(
                    icon: Icon(
                      Icons.clear,
                      size: 32.0,
                      color: Color(MyColors.titleTextColor),
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Text(
                    "Period Calendar Date",
                    style: Theme.of(context).textTheme.headline2.copyWith(
                          color: Color(MyColors.titleTextColor),
                          fontSize: getProportionateScreenWidth(20),
                        ),
                  )
                ],
              ),
              SizedBox(height: 30.0),
              Container(
                height: 600.0,
                child: SfDateRangePicker(
                  rangeSelectionColor: Color(MyColors.primaryColor),
                  showNavigationArrow: true,
                  selectionMode: DateRangePickerSelectionMode.range,
                  rangeTextStyle: TextStyle(color: Colors.white),
                  enableMultiView: false,
                  navigationDirection: DateRangePickerNavigationDirection.vertical,
                  selectionShape: DateRangePickerSelectionShape.rectangle,navigationMode: DateRangePickerNavigationMode.scroll,
                  controller: _datePickerController,
                  minDate: min,
                  maxDate: max,
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
