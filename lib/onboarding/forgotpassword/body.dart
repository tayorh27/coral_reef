import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/components/coral_back_button.dart';
import 'package:flutter/material.dart';
import '../../size_config.dart';
import '../../components/default_button.dart';
import 'package:coral_reef/onboarding/sign_in/sign_in_screen.dart';
import 'passwordform.dart';

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
                SizedBox(height: 40.0),
                Row(
                  children: [
                    CoralBackButton(onPress: (){
                      Navigator.of(context).pop();
                    },),
                  ],
                ),
                SizedBox(height: 40.0),
                Logo(),
                SizedBox(height: SizeConfig.screenHeight * 0.01),
                Heading(),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                EmailField(),
              ],
            ),
          ),
        ),
      ),
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


class Heading extends StatelessWidget {
  const Heading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Reset password",
                style: Theme.of(context).textTheme.headline1.copyWith(
                  color: Color(MyColors.titleTextColor),
                  fontSize: getProportionateScreenWidth(25),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Please enter your email address to request \npassword reset",
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: Color(MyColors.inActiveState),
                  fontSize: getProportionateScreenWidth(14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}