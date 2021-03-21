import 'dart:async';
import 'dart:convert';

import 'package:coral_reef/ListItem/OnboardingQuestions.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/coral_back_button.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/shared_screens/horizontal_progress_slider.dart';
import 'package:coral_reef/shared_screens/task_completed_screen.dart';
import 'package:flutter/material.dart';

import '../../size_config.dart';

class PregnancyInfo extends StatefulWidget {
  static final routeName = '/pregnancy-info';

  @override
  State<StatefulWidget> createState() => _PregnancyInfo();
}

class _PregnancyInfo extends State<PregnancyInfo> {
  StorageSystem ss = new StorageSystem();
  List<OnboardingQuestions> questionsAndOptions = [
    OnboardingQuestions("Have you given birth before?", ["Yes", "No"]),
    OnboardingQuestions("What is your activity level?", [
      "Little or no exercise",
      "Physically active job ",
      "Exercise 2-3 times a week",
      "Exercise more than 3 times a week"
    ]),
    OnboardingQuestions("How often do you feel stressed?", [
      "Rarely",
      "Several times a month",
      "Several times a week",
      "Almost everyday"
    ]),
    OnboardingQuestions("What is your diet like?",
        ["No restrictions", "Vegetarian", "Vegan", "Other"]),
  ];
  Map<String, dynamic> answers = Map();
  int pageIndex = 0;
  List<double> sliderProgressBar = [25];

  bool isDone = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ss.getItem("pregnancyRecord").then((pregnancyRecord) => {
          if (pregnancyRecord != null)
            {
              setState(() {
                answers = jsonDecode(pregnancyRecord);
              })
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
          height: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(24)),
            child: SingleChildScrollView(
              child: (!isDone)
                  ? Column(
                      children: [
                        SizedBox(height: SizeConfig.screenHeight * 0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CoralBackButton(),
                            Container(
                              width: 10.0,
                            ),
                            HorizontalProgressSlider(sliderProgressBar)
                          ],
                        ),
                        SizedBox(height: SizeConfig.screenHeight * 0.05),
                        Container(
                          child: Text(
                            questionsAndOptions[pageIndex].question,
                            softWrap: true,
                            textAlign: TextAlign.start,
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                .copyWith(
                                    color: Color(MyColors.titleTextColor),
                                    fontSize: getProportionateScreenWidth(18)),
                          ),
                        ),
                        SizedBox(height: SizeConfig.screenHeight * 0.05),
                        ...buildOptions(),
                        SizedBox(height: SizeConfig.screenHeight * 0.03),
                        (pageIndex > 0)
                            ? DefaultButton2(
                                text: "Go back",
                                press: previousClicked,
                              )
                            : Text(''),
                        // SizedBox(height: SizeConfig.screenHeight * 0.2),
                      ],
                    )
                  : TaskCompletedScreen("You are all set!"),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildOptions() {
    List<Widget> opt = [];
    questionsAndOptions[pageIndex].options.forEach((element) {
      dynamic answerSelected =
          (answers["$pageIndex"] == null) ? '' : answers["$pageIndex"];
      var item = Container(
        // height: 60.0,
        margin: EdgeInsets.only(bottom: 0.0, top: 30.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(color: Colors.white, width: 0.0),
            color: (answerSelected == element)
                ? Color(MyColors.other3)
                : Color(MyColors.optionsBackgroundColor)),
        child: ListTile(
          title: Text(
            element,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: (answerSelected == element)
                    ? Color(MyColors.primaryColor)
                    : Color(MyColors.titleTextColor),
                fontSize: 16.0),
          ),
          trailing: (answerSelected == element)
              ? Icon(
                  Icons.check_circle,
                  color: Colors.white,
                )
              : Text(''),
          onTap: () {
            selectedOption(element);
          },
        ),
      );
      opt.add(item);
    });
    opt.add(Container(
      height: 40.0,
    ));
    return opt;
  }

  /*
  when an option is selected, store the selected option to answers
  Also determine if that's the end of the question. If isDone = true, start timer and display done page
  */
  selectedOption(String option) {
    if (!mounted) return;
    setState(() {
      answers["$pageIndex"] = option;
      if ((pageIndex + 1) == questionsAndOptions.length) {
        isDone = true;
        startTimer();
      } else {
        pageIndex++;
        double nextSliderValue = (pageIndex + 1) * 25.0;
        sliderProgressBar = [nextSliderValue];
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
      }
    });
  }

  startTimer() {
    Timer(Duration(seconds: 2), () async {
      //encode the answers from the questions and store in local storage
      String pregnancyRecord = jsonEncode(answers);
      await ss.setPrefItem("pregnancyRecord", pregnancyRecord);
      await ss.setPrefItem(
          "wellnessSetup", "true"); //don't display wellness.dart again
      //go to pregnancy dashboard
    });
  }
}
