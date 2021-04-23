
import 'dart:async';
import 'dart:convert';

import 'package:coral_reef/ListItem/OnboardingQuestions.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/alertdialog.dart';
import 'package:coral_reef/components/coral_back_button.dart';
import 'package:coral_reef/shared_screens/horizontal_progress_slider.dart';
import 'package:coral_reef/tracker_screens/bottom_navigation_bar.dart';
import 'package:coral_reef/wellness/diet_exercise_well_being/required_weight.dart';
import 'package:coral_reef/wellness/diet_exercise_well_being/weight.dart';
import 'package:coral_reef/wellness/period/year.dart';
import 'package:flutter/material.dart';

import '../../size_config.dart';
import 'height.dart';

class DietExerciseWellBeingInfo extends StatefulWidget {

  static final routeName = "/diet-exercise-well-being";

  @override
  State<StatefulWidget> createState() => _DietExerciseWellBeingInfo();
}

enum ScreenType { year, weight, desired_weight, height }

class _DietExerciseWellBeingInfo extends State<DietExerciseWellBeingInfo> {

  StorageSystem ss = new StorageSystem();
  List<OnboardingQuestions> questionsAndScreenType = [
    OnboardingQuestions("What year were you born?", ScreenType.year),
    OnboardingQuestions("Add Weight", ScreenType.weight),
    OnboardingQuestions("Add Desired Weight", ScreenType.desired_weight),
    OnboardingQuestions("Add Height", ScreenType.height),
  ];

  Map<String, dynamic> answers = Map();
  int pageIndex = 0;
  List<double> sliderProgressBar = [25];

  bool isDone = false;

  ScreenType screenType;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ss.getItem("dewRecord").then((dewRecord) {
      if (dewRecord != null) {
        setState(() {
          answers = jsonDecode(dewRecord);
          screenType = ScreenType.year;
        });
      } else {
        setState(() {
          screenType = ScreenType.year;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(24)),
                  child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: SizeConfig.screenHeight * 0.05),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CoralBackButton(),
                              Container(width: 10.0,),
                              HorizontalProgressSlider(sliderProgressBar)
                            ],
                          ),
                          SizedBox(height: SizeConfig.screenHeight * 0.05),
                          Container(
                            child: Text(
                              questionsAndScreenType[pageIndex].question,
                              softWrap: true,
                              textAlign: TextAlign.start,
                              style:
                              Theme.of(context).textTheme.headline2.copyWith(
                                  color: Color(MyColors.titleTextColor),
                                  fontSize: getProportionateScreenWidth(18)
                              ),
                            ),
                          ),
                          SizedBox(height: SizeConfig.screenHeight * 0.01),
                          displayScreen(),
                          (pageIndex > 0) ? TextButton(onPressed: previousClicked,
                            child: Text('Go back',
                                style: Theme.of(context).textTheme.headline2.copyWith(
                                  fontSize: getProportionateScreenWidth(16),
                                  color: Color(MyColors.primaryColor),
                                )),): Text(""),
                          // SizedBox(height: SizeConfig.screenHeight * 0.2),
                        ],
                      )
                  ),
                ))));
  }

  Widget displayScreen() {
    if(screenType == ScreenType.year) {
      return YearScreen(answers["$pageIndex"],onPress: (selectedDate, clicked){
        print('I clicked $clicked');
        if(!clicked) return;
        print('hello $selectedDate');
        if(selectedDate != null)
          selectedOption(selectedDate.split("/")[0]);
      });
    }
    if(screenType == ScreenType.weight){
      return WeightScreen(answers["$pageIndex"], onPress: (selectedWeight, clicked){
        if(!clicked) return;
        if(selectedWeight != null)
          selectedOption(selectedWeight);
      });
    }
    if(screenType == ScreenType.desired_weight){
      return DesiredWeightScreen(answers["$pageIndex"], onPress: (selectedWeight, clicked){
        if(!clicked) return;
        if(selectedWeight != null)
          selectedOption(selectedWeight);
      });
    }
    if(screenType == ScreenType.height){
      return HeightScreen(answers["$pageIndex"], onPress: (selectedWeight, clicked){
        if(!clicked) return;
        if(selectedWeight != null)
          selectedOption(selectedWeight);
      });
    }
    return Text('');
  }

  /*
  when an option is selected, store the selected option to answers
  Also determine if that's the end of the question. If isDone = true, start timer and display done page
  */
  selectedOption(dynamic option) {
    if (!mounted) return;
    setState(() {
      answers["$pageIndex"] = option;
      if((pageIndex + 1) == questionsAndScreenType.length) {
        isDone = true;
        startTimer();
      }else {
        pageIndex++;
        double nextSliderValue = (pageIndex + 1) * 25.0;
        sliderProgressBar = [nextSliderValue];
        screenType = questionsAndScreenType[pageIndex].options;
      }
    });
  }

  /*
  when the previous button is pressed
  */
  previousClicked() {
    if (!mounted) return;
    setState(() {
      if ((pageIndex - 1) >= 0) {
        pageIndex--;
        double nextSliderValue = sliderProgressBar[0] - 25.0;
        sliderProgressBar = [nextSliderValue];
        screenType = questionsAndScreenType[pageIndex].options;
      }
    });
  }

  startTimer() {
    _showTestDialog(context);
    Timer(Duration(seconds: 3), () async {
      //encode the answers from the questions and store in local storage
      String dewRecord = jsonEncode(answers);
      await ss.setPrefItem("dewRecord", dewRecord);
      await ss.setPrefItem("dewSetup", "true");//don't display wellness.dart again
      //go to period dashboard
      Navigator.pushNamed(context, CoralBottomNavigationBar.routeName);

    });
  }

  void _showTestDialog(context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        //context: _scaffoldKey.currentContext,
        builder: (context) {
          return AlertDialogSuccessPage();
        });
  }
}