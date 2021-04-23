import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/coral_back_button.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/wellness/onboarding/component.dart';
import 'package:coral_reef/wellness/conceive/conceive_info.dart';
import 'package:coral_reef/wellness/period/period_info.dart';
import 'package:coral_reef/wellness/pregnancy/pregnancy_info.dart';
import 'package:flutter/material.dart';
import 'package:coral_reef/size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  StorageSystem ss = new StorageSystem();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(24)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.05),
                CoralBackButton(),
                SizedBox(height: SizeConfig.screenHeight * 0.09),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'What are you trying to do?',
                      softWrap: true,
                      style: Theme.of(context).textTheme.headline2.copyWith(
                          color: Color(MyColors.titleTextColor),
                          fontSize: getProportionateScreenWidth(18)),
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
                  title: 'Trying to Conceive',
                  icon: 'assets/icons/conceive.svg',
                  color: Color(MyColors.other4),
                  onPress: trackConceivePress,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                BuildCard(
                  title: 'Track Pregnancy',
                  icon: 'assets/icons/belle.svg',
                  color: Color(MyColors.other5),
                  onPress: trackPregnancyPress,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.05),
                Center(
                    child: Text(
                  'You can always change preferences later',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: Color(MyColors.titleTextColor),
                      fontSize: getProportionateScreenWidth(14)),
                )),
                SizedBox(height: SizeConfig.screenHeight * 0.2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /*
   * Determine if the period set up has been attended to
   */
  Future<void> trackPeriodPress() async {
    String periodRecord = await ss.getItem("periodRecord") ?? "";

    await ss.setPrefItem("dashboardGoal", "period"); //set user dashboard goal

    // if(periodRecord.isNotEmpty) {
    //   return;
    // }

    //go to period screen to ask questions
    Navigator.pushNamed(context, PeriodInfo.routeName);
  }

  /*
   * Determine if the conceive set up has been attended to
   */
  Future<void> trackConceivePress() async {
    String conceiveRecord = await ss.getItem("conceiveRecord") ?? "";

    await ss.setPrefItem("dashboardGoal", "conceive"); //set user dashboard goal

    // if(conceiveRecord.isNotEmpty) {
    //   return;
    // }

    //go to conceive screen to ask questions. same as period
    Navigator.pushNamed(context, ConceiveInfo.routeName);
  }

  /*
   * Determine if the pregnancy set up has been attended to
   */
  Future<void> trackPregnancyPress() async {
    String pregnancyRecord = await ss.getItem("pregnancyRecord") ?? "";

    await ss.setPrefItem(
        "dashboardGoal", "pregnancy"); //set user dashboard goal

    // if(pregnancyRecord.isNotEmpty) {
    //   return;
    // }

    //go to pregnancy screen to ask questions
    Navigator.pushNamed(context, PregnancyInfo.routeName);
  }
}
