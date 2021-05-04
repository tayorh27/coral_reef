
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/components/coral_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../size_config.dart';

class CloseHeader extends StatelessWidget {
  
  final String subtitle;
  
  CloseHeader({this.subtitle});
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final date = DateTime.now();
    final months = ["JAN", "FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];
    final days = ["MON","TUE","WED","THU","FRI","SAT","SUN"];
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CoralBackButton(icon: Icon(Icons.clear, size: 32.0, color: Color(MyColors.titleTextColor),),),
        Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SvgPicture.asset("assets/icons/daylight.svg",
                    height: 22.0),
                Container(
                  width: 10.0,
                ),
                Text(
                  "${days[date.weekday - 1]} ${date.day} ${months[date.month - 1]}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(
                      color: Color(MyColors.primaryColor),
                      fontSize:
                      getProportionateScreenWidth(12)),
                ),
              ],
            ),
            Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 0.0,//initial 30
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(
                        color: Color(MyColors.titleTextColor),
                        fontSize:
                        getProportionateScreenWidth(12)),
                  )
                ])
          ],
        )
      ],
    );
  }
}