import 'dart:async';
import 'dart:convert';

import 'package:coral_reef/ListItem/OnboardingQuestions.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/alertdialog.dart';
import 'package:coral_reef/components/coral_back_button.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/shared_screens/horizontal_progress_slider.dart';
import 'package:coral_reef/shared_screens/task_completed_screen.dart';
import 'package:coral_reef/tracker_screens/bottom_navigation_bar.dart';
import 'package:coral_reef/wellness/period/period_info.dart';
import 'package:flutter/material.dart';

import '../../size_config.dart';


class ConceiveInfo extends StatefulWidget {
  static final routeName = '/conceive-info';

  @override
  State<StatefulWidget> createState() => _ConceiveInfo();
}

class _ConceiveInfo extends State<ConceiveInfo> {

  StorageSystem ss = new StorageSystem();

  List<OnboardingQuestions> questionsAndOptions = [
    OnboardingQuestions("How long have you been actively trying to conceive?", ["Just getting started", "1 month","2 months","3 months","4 months","5 months","6 months","7 months","8 months","9 months","10 month","11 month","12 month","More than a year",]),
    OnboardingQuestions("Would you describe your periods as regular?", [
      "Yes",
      "No",
      "I don't know",
    ]),
    OnboardingQuestions("Do you calculate your fertile window when planning your sex life?", [
      "Yes",
      "I've heard about it, but I don't do it",
      "I don't know what the fertile window is",
    ]),
    OnboardingQuestions("How you sought pre-pregnancy care recently?",
        ["I've been to a check-up", "I'm going through treatment now", "I've undergone treatment", "I'm waiting for an appointment", "I didn't think it was necessary"]),
    OnboardingQuestions("Do you take any prenatal vitamins or supplements?", ["Yes, a special vitamin complex", "I take folic acid", "I don't take any vitamins or supplements"]),
    OnboardingQuestions("How were you planning to track your future baby's development?", ["Week by week", "Month by month", "Trimester by trimester"]),
  ];
  Map<String, dynamic> answers = Map();
  int pageIndex = 0;
  List<double> sliderProgressBar = [25];

  bool isDone = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ss.getItem("conceiveRecord").then((pregnancyRecord) => {
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
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CoralBackButton(),
                      Container(
                        width: 10.0,
                      ),
                      HorizontalProgressSlider(sliderProgressBar, maxValue: 150.0,)
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

  startTimer() async {
    // _showTestDialog(context);
    // Timer(Duration(seconds: 3), () async {
    //
    // });
    //encode the answers from the questions and store in local storage
    String conceiveRecord = jsonEncode(answers);
    await ss.setPrefItem("conceiveRecord", conceiveRecord);
    //await ss.setPrefItem("wellnessSetup", "true"); //don't display wellness.dart again
    //go to period info
    Navigator.pushNamed(context, PeriodInfo.routeName);
    // Navigator.pushNamed(context, CoralBottomNavigationBar.routeName);
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
