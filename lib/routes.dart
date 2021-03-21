import 'package:coral_reef/onboarding/splash/Onboard_screen.dart';
import 'package:coral_reef/onboarding/sign_in/sign_in_screen.dart';
import 'package:coral_reef/onboarding/sign_up/signup_screen.dart';
import 'package:coral_reef/onboarding/forgotpassword/forgotpassword.dart';
import 'package:coral_reef/wellness/onboarding/height.dart';
import 'package:coral_reef/wellness/onboarding/period_info.dart';
import 'package:coral_reef/wellness/onboarding/pregnancy_info.dart';
import 'package:coral_reef/wellness/onboarding/required_weight.dart';
import 'package:coral_reef/wellness/onboarding/weight.dart';
import 'package:coral_reef/wellness/onboarding/wellness.dart';
import 'package:coral_reef/wellness/onboarding/year.dart';
import 'package:flutter/widgets.dart';
import 'package:coral_reef/homescreen/Home.dart';



final Map<String, WidgetBuilder> routes = {
  OnboardScreen.routeName: (context) => OnboardScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  WellnessScreen.routeName: (context) => WellnessScreen(),
  // YearScreen.routeName: (context) => YearScreen(),
  WeightScreen.routeName: (context) => WeightScreen(),
  RequiredWeightScreen.routeName: (context) => RequiredWeightScreen(),
  HeightScreen.routeName: (context) => HeightScreen(),
  PregnancyInfo.routeName: (context) => PregnancyInfo(),
  PeriodInfo.routeName: (context) => PeriodInfo(),
};
