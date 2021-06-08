import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/ListItem/model_vitamins_data.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/constants.dart';
import 'package:coral_reef/g_chat_screen/components/topics_selection.dart';
import 'package:coral_reef/shared_screens/pill_icon.dart';
import 'package:coral_reef/tracker_screens/well_being_tracker/components/diet_header.dart';
import 'package:coral_reef/tracker_screens/well_being_tracker/services/vitamins_services.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../size_config.dart';

class SleepScreen extends StatefulWidget {
  static final routeName = "sleep-screen";

  @override
  State<StatefulWidget> createState() => _SleepScreen();
}

class _SleepScreen extends State<SleepScreen> {

  bool _loading = false;

  WellBeingServices vitaminServices;

  StorageSystem ss = new StorageSystem();

  String currentMood = "";

  String bedtime = "N/A", wakeup = "N/A", sleepingTime = "N/A";

  int bedtimeValue = 0, wakeupValue = 6;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vitaminServices = new WellBeingServices();
    getSleepLocalData();
  }

  getSleepLocalData() async {
    final date = DateTime.now();
    final months = ["JAN", "FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];

    String formatDate = "${date.year}_${months[date.month - 1]}_${date.day}";

    String current = await ss.getItem("sleepCurrent_$formatDate") ?? "";

    String _bedtimeValue = await ss.getItem("bedtimeValue") ?? "0";
    String _wakeupValue = await ss.getItem("wakeupValue") ?? "6";

    if(current.isEmpty) return;

    List<String> list = current.split("/");

    setState(() {
      bedtime = list[0];
      wakeup = list[1];
      sleepingTime = list[2];

      bedtimeValue = int.parse(_bedtimeValue);
      wakeupValue = int.parse(_wakeupValue);
    });
  }

  double getPointerValue() {
    // return ((int.parse(currentTakenVitamins) / int.parse(vitaminsGoal)) * 100);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DietHeader("Sleep").appBar(context),
      body: SafeArea(
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(30)),
                  child: Container(
                      child: SingleChildScrollView(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(height: SizeConfig.screenHeight * 0.01),
                                Padding(padding: EdgeInsets.symmetric(horizontal: 40),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      topSleepSummary("assets/well_being/sleep.svg", "BEDTIME", bedtime),
                                      topSleepSummary("assets/well_being/time.svg", "WAKE UP", wakeup)
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child:  SfRadialGauge(
                                      axes: <RadialAxis>[
                                        RadialAxis(
                                            interval: 1,
                                            startAngle: 0,
                                            endAngle: 360,
                                            showTicks: true,
                                            showLabels: true,
                                          onLabelCreated: (label) {
                                              return "$label AM";
                                          },
                                          showAxisLine: true,
                                          maximum: 23,
                                            minimum: 0,
                                            canScaleToFit: true,
                                            axisLineStyle: AxisLineStyle(thickness: 30, color: Color(MyColors.lightBackground)),

                                            pointers: <GaugePointer>[
                                              WidgetPointer(
                                                child: Container(
                                                    width: 50.0,
                                                    height: 50.0,
                                                    margin: EdgeInsets.only(left: 0.0),
                                                    decoration: BoxDecoration(
                                                        color: Color(MyColors.primaryColor),
                                                        borderRadius: BorderRadius.circular(25.0),
                                                        border: Border.all(color: Colors.white, width: 3.0)
                                                    ),
                                                    child: Stack(
                                                      children: [
                                                        Positioned(
                                                          left: 12.0,
                                                          top: 12.0,
                                                          child: PillIcon(
                                                            icon: 'assets/well_being/sleep.svg',
                                                            size: 20,
                                                            svgColor: Colors.white,
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                ),
                                                value: bedtimeValue.toDouble(),enableDragging: true,enableAnimation: true, onValueChanged: (double value) async {
                                                int v = value.ceil();
                                                String bt = (v >= 12) ? "PM" : "AM";
                                                if(bt == "PM") {
                                                  v = (v == 12) ? 12 : v - 12; //convert 24-hr to 12-hr time
                                                }
                                                int _diff = wakeupValue - value.ceil();
                                                int diff = (_diff < 0) ? (_diff * -1) : _diff;
                                                setState(() {
                                                  bedtimeValue = v;
                                                  bedtime = "$v:00 $bt";
                                                  sleepingTime = "$diff hrs";
                                                });
                                              },
                                              ),
                                              WidgetPointer(
                                                child: Container(
                                                    width: 50.0,
                                                    height: 50.0,
                                                    margin: EdgeInsets.only(left: 0.0),
                                                    decoration: BoxDecoration(
                                                        color: Color(MyColors.primaryColor),
                                                        borderRadius: BorderRadius.circular(25.0),
                                                        border: Border.all(color: Colors.white, width: 3.0)
                                                    ),
                                                    child: Stack(
                                                      children: [
                                                        Positioned(
                                                          left: 12.0,
                                                          top: 12.0,
                                                          child: PillIcon(
                                                            icon: 'assets/well_being/time.svg',
                                                            size: 20,
                                                            svgColor: Colors.white,
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                ),
                                                value: wakeupValue.toDouble(),enableDragging: true,enableAnimation: true, onValueChanged: (double value) async {
                                                int v = value.ceil();
                                                String bt = (v >= 12) ? "PM" : "AM";
                                                if(bt == "PM") {
                                                  v = (v == 12) ? 12 : v - 12; //convert 24-hr to 12-hr time
                                                }
                                                int _diff = value.ceil() - bedtimeValue;
                                                int diff = (_diff < 0) ? (_diff * -1) : _diff;
                                                setState(() {
                                                  wakeupValue = v;
                                                  wakeup = "$v:00 $bt";
                                                  sleepingTime = "$diff hrs";
                                                });
                                              },
                                              ),
                                            ],),
                                      ]
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    sleepingTime, textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.headline2.copyWith(
                                        color: Color(MyColors.titleTextColor),
                                        fontWeight: FontWeight.bold,
                                        fontSize: getProportionateScreenWidth(20)),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Total sleeping time", textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                                        color: Color(MyColors.titleTextColor),
                                        fontSize: getProportionateScreenWidth(15)),
                                  ),
                                ),
                                SizedBox(height: SizeConfig.screenHeight * 0.05),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 140.0,
                                  padding: EdgeInsets.all(20.0),
                                  decoration: BoxDecoration(
                                    color: Color(MyColors.defaultTextInField).withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Your daily sleep schedule", textAlign: TextAlign.center,
                                            style: Theme.of(context).textTheme.bodyText1.copyWith(
                                                color: Color(MyColors.titleTextColor),
                                                fontSize: getProportionateScreenWidth(15)),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                                      Row(
                                        children: [
                                          bottomSleepSummary("assets/well_being/sleep.svg", "BEDTIME", bedtime),
                                          SizedBox(width: 50.0,),
                                          bottomSleepSummary("assets/well_being/time.svg", "WAKE UP", wakeup),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: SizeConfig.screenHeight * 0.07),
                                DefaultButton(
                                  text: "Save",
                                  loading: _loading,
                                  press: () async {
                                    setState(() {
                                      _loading = true;
                                    });
                                    await ss.setPrefItem("bedtimeValue", "$bedtimeValue");
                                    await ss.setPrefItem("wakeupValue", "$wakeupValue");
                                    await vitaminServices.updateSleepData(bedtime, wakeup, sleepingTime);
                                    setState(() {
                                      _loading = false;
                                    });
                                    new GeneralUtils().showToast(context, "Sleep saved successfully.");
                                  },
                                ),
                                SizedBox(height: SizeConfig.screenHeight * 0.1),
                              ])))))),
    );
  }

  Widget topSleepSummary(String icon, String header, String subtitle) {
    return Column(
      children: [
        PillIcon(
          icon: icon,
          size: 20,
          paddingRight: 0,
        ),
        Text(
          header, textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle1.copyWith(
              color: Colors.grey,
              fontSize: getProportionateScreenWidth(15)),
        ),
        Text(
          subtitle, textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2.copyWith(
              color: Color(MyColors.titleTextColor),
              fontSize: getProportionateScreenWidth(15)),
        ),
      ],
    );
  }

  Widget bottomSleepSummary(String icon, String header, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            PillIcon(
              icon: icon,
              size: 20,
              paddingRight: 0.0,
            ),
            SizedBox(width: 5.0,),
            Text(
              header, textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: Colors.grey,
                  fontSize: getProportionateScreenWidth(15)),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              subtitle, textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.headline2.copyWith(
                  color: Color(MyColors.titleTextColor),
                  fontSize: getProportionateScreenWidth(15)),
            ),
          ],
        )
      ],
    );
  }

  Future<bool> displayDialog(MoodData md) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialogPage(
              title: "Sleep reminder",
              md: md);
        });
  }
}

class AlertDialogPage extends StatefulWidget {
  const AlertDialogPage(
      {Key key, this.title, this.md})
      : super(key: key);
  final String title;
  final MoodData md;

  @override
  _AlertDialogPageState createState() => _AlertDialogPageState();
}

class _AlertDialogPageState extends State<AlertDialogPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          Text(widget.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: Color(MyColors.titleTextColor),
                  fontSize: getProportionateScreenWidth(18))),
          Divider()
        ],
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Container(
        height: 300,
        width: MediaQuery.of(context).size.width - 100.0,
        child: SingleChildScrollView(
          child: Container(
            child: Center(
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PillIcon(
                            icon: 'assets/well_being/${widget.md.mood_type.toLowerCase()}.svg',
                            size: 60,
                          ),
                          SizedBox(height: SizeConfig.screenHeight * 0.03),
                          Text('${widget.md.mood_type}',textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline1.copyWith(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(27),
                            ),),
                          SizedBox(height: SizeConfig.screenHeight * 0.07),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PillIcon(
                                icon: 'assets/well_being/sleep.svg',
                                size: 20,
                                paddingRight: 0.0,
                              ),
                              SizedBox(width: 20.0,),
                              Text(
                                "${widget.md.week} ${widget.md.day} ${widget.md.month}, ${widget.md.year}",
                                style: Theme.of(context).textTheme.subtitle1.copyWith(
                                  color: Color(MyColors.primaryColor),
                                  fontSize: getProportionateScreenWidth(12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
