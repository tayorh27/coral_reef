
import 'package:coral_reef/ListItem/model_diet_data.dart';
import 'package:coral_reef/ListItem/model_vitamins_data.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/shared_screens/pill_icon.dart';
import 'package:coral_reef/tracker_screens/services/general_dew_services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

import '../../../size_config.dart';

class CaloriesInsight extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CaloriesInsight();
}

class _CaloriesInsight extends State<CaloriesInsight> {

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

  List<WaterData> waterData = [];
  String caloriesCount = "N/A", createdDate = "N/A";

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
      caloriesCount = "N/A";
      createdDate = "N/A";
    });
    Map<String, dynamic> data = await dewServices.getCaloriesDataInsight(selectedDataByType);
    setState(() {
      waterData = data["data"];
      rawBarGroups = data["chart"];
      showingBarGroups = rawBarGroups;

      if(waterData.isNotEmpty) {
        caloriesCount = waterData[0].glasses_count;
        createdDate = (selectedDataByType == "Days") ? "${waterData[0].week}, ${waterData[0].month} ${waterData[0].day}" : "${waterData[0].created_date}";
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
      width: 200.0,
      height: 200.0,
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Average calories taken', textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Color(MyColors.titleTextColor),
              fontSize: getProportionateScreenWidth(13),
            ),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$caloriesCount',textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline2.copyWith(
                  color: Color(MyColors.primaryColor),
                  fontSize: getProportionateScreenWidth(27),
                ),),
              Text('kcal', textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: Color(MyColors.primaryColor),
                  fontSize: getProportionateScreenWidth(13),
                ),),
              Container(
                margin: EdgeInsets.only(left: 0.0),
                child: PillIcon(
                  icon: 'assets/diet/kcal.svg',
                  size: 15,
                ),
              ),
            ],
          )
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
            ),touchCallback: (response){
          if(response.spot == null) {
            return;
          }
          int index = response.spot.touchedBarGroupIndex;
          setState(() {
            caloriesCount = waterData[index].glasses_count;
            createdDate = (selectedDataByType == "Days") ? "${waterData[index].week}, ${waterData[index].month} ${waterData[index].day}" : "${waterData[index].created_date}";
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