import 'dart:io';

import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/components/socal_card.dart';
import 'package:coral_reef/onboarding/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import '../../../size_config.dart';
import 'signup_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                Logo(),
                SizedBox(),
                Heading(),
                SizedBox(height: SizeConfig.screenHeight * 0.05),
                SignForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                Center(
                    child: Line()),
                SizedBox(
                  height: 10,
                ),
                Socials(),
                SizedBox(height: getProportionateScreenHeight(10)),
                HaveAccountText(),
                SizedBox(height: getProportionateScreenHeight(10)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HaveAccountText extends StatelessWidget {
  const HaveAccountText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: Theme.of(context).textTheme.bodyText1.copyWith(
            color: Color(MyColors.titleTextColor),
            fontSize: getProportionateScreenWidth(16),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, SignInScreen.routeName),
          child: Text(
            "Log in",
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                fontSize: getProportionateScreenWidth(16),
                color: Color(MyColors.primaryColor), fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class Line extends StatelessWidget {
  const Line({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: Divider(
          thickness: 0.5,
          color: Color(MyColors.primaryColor).withAlpha(40),
        )),
        SizedBox(
          width: 5,
        ),
        Text('or sign up with', style: Theme.of(context)
            .textTheme
            .subtitle1.copyWith(color: Color(MyColors.titleTextColor)),),
        SizedBox(
          width: 5,
        ),
        Expanded(
            child: Divider(
          thickness: 0.5,
          color: Color(MyColors.primaryColor).withAlpha(40),
        )),
      ],
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({
    Key key,
    this.icon,
  }) : super(key: key);

  final String icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          //margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(5)),
          //padding: EdgeInsets.all(getProportionateScreenWidth(0)),
          height: getProportionateScreenHeight(40),
          width: getProportionateScreenWidth(40),
          decoration: BoxDecoration(
            color: Color(0xFFF5F6F9),
            shape: BoxShape.circle,
          ),
          child: Image.asset('assets/images/logo2.png'),
        ),
      ],
    );
  }
}

class Socials extends StatelessWidget {
  const Socials({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialCard(
          icon: "assets/icons/google.png",
          press: () {},
        ),
        SocialCard(
          icon: "assets/icons/facebook.png",
          press: () {},
        ),
        (Platform.isIOS)
            ? SocialCard(
                icon: "assets/icons/apple.png",
                press: () {},
              )
            : Text(''),
      ],
    );
  }
}

class Heading extends StatelessWidget {
  const Heading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Create a new \naccount",
              style: Theme.of(context).textTheme.headline1.copyWith(
                  color: Color(MyColors.titleTextColor),
                  fontSize: getProportionateScreenWidth(25),
                  height: 1),
            ),
          ],
        ),
      ],
    );
  }
}
