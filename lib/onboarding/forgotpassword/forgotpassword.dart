import 'package:coral_reef/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'body.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static String routeName = "/password";
  @override
  Widget build(BuildContext context) {
    // Animation<Color> color = Animation<Color>(Colors.deepPurple);
    return Scaffold(
        body: ModalProgressHUD(
      inAsyncCall: false,
      opacity: 0.6,
      progressIndicator: CircularProgressIndicator(),
      color: Color(MyColors.titleTextColor),
      child: Body(),
    ));
  }
}
