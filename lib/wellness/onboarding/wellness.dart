import 'package:coral_reef/Utils/colors.dart';
import 'package:flutter/material.dart';

import 'body.dart';

class WellnessScreen extends StatelessWidget {
  static String routeName = "/wellness";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(MyColors.lightBackground),
      body: Body(),
    );
  }
}