
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/shared_screens/pill_icon.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';

class InsightCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InsightCard();
}

class _InsightCard extends State<InsightCard> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, InsightsScreen.routeName);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.purpleAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        width: double.infinity,
        height: 150,
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Insights", textAlign: TextAlign.start, style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: getProportionateScreenWidth(18),
                    color: Color(MyColors.primaryColor)
                ),),
                PillIcon(
                  icon: 'assets/well_being/sleep.svg',
                  size: 20,
                  paddingRight: 0.0,
                )
              ],
            ),
            Container(height: 20.0,),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "5hrs 33min\n",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: getProportionateScreenWidth(18),
                            color: Color(MyColors.titleTextColor)
                        ),
                      ),
                      TextSpan(text: "Average bed time", style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Color(MyColors.titleTextColor)
                      ),)
                    ],
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "12AM - 6AM\n",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: getProportionateScreenWidth(18),
                            color: Color(MyColors.titleTextColor)
                        ),
                      ),
                      TextSpan(text: " Sleep schedule", style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Color(MyColors.titleTextColor)
                      ),),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}