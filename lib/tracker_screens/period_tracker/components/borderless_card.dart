
import 'package:coral_reef/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BorderlessCard extends StatelessWidget {

  final Color borderColor;
  final String image;
  final String text;
  BorderlessCard({this.borderColor, this.image, this.text});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 120.0,
      width: getProportionateScreenWidth(100),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: borderColor)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(image, height: (text.toLowerCase() != "low") ? 20.0 : 30.0,),
          SizedBox(height: 5.0,),
          Text(text, style: Theme.of(context).textTheme.subtitle1.copyWith(
            color: borderColor,
            fontSize: getProportionateScreenWidth(15)
          ))
        ],
      )
    );
  }
}