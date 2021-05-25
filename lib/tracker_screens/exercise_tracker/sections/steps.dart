import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/locator.dart';
import 'package:coral_reef/models/step_goal_model.dart';
import 'package:coral_reef/services/step_service.dart';
import 'package:coral_reef/size_config.dart';
import 'package:direct_select/direct_select.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import 'package:stacked/stacked.dart';

import '../view_models/step_view_model.dart';

class Steps extends StatefulWidget {
  static final routeName = "stepsGoal";
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Steps> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final StepService _stepService = locator<StepService>();
  @override
  void initState() {
    super.initState();
  }

  _showGoalDialog(StepViewModel model) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                Text(
                  "Set daily step goal",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Date",
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      model.outputFormat.format(DateTime.now()).toString(),
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(MyColors.primaryColor).withOpacity(0.8)),
                    ),
                  ],
                )
              ],
            ),
            content: Container(
              height: 150,
              child: Column(
                children: [
                  DirectSelect(
                      itemExtent: 35.0,
                      selectionColor:
                          Color(MyColors.primaryColor).withOpacity(0.1),
                      selectedIndex: model.selectedIndex,
                      child: MySelectionItem(
                        isForList: false,
                        title: model.stepsGoal.floor().toString(),
                      ),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          model.selectedIndex = index;
                          Navigator.pop(context);
                          Navigator.pop(context);
                          model.stepsGoal =
                              double.parse(model.elements[model.selectedIndex]);
                          print(model.selectedIndex);
                          _showGoalDialog(model);
                        });
                      },
                      mode: DirectSelectMode.tap,
                      items: model.buildItems1()),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                      height: 40,
                      child: DefaultButton(
                        text: 'Save',
                        press: () {
                          model.setStepGoal(
                              StepGoalModel(
                                  stepGoal: model.stepsGoal.floor().toString()),
                              model.stepsGoal.floor().toString());
                          _stepService.getSteps();
                          Navigator.pop(context);
                        },
                      ))
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(15)),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StepViewModel>.reactive(
        viewModelBuilder: () => StepViewModel(),
        onModelReady: (viewModel) {
          viewModel.currentStep();
        },
        builder: (context, model, child) {
          //model.currentStep();

          return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                elevation: 0,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back_ios)),
                    Text(
                      'Steps Goal',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: getProportionateScreenWidth(15),
                          ),
                    ),
                    SvgPicture.asset(
                        "assets/icons/clarity_notification-outline-badged.svg",
                        height: 22.0),
                  ],
                ),
              ),
              body: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Goal',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    fontSize: getProportionateScreenWidth(18),
                                  ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(model.stepsGoal.round().toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                        color: Color(MyColors.primaryColor),
                                        fontSize:
                                            getProportionateScreenWidth(25),
                                        fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              width: 200.0,
                              height: 200.0,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100.0)),
                              child: SleekCircularSlider(
                                  appearance: CircularSliderAppearance(
                                      angleRange: 360.0,
                                      customColors: CustomSliderColors(
                                        progressBarColors: [
                                          Colors.deepPurpleAccent,
                                          Color(MyColors.dietSliderTrackColor),
                                        ],
                                        trackColor:
                                            Color(MyColors.dietSliderBgColor),
                                        dynamicGradient: true,
                                      ),
                                      customWidths:
                                          CustomSliderWidths(trackWidth: 8.0)),
                                  initialValue: double.parse(
                                      _stepService.steps.toString()),
                                  min: 0,
                                  max: model.stepsGoal,
                                  innerWidget: (double value) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/exercise/purple_foot.svg",
                                          height: 40.0,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(_stepService.steps.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1
                                                .copyWith(
                                                    color: Colors.black,
                                                    fontSize:
                                                        getProportionateScreenWidth(
                                                            20),
                                                    fontWeight:
                                                        FontWeight.bold)),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text("Steps",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1
                                                .copyWith(
                                                    color: Colors.black,
                                                    fontSize:
                                                        getProportionateScreenWidth(
                                                            15),
                                                    fontWeight:
                                                        FontWeight.bold)),
                                      ],
                                    );
                                  },
                                  onChange: (double value) {
                                    //print(value);
                                    setState(() {
                                      //_stepService.stepsGoal = value;
                                    });
                                  }),
                            ),
                            Container(
                                padding: EdgeInsets.all(20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/exercise/fire.svg",
                                          height: 40.0,
                                        ),
                                        Text(
                                            (int.parse(_stepService.steps) /
                                                        63.4)
                                                    .floor()
                                                    .toString() +
                                                "kcal",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1
                                                .copyWith(
                                                  color: Colors.black,
                                                  fontSize:
                                                      getProportionateScreenWidth(
                                                          15),
                                                )),
                                      ],
                                    ),
                                    Column(children: [
                                      SvgPicture.asset(
                                        "assets/exercise/location.svg",
                                        height: 40.0,
                                      ),
                                      Text(
                                          (int.parse(_stepService.steps) *
                                                      0.000762)
                                                  .roundToDouble()
                                                  .toString() +
                                              'km',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .copyWith(
                                                color: Colors.black,
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        15),
                                              )),
                                    ]),
                                    Column(children: [
                                      SvgPicture.asset(
                                        "assets/exercise/time.svg",
                                        height: 40.0,
                                      ),
                                      Text(
                                          (int.parse(_stepService.steps) / 100)
                                                  .round()
                                                  .toString() +
                                              "Min",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .copyWith(
                                                color: Colors.black,
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        15),
                                              )),
                                    ]),
                                  ],
                                )),
                            SizedBox(
                              height: 50,
                            ),
                            DefaultButton(
                              text: 'Set daily goal',
                              press: () {
                                _showGoalDialog(model);
                              },
                            )
                          ],
                        )
                      ])));
        });
  }
}
