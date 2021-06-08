import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/shared_screens/pill_icon.dart';
import 'package:coral_reef/tracker_screens/diet_tracker_screen/services/diet_service.dart';
import 'package:coral_reef/tracker_screens/well_being_tracker/components/diet_header.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../size_config.dart';

class WaterGoal extends StatefulWidget {
  static final routeName = "water-goals";

  @override
  State<StatefulWidget> createState() => _WaterGoal();
}

class _WaterGoal extends State<WaterGoal> {

  bool _loading = false;

  String waterGoal = "0", currentTakenWater = "0";

  DietServices dietServices;

  StorageSystem ss = new StorageSystem();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dietServices = new DietServices();
    getWaterLocalData();
  }

  getWaterLocalData() async {
    final date = DateTime.now();
    final months = ["JAN", "FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];

    String formatDate = "${date.year}_${months[date.month - 1]}_${date.day}";

    String goal = await ss.getItem("waterGoal") ?? "0";
    String current = await ss.getItem("waterCurrent_$formatDate") ?? "0";

    setState(() {
      waterGoal = goal;
      currentTakenWater = current;
    });
  }

  double getPointerValue() {
    return ((int.parse(currentTakenWater) / int.parse(waterGoal)) * 100);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DietHeader("Water").appBar(context),
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
                                Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child:  SfRadialGauge(
                                      axes: <RadialAxis>[
                                        RadialAxis(
                                            interval: 10,
                                            startAngle: 0,
                                            endAngle: 360,
                                            showTicks: false,
                                            showLabels: false,
                                            axisLineStyle: AxisLineStyle(thickness: 30, color: Color(MyColors.stroke2Color).withOpacity(0.2)),
                                            pointers: <GaugePointer>[
                                              RangePointer(
                                                  value: getPointerValue() > 100 ? 100 : getPointerValue(),
                                                  width: 30,
                                                  color: Color(MyColors.stroke2Color),
                                                  enableAnimation: true,
                                                  cornerStyle: CornerStyle.bothCurve)
                                            ],
                                            annotations: <GaugeAnnotation>[
                                              GaugeAnnotation(
                                                  widget: Container(
                                                    width: 200.0,
                                                    height: 200.0,
                                                    child:  Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        Container(
                                                          margin: EdgeInsets.only(left: 30.0),
                                                          child: PillIcon(
                                                            icon: 'assets/diet/glass.svg',
                                                            size: 40,
                                                            svgColor: Color(MyColors.stroke2Color),
                                                          ),
                                                        ),
                                                        Text('$currentTakenWater/$waterGoal',textAlign: TextAlign.center,
                                                          style: Theme.of(context).textTheme.headline2.copyWith(
                                                            color: Colors.black,
                                                            fontSize: getProportionateScreenWidth(27),
                                                          ),),
                                                        Text('glasses', textAlign: TextAlign.center,
                                                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                                            color: Color(MyColors.titleTextColor),
                                                            fontSize: getProportionateScreenWidth(13),
                                                          ),),
                                                      ],
                                                    ),
                                                  ),
                                                  angle: 270,
                                                  positionFactor: 0.1)
                                            ])
                                      ]),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 50.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          int goal = int.parse(waterGoal);
                                          int currentV = int.parse(currentTakenWater);
                                          if(goal <= 0 || (currentV - 1) < 0) {
                                            return;
                                          }
                                          setState(() {
                                            currentTakenWater = "${currentV - 1}";
                                            getPointerValue();
                                          });
                                          dietServices.updateWaterTakenCount(currentV - 1, goal);
                                        },
                                        child: PillIcon(
                                          icon: 'assets/well_being/Subtract.svg',
                                          size: 30,
                                          svgColor: Colors.grey,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          int goal = int.parse(waterGoal);
                                          if(goal <= 0) {
                                            return;
                                          }
                                          int currentV = int.parse(currentTakenWater);
                                          setState(() {
                                            currentTakenWater = "${currentV + 1}";
                                            getPointerValue();
                                          });
                                          dietServices.updateWaterTakenCount((currentV + 1), goal);
                                        },
                                        child: PillIcon(
                                          icon: 'assets/well_being/add.svg',
                                          size: 30,
                                          svgColor: Color(MyColors.stroke2Color),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: SizeConfig.screenHeight * 0.07),
                                DefaultButton(
                                  text: "Set daily goal",
                                  loading: _loading,
                                  press: displayDialog,
                                )
                              ])))))),
    );
  }

  Future<bool> displayDialog() {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialogPage(
              title: "Daily water intake (glasses)",
              initialValue: waterGoal,
              onOptionSelected: (val) {
                if (!mounted) return;
                setState(() {
                  waterGoal = val;
                  // getPointerValue();
                });
              });
        });
  }
}

class AlertDialogPage extends StatefulWidget {
  const AlertDialogPage(
      {Key key, this.onOptionSelected, this.title, this.initialValue = ""})
      : super(key: key);

  final Function(String value) onOptionSelected;
  final String title;
  final String initialValue;

  @override
  _AlertDialogPageState createState() => _AlertDialogPageState();
}

class _AlertDialogPageState extends State<AlertDialogPage> {

  TextEditingController _textEditingController;
  DietServices dietServices;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String init = (widget.initialValue == "0") ? "" : widget.initialValue;
    _textEditingController = new TextEditingController(text: init);
    dietServices = new DietServices();
  }

  rewriteTimeValue(int value) {
    return value < 10 ? "0$value" : "$value";
  }

  getCurrentDateTime() {
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    DateTime date = DateTime.now();
    return "${rewriteTimeValue(date.day)} ${months[date.month - 1]} ${date.year}, ${rewriteTimeValue(date.hour)}:${rewriteTimeValue(date.minute)}";
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
          // (widget.description.isEmpty) ? SizedBox() : Text(
          //     widget.description,
          //     textAlign: TextAlign.center,
          //     style: Theme.of(context).textTheme.subtitle1.copyWith(
          //         color: Colors.grey,
          //         fontSize: getProportionateScreenWidth(13)
          //     )
          // ),
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
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      autofocus: true,
                      controller: _textEditingController,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline2.copyWith(
                          fontSize: getProportionateScreenWidth(45),
                          color: Color(MyColors.primaryColor)
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 15,
                          ),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,hintText: "0"
                      ),
                    ),
                  ),
                  Divider(),
                  Text(
                    "1 glass of water is 250 ml",
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: Colors.grey,
                      fontSize: getProportionateScreenWidth(12),
                    ),
                  ),
                  Divider(thickness: 2.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Date",
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Color(MyColors.titleTextColor),
                          fontSize: getProportionateScreenWidth(12),
                        ),
                      ),
                      Text(
                        getCurrentDateTime(),
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Color(MyColors.primaryColor),
                          fontSize: getProportionateScreenWidth(12),
                        ),
                      ),
                    ],
                  ),
                  Divider(thickness: 2.0,),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  DefaultButton(
                      text: 'Save',
                      press: () async {
                        if(_textEditingController.text.isEmpty) return;
                        await dietServices.saveWaterGoal(_textEditingController.text);
                        widget.onOptionSelected(_textEditingController.text);
                        Navigator.of(context).pop(false);
                      }),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text(
                        "Cancel",
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: Color(MyColors.primaryColor),
                            fontSize: getProportionateScreenWidth(16)),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
