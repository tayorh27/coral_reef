import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/constants.dart';
import 'package:coral_reef/g_chat_screen/components/topics_selection.dart';
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
      ss.setPrefItem("weight_metric", metricSelected);
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
                SizedBox(height: SizeConfig.screenHeight * 0.01),
                metricSwitch(),
                Container(
                  child: Column(
                    children: [
                      Container(
                        height: 100.0,
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: displayDialog,
                          child: Text(
                            "$weight $metricSelected",
                            style: Theme.of(context).textTheme.headline2.copyWith(
                                fontSize: 40.0,
                                color: Color(MyColors.primaryColor)
                            ),
                          ),
                        ),
                      ),
                      Text("Tap above to edit",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Color(MyColors.titleTextColor),
                              fontSize: getProportionateScreenWidth(15))),
                      VerticalWeightSlider(
                        maximumWeight: 2000,
                        initialWeight: weight,
                        minimumWeight: 10,
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
                    }),
                SizedBox(height: SizeConfig.screenHeight * 0.05),
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
                await ss.setPrefItem("weight_metric", "kg");
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
                await ss.setPrefItem("weight_metric", "lbs");
                setState(() {
                  metricSelected = "lbs";
                });
              }),
        ),
      ],
    );
  }

  Future<bool> displayDialog() {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialogPage(
              title: "Add Weight",
              initialValue: "$weight",
              wMetric: metricSelected,
              onSaved: (mw, metric) {
                if (!mounted) return;
                setState(() {
                  weight = mw;
                  metricSelected = metric;
                });
              });
        });
  }
}

class AlertDialogPage extends StatefulWidget {
  const AlertDialogPage(
      {Key key, this.title, this.initialValue, this.wMetric, this.onSaved})
      : super(key: key);
  final String title;
  final String initialValue;
  final String wMetric;
  final Function(double newWeight, String newMetric) onSaved;

  @override
  _AlertDialogPageState createState() => _AlertDialogPageState();
}

class _AlertDialogPageState extends State<AlertDialogPage> {

  TextEditingController _textEditingController;
  bool _loading = false;
  String wMetric = "";

  StorageSystem ss = new StorageSystem();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    wMetric = widget.wMetric;
    _textEditingController = new TextEditingController(text: widget.initialValue);
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
                          width: 100.0,
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
