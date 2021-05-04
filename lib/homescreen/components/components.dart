import 'dart:convert';

import 'package:coral_reef/Utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:coral_reef/size_config.dart';



class HomeLogo extends StatelessWidget {
  const HomeLogo({
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
          height: getProportionateScreenHeight(50),
          width: getProportionateScreenWidth(90),
          decoration: BoxDecoration(
            // color: Color(0xFFF5F6F9),
            //shape: BoxShape.circle,
          ),
          child: Image.asset('assets/images/coral_reef_splash_logo.png'),
        ),
      ],
    );
  }
}

class IconBtn extends StatelessWidget {
  const IconBtn({
    Key key,
    @required this.press,
  }) : super(key: key);
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
      horizontal: getProportionateScreenWidth(10.0),
      vertical: getProportionateScreenWidth(23),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: this.press, //(){_showTestDialog(context);},
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Container(
              height: getProportionateScreenWidth(50),
              width: getProportionateScreenWidth(50),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Center(child: Image.asset("assets/images/forward_icon.png",)),
            ),
          ],
        ),
      ),
    );
  }
}