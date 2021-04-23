
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/shared_screens/pill_icon.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';

class InsightCard extends StatelessWidget {
  const InsightCard({
    Key key,

  }) : super(key: key);

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
        height: 180,
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
                  icon: 'assets/diet/Shape.svg',
                  size: 20,
                  paddingRight: 0.0,
                )
              ],
            ),
            Container(height: 10.0,),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "70",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: getProportionateScreenWidth(18),
                            color: Color(MyColors.primaryColor)
                        ),
                      ),
                      TextSpan(
                        text: "kg\n",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: getProportionateScreenWidth(10),
                            color: Color(MyColors.primaryColor)
                        ),
                      ),
                      TextSpan(text: "Current Weight\n", style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Color(MyColors.titleTextColor)
                      ),),
                      TextSpan(text: "BMI 25.6", style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Colors.grey
                      ),)
                    ],
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "0.0",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: getProportionateScreenWidth(18),
                            color: Color(MyColors.primaryColor)
                        ),
                      ),
                      TextSpan(
                        text: "kg\n",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: getProportionateScreenWidth(10),
                            color: Color(MyColors.primaryColor)
                        ),
                      ),
                      TextSpan(text: "New Weight", style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Color(MyColors.titleTextColor)
                      ),),
                    ],
                  ),textAlign: TextAlign.right,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}