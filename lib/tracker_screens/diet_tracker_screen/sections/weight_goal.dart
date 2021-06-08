import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/ListItem/model_vitamins_data.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/constants.dart';
import 'package:coral_reef/g_chat_screen/components/topics_selection.dart';
import 'package:coral_reef/shared_screens/pill_icon.dart';
import 'package:coral_reef/tracker_screens/diet_tracker_screen/services/diet_service.dart';
import 'package:coral_reef/tracker_screens/well_being_tracker/components/diet_header.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../size_config.dart';

class WeightGoal extends StatefulWidget {
  static final routeName = "weight-goal";

  @override
  State<StatefulWidget> createState() => _WeightGoal();
}

class _WeightGoal extends State<WeightGoal> {

  bool _loading = false;

  String currentWeight = "", currentBMI = "", currentHeight = "", currentInch = "";
  String goalWeight = "", weightMetric = "kg", heightMetric = "cm";

  DietServices dietServices;

  StorageSystem ss = new StorageSystem();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dietServices = new DietServices();
    getWeightLocalData();
    getExerciseSetupData();
  }

  getExerciseSetupData() async {
    String exercise = await ss.getItem("dewRecord");
    String wMetric = await ss.getItem("weight_metric");
    String hMetric = await ss.getItem("height_metric");
    Map<String, dynamic> json = jsonDecode(exercise);
    setState(() {
      weightMetric = wMetric;
      heightMetric = hMetric;
      goalWeight = "${json["2"]}";
      currentHeight = "${json["3"]}";
      currentInch = "${json["inch"]}";
      if(currentWeight.isEmpty) {
        currentWeight = "${json["1"]}";
      }
    });
  }

  getWeightLocalData() async {
    final date = DateTime.now();
    final months = ["JAN", "FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];

    String formatDate = "${date.year}_${months[date.month - 1]}_${date.day}";

    String current = await ss.getItem("weightCurrent_$formatDate") ?? "";

    if(current.isEmpty) return;

    List<String> list = current.split("/");

    setState(() {
      currentWeight = list[0];
      currentBMI = list[1];
      currentHeight = list[2];
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DietHeader("Weight").appBar(context),
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
                                SizedBox(height: SizeConfig.screenHeight * 0.03),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: formatTexts("Goal Weight: ", goalWeight, weightMetric),
                                ),
                                SizedBox(height: SizeConfig.screenHeight * 0.03),
                                Padding(
                                  padding: EdgeInsets.all(0.0),
                                  child:  Stack(
                                    children: [
                                      SfRadialGauge(
                                          axes: <RadialAxis>[
                                            RadialAxis(
                                                interval: 20,
                                                startAngle: 180,
                                                endAngle: 360,
                                                showTicks: true,
                                                showLabels: false,
                                                axisLineStyle: AxisLineStyle(thickness: 30, color: Color(MyColors.primaryColor)),)
                                          ]),
                                      Container(
                                          width: MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.only(top: 80.0),
                                          height: 100.0,
                                          child:  Align(
                                            alignment: Alignment.center,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                formatTexts("", currentWeight, weightMetric),
                                              ],
                                            ),
                                          )
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(top:220.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "BMI", textAlign: TextAlign.center,
                                                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                                                        color: Colors.black,
                                                        fontSize: getProportionateScreenWidth(16)),
                                                  ),
                                                  Text(
                                                    calculateBMI(), textAlign: TextAlign.center,
                                                    style: Theme.of(context).textTheme.headline2.copyWith(
                                                        color: Color(MyColors.primaryColor),
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: getProportionateScreenWidth(22)),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Height", textAlign: TextAlign.center,
                                                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                                                        color: Colors.black,
                                                        fontSize: getProportionateScreenWidth(16)),
                                                  ),
                                                  (heightMetric == "cm") ? formatTexts("", currentHeight, heightMetric) : Row(
                                                    children: [
                                                      formatTexts("", currentHeight, heightMetric),
                                                      SizedBox(width: 5.0,),
                                                      formatTexts("", currentInch, "''"),
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                          )
                                      ),
                                    ],
                                  )
                                ),
                              SizedBox(height: SizeConfig.screenHeight * 0.1),
                                DefaultButton(
                                  text: "Add new weight",
                                  loading: _loading,
                                  press: displayDialog
                                )
                              ])))))),
    );
  }

  Widget formatTexts(String prefix, String value, String suffix) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          prefix,
          style: Theme.of(context).textTheme.subtitle1.copyWith(
            fontSize: getProportionateScreenWidth(16),
            color: Color(MyColors.titleTextColor), ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.headline2.copyWith(
            color: Color(MyColors.primaryColor),
              fontWeight: FontWeight.bold,
            fontSize: getProportionateScreenWidth(22),
          ),
        ),
        Text(
          suffix,
          style: Theme.of(context).textTheme.subtitle1.copyWith(
              fontSize: getProportionateScreenWidth(16),
              color: Color(MyColors.primaryColor), ),
        ),
      ],
    );
  }

  String calculateBMI() {
    double bmi = 0;
    if(weightMetric == "kg" && heightMetric == "cm") {
      double heightInMeters = double.parse(currentHeight) / 100;
      bmi = double.parse(currentWeight) / (heightInMeters * heightInMeters);
      return bmi.toStringAsFixed(2);
    }
    if(weightMetric == "lbs" && heightMetric == "ft") {
        double totalHeight = getTotalHeightFt();
        bmi = (double.parse(currentWeight) / (totalHeight * totalHeight)) * 703;
        return bmi.toStringAsFixed(2);
    }
    double weight = (weightMetric == "kg") ? double.parse(currentWeight) : double.parse(currentWeight) * 2.205;
    double height = (heightMetric == "cm") ? (double.parse(currentHeight) / 100) : (getTotalHeightFt() * 2.54);

    bmi = weight / (height * height);
    return bmi.toStringAsFixed(2);
  }

  getTotalHeightFt() {
    double convertFtToIn = double.parse(currentHeight) * 12;
    return convertFtToIn + double.parse(currentInch);
  }

  Future<bool> displayDialog() {
    return showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialogPage(
              title: "Add weight",
              initialValue: currentWeight,
              height: currentHeight,
              inches: currentInch,
              wMetric: weightMetric,
              hMetric: heightMetric,
              weightGoal: goalWeight,
              onSaved: (weight, metric) {
                setState(() {
                  currentWeight = "$weight";
                  weightMetric = metric;
                });
                calculateBMI();
              }
          );
        });
  }
}

class AlertDialogPage extends StatefulWidget {
  const AlertDialogPage(
      {Key key, this.title, this.initialValue, this.height, this.inches, this.wMetric, this.hMetric, this.weightGoal, this.onSaved})
      : super(key: key);
  final String title;
  final String initialValue;
  final String height;
  final String inches;
  final String wMetric;
  final String hMetric;
  final String weightGoal;
  final Function(double newWeight, String newMetric) onSaved;

  @override
  _AlertDialogPageState createState() => _AlertDialogPageState();
}

class _AlertDialogPageState extends State<AlertDialogPage> {

  TextEditingController _textEditingController;
  DietServices dietServices;
  bool _loading = false;
  String wMetric = "";

  StorageSystem ss = new StorageSystem();

  String calculateBMI() {
    double bmi = 0;
    if(widget.wMetric == "kg" && widget.hMetric == "cm") {
      double heightInMeters = double.parse(widget.height) / 100;
      bmi = double.parse(_textEditingController.text) / (heightInMeters * heightInMeters);
      return bmi.toStringAsFixed(2);
    }
    if(widget.wMetric == "lbs" && widget.hMetric == "ft") {
      double totalHeight = getTotalHeightFt();
      bmi = (double.parse(_textEditingController.text) / (totalHeight * totalHeight)) * 703;
      return bmi.toStringAsFixed(2);
    }
    double weight = (widget.wMetric == "kg") ? double.parse(_textEditingController.text) : double.parse(_textEditingController.text) * 2.205;
    double height = (widget.hMetric == "cm") ? double.parse(widget.height) / 100 : getTotalHeightFt() * 2.54;

    bmi = weight / (height * height);
    return bmi.toStringAsFixed(2);
  }

  getTotalHeightFt() {
    double convertFtToIn = double.parse(widget.height) * 12;
    return convertFtToIn + double.parse(widget.inches);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    wMetric = widget.wMetric;
    _textEditingController = new TextEditingController(text: widget.initialValue);
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
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 200.0,
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
                        Align(
                          alignment: Alignment.topRight,
                          child: TopicsSelection(text: wMetric, selected: true, onTap: () async {
                            setState(() {
                              wMetric = (wMetric == "kg") ? "lbs" : "kg";
                            });
                            await ss.setPrefItem("weight_metric", wMetric);
                          },),
                        ),
                      ],
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
                      loading: _loading,
                      press: () async {
                        if(_textEditingController.text.isEmpty) return;
                        await dietServices.updateWeightData(_textEditingController.text, calculateBMI(), widget.height, widget.weightGoal);
                        widget.onSaved(double.parse(_textEditingController.text), wMetric);
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

/*
() async {
                                    setState(() {
                                      _loading = true;
                                    });
                                    // await dietServices.updateMoodData(currentMood);
                                    setState(() {
                                      _loading = false;
                                    });
                                    new GeneralUtils().showToast(context, "Weight saved successfully.");
                                  },
* */
