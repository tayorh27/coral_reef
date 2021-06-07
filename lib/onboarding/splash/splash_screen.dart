import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/homescreen/Home.dart';
import 'package:coral_reef/onboarding/sign_in/sign_in_screen.dart';
import 'package:coral_reef/onboarding/splash/Onboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../size_config.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  StorageSystem ss = new StorageSystem();

  bool destroyApp = false;

  @override
  void initState() {

    appCheck();
    // FirebaseAuth.instance.signOut().then((value) {print("fodne");});
    // ss.clearPref();

    var d = Duration(seconds: 3);
    // delayed 3 seconds to next page
    Future.delayed(d, () async {
      // await ss.clearPref();

      if(destroyApp){
        new GeneralUtils().displayAlertDialog(context, "Attention", "This app is no longer available for test.");
        return;
      }

      String logged = await ss.getItem("loggedin") ?? '';

      final boarded = await ss.getItem("boarded") ?? '';

      print('boarded ========$boarded');
      print('logged ========$logged');

      //check if user has viewed the boarding screens
      if (boarded.isEmpty || boarded == "false") {
        print('boarded ========$boarded');
        await ss.setPrefItem("boarded", "true");
        // Navigator.of(context).pushReplacementNamed("on_boarding");
        gotoOnBoardingScreen();
        return;
      }

      //check if user is logged in
      if(logged == "true") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HomeScreen();
            },
          ),
              (route) => false,
        );
        return;
      }

      //if user is not logged in
      Navigator.pushReplacementNamed(context, SignInScreen.routeName);
    });

    super.initState();
  }

  appCheck() async {
    DocumentSnapshot query = await FirebaseFirestore.instance.collection("db").doc("global-settings").get();
    Map<String, dynamic> dt = query.data();
    destroyApp = (Platform.isIOS) ? dt["destroy_app_ios"] : dt["destroy_app_android"];
    if(destroyApp == null) {
      destroyApp = false;
    }
  }

  gotoOnBoardingScreen() {
    // to next page and close this page
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) {
          return OnboardScreen();
        },
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/splash_screen.png'),
                  fit: BoxFit.cover),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/coral_reef_splash_logo.png',
                      height: getProportionateScreenHeight(90.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
