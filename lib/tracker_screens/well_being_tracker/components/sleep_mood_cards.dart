import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../size_config.dart';

class SleepMoodCard extends StatelessWidget {
  const SleepMoodCard({
    Key key,
    @required this.title,
    @required this.icon,
    @required this.title2,
    this.title3,
    @required this.title4,
    @required this.press,
    @required this.color,
  }) : super(key: key);

  final String title, icon,title2,title3,title4;
  final Color color;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: press,
        child: Container(
          //width: getProportionateScreenWidth(130),
            height: getProportionateScreenWidth(200),
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
                          color: Colors.white,
                          fontSize: getProportionateScreenWidth(15),
                        ),),
                    ),
                  ],
                ),
                SizedBox(height: 20.0,),
                Center(
                  child: SvgPicture.asset(icon, height: 60,color: Colors.white,),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:35.0,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title2,
                        style: TextStyle(
                          color: Colors.white,
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
                            style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Colors.white,
                              fontSize: getProportionateScreenWidth(12),
                            ),),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:20.0, bottom: 20.0),
                          child: Text(title4,
                            style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: Colors.white,
                              fontSize: getProportionateScreenWidth(15),
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