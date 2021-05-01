import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BorderlessCard extends StatelessWidget {
  final Color borderColor;
  final String image;
  final String text, bottomText;
  BorderlessCard({this.borderColor, this.image, this.text, this.bottomText});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Container(
            height: 100.0,
            width: getProportionateScreenWidth(80),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: borderColor)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  image,
                  height: (text.toLowerCase() != "low") ? 15.0 : 20.0,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(text,
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: borderColor,
                        fontSize: getProportionateScreenWidth(13)))
              ],
            )),
        SizedBox(
          height: 5.0,
        ),
        Center(
          child: Text(bottomText,
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: Color(MyColors.titleTextColor),
                  fontSize: getProportionateScreenWidth(10))),
        )
      ],
    );
  }
}
