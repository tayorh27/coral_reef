import 'package:coral_reef/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:coral_reef/onboarding/sign_up/signup_screen.dart';
import '../constants.dart';
import '../size_config.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don’t have an account? ",
          style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Color(MyColors.titleTextColor),
                fontSize: getProportionateScreenWidth(16),
              ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, SignUpScreen.routeName),
          child: Text(
            "Register",
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                fontSize: getProportionateScreenWidth(16),
                color: Color(MyColors.primaryColor), fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
