
import 'package:coral_reef/ListItem/model_vitamins_data.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/shared_screens/pill_icon.dart';
import 'package:coral_reef/tracker_screens/services/general_dew_services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

import '../../../size_config.dart';

class SleepInsight extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SleepInsight();
}

class _SleepInsight extends State<SleepInsight> {

  String selectedDataByType = "Days";
  List<String> typeOptions = ["Days", "Weeks", "Months"];

  final months = [
    "JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG", "SEP","OCT","NOV","DEC"
  ];

  DewServices dewServices;

  final Color leftBarColor = const Color(0xff53fdd7);
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 7;

  List<BarChartGroupData> rawBarGroups = [];
  List<BarChartGroupData> showingBarGroups = [];

  int touchedGroupIndex = 0;

  List<SleepData> sleepData = [];
  String bedtime = "N/A", wakeup = "N/A", sleepingTime = "N/A", createdDate = "N/A";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dewServices = new DewServices(context);
    setState(() {
      rawBarGroups = [dewServices.makeGroupData(0, 0, 0)];
      showingBarGroups = [dewServices.makeGroupData(0, 0, 0)];
    });
    getInitialChartData();
  }

  getInitialChartData() async {
    setState(() {
      bedtime = "N/A";
      wakeup = "N/A";
      sleepingTime = "N/A";
      createdDate = "N/A";
    });
    Map<String, dynamic> data = await dewServices.getSleepDataInsight(selectedDataByType);
    print(selectedDataByType);
    setState(() {
      sleepData = data["sleep"];
      rawBarGroups = data["chart"];
      showingBarGroups = rawBarGroups;

      if(sleepData.isNotEmpty) {
        bedtime = sleepData[0].bed_time;
        wakeup = sleepData[0].wake_up;
        sleepingTime = sleepData[0].sleeping_time;
        createdDate = (selectedDataByType == "Days") ? "${sleepData[0].week}, ${sleepData[0].month} ${sleepData[0].day}" : "${sleepData[0].created_date}";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [

        Align(
          alignment: Alignment.center,
          child: GroupButton(
              buttons: typeOptions,
              // borderRadius: BorderRadius.circular(10.0),
              selectedColor: Color(MyColors.primaryColor),
              unselectedBorderColor: Color(MyColors.lightBackground),
              unselectedTextStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Color(MyColors.primaryColor),
              ),
              selectedTextStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Colors.white,
              ),
              buttonHeight: 40.0,
              onSelected: (index, type) {
                setState(() {
                  selectedDataByType = typeOptions[index];
                });
                getInitialChartData();
              }),
        ),
        SizedBox(height: SizeConfig.screenHeight * 0.03),
        Container(
            height: 250.0,
            child: barChart()
        ),
        SizedBox(height: SizeConfig.screenHeight * 0.03),
        Align(
            alignment: Alignment.center,
            child: Text(createdDate, style: Theme.of(context).textTheme.headline2.copyWith(
                color: Color(MyColors.titleTextColor),
                fontSize: getProportionateScreenWidth(20)
            ),)
        ),
        insightInfo()
      ],
    );
  }


  Widget insightInfo() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.purpleAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      height: 135,
      padding: EdgeInsets.all(15.0),
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
                icon: 'assets/well_being/sleep.svg',
                size: 20,
                paddingRight: 0.0,
              )
            ],
          ),
          Container(height: 20.0,),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "$sleepingTime\n",
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: getProportionateScreenWidth(15),
                          color: Color(MyColors.titleTextColor)
                      ),
                    ),
                    TextSpan(text: "Average bed time", style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Color(MyColors.titleTextColor)
                    ),)
                  ],
                ),
                textAlign: TextAlign.start,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "$bedtime - $wakeup\n",
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: getProportionateScreenWidth(15),
                          color: Color(MyColors.titleTextColor)
                      ),
                    ),
                    TextSpan(text: " Sleep schedule", style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Color(MyColors.titleTextColor)
                    ),),
                  ],
                ),
                textAlign: TextAlign.end,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget barChart() {
    return BarChart(
      BarChartData(
        // maxY: 20,
        gridData: FlGridData(
          show: true,
        ),
        barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor:  Color(MyColors.primaryColor),
              direction: TooltipDirection.auto,
              getTooltipItem: (_a, _b, _c, _d) {
                return BarTooltipItem("${_c.y}",Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14));
              },
            ),
            touchCallback: (response){
          if(response.spot == null) {
            return;
          }
          int index = response.spot.touchedBarGroupIndex;
          setState(() {
            bedtime = sleepData[index].bed_time;
            wakeup = sleepData[index].wake_up;
            sleepingTime = sleepData[index].sleeping_time;
            createdDate = (selectedDataByType == "Days") ? "${sleepData[index].week}, ${sleepData[index].month} ${sleepData[index].day}" : "${sleepData[index].created_date}";
          });
          print("${response.spot.touchedBarGroupIndex}");
        }),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: (value) => Theme.of(context).textTheme.bodyText1.copyWith(
                color: Color(MyColors.primaryColor),
                fontWeight: FontWeight.bold,
                fontSize: 14),
            margin: 10,
            getTitles: (double value) {
              return (selectedDataByType == "Days") ? "${value.ceil()}" : (selectedDataByType == "Weeks") ? "wk ${value.ceil()}" : months[value.ceil()];
              //   switch (value.toInt()) {
              //     case 0:
              //       return 'Mon';
              //     case 1:
              //       return 'Tue';
              //     case 2:
              //       return 'Wed';
              //     case 3:
              //       return 'Thu';
              //     case 4:
              //       return 'Fri';
              //     case 5:
              //       return 'Sat';
              //     case 6:
              //       return 'Sun';
              //     default:
              //       return '';
              //   }
            },
          ),
          leftTitles: SideTitles(
            showTitles: false,
            getTextStyles: (value) => Theme.of(context).textTheme.bodyText1.copyWith(
                color: Color(MyColors.primaryColor),
                fontWeight: FontWeight.bold,
                fontSize: 14),
            margin: 10,
            reservedSize: 14,
            // getTitles: (value) {
            //   if (value == 0) {
            //     return '20000';
            //   } else if (value == 10) {
            //     return '15000';
            //   } else if (value == 19) {
            //     return '10000';
            //   } else {
            //     return '';
            //   }
            // },
          ),
        ),
        borderData: FlBorderData(
            show: true,
            border: Border.all(color: Color(MyColors.lightBackground),)
        ),
        barGroups: showingBarGroups,
      ),
      swapAnimationCurve: Curves.easeInOutCubic, swapAnimationDuration: Duration(milliseconds: 300),
    );
  }
}