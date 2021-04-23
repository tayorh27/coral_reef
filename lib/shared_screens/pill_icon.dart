import 'package:coral_reef/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../size_config.dart';


class PillIcon extends StatelessWidget {
  const PillIcon({
    Key key,
    this.icon,
    this.press,
    this.size,
    this.paddingRight,
    this.svgColor,
  }) : super(key: key);
  final String icon;
  final double size;
  final double paddingRight;
  final Function press;
  final Color svgColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Padding(
        padding: EdgeInsets.only(right: (paddingRight == null) ? 20.0 : paddingRight),
        child: Container(
          height: getProportionateScreenWidth(size),
          width: getProportionateScreenWidth(size),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(icon, color: (svgColor == null) ? Color(MyColors.primaryColor): svgColor,),
        ),
      ),
    );
  }
}