
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/alertdialog.dart';
import 'package:coral_reef/components/coral_back_button.dart';
import 'package:coral_reef/homescreen/Home.dart';
import 'package:coral_reef/wellness/diet_exercise_well_being/diet_exercise_well_being_info.dart';
import 'package:coral_reef/wellness/onboarding/wellness.dart';
import 'package:flutter/material.dart';

import '../size_config.dart';
import 'onboarding/component.dart';

class WellnessTrackerOptions extends StatefulWidget {
  static final routeName = '/wellness-tracker-options';

  @override
  State<StatefulWidget> createState() => _WellnessTrackerOptions();
}

class _WellnessTrackerOptions extends State<WellnessTrackerOptions> {

  StorageSystem ss = new StorageSystem();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(MyColors.lightBackground),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(24)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.05),
                  CoralBackButton(onPress: (){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => new HomeScreen()));
                  },),
                  SizedBox(height: SizeConfig.screenHeight * 0.09),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'How can we help you?',
                        softWrap: true,
                        style:
                        Theme.of(context).textTheme.headline2.copyWith(
                            color: Color(MyColors.titleTextColor),
                            fontSize: getProportionateScreenWidth(18)
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.03),
                  BuildCard(
                    title: 'Track Period',
                    icon: 'assets/icons/period.svg',
                    color: Color(MyColors.other3),
                    onPress: trackPeriodPress,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  BuildCard(
                    title: 'Track Diet',
                    icon: 'assets/icons/diet.svg',
                    color: Color(MyColors.other1),
                    onPress: trackDietPress,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  BuildCard(
                    title: 'Track Exercise',
                    icon: 'assets/icons/exercise.svg',
                    color: Color(MyColors.other5),
                    onPress: trackExercisePress,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  BuildCard(
                    title: 'Track Well-being',
                    icon: 'assets/icons/well-being.svg',
                    color: Color(MyColors.other4),
                    onPress: trackWellBeingPress,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.2),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

  /*
   * Determine if the period set up has been attended to
   */
  Future<void> trackPeriodPress() async {
    //go to period screen to ask questions
    Navigator.pushNamed(context, WellnessScreen.routeName);
  }

  /*
   * Determine if the diet set up has been attended to
   */
  Future<void> trackDietPress() async {
    await ss.setPrefItem("dashboardGoal", "diet");//set user dashboard goal
    Navigator.pushNamed(context, DietExerciseWellBeingInfo.routeName);
    // _showTestDialog(context);
  }

  /*
   * Determine if the exercise set up has been attended to
   */
  Future<void> trackExercisePress() async {
    await ss.setPrefItem("dashboardGoal", "exercise");//set user dashboard goal
    Navigator.pushNamed(context, DietExerciseWellBeingInfo.routeName);
  }

  /*
   * Determine if the well-being set up has been attended to
   */
  Future<void> trackWellBeingPress() async {
    await ss.setPrefItem("dashboardGoal", "well-being");//set user dashboard goal
    Navigator.pushNamed(context, DietExerciseWellBeingInfo.routeName);
  }

  void _showTestDialog(context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        //context: _scaffoldKey.currentContext,
        builder: (context) {
          return AlertDialogSuccessPage(text: 'Coming Soon...',);
        });
  }
}
