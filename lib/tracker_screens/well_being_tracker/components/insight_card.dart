
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/shared_screens/pill_icon.dart';
import 'package:coral_reef/tracker_screens/insights/dew_insights.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';

class InsightCard extends StatefulWidget {

  final String bedtime, wakeup, sleepingTime;

  InsightCard({this.bedtime, this.wakeup, this.sleepingTime});

  @override
  State<StatefulWidget> createState() => _InsightCard();
}

class _InsightCard extends State<InsightCard> {

  String bedtime = "N/A", wakeup = "N/A", sleepingTime = "N/A";

  StorageSystem ss = new StorageSystem();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.bedtime != null) {
      setState(() {
        bedtime = widget.bedtime;
        wakeup = widget.wakeup;
        sleepingTime = widget.sleepingTime;
      });
      return;
    }
    getSleepLocalData();
  }

  getSleepLocalData() async {

    String current = await ss.getItem("generalSleepCurrent") ?? "";

    if(current.isEmpty) return;

    List<String> list = current.split("/");

    setState(() {
      bedtime = list[0];
      wakeup = list[1];
      sleepingTime = list[2];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, DewInsights.routeName, arguments: "Sleep");
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
                        text: "$sleepingTime\n",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: getProportionateScreenWidth(15),
                            color: Color(MyColors.titleTextColor)
                        ),
                      ),
                      TextSpan(text: "Average bed time", style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Color(MyColors.titleTextColor)
                      ),)
                    ],
                  ),
                  textAlign: TextAlign.start,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "$bedtime - $wakeup\n",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: getProportionateScreenWidth(15),
                            color: Color(MyColors.titleTextColor)
                        ),
                      ),
                      TextSpan(text: " Sleep schedule", style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Color(MyColors.titleTextColor)
                      ),),
                    ],
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}