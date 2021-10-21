import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/g_chat_screen/components/topics_selection.dart';
import 'package:coral_reef/shared_screens/pill_icon.dart';
import 'package:coral_reef/tracker_screens/diet_tracker_screen/sections/meal/add_meal.dart';
import 'package:coral_reef/tracker_screens/diet_tracker_screen/sections/meal/meal_info.dart';
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

  List<Map<String, dynamic>> mealDetails = [];

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
                                buildMealDetails(Color(MyColors.other1), 0),
                                buildMealDetails(Color(MyColors.other2), 1),
                                buildMealDetails(Color(MyColors.other3), 2),
                                SizedBox(height: SizeConfig.screenHeight * 0.02),
                                (caloriesGoal != "0") ? Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TopicsSelection(text: "Remove calories", selected: true, onTap: (currentTakenCalories == "0") ? null : (){displayDialog("remove");},),
                                    TopicsSelection(text: "Add calories", selected: true, onTap: (){displayDialog("add");},),
                                  ],
                                ) : SizedBox(),
                                (caloriesGoal != "0") ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(top: 40.0),
                                  child: Center(
                                    child: TopicsSelection(text: "Add meal", selected: true, onTap: () async {
                                      await Navigator.pushNamed(context, MealList.routeName);
                                      await getCaloriesLocalData();
                                    },),
                                  ),
                                ) : SizedBox(),
                                SizedBox(height: SizeConfig.screenHeight * 0.05),
                                DefaultButton(
                                  text: "Set daily goal",
                                  loading: _loading,
                                  press: displayDialog2,
                                ),
                                SizedBox(height: SizeConfig.screenHeight * 0.07),
                              ])))))),
    );
  }

  Widget buildMealDetails(Color color, int index) {
    if(mealDetails.length != 3) return SizedBox();
    Map<String, dynamic> meal = mealDetails[index];
    if(meal == null) return SizedBox();
    if(meal.isEmpty) return SizedBox();
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: SizeConfig.screenHeight * 0.02,
                height: SizeConfig.screenHeight * 0.02,
                decoration: BoxDecoration(
                    color: color
                ),
              ),
              Text(meal["class"],
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: Color(MyColors.titleTextColor),
                  fontSize: getProportionateScreenWidth(13),
                ),),
              Text(meal["weight"],
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: Color(MyColors.titleTextColor),
                  fontSize: getProportionateScreenWidth(13),
                ),),
              Text(meal["percent"],
                style: Theme.of(context).textTheme.headline2.copyWith(
                  color: Color(MyColors.titleTextColor),
                  fontSize: getProportionateScreenWidth(13),
                ),),
            ],
          ),
          Divider()
        ],
      ),
    );
  }

  Future<bool> displayDialog(String action) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialogPage(
              title: (action == "add") ? "Add Calories" : "Remove Calories",
              initialValue: currentTakenCalories,
              goal: caloriesGoal,
              action: action,
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
      {Key key, this.onOptionSelected, this.title, this.initialValue = "", this.goal, this.action})
      : super(key: key);

  final Function(String value) onOptionSelected;
  final String title;
  final String initialValue;
  final String goal;
  final String action;

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
                        if(!new GeneralUtils().isNumberFormatted(_textEditingController.text)) {
                          new GeneralUtils().showToast(context, "Enter a valid number.");
                          return;
                        }
                        // setState(() {
                        //   _loading = true;
                        // });
                        double initCount = double.parse(widget.initialValue);
                        double current = double.parse(_textEditingController.text);
                        String total = "0";
                        if(widget.action == "add") {
                          total = (initCount + current).ceil().toString();
                        }else {
                          total = (initCount - current).ceil().toString();
                        }

                        if(double.parse(total) < 0) {
                          new GeneralUtils().showToast(context, "Number of calories cannot be negative.");
                          return;
                        }
                        await dietServices.updateCaloriesTakenCount(total, widget.goal);
                        // setState(() {
                        //   _loading = false;
                        // });
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
                        if(!new GeneralUtils().isNumberFormatted(_textEditingController.text)) {
                          new GeneralUtils().showToast(context, "Enter a valid number.");
                          return;
                        }
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
