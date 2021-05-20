import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class PastChallenges extends StatefulWidget {
  static final routeName = "pastChallenges";
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<PastChallenges> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios)),
              Text(
                'Past challenges',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: getProportionateScreenWidth(15),
                  fontWeight: FontWeight.bold
                    ),
              ),
              Text('')
            ],
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset("assets/exercise/foot.svg",
                                height: 50.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('February Steps Challenge',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                          fontSize:
                                              getProportionateScreenWidth(15),
                                        )),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                        "assets/exercise/female.svg",
                                        height: 12.0),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('12',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                              color: Colors.grey,
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      10),
                                            )),
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text('24 / 28 days',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                          color: Colors.grey,
                                          fontSize:
                                              getProportionateScreenWidth(10),
                                        )),
                                LinearPercentIndicator(
                                  padding: EdgeInsets.zero,
                                  width: 200.0,
                                  lineHeight: 4.0,
                                  percent: 0.9,
                                  progressColor: Color(MyColors.primaryColor),
                                )
                              ],
                            ),
                            Text('Finished',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      color: Colors.grey,
                                      fontSize: getProportionateScreenWidth(10),
                                    )),
                          ],
                        ),
                      ),

                      Divider(thickness: 3,),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset("assets/exercise/foot.svg",
                                height: 50.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('February Steps Challenge',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                      fontSize:
                                      getProportionateScreenWidth(15),
                                    )),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                        "assets/exercise/female.svg",
                                        height: 12.0),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('12',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                          color: Colors.grey,
                                          fontSize:
                                          getProportionateScreenWidth(
                                              10),
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text('24 / 28 days',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                      color: Colors.grey,
                                      fontSize:
                                      getProportionateScreenWidth(10),
                                    )),
                                LinearPercentIndicator(
                                  padding: EdgeInsets.zero,
                                  width: 200.0,
                                  lineHeight: 4.0,
                                  percent: 0.9,
                                  progressColor: Color(MyColors.primaryColor),
                                )
                              ],
                            ),
                            Text('Finished',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                  color: Colors.grey,
                                  fontSize: getProportionateScreenWidth(10),
                                )),
                          ],
                        ),
                      ),
                      Divider(thickness: 3,),
                    ]))));
  }
}
