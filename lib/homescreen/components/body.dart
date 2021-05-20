import 'dart:convert';

import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/alertdialog.dart';
import 'package:coral_reef/shared_screens/header_name.dart';
import 'package:coral_reef/shared_screens/special_offer_card.dart';
import 'package:coral_reef/tracker_screens/bottom_navigation_bar.dart';
import 'package:coral_reef/wellness/wellness_tracker_options.dart';
import 'package:flutter/material.dart';
import 'package:coral_reef/size_config.dart';
import 'package:coral_reef/homescreen/components/components.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  String wellnessSetup = "";

  StorageSystem ss = new StorageSystem();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ss.getItem("wellnessSetup").then((value) {
      String v = value ?? "";
      setState(() {
        wellnessSetup = v;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(25)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.05),
                HomeLogo(),
                SizedBox(height: SizeConfig.screenHeight * 0.01),
                Heading(body: "Hope you're feeling good today"),
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                Cards(wellnessSetup),
                // SizedBox(height: SizeConfig.screenHeight * 0.08),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Cards extends StatelessWidget {
  final String ws;

  Cards(this.ws,{
    Key key,
  }) : super(key: key);

  StorageSystem ss = new StorageSystem();

  // List<Map<String, dynamic>> vals = [
  //   {
  //     "image": "assets/images/wellness_card.png",
  //               "title": "Wellness Tracker",
  //               "title2":
  //                   'keep track of your well-being, exercise, period and diet',
  //               "press": () {},
  //   },{
  //     "image": "assets/images/wellness_card.png",
  //               "title": "Wellness Tracker",
  //               "title2":
  //                   'keep track of your well-being, exercise, period and diet',
  //               "press": () {},
  //   },{
  //     "image": "assets/images/wellness_card.png",
  //               "title": "Wellness Tracker",
  //               "title2":
  //                   'keep track of your well-being, exercise, period and diet',
  //               "press": () {},
  //   },
  // ];

  @override
  Widget build(BuildContext context) {
    // return Column(
    //   children: [
    //     Row(
    //       children: [
    //         SpecialOfferCard(
    //           image: "assets/images/wellness_card.png",
    //           title: "Wellness Tracker",
    //           title2:
    //               'keep track of your well-being, exercise, period and diet',
    //           press: () {},
    //         ),
    //         SpecialOfferCard(
    //           image: "assets/images/shop_coral.png",
    //           title: "Shop Coral",
    //           title2: 'All things you need under one click',
    //           press: () {
    //             _showTestDialog(context);
    //           },
    //         ),
    //       ],
    //     ),
    //     SizedBox(height: SizeConfig.screenHeight * 0.01),
    //     Row(
    //       children: [
    //         SpecialOfferCard(
    //           image: "assets/images/G-chat.png",
    //           title: "G-Chat",
    //           title2: 'Chat with us to solve your issues',
    //           press: () {},
    //         ),
    //         SpecialOfferCard(
    //           image: "assets/images/G-expert_corner.png",
    //           title: "G-Expert Corner",
    //           title2: 'All things you need under one click',
    //           press: () {},
    //         ),
    //       ],
    //     ),
    //   ],
    // );

    // return GridView.count(
    //   shrinkWrap: true,
    //   padding:
    //   EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
    //   crossAxisSpacing: 10.0,
    //   mainAxisSpacing: 17.0,
    //   childAspectRatio: 0.545,
    //   crossAxisCount: 2,
    //   primary: false,
    //   children: vals
    //       .map((pro) =>
    //       SpecialOfferCard()
    //       .toList(),
    //   ));

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 550.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SpecialOfferCard(
                image: "assets/images/wellness_card.png",
                title: "Wellness Tracker",
                title2:
                    'keep track of your well-being, exercise, period and diet',
                press: () {
                  wellnessTrackerClicked(context, ws);
                },
              ),
              SpecialOfferCard(
                image: "assets/images/gchat_card_new.png",
                title: "G-Chat",
                title2: 'Chat with us to solve your issues',
                press: () async {
                  String _checkSetup = await ss.getItem("gchatSetup");// check if user has set up gchat settings
                  bool hasSetup = _checkSetup != null;
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => new CoralBottomNavigationBar(isGChat: true, hasGChatSetup: hasSetup,)));
                },
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SpecialOfferCard(
                image: "assets/images/shop_coral.png",
                title: "Shop Coral",
                title2: 'All things you need under one click',
                press: () {
                  _showTestDialog(context);
                },
              ),
              SpecialOfferCard(
                image: "assets/images/G-expert_corner.png",
                title: "G-Expert Corner",
                title2: 'All things you need under one click',
                press: () {
                  _showTestDialog(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /*
   * Determine if the wellness set up has been attended to
   */
  Future<void> wellnessTrackerClicked(BuildContext context, String wellnessSetup) async {
    // await ss.setPrefItem("dashboardGoal", "pregnancy");//to be deleted
    if (wellnessSetup.isEmpty) {
      //go to wellness setup screen
      Navigator.pushNamed(context, WellnessTrackerOptions.routeName);
    } else {
      String _checkSetup = await ss.getItem("gchatSetup");// check if user has set up gchat settings
      bool hasSetup = _checkSetup != null;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => new CoralBottomNavigationBar(isGChat: false, hasGChatSetup: hasSetup,)));
      // Navigator.pushNamed(context, CoralBottomNavigationBar.routeName);

      String dashboardGoal = await ss.getItem("dashboardGoal") ?? "";
      if (dashboardGoal.isEmpty || dashboardGoal == "period") {
        //go to period dashboard
        return;
      }
      if (dashboardGoal == "pregnancy") {
        //go to pregnancy dashboard
        return;
      }
      if (dashboardGoal == "conceive") {
        //go to conceive dashboard
        return;
      }
    }
  }

  void _showTestDialog(context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        //context: _scaffoldKey.currentContext,
        builder: (context) {
          return AlertDialogSuccessPage(
            text: 'Coming Soon...',
          );
        });
  }
}
