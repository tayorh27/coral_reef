import 'dart:io';

import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/components/no_account_text.dart';
import 'package:coral_reef/components/socal_card.dart';
import 'package:flutter/material.dart';
import '../../../size_config.dart';
import 'sign_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20.0)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.05),
                Logo(),
                SizedBox(),
                Heading(),
                SizedBox(height: SizeConfig.screenHeight * 0.05),
                SignForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                Line(),
                SizedBox(
                  height: 5,
                ),
                Center(child: Text('Sign in with',style: Theme.of(context)
                    .textTheme
                    .subtitle1.copyWith(color: Color(MyColors.titleTextColor)))),
                SizedBox(
                  height: 20,
                ),
                Socials(),
                SizedBox(height: getProportionateScreenHeight(20)),
                NoAccountText(),
              ],
            ),
          ),
        ),
      ),
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
        Text('or',style: Theme.of(context)
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Welcome to",
                style: Theme.of(context).textTheme.headline1.copyWith(
      color: Color(MyColors.titleTextColor),
      fontSize: getProportionateScreenWidth(25),
    )),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "CoralReef",
              style: Theme.of(context).textTheme.headline1.copyWith(
                    color: Color(MyColors.primaryColor),
                    fontSize: getProportionateScreenWidth(25),
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
