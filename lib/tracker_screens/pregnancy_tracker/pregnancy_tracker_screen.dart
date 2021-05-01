import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/shared_screens/header_name.dart';
import 'package:coral_reef/tracker_screens/pregnancy_tracker/sections/your_baby.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../size_config.dart';
import 'components/list_card.dart';
import 'sections/tips.dart';
import 'sections/your_body.dart';

class PregnancyTrackerScreen extends StatefulWidget {
  static final routeName = "period-tracker-screen";

  @override
  State<StatefulWidget> createState() => _PregnancyTrackerScreen();
}

class _PregnancyTrackerScreen extends State<PregnancyTrackerScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
        EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: SizeConfig.screenHeight * 0.03),
            Heading(body: "Select a card to get started.",),
            SizedBox(height: SizeConfig.screenHeight * 0.03),
            Row(
              children: [
                SpecialOfferCard(
                  image: "assets/images/pland1.png",
                  title: "Week of \n Pregnancy",
                  title2: '17th Weeks',
                  press: () {
                    Navigator.pushNamed(context, TipsScreen.routeName);
                  },
                ),
                SpecialOfferCard(
                  image: "assets/images/pland2.png",
                  title: "Due Date of \n Birth",
                  title2: 'Feb 23, 2021',
                  press: () {},
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, YourBody.routeName);
              },
              child: PregListCard(
                title: "Your Body",
                title2: "Learn about your body",
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              thickness: 2,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, YourBaby.routeName);
                },
                child: PregListCard(
                  title: "Your Baby",
                  title2: "Learn about your baby",
                )),
            SizedBox(
              height: 10,
            ),
            Divider(
              thickness: 2,
            ),
            GestureDetector(
              onTap: () {},
              child: PregListCard(
                title: "Tips",
                title2: "Get helpful tips",
              ),
            ),
            Divider(
              thickness: 2,
            ),
          ],
        ));
  }

  Widget _Heading() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Hi ",
              style: Theme.of(context).textTheme.headline1.copyWith(
                  color: Color(MyColors.titleTextColor),
                  fontSize: getProportionateScreenWidth(19)),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Good morning, select a card to get started.",
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: Color(MyColors.titleTextColor),
                  fontSize: getProportionateScreenWidth(13)),
            ),
          ],
        ),
      ],
    );
  }
}



class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key key,
    @required this.title,
    @required this.image,
    @required this.title2,
    @required this.press,
  }) : super(key: key);

  final String title, image, title2;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: Duration(seconds: 7),
        curve: Curves.easeInSine,
        // width: (MediaQuery.of(context).size.width / 2) - 30.0,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: GestureDetector(
            onTap: press,
            child: SizedBox(
              width: getProportionateScreenWidth(145),
              // height: getProportionateScreenWidth(250),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Image.asset(
                      image,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(10.0),
                        vertical: getProportionateScreenWidth(25),
                      ),
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(color: Colors.white),
                          children: [
                            TextSpan(
                              text: "$title\n",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  .copyWith(
                                  color: Colors.white,
                                  fontSize:
                                  getProportionateScreenWidth(14)),
                            ),
                            TextSpan(
                                text: "$title2",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                    getProportionateScreenWidth(17)))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}