import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/size_config.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/create_challenge.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/start_community.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/start_weekdays.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/start_weekend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChallengePage extends StatefulWidget {
  static final routeName = "challengePage";
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<ChallengePage> {
  String selected = 'community';
  optionDialog() {
    print(selected);
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(15)),
              content: Container(
                  height: MediaQuery.of(context).size.height / 2,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: selected == 'friends'
                                      ? Color(MyColors.other3)
                                      : Color(MyColors.defaultTextInField)
                                          .withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10.0)),
                              padding: EdgeInsets.only(
                                  right: 20, left: 20, top: 10.0, bottom: 10.0),
                              margin: EdgeInsets.only(right: 15.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selected = 'friends';
                                    Navigator.pop(context);
                                    optionDialog();
                                  });
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Friends',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                              color: selected == 'friends'
                                                  ? Color(MyColors.primaryColor)
                                                  : Color(
                                                      MyColors.titleTextColor)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: selected == 'community'
                                      ? Color(MyColors.other3)
                                      : Color(MyColors.defaultTextInField)
                                          .withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10.0)),
                              padding: EdgeInsets.only(
                                  right: 20, left: 20, top: 10.0, bottom: 10.0),
                              margin: EdgeInsets.only(right: 15.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selected = 'community';
                                    Navigator.pop(context);
                                    optionDialog();
                                  });
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Community',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                              color: selected == 'community'
                                                  ? Color(MyColors.primaryColor)
                                                  : Color(
                                                      MyColors.titleTextColor)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        selected == 'community'
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Text(
                                      'Create a challenge for',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      15),
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      'the coral community',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      15),
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              CreateChallengePage.routeName);
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  Color(MyColors.primaryColor)
                                                      .withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            width: getProportionateScreenWidth(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.5),
                                            height:
                                                getProportionateScreenHeight(
                                                    130),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child: SvgPicture.asset(
                                                        "assets/exercise/speed_run.svg",
                                                        color: Color(MyColors
                                                            .primaryColor),
                                                        height: 50.0)),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Open to all in the coral",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14),
                                                    ),
                                                    Text(
                                                      "community, unlimited",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14),
                                                    ),
                                                    Text(
                                                      "participants",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 10),
                                                    child: SvgPicture.asset(
                                                        "assets/exercise/plus.svg",
                                                        color: Color(MyColors
                                                            .primaryColor),
                                                        height: 30.0)),
                                              ],
                                            ))),
                                  ])
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Text(
                                      'Choose weekend or',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      15),
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      'weekday challenge',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      15),
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context,
                                                  CreateChallengePage
                                                      .routeName);
                                            },
                                            child: Column(
                                              children: [
                                                SvgPicture.asset(
                                                    "assets/exercise/hill.svg",
                                                    height: 100.0),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  'Weekday',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                          fontSize:
                                                              getProportionateScreenWidth(
                                                                  12),
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ),
                                                Text(
                                                  'Challenge',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                          fontSize:
                                                              getProportionateScreenWidth(
                                                                  12),
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ),
                                              ],
                                            )),
                                        InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context,
                                                  CreateChallengePage
                                                      .routeName);
                                            },
                                            child: Column(
                                              children: [
                                                SvgPicture.asset(
                                                    "assets/exercise/step.svg",
                                                    height: 100.0),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  'Weekend',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                          fontSize:
                                                              getProportionateScreenWidth(
                                                                  12),
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ),
                                                Text(
                                                  'Challenge',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                          fontSize:
                                                              getProportionateScreenWidth(
                                                                  12),
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Invite friends and family to join',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      15),
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      'your challenge',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      15),
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                    ),
                                  ]),
                      ])));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                'Challenges',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: getProportionateScreenWidth(15),
                    ),
              ),
              SvgPicture.asset(
                  "assets/icons/clarity_notification-outline-badged.svg",
                  height: 22.0),
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
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                    onTap: () {
                                      optionDialog();
                                      //Navigator.pushNamed(context, CreateChallengePage.routeName);
                                    },
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                            "assets/exercise/trophy.svg",
                                            height: 50.0),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text('Create',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                  fontSize:
                                                      getProportionateScreenWidth(
                                                          12),
                                                )),
                                      ],
                                    )),
                                SizedBox(
                                  width: 20,
                                ),
                                InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                          CreateChallengePage.routeName);
                                    },
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                            "assets/exercise/dp.svg",
                                            height: 50.0),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text('Weekend ch...',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                  fontSize:
                                                      getProportionateScreenWidth(
                                                          12),
                                                )),
                                      ],
                                    )),
                              ],
                            )
                          ]),
                      SizedBox(height: 70),
                      Text('Choose your challenge',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: getProportionateScreenWidth(20),
                              fontWeight: FontWeight.bold)),
                      Divider(
                        thickness: 2,
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset("assets/exercise/foot.svg",
                                  height: 50.0),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('February Steps Challenge',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                            fontSize:
                                                getProportionateScreenWidth(15),
                                          )),
                                  Text('Take 5000 steps a day',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                            fontSize:
                                                getProportionateScreenWidth(12),
                                          )),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
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
                                                    fontSize:
                                                        getProportionateScreenWidth(
                                                            10),
                                                  )),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Text('3 days left',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        10),
                                              )),
                                    ],
                                  )
                                ],
                              ),
                              Container(
                                  width: 80,
                                  height: 30,
                                  child: DefaultButton(
                                    press: () {
                                      Navigator.pushNamed(
                                          context, StartWeekend.routeName);
                                    },
                                    loading: false,
                                    text: 'Join',
                                  ))
                            ],
                          )),
                      Divider(
                        thickness: 2,
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset("assets/exercise/foot.svg",
                                  height: 50.0),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('February Steps Challenge',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                            fontSize:
                                                getProportionateScreenWidth(15),
                                          )),
                                  Text('Take 5000 steps a day',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                            fontSize:
                                                getProportionateScreenWidth(12),
                                          )),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
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
                                                    fontSize:
                                                        getProportionateScreenWidth(
                                                            10),
                                                  )),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Text('3 days left',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        10),
                                              )),
                                    ],
                                  )
                                ],
                              ),
                              Container(
                                  width: 80,
                                  height: 30,
                                  child: DefaultButton(
                                    press: () {
                                      Navigator.pushNamed(
                                          context, StartWeekdays.routeName);
                                    },
                                    loading: false,
                                    text: 'Join',
                                  ))
                            ],
                          )),
                      Divider(
                        thickness: 2,
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset("assets/exercise/foot.svg",
                                  height: 50.0),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('February Steps Challenge',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                            fontSize:
                                                getProportionateScreenWidth(15),
                                          )),
                                  Text('Take 5000 steps a day',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                            fontSize:
                                                getProportionateScreenWidth(12),
                                          )),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
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
                                                    fontSize:
                                                        getProportionateScreenWidth(
                                                            10),
                                                  )),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Text('3 days left',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        10),
                                              )),
                                    ],
                                  )
                                ],
                              ),
                              Container(
                                  width: 80,
                                  height: 30,
                                  child: DefaultButton(
                                    press: () {
                                      Navigator.pushNamed(
                                          context, StartCommunity.routeName);
                                    },
                                    loading: false,
                                    text: 'Join',
                                  ))
                            ],
                          )),
                      Divider(
                        thickness: 2,
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset("assets/exercise/foot.svg",
                                  height: 50.0),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('February Steps Challenge',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                            fontSize:
                                                getProportionateScreenWidth(15),
                                          )),
                                  Text('Take 5000 steps a day',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                            fontSize:
                                                getProportionateScreenWidth(12),
                                          )),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
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
                                                    fontSize:
                                                        getProportionateScreenWidth(
                                                            10),
                                                  )),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Text('3 days left',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        10),
                                              )),
                                    ],
                                  )
                                ],
                              ),
                              Container(
                                  width: 80,
                                  height: 30,
                                  child: DefaultButton(
                                    loading: false,
                                    text: 'Join',
                                  ))
                            ],
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, CreateChallengePage.routeName);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(MyColors.other2).withOpacity(0.4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: double.infinity,
                            //   padding: EdgeInsets.all(20.0),
                            height: getProportionateScreenHeight(80),
                            child: ClipRRect(
                                child: Stack(children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Image.asset(
                                  "assets/exercise/coral.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      "My coral rewards",
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      18),
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                    ),
                                  )
                                ],
                              ),
                            ])),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, ChallengePage.routeName);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  Color(MyColors.primaryColor).withOpacity(0.4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: double.infinity,
                            height: getProportionateScreenHeight(130),
                            child: ClipRRect(
                                child: Stack(children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Image.asset(
                                  "assets/exercise/chal.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(20.0),
                                      child: Text(
                                        "Past challenges",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(fontSize: 18),
                                      )),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(''),
                                      Padding(
                                        padding: EdgeInsets.only(right: 2.0),
                                        child: Container(
                                          height:
                                              getProportionateScreenWidth(40),
                                          width:
                                              getProportionateScreenWidth(40),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: SvgPicture.asset(
                                            "assets/exercise/cup_2.svg",
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ])),
                          ))
                    ]))));
  }
}
