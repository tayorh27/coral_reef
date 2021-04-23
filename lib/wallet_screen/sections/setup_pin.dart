import 'dart:ui';

import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/wallet_screen/components/pin_input_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../size_config.dart';

class SetupPin extends StatefulWidget {

  static final routeName = "setup-pin";

  @override
  State<StatefulWidget> createState() => _SetupPin();
}

class _SetupPin extends State<SetupPin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(40)),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  Text(
                    "Create new PIN",
                    style: Theme.of(context).textTheme.headline2.copyWith(
                      color: Color(MyColors.titleTextColor),
                      fontSize: getProportionateScreenWidth(25)
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.01),
                  Text(
                      "Verify your account by entering the 4 digits code we sent to your phone number",
                      textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: Color(MyColors.titleTextColor),
                      fontSize: getProportionateScreenWidth(15)),
                  ),
                  // Text(
                  //   "+234 567 647 7684",
                  //   style: TextStyle(color: Color(MyColors.primaryColor)),
                  // ),
                  SetupForm(),
                  SizedBox(height: SizeConfig.screenHeight * 0.4),
                  // buildTimer(),
                  // SizedBox(height: SizeConfig.screenHeight * 0.02),
                  // GestureDetector(
                  //   onTap: () {
                  //     // OTP code resend
                  //   },
                  //   child: Text("Call me instead"),
                  // ),
                  // SizedBox(height: SizeConfig.screenHeight * 0.4),
                  DefaultButton(
                    text: "Continue",
                    press: () {
                      _showTestDialog(context);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Resend OTP Code "),
        TweenAnimationBuilder(
          tween: Tween(begin: 30.0, end: 0.0),
          duration: Duration(seconds: 30),
          builder: (_, value, child) => Text(
            "00:${value.toInt()}",
            style: TextStyle(color: Color(MyColors.primaryColor)),
          ),
        ),
      ],
    );
  }
}

void _showTestDialog(context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      //context: _scaffoldKey.currentContext,
      builder: (context) {
        return AlertDialogPage();
      });
}

class AlertDialogPage extends StatelessWidget {
  const AlertDialogPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //contentPadding: EdgeInsets.only(left: 20, right: 20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Container(
        height: 300,
        width: 300,
        child: SingleChildScrollView(
          child: Container(
            child: Center(
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      child: SvgPicture.asset(
                        'assets/icons/guard.svg',
                        height: 70,
                      ),
                    ),
                  ),
                  Text(
                    'Pin setup successful!',
                    style: Theme.of(context).textTheme.headline2.copyWith(
                      fontSize: getProportionateScreenWidth(20),
                      color: Color(MyColors.titleTextColor)
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.01),
                  Text(
                    'Your account is secured.\nContinue to view your wallet.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontSize: getProportionateScreenWidth(12),
                        color: Color(MyColors.titleTextColor)
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.05),
                  DefaultButton(
                    text: "Continue",
                    press: () {
                      // Navigator.pushNamed(context, Country.routeName);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
