import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/constants.dart';
import 'package:coral_reef/shared_screens/header_name.dart';
import 'package:coral_reef/tracker_screens/well_being_tracker/components/vitamins_card.dart';
// import 'package:coral_reef/screens/insightscreen/insight.dart';
import 'package:flutter/material.dart';
import 'package:coral_reef/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'components/insight_card.dart';
import 'components/populate_card_titles.dart';


class WellBeingTrackerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WellBeingTrackerScreen();
}

class _WellBeingTrackerScreen extends State<WellBeingTrackerScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                Heading(body: "Select a card to get started.",),
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                PopulateCardTiles(),
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                VitaminCard(),
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                // InsightCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Categories extends StatelessWidget {
  const Categories({
    Key key,
    @required this.category,
    this.press,
    this.color,
  }) : super(key: key);

  final String category;
  final Color color;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(0),right: getProportionateScreenWidth(5)),
      child: GestureDetector(
        onTap: press,
        child: Container(
          width: getProportionateScreenWidth(150),
          height: getProportionateScreenWidth(50),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.1),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(category,
              style: TextStyle(
                color: color,
                fontSize: getProportionateScreenWidth(12),
              ),),
          ),
        ),
      ),
    );
  }
}