import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/wallet_screen/sections/setup_pin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../size_config.dart';

class WalletSetupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WalletSetupScreen();
}

class _WalletSetupScreen extends State<WalletSetupScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(40),
              vertical: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  Container(
                    child: SvgPicture.asset(
                      'assets/icons/guard.svg',
                      height: 250,
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.05),
                  Text('Secure your account!',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.headline2.copyWith(
                          color: Color(MyColors.titleTextColor),
                          fontSize: getProportionateScreenWidth(25))),
                  SizedBox(height: SizeConfig.screenHeight * 0.01),
                  Text(
                    'One way to keep your account safe is to set up a security pin for your transactions.',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Color(MyColors.titleTextColor),
                        fontSize: getProportionateScreenWidth(15)),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  DefaultButton(
                    text: 'Continue',
                    press: () {
                      Navigator.pushNamed(context, SetupPin.routeName);
                    },
                  ),
                ],
              ),
            )
          ),
        ),
      ),
    ));
  }
}
