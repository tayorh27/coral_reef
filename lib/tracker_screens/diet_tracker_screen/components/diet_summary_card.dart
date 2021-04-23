import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../size_config.dart';

class DietSummaryCard extends StatelessWidget {
  const DietSummaryCard({
    Key key,
    @required this.title,
    @required this.icon,
    @required this.title2,
    this.title3,
    @required this.title4,
    @required this.press,
    @required this.color,
    @required this.textColor,
    @required this.child,
  }) : super(key: key);

  final String title, icon,title2,title3,title4;
  final Color color, textColor;
  final Widget child;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: press,
        child: Container(
          //width: getProportionateScreenWidth(130),
            height: getProportionateScreenWidth(240),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:20.0, left: 20.0),
                      child: Text(title,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: textColor,
                          fontSize: getProportionateScreenWidth(15),
                        ),),
                    ),
                  ],
                ),
                SizedBox(height: 0.0,),
                Center(
                  child: child
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:35.0,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title2,
                        style: TextStyle(
                          color: textColor,
                          fontSize: getProportionateScreenWidth(15),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:20.0),
                          child: Text(title3,
                            style: Theme.of(context).textTheme.headline2.copyWith(
                              color: textColor,
                              fontSize: getProportionateScreenWidth(15),
                            ),),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:20.0, bottom: 20.0),
                          child: Text(title4,
                            style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: textColor,
                              fontSize: getProportionateScreenWidth(12),
                            ),),
                        ),
                      ],
                    )
                  ],
                )
              ],)
        ),
      ),
    );
  }
}