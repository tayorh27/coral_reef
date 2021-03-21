import 'package:coral_reef/Utils/colors.dart';
import 'package:flutter/material.dart';
import '../../../size_config.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key key,
    this.text,
    this.text1,
    this.image,
  }) : super(key: key);
  final String text1, text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(flex: 2),
        Image.asset(
          image,
          height: getProportionateScreenHeight(265),
          width: getProportionateScreenWidth(235),
        ),
        SizedBox(
          height: getProportionateScreenHeight(20.0),
        ),
        Text(
          text1,
          style: Theme.of(context).textTheme.headline1.copyWith(
            fontSize: getProportionateScreenWidth(25), color: Color(MyColors.titleTextColor)
          ),
        ),
        SizedBox(),
        Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2.copyWith(
              fontSize: getProportionateScreenWidth(14), color: Color(MyColors.secondaryTextColor)
          ),
        ),
      ],
    );
  }
}
