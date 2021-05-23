import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/ListItem/model_challenge.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/constants.dart';
import 'package:coral_reef/size_config.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/active_challenge/track_challenge_activities.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/challenge_details.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/coral_rewards.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/create_challenge.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/past_challenges.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/start_community.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/start_weekdays.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/start_weekend.dart';
import 'package:coral_reef/wallet_screen/services/wallet_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:readmore/readmore.dart';

import 'community_challenge_details.dart';

class ChallengePage extends StatefulWidget {
  static final routeName = "challengePage";
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<ChallengePage> {
  String selected = 'community';

  optionDialog() {
    // print(selected);
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
                                          Navigator.of(context).pop();
                                          Navigator.pushNamed(context,
                                              CreateChallengePage.routeName,
                                              arguments: "Community");
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
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle1
                                                          .copyWith(
                                                              color: Color(MyColors
                                                                  .titleTextColor),
                                                              fontSize: 14.0),
                                                    ),
                                                    Text(
                                                      "community, unlimited",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle1
                                                          .copyWith(
                                                              color: Color(MyColors
                                                                  .titleTextColor),
                                                              fontSize: 14.0),
                                                    ),
                                                    Text(
                                                      "participants",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle1
                                                          .copyWith(
                                                              color: Color(MyColors
                                                                  .titleTextColor),
                                                              fontSize: 14.0),
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
                                              color: Color(
                                                  MyColors.titleTextColor),
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
                                              color: Color(
                                                  MyColors.titleTextColor),
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
                                              Navigator.of(context).pop();
                                              Navigator.pushNamed(context,
                                                  CreateChallengePage.routeName,
                                                  arguments: "Friends");
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
                                                          color: Color(MyColors
                                                              .titleTextColor),
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
                                                          color: Color(MyColors
                                                              .titleTextColor),
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ),
                                              ],
                                            )),
                                        InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              Navigator.pushNamed(context,
                                                  CreateChallengePage.routeName,
                                                  arguments: "Friends");
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
                                                          color: Color(MyColors
                                                              .titleTextColor),
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
                                                          color: Color(MyColors
                                                              .titleTextColor),
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
                                          .subtitle1
                                          .copyWith(
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      15),
                                              color: Color(
                                                  MyColors.titleTextColor),
                                              fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      'your challenge',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      15),
                                              color: Color(
                                                  MyColors.titleTextColor),
                                              fontWeight: FontWeight.w500),
                                    ),
                                  ]),
                      ])));
        });
  }

  List<VirtualChallenge> challenges = [];
  List<VirtualChallenge> myChallenges = [];

  bool _inAsyncCall = false;

  String crlxBalance = "0";

  WalletServices walletServices;
  Map<String, dynamic> addresses = new Map();

  StorageSystem ss = new StorageSystem();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //get general challenges
    FirebaseFirestore.instance.collection("challenges").get().then((query) {
      if (query.size == 0) return;
      query.docs.forEach((chan) {
        VirtualChallenge vc = VirtualChallenge.fromSnapshot(chan.data());
        setState(() {
          challenges.add(vc);
        });
      });
    });

    //get user challenges
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("my-challenges")
        .get()
        .then((query) {
      if (query.size == 0) return;
      query.docs.forEach((chan) {
        VirtualChallenge vc = VirtualChallenge.fromSnapshot(chan.data());
        setState(() {
          myChallenges.add(vc);
        });
      });
    });
    walletServices = new WalletServices();
    setupInitWallet();
  }

  setupInitWallet() async {
    addresses = await walletServices.getUserAddresses();
    Map<String, dynamic> resp =
        await walletServices.getTokenBalance(addresses["public"]);
    crlxBalance = resp["crlx"];
  }

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
        body: ModalProgressHUD(
            inAsyncCall: _inAsyncCall,
            opacity: 0.6,
            progressIndicator: CircularProgressIndicator(),
            color: Color(MyColors.titleTextColor),
            child: SingleChildScrollView(
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
                                    Visibility(
                                      visible: false,
                                      child: InkWell(
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
                                    )
                                  ],
                                )
                              ]),
                          SizedBox(height: 50),
                          Text('Choose your challenge',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  .copyWith(
                                      fontSize: getProportionateScreenWidth(20),
                                      color: Color(MyColors.titleTextColor))),
                          SizedBox(height: 20),
                          ...buildChallengesList(),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, CoralRewards.routeName);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      Color(MyColors.other2).withOpacity(0.4),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                color: Color(
                                                    MyColors.titleTextColor),
                                              ),
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
                                    context, PastChallenges.routeName);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color(MyColors.primaryColor)
                                        .withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/exercise/chal.png"),
                                      fit: BoxFit.contain,
                                    )),
                                width: double.infinity,
                                height: getProportionateScreenHeight(110),
                                child: ClipRRect(
                                    child: Stack(children: [
                                  // Container(
                                  //   width: MediaQuery.of(context).size.width,
                                  //   child: Image.asset(
                                  //     "assets/exercise/chal.png",
                                  //     fit: BoxFit.cover,
                                  //   ),
                                  // ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.all(20.0),
                                          child: Text(
                                            "My Recent Challenges",
                                            textAlign: TextAlign.start,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                    color: Color(MyColors
                                                        .titleTextColor),
                                                    fontSize:
                                                        getProportionateScreenWidth(
                                                            18)),
                                          )),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(''),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 2.0),
                                            child: Container(
                                              height:
                                                  getProportionateScreenWidth(
                                                      40),
                                              width:
                                                  getProportionateScreenWidth(
                                                      40),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: SvgPicture.asset(
                                                "assets/exercise/challenge_cup_2.svg",
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ])),
                              ))
                        ])))));
  }

  bool checkIfChallengeExist(String chanID) {
    Iterable<VirtualChallenge> findChan =
        myChallenges.where((element) => element.id == chanID);
    return findChan.isNotEmpty;
  }

  List<Widget> buildChallengesList() {
    List<Widget> chans = [];

    challenges.forEach((ch) {
      bool hasStarted = false, hasEnded = false;

      DateTime today = DateTime.now();
      DateTime start = DateTime.parse(ch.start_date);
      DateTime end = DateTime.parse(ch.end_date);

      int diffStart = today.difference(start).inMilliseconds;
      int diffEnd = end.difference(today).inMilliseconds;

      hasStarted = diffStart > 0;
      hasEnded = diffEnd < 0;

      int daysLeftToStart = 0;
      int daysLeftToEnd = 0;

      // print(hasStarted);
      // print(hasEnded);

      if (!hasEnded) {
        daysLeftToStart = start.difference(today).inDays;
        daysLeftToEnd = end.difference(today).inDays;

        bool hasJoinedChallenge = checkIfChallengeExist(ch.id);

        chans.add(InkWell(
            onTap: () {
              if (!hasJoinedChallenge || !hasStarted) return; //
              Navigator.pushNamed(context, CommunityChallengeDetails.routeName,
                  arguments: ch);
            },
            child: ListTile(
              leading:
                  SvgPicture.asset("assets/exercise/foot.svg", height: 50.0),
              title: Text(ch.title,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontSize: getProportionateScreenWidth(13),
                      )),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReadMoreText(
                    ch.description,
                    trimLines: 1,
                    colorClickableText: Color(MyColors.primaryColor),
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'more',
                    trimExpandedText: 'less',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                        fontSize: 12.0, color: Color(MyColors.titleTextColor)),
                    moreStyle: Theme.of(context).textTheme.headline2.copyWith(
                        fontSize: 12.0, color: Color(MyColors.primaryColor)),
                    lessStyle: Theme.of(context).textTheme.headline2.copyWith(
                        fontSize: 12.0, color: Color(MyColors.primaryColor)),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset("assets/exercise/female.svg",
                              height: 12.0),
                          SizedBox(
                            width: 5,
                          ),
                          Text("${ch.max_user}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    fontSize: getProportionateScreenWidth(10),
                                  )),
                        ],
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      (!hasStarted || !hasEnded)
                          ? (hasStarted)
                              ? CountdownTimer(
                                  endTime:
                                      end.millisecondsSinceEpoch + 1000 * 30,
                                  widgetBuilder:
                                      (_, CurrentRemainingTime time) {
                                    if (time == null) {
                                      return Text('Finished');
                                    }
                                    return Text(
                                        'Ending in ${time.days ?? 0}D:${time.hours ?? 0}H:${time.min ?? 0}M:${time.sec ?? 0}S',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      10),
                                            ));
                                    // return Text(
                                    //     'days: [ ${time.days} ], hours: [ ${time.hours} ], min: [ ${time.min} ], sec: [ ${time.sec} ]');
                                  },
                                )
                              : CountdownTimer(
                                  endTime:
                                      start.millisecondsSinceEpoch + 1000 * 30,
                                  widgetBuilder:
                                      (_, CurrentRemainingTime time) {
                                    if (time == null) {
                                      return Text('Finished');
                                    }
                                    return Text(
                                        'Starting in ${time.days ?? 0}D:${time.hours ?? 0}H:${time.min ?? 0}M:${time.sec ?? 0}S',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      10),
                                            ));
                                    // return Text(
                                    //     'days: [ ${time.days} ], hours: [ ${time.hours} ], min: [ ${time.min} ], sec: [ ${time.sec} ]');
                                  },
                                )
                          : SizedBox(),
                      SizedBox(
                        width: 30,
                      ),
                      (hasJoinedChallenge)
                          ? Text(
                              "Joined",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  .copyWith(
                                      fontSize: 10.0,
                                      color: Color(MyColors.primaryColor)),
                            )
                          : SizedBox()
                    ],
                  )
                ],
              ),
              isThreeLine: true,
            )));
        chans.add(
          (hasStarted && !hasEnded)
              ? (!hasJoinedChallenge)
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                          width: 80,
                          height: 30,
                          child: DefaultButton(
                            press: () {
                              // Navigator.pushNamed(
                              //     context, StartWeekend.routeName);
                              joinChallenge(ch);
                            },
                            loading: false,
                            fontSize: 14,
                            text: 'Join',
                          )),
                    )
                  : SizedBox()
              : SizedBox(),
        );
        chans.add(
          Divider(
            thickness: 2,
          ),
        );
      }
    });

    return chans;
  }

  Future<void> joinChallenge(VirtualChallenge ch) async {
    //check max
    if (ch.max_user >= 50) {
      new GeneralUtils().displayAlertDialog(context, "Attention",
          "Sorry the maximum number of users to join this challenge has been reached.");
      return;
    }

    String currentCH = await ss.getItem("currentChallenge");

    if (currentCH != null) {
      new GeneralUtils().displayAlertDialog(context, "Attention",
          "Please complete your current challenge before joining another.");
      return;
    }

    if (ch.challenge_type == "Pool") {
      bool getResp = await new GeneralUtils().displayReturnedValueAlertDialog(
          context,
          "Attention",
          "${ch.reward_value} CRLX is required to join this challenge. Continue?");
      if (!getResp) return;

      double crlx = double.parse(crlxBalance);
      double chanValue = double.parse(ch.reward_value);

      if (crlxBalance == "0" || crlx < chanValue) {
        new GeneralUtils().displayAlertDialog(context, "Attention",
            "Sorry, you do not have enough CRLX to join this challenge.");
        return;
      }

      setState(() {
        _inAsyncCall = true;
      });

      //deduct and join challenge
      await walletServices.transferAdmin(
          addresses["public"],
          "${ch.reward_value} CRLX has been deducted from your wallet for being a sponsor.",
          ch.reward_value);

      //update challenge data
      await FirebaseFirestore.instance
          .collection("challenges")
          .doc(ch.id)
          .update({
        "max_user": FieldValue.increment(1),
        "winner_amount": FieldValue.increment(chanValue)
      });

      postJoinChallenge(ch);
      return;
    }

    setState(() {
      _inAsyncCall = true;
    });

    //update challenge data
    await FirebaseFirestore.instance
        .collection("challenges")
        .doc(ch.id)
        .update({
      "max_user": FieldValue.increment(1),
    });

    postJoinChallenge(ch);
  }

  postJoinChallenge(VirtualChallenge ch) async {
    //add to activity
    String id = FirebaseDatabase.instance.reference().push().key;

    //get user data
    String localUser = await ss.getItem('user');
    Map<String, dynamic> json = jsonDecode(localUser);

    String image = (json["picture"] == "")
        ? "https://firebasestorage.googleapis.com/v0/b/coraltrackerapp.appspot.com/o/default_avatar.png?alt=media&token=f7fcf422-1853-4c7c-9b3a-bb5204c3a94f"
        : json["picture"];

    VirtualChallengeActivities vca = new VirtualChallengeActivities(
        id,
        user.uid,
        "joined",
        "${json["firstname"]} ${json["lastname"]} has joined this challenge.",
        image,
        new DateTime.now().toString(),
        FieldValue.serverTimestamp(),
        ch.msgId);
    await FirebaseFirestore.instance
        .collection("challenges")
        .doc(ch.id)
        .collection("activities")
        .doc(id)
        .set(vca.toJSON());

    //subscribe to topic
    await new GeneralUtils().subscribeToTopic(ch.id, json["msgId"]);

    //add to user joined challenges
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("my-challenges")
        .doc(ch.id)
        .set(ch.toJSON());

    //add users to challenge collection
    VirtualChallengeMembers vcm = new VirtualChallengeMembers(
        id,
        user.uid,
        "${json["firstname"]} ${json["lastname"]}",
        image,
        new DateTime.now().toString(),
        FieldValue.serverTimestamp(),
        json["msgId"],
        0,
        0,
        0,
        0);
    await FirebaseFirestore.instance
        .collection("challenges")
        .doc(ch.id)
        .collection("joined-users")
        .doc(id)
        .set(vcm.toJSON());

    new GeneralUtils()
        .showToast(context, "You have successfully joined the challenge");

    //save to local storage
    ch.timestamp = "";
    await ss.setPrefItem("currentChallenge", jsonEncode(ch.toJSON()));
    await ss.setPrefItem("user_ch_id", id);

    setState(() {
      _inAsyncCall = false;
    });

    //goto active challenge
    Navigator.pushNamed(context, TrackChallengeActivities.routeName,
        arguments: ch);
  }
}

/*
InkWell(
                        onTap: (){
                          Navigator.pushNamed(
                              context,
                              ChallengeDetails
                                  .routeName);

                        },
                        child:
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
                          ))),
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
                                    press: () {},
                                    text: 'Join',
                                  ))
                            ],
                          )),
* */
