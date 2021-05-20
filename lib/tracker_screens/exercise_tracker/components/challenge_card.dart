import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/shared_screens/pill_icon.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/challenge_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../size_config.dart';

class ChallengeCard extends StatelessWidget {
  const ChallengeCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
           Navigator.pushNamed(context, ChallengePage.routeName);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Color(MyColors.other2).withOpacity(0.4),
            borderRadius: BorderRadius.circular(10),
          ),
          width: double.infinity,
          height:  getProportionateScreenHeight(230),
          child: ClipRRect(
              child: Stack(children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child:
                Image.asset(
                  "assets/exercise/challenge_bg.png",
                  fit: BoxFit.cover,
                ),),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left:20.0, top: 20.0),
                      child: Text(
                        "Challenges",
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: getProportionateScreenWidth(16),
                          color: Color(MyColors.challengeCardTextColor),
                        ),
                      ),
                    ),
                    Container(
                      height: 10.0,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width / 1.3,
                        padding: EdgeInsets.only(left:20.0),
                        child: Text(
                          "Take on different challenges and get coral rewards",
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                fontSize: getProportionateScreenWidth(13),
                                color: Color(MyColors.titleTextColor),
                              ),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(''),
                        Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: Container(
                            height: getProportionateScreenWidth(80),
                            width: getProportionateScreenWidth(80),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              "assets/exercise/challenge_cup.svg",
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ])),
        ));
  }
}
