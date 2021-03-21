import 'dart:async';
import 'dart:convert';

import 'package:coral_reef/ListItem/OnboardingQuestions.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/coral_back_button.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/shared_screens/horizontal_progress_slider.dart';
import 'package:coral_reef/shared_screens/task_completed_screen.dart';
import 'package:coral_reef/wellness/onboarding/last_period.dart';
import 'package:coral_reef/wellness/onboarding/period_length.dart';
import 'package:coral_reef/wellness/onboarding/year.dart';
import 'package:flutter/material.dart';

import '../../size_config.dart';
import 'cycle.dart';

class PeriodInfo extends StatefulWidget {
  static final routeName = '/period-info';

  @override
  State<StatefulWidget> createState() => _PeriodInfo();
}

enum ScreenType { year, last_period, period_length, cycle }

class _PeriodInfo extends State<PeriodInfo> {

  StorageSystem ss = new StorageSystem();
  // List<OnboardingQuestions> questionsAndOptions = [
  //   OnboardingQuestions("Have you given birth before?", ["Yes", "No"]),
  //   OnboardingQuestions("What is your activity level?", ["Little or no exercise", "Physically active job ","Exercise 2-3 times a week", "Exercise more than 3 times a week"]),
  //   OnboardingQuestions("How often do you feel stressed?", ["Rarely", "Several times a month","Several times a week", "Almost everyday"]),
  //   OnboardingQuestions("What is your diet like?", ["No restrictions", "Vegetarian","Vegan", "Other"]),
  // ];
  List<OnboardingQuestions> questionsAndScreenType = [
    OnboardingQuestions("What year were you born?", ScreenType.year),
    OnboardingQuestions("Date of last period?", ScreenType.last_period),
    OnboardingQuestions("How long is your period?", ScreenType.period_length),
    OnboardingQuestions("How many days is your cycle?", ScreenType.cycle),
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
    ss.getItem("periodRecord").then((periodRecord) {
      print(periodRecord);
      if (periodRecord != null)
        {
          setState(() {
            answers = jsonDecode(periodRecord);
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
                    child: (!isDone) ? Column(
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
                        SizedBox(height: SizeConfig.screenHeight * 0.05),
                        displayScreen(),
                        (pageIndex > 0) ? TextButton(onPressed: previousClicked,
                          child: Text('Go back',
                              style: Theme.of(context).textTheme.headline2.copyWith(
                                fontSize: getProportionateScreenWidth(16),
                                color: Color(MyColors.primaryColor),
                              )),): Text(""),
                        // SizedBox(height: SizeConfig.screenHeight * 0.2),
                      ],
                    ): TaskCompletedScreen("You are all set!"),
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
    if(screenType == ScreenType.last_period){
      return LastPeriodScreen(answers["$pageIndex"],onPress: (selectedDate, clicked){
        if(!clicked) return;
        if(selectedDate != null)
          selectedOption(selectedDate);
      });
    }
    if(screenType == ScreenType.period_length){
      return PeriodLengthScreen(answers["$pageIndex"],onPress: (selectedDate, clicked){
        if(!clicked) return;
        if(selectedDate != null)
          selectedOption(selectedDate.split("/")[2]);
      });
    }
    if(screenType == ScreenType.cycle){
      return CycleScreen(answers["$pageIndex"],onPress: (selectedDate, clicked){
        if(!clicked) return;
        if(selectedDate != null)
          selectedOption(selectedDate.split("/")[2]);
      });
    }
    return Text('');
  }

  /*
  when an option is selected, store the selected option to answers
  Also determine if that's the end of the question. If isDone = true, start timer and display done page
  */
  selectedOption(String option) {
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
    Timer(Duration(seconds: 2), () async {
      //encode the answers from the questions and store in local storage
      String periodRecord = jsonEncode(answers);
      print(periodRecord);
      await ss.setPrefItem("periodRecord", periodRecord);
      await ss.setPrefItem("wellnessSetup", "true");//don't display wellness.dart again
      //go to period dashboard

    });
  }
}
