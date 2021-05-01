import 'dart:ui';

import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/tracker_screens/bottom_navigation_bar.dart';
import 'package:coral_reef/wallet_screen/components/pin_input_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../size_config.dart';

enum ScreenType {initial, retype}

class SetupPin extends StatefulWidget {

  static final routeName = "setup-pin";

  @override
  State<StatefulWidget> createState() => _SetupPin();
}

class _SetupPin extends State<SetupPin> {

  ScreenType reTypePin = ScreenType.initial;
  String userPin = "", retypePin = "";

  StorageSystem ss = new StorageSystem();

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
                  SizedBox(height: SizeConfig.screenHeight * 0.09),
                  Text(
                    (reTypePin == ScreenType.initial) ? "Create new PIN" : "Retype your PIN",
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
                  (reTypePin == ScreenType.initial) ? SetupForm1(onFinish: (String pin) {
                    userPin = pin;
                    setState(() {
                      reTypePin = ScreenType.retype;
                    });
                  }) : SetupForm2(onFinish: (String pin) {
                    retypePin = pin;
                  }),
                  // buildTimer(),
                  SizedBox(height: SizeConfig.screenHeight * 0.03),
                  (reTypePin == ScreenType.retype) ? GestureDetector(
                    onTap: () {
                      // setState(() {
                      //   reTypePin = ScreenType.initial;
                      // });
                      Navigator.pushReplacementNamed(context, SetupPin.routeName);
                    },
                    child: Text("Reset Pin", textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Color(MyColors.primaryColor),
                          fontSize: getProportionateScreenWidth(15))),
                  ) : SizedBox(),
                  SizedBox(height: SizeConfig.screenHeight * 0.3),
                  (reTypePin == ScreenType.retype) ? DefaultButton(
                    text: "Continue",
                    press: () async {
                      if(userPin.isEmpty || retypePin.isEmpty) {
                        new GeneralUtils().displayAlertDialog(context, "Attention", "Pins do not match.");
                        return;
                      }
                      if(userPin != retypePin) {
                        new GeneralUtils().displayAlertDialog(context, "Attention", "Pins do not match.");
                        return;
                      }
                      await ss.setPrefItem("userPin", retypePin);
                      await ss.setPrefItem("walletSetup", "true");
                      _showTestDialog(context);
                    },
                  ) : SizedBox()
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

  AlertDialogPage({
    Key key,
  }) : super(key: key);

  StorageSystem ss = new StorageSystem();

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
                    press: () async {
                      String _checkSetup = await ss.getItem("gchatSetup");// check if user has set up gchat settings
                      bool hasSetup = _checkSetup != null;
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => new CoralBottomNavigationBar(isGChat: false, hasGChatSetup: hasSetup, goToWallet: true,)));
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
