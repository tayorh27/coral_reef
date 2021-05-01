import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget appbar(context) {
  return AppBar(
    leading: Container(
      margin: EdgeInsets.only(top: 20.0),
      child: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          }),
    ),
    backgroundColor: Colors.white,
    elevation: 0,
    actions: [
      Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SvgPicture.asset("assets/icons/daylight.svg", height: 22.0),
          Container(
            width: 10.0,
          ),
          // Text(
          //   "${days[date.weekday - 1]} ${date.day} ${months[date.month - 1]}",
          //   style: Theme.of(context).textTheme.bodyText1.copyWith(
          //       color: Color(MyColors.primaryColor),
          //       fontSize: getProportionateScreenWidth(12)),
          // ),
          Container(
            width: 10.0,
          ),
          SvgPicture.asset(
              "assets/icons/clarity_notification-outline-badged.svg",
              height: 22.0),
        ],
      ),
      SizedBox(
        width: 30.0,
      ),
    ],
  );
}