import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/onboarding/splash/components/body.dart';
import 'package:flutter/material.dart';

import '../../size_config.dart';



class OnboardScreen extends StatelessWidget {
  static String routeName = "/onboard";
  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(MyColors.lightBackground),
      body: Body(),
    );
  }
}
