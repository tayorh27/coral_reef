import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/onboarding/sign_in/sign_in_screen.dart';
import 'package:coral_reef/onboarding/splash/Onboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../size_config.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  StorageSystem ss = new StorageSystem();

  @override
  void initState() {

    // ss.clearPref();

    var d = Duration(seconds: 4);
    // delayed 3 seconds to next page
    Future.delayed(d, () async {
      // await ss.clearPref();

      String logged = await ss.getItem('loggedin') ?? '';

      final boarded = await ss.getItem('boarded') ?? '';

      //check if user has viewed the boarding screens
      if (boarded.isEmpty || boarded == 'false') {
        print('boarded ========$boarded');
        await ss.setPrefItem('boarded', 'true');
        // Navigator.of(context).pushReplacementNamed("on_boarding");
        gotoOnBoardingScreen();
        return;
      }

      //check if user is logged in
      if(logged == 'true') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) {
              return OnboardScreen();
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
