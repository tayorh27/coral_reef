import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/g_chat_screen/components/topics_selection.dart';
import 'package:coral_reef/wellness/onboarding/component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vertical_weight_slider/vertical_weight_slider.dart';

import '../../size_config.dart';


class HeightScreen extends StatefulWidget {

  static String routeName = "/weight";
  final double currentHeight;
  final int currentInches;
  final Function(double weight, int inch, bool clicked) onPress;

  HeightScreen(this.currentHeight, this.currentInches, {this.onPress});

  @override
  State<StatefulWidget> createState() => _HeightScreen();
}

class _HeightScreen extends State<HeightScreen> {

  double height = 7.0;
  int inches = 0;

  StorageSystem ss = new StorageSystem();

  String metricSelected = "ft";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    height = (widget.currentHeight == null) ? 7.0 : widget.currentHeight;
    inches = (widget.currentInches == null) ? 0 : widget.currentInches;
    ss.getItem("height_metric").then((value) {
      String v = value ?? "ft";
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
                          onTap: displayDialog,
                          child: Text(
                            (metricSelected == "cm") ? "$height $metricSelected" : "$height $metricSelected $inches''",
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
                      // VerticalWeightSlider(
                      //   maximumWeight: 2000,
                      //   initialWeight: height,
                      //   gradationColor: [
                      //     Colors.purple[500],
                      //     Colors.purple[300],
                      //     Colors.purple[100],
                      //   ],
                      //   onChanged: (value) {
                      //     setState(() {
                      //       height = value;
                      //     });
                      //   },
                      // )
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.2),
                DefaultButton(
                    text: 'Continue',
                    press: () {
                      widget.onPress(height, inches, true);
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
              text: 'ft',
              selected: metricSelected == "ft",
              press: () async {
                await ss.setPrefItem("height_metric", "ft");
                setState(() {
                  metricSelected = "ft";
                });
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: SwitchButtons(
              text: 'cm',
              selected: metricSelected == "cm",
              press: () async {
                await ss.setPrefItem("height_metric", "cm");
                setState(() {
                  metricSelected = "cm";
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
              title: "Add Height",
              initialValue: "$height",
              initialValueInches: "$inches",
              hMetric: metricSelected,
              onSaved: (mh, inch, metric) {
                if (!mounted) return;
                setState(() {
                  height = mh;
                  inches = inch;
                  metricSelected = metric;
                });
              });
        });
  }
}

class AlertDialogPage extends StatefulWidget {
  const AlertDialogPage(
      {Key key, this.title, this.initialValue, this.initialValueInches, this.hMetric, this.onSaved})
      : super(key: key);
  final String title;
  final String initialValue;
  final String initialValueInches;
  final String hMetric;
  final Function(double newWeight, int inches, String newMetric) onSaved;

  @override
  _AlertDialogPageState createState() => _AlertDialogPageState();
}

class _AlertDialogPageState extends State<AlertDialogPage> {

  TextEditingController _textEditingController, _textEditingControllerInches;
  bool _loading = false;
  String hMetric = "";

  StorageSystem ss = new StorageSystem();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hMetric = widget.hMetric;
    _textEditingController = new TextEditingController(text: widget.initialValue);
    _textEditingControllerInches = new TextEditingController(text: widget.initialValueInches);
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
        height: 250,
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
                          width: 60.0,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            obscureText: false,
                            autofocus: true,
                            controller: _textEditingController,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline2.copyWith(
                                fontSize: getProportionateScreenWidth(25),
                                color: Color(MyColors.primaryColor)
                            ),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 15,
                                ),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,hintText: "0",

                                suffixStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                                    fontSize: getProportionateScreenWidth(10),
                                    color: Color(MyColors.primaryColor)
                                ),
                                suffixText: (hMetric == "ft") ? "feet" : "cm"
                            ),
                          ),
                        ),
                        (hMetric == "ft") ? Container(
                          width: 100.0,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            obscureText: false,
                            autofocus: true,
                            controller: _textEditingControllerInches,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline2.copyWith(
                                fontSize: getProportionateScreenWidth(25),
                                color: Color(MyColors.primaryColor)
                            ),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 15,
                                ),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,hintText: "0",
                                suffixStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                                  fontSize: getProportionateScreenWidth(10),
                                  color: Color(MyColors.primaryColor)
                              ),
                                suffixText: "inches"
                            ),
                          ),
                        ) : Text(""),
                        Align(
                          alignment: Alignment.topRight,
                          child: TopicsSelection(text: hMetric, selected: true, onTap: () async {
                            setState(() {
                              hMetric = (hMetric == "cm") ? "ft" : "cm";
                            });
                            await ss.setPrefItem("height_metric", hMetric);
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
                        widget.onSaved(double.parse(_textEditingController.text), int.parse(_textEditingControllerInches.text), hMetric);
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