import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/size_config.dart';
import 'package:flutter/material.dart';

class EmptyCoffeeShop extends StatelessWidget {
  final String text;
  // final bool showButton;

  EmptyCoffeeShop(this.text);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: 500.0,
      color: Colors.white,
      height: 500.0,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding:
                    EdgeInsets.only(top: mediaQueryData.padding.top + 50.0)),
            Image.asset(
              "assets/images/vector.png",
              height: 300.0,
            ),
            Padding(padding: EdgeInsets.only(bottom: 10.0)),
            Text(
              text,
              style: Theme.of(context).textTheme.headline2.copyWith(
                    color: Color(MyColors.titleTextColor),
                    fontSize: getProportionateScreenWidth(18),
                  ),
            )
          ],
        ),
      ),
    );
  }
}
