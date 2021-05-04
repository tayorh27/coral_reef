import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/constants.dart';
import 'package:coral_reef/wellness/diet_exercise_well_being/required_weight.dart';
import 'package:vertical_weight_slider/vertical_weight_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:coral_reef/wellness/onboarding/component.dart';

import '../../size_config.dart';

class WeightScreen extends StatefulWidget {

  static String routeName = "/weight";
  final double currentWeight;
  final Function(double weight, bool clicked) onPress;

  WeightScreen(this.currentWeight, {this.onPress});

  @override
  State<StatefulWidget> createState() => _WeightScreen();
}

class _WeightScreen extends State<WeightScreen> {

  double weight = 30.0;

  StorageSystem ss = new StorageSystem();

  String metricSelected = "kg";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    weight = (widget.currentWeight == null) ? 30.0 : widget.currentWeight;
    ss.getItem("weight_metric").then((value) {
      String v = value ?? "kg";
      setState(() {
        metricSelected = v;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20),
              vertical: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // SizedBox(height: SizeConfig.screenHeight * 0.01),
                // HeadingText(),
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                metricSwitch(),
                Container(
                  child: Column(
                    children: [
                      Container(
                        height: 100.0,
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            _showTestDialog(context);
                          },
                          child: Text(
                            "$weight $metricSelected",
                            style: TextStyle(
                                color: Colors.purple,
                                fontSize: 40.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      VerticalWeightSlider(
                        maximumWeight: 2000,
                        initialWeight: weight,
                        gradationColor: [
                          Colors.purple[500],
                          Colors.purple[300],
                          Colors.purple[100],
                        ],
                        onChanged: (value) {
                          setState(() {
                            weight = value;
                          });
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                DefaultButton(
                    text: 'Continue',
                    press: () {
                      widget.onPress(weight, true);
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget metricSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: SwitchButtons(
              text: 'kg',
              selected: metricSelected == "kg",
              press: () async {
                // await ss.setPrefItem("weight_metric", "kg");
                setState(() {
                  metricSelected = "kg";
                });
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: SwitchButtons(
              text: 'lbs',
              selected: metricSelected == "lbs",
              press: () async {
                // await ss.setPrefItem("weight_metric", "lbs");
                setState(() {
                  metricSelected = "lbs";
                });
              }),
        ),
      ],
    );
  }
}

void _showTestDialog(context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      //context: _scaffoldKey.currentContext,
      builder: (context) {
        return AlertDialogPage();
      });
}

class AlertDialogPage extends StatefulWidget {
  const AlertDialogPage({
    Key key,
  }) : super(key: key);

  @override
  _AlertDialogPageState createState() => _AlertDialogPageState();
}

class _AlertDialogPageState extends State<AlertDialogPage> {
  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //contentPadding: EdgeInsets.only(left: 20, right: 20),
      title: Text(
        'Add Weight',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: getProportionateScreenWidth(20),
          fontWeight: FontWeight.bold,
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Container(
        height: 200,
        width: 300,
        child: SingleChildScrollView(
          child: Container(
            child: Center(
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '70.0',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: getProportionateScreenWidth(30),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Button2(
                        text: 'kg',
                      )
                    ],
                  ),
                  Divider(),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'DATE: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(13),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text(
                        now.toString(),
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: getProportionateScreenWidth(13),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Divider(),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  DefaultButton(
                      text: 'Save',
                      press: () {
                        Navigator.pop(context);
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
