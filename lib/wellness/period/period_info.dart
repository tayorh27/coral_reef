import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/ListItem/OnboardingQuestions.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/alertdialog.dart';
import 'package:coral_reef/components/coral_back_button.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/shared_screens/horizontal_progress_slider.dart';
import 'package:coral_reef/shared_screens/task_completed_screen.dart';
import 'package:coral_reef/tracker_screens/bottom_navigation_bar.dart';
import 'package:coral_reef/wellness/period/last_period.dart';
import 'package:coral_reef/wellness/period/period_length.dart';
import 'package:coral_reef/wellness/period/year.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
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
      // print(periodRecord);
      if (periodRecord != null) {
          setState(() {
            answers = jsonDecode(periodRecord);
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
                    )
                  ),
                ))));
  }

  String birthYear = "";
  String lastPeriod = "";
  String length = "";
  String cycle = "";

  Widget displayScreen() {
    if (screenType == ScreenType.year) {
      return YearScreen(answers["$pageIndex"],
          onPress: (selectedDate, clicked) {
            print("i was born in" + selectedDate);

            print("birth year value " + birthYear);
            if (!clicked) return;
            if (selectedDate != null) selectedOption(selectedDate.split("/")[0]);
            birthYear = selectedDate.split("/")[0];
            setState(() {});
          });
    }
    if (screenType == ScreenType.last_period) {
      return LastPeriodScreen(answers["$pageIndex"],
          onPress: (selectedDate, clicked) {
            if (!clicked) return;
            if (selectedDate != null) selectedOption(selectedDate);
            // lastPeriod = selectedOption(selectedDate);
            lastPeriod = selectedDate;
            setState(() {});
            print("my last period " + lastPeriod);
          });
    }

    if (screenType == ScreenType.period_length) {
      return PeriodLengthScreen(answers["$pageIndex"],
          onPress: (selectedDate, clicked) {
            if (!clicked) return;
            if (selectedDate != null) selectedOption(selectedDate.split("/")[2]);
            // length = selectedOption(selectedDate.split("/")[1]);
            length = selectedDate.split('/')[1];
            print("bleeding time  " + length);
          });
    }

    if (screenType == ScreenType.cycle) {
      return CycleScreen(answers["$pageIndex"],
          onPress: (selectedDate, clicked) {
            if (!clicked) return;
            if (selectedDate != null) selectedOption(selectedDate.split("/")[2]);
            // cycle = selectedOption(selectedDate.split("/")[2]);
            cycle = selectedDate.split('/')[2];
            setState(() {});
            print("my cycle is   " + cycle);
          });
    }
    return Text('');
  }


  // Widget displayScreen() {
  //   if(screenType == ScreenType.year) {
  //     return YearScreen(answers["$pageIndex"],onPress: (selectedDate, clicked){
  //       print('I clicked $clicked');
  //       if(!clicked) return;
  //       print('hello $selectedDate');
  //       if(selectedDate != null)
  //         selectedOption(selectedDate.split("/")[0]);
  //     });
  //   }
  //   if(screenType == ScreenType.last_period){
  //     return LastPeriodScreen(answers["$pageIndex"],onPress: (selectedDate, clicked){
  //       if(!clicked) return;
  //       if(selectedDate != null)
  //         selectedOption(selectedDate);
  //     });
  //   }
  //   if(screenType == ScreenType.period_length){
  //     return PeriodLengthScreen(answers["$pageIndex"],onPress: (selectedDate, clicked){
  //       if(!clicked) return;
  //       if(selectedDate != null)
  //         selectedOption(selectedDate.split("/")[2]);
  //     });
  //   }
  //   if(screenType == ScreenType.cycle){
  //     return CycleScreen(answers["$pageIndex"],onPress: (selectedDate, clicked){
  //       if(!clicked) return;
  //       if(selectedDate != null)
  //         selectedOption(selectedDate.split("/")[2]);
  //     });
  //   }
  //   return Text('');
  // }

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
    _showTestDialog(context);
    Timer(Duration(seconds: 1), () async {
      String key = FirebaseFirestore.instance.collection("users").doc().id;

      Map<String, dynamic> userPeriodDetails = {
        "birthYear": birthYear,
        "lastPeriod": lastPeriod,
        "length": length,
        "cycle": cycle,
        "id": key,
        "timestamp": FieldValue.serverTimestamp(),
      };

      Map<String, dynamic> userPeriodDetailsLocal = {
        "birthYear": birthYear,
        "lastPeriod": lastPeriod,
        "length": length,
        "cycle": cycle,
      };
      //encode the answers from the questions and store in local storage
      String periodRecord = jsonEncode(userPeriodDetailsLocal);
      print(periodRecord);
      await ss.setPrefItem("periodRecord", periodRecord);
      await ss.setPrefItem("wellnessSetup", "true");//don't display wellness.dart again
      //save to firestore and go to period dashboard

      await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("periods").doc(key).set(userPeriodDetails);

      //go to period dashboard
      Navigator.pushNamed(context, CoralBottomNavigationBar.routeName);

      // firestoreinstance
      //     .collection("perioddetails")
      //     .doc(user.uid)
      //     .set(userPeriodDetails)
      //     .then((value) {
      //
      // });

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
