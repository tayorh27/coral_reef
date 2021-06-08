import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/g_chat_screen/components/topics_selection.dart';
import 'package:coral_reef/shared_screens/pill_icon.dart';
import 'package:coral_reef/tracker_screens/diet_tracker_screen/services/diet_service.dart';
import 'package:coral_reef/tracker_screens/well_being_tracker/components/diet_header.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../size_config.dart';

class CaloriesGoal extends StatefulWidget {
  static final routeName = "calories-goals";

  @override
  State<StatefulWidget> createState() => _CaloriesGoal();
}

class _CaloriesGoal extends State<CaloriesGoal> {

  bool _loading = false;

  String caloriesGoal = "0", currentTakenCalories = "0";

  DietServices dietServices;

  StorageSystem ss = new StorageSystem();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dietServices = new DietServices();
    getCaloriesLocalData();
  }

  getCaloriesLocalData() async {
    final date = DateTime.now();
    final months = ["JAN", "FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];

    String formatDate = "${date.year}_${months[date.month - 1]}_${date.day}";

    String goal = await ss.getItem("caloriesGoal") ?? "0";
    String current = await ss.getItem("caloriesCurrent_$formatDate") ?? "0";

    setState(() {
      caloriesGoal = goal;
      currentTakenCalories = current;
    });
  }

  double getPointerValue() {
    return ((double.parse(currentTakenCalories) / double.parse(caloriesGoal)) * 100);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DietHeader("Calories").appBar(context),
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Goal', textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                                        color: Color(MyColors.titleTextColor),
                                        fontSize: getProportionateScreenWidth(13),
                                      ),),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('$caloriesGoal',textAlign: TextAlign.center,
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
                                            axisLineStyle: AxisLineStyle(thickness: 30, color: Color(MyColors.lightBackground)),
                                            pointers: <GaugePointer>[
                                              RangePointer(
                                                  value: getPointerValue() > 100 ? 100 : getPointerValue(),
                                                  width: 30,
                                                  color: Color(MyColors.primaryColor),
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
                                                        Text('You have taken', textAlign: TextAlign.center,
                                                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                                            color: Color(MyColors.titleTextColor),
                                                            fontSize: getProportionateScreenWidth(13),
                                                          ),),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text('$currentTakenCalories',textAlign: TextAlign.center,
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
                                                  ),
                                                  angle: 270,
                                                  positionFactor: 0.1)
                                            ])
                                      ]),
                                ),
                                (caloriesGoal != "0") ? Align(
                                  alignment: Alignment.topCenter,
                                  child: TopicsSelection(text: "Add calories", selected: true, onTap: displayDialog,),
                                ) : Text(""),
                                SizedBox(height: SizeConfig.screenHeight * 0.07),
                                DefaultButton(
                                  text: "Set daily goal",
                                  loading: _loading,
                                  press: displayDialog2,
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
              title: "Add Calories",
              initialValue: currentTakenCalories,
              goal: caloriesGoal,
              onOptionSelected: (val) {
                if (!mounted) return;
                setState(() {
                  currentTakenCalories = val;
                  // getPointerValue();
                });
              });
        });
  }

  Future<bool> displayDialog2() {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialogPageGoal(
              title: "Add Daily Calories Goal",
              initialValue: caloriesGoal,
              onOptionSelected: (val) {
                if (!mounted) return;
                setState(() {
                  caloriesGoal = val;
                  // getPointerValue();
                });
              });
        });
  }
}

class AlertDialogPage extends StatefulWidget {
  const AlertDialogPage(
      {Key key, this.onOptionSelected, this.title, this.initialValue = "", this.goal})
      : super(key: key);

  final Function(String value) onOptionSelected;
  final String title;
  final String initialValue;
  final String goal;

  @override
  _AlertDialogPageState createState() => _AlertDialogPageState();
}

class _AlertDialogPageState extends State<AlertDialogPage> {

  TextEditingController _textEditingController;
  DietServices dietServices;
  bool _loading = false;

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
                        setState(() {
                          _loading = true;
                        });
                        double initCount = double.parse(widget.initialValue);
                        double current = double.parse(_textEditingController.text);
                        String total = (initCount + current).ceil().toString();
                        await dietServices.updateCaloriesTakenCount(total, widget.goal);
                        setState(() {
                          _loading = false;
                        });
                        widget.onOptionSelected(total);
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

class AlertDialogPageGoal extends StatefulWidget {
  const AlertDialogPageGoal(
      {Key key, this.onOptionSelected, this.title, this.initialValue = ""})
      : super(key: key);

  final Function(String value) onOptionSelected;
  final String title;
  final String initialValue;

  @override
  _AlertDialogPageStateGoal createState() => _AlertDialogPageStateGoal();
}

class _AlertDialogPageStateGoal extends State<AlertDialogPageGoal> {

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
                        await dietServices.saveCaloriesGoal(_textEditingController.text);
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
