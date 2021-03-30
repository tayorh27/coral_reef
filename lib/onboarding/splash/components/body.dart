import 'package:coral_reef/onboarding/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../components/splash_content.dart';
import '../../../components/default_button.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text1":"Track your Wellness",
      "text": "Keep track of your well-being exercise, \nperiod and diet",
      "image": "assets/images/img1.png"
    },
    {
      "text1":"Get Connected",
      "text":
      "Chat anonymously using avatars to \ndiscuss topics that matter and get easily \nconnected to each other",
      "image": "assets/images/img2.png"
    },
    {
      "text1":"Shop",
      "text": "All things you need under one-click",
      "image": "assets/images/img3.png"
    },
    { 
      "text1":"Virtual Consultation",
      "text": "Book appointments with experts",
      "image": "assets/images/img4.png"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(5)),
          child: Column(
           children: <Widget>[
             Expanded(
               flex: 3,
               child: PageView.builder(
                 onPageChanged: (value) {
                   setState(() {
                     currentPage = value;
                   });
                 },
                 itemCount: splashData.length,
                 itemBuilder: (context, index) => SplashContent(
                   image: splashData[index]["image"],
                   text: splashData[index]['text'],
                   text1: splashData[index]['text1'],
                 ),
               ),
             ),
             Expanded(
               flex: 2,
               child: Padding(
                 padding: EdgeInsets.symmetric(
                     horizontal: getProportionateScreenWidth(20)),
                 child: Column(
                   children: <Widget>[
                     Spacer(),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: List.generate(
                         splashData.length,
                         (index) => buildDot(index: index),
                       ),
                     ),
                     Spacer(flex: 3),
                     DefaultButton(
                       text: "Get started",
                       press: () {
                       Navigator.pushNamed(context, SignInScreen.routeName);
                       },
                     ),
                     SizedBox(height: 10,),
                     DefaultButton2(
                       text: "Log in",
                       press: () {
                         Navigator.pushReplacementNamed(context, SignInScreen.routeName);
                       },
                     ),
                     Spacer(),
                   ],
                 ),
               ),
             ),
           ],
            ),
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 10 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
