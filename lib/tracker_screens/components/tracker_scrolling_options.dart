
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:flutter/material.dart';

import '../../size_config.dart';

class TrackerScrollingOptions extends StatefulWidget {
  final Function(String selectedMenu, bool hasWellnessRecord, bool hasDewRecord) onSelectedMenu;

  TrackerScrollingOptions({this.onSelectedMenu});

  @override
  State<StatefulWidget> createState() => _TrackerScrollingOptions();
}

class _TrackerScrollingOptions extends State<TrackerScrollingOptions> {

  String selectedMenu = "Diet tracker";
  StorageSystem ss = new StorageSystem();

  bool isPeriodTracker = false;
  bool isPregnancyTracker = false;
  bool hasWellnessRecord = false; //not used
  bool hasDewRecord = false; //diet, exercise, well-being

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // widget.onSelectedMenu(selectedMenu, hasWellnessRecord);
    //get the goal of the user and dynamically change what the user sees.
    ss.getItem("dashboardGoal").then((value) {
      setState(() {
        //check if period or pregnancy tracker is the goal
        if(value == "period" || value == "pregnancy" || value == "conceive") {
          isPeriodTracker = value == "period";
          isPregnancyTracker = value == "pregnancy" || value == "conceive";
        }

        if(isPregnancyTracker)
          changeMenu("Pregnancy tracker", context);
        else if(isPeriodTracker)
          changeMenu("Period tracker", context);
      });
    });

    //check if user has answered wellness questions. i.e height, weight, etc.
    ss.getItem("wellnessRecord").then((val) {
      String value = val ?? "";
      setState(() {
        hasWellnessRecord = value.isNotEmpty;
      });
    });

    ss.getItem("dewSetup").then((value) {
      String v = value ?? "";
      setState(() {
        hasDewRecord = v.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 65,
      padding: EdgeInsets.symmetric(vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          (isPeriodTracker) ? topScrollElement(context, "Period tracker", selected: selectedMenu == "Period tracker",
              onTap: () {
                changeMenu('Period tracker', context);
              }) : Text(""),
          (isPregnancyTracker) ? topScrollElement(context, "Pregnancy tracker",
              selected: selectedMenu == "Pregnancy tracker", onTap: () {
                changeMenu('Pregnancy tracker', context);
              }) : Text(""),
          topScrollElement(context, "Diet tracker",
              selected: selectedMenu == "Diet tracker", onTap: () {
                changeMenu('Diet tracker', context);
              }),
          topScrollElement(context, "Exercise tracker",
              selected: selectedMenu == "Exercise tracker", onTap: () {
                changeMenu('Exercise tracker', context);
              }),
          topScrollElement(context, "Well-being tracker",
              selected: selectedMenu == "Well-being tracker", onTap: () {
                changeMenu('Well-being tracker', context);
              }),
        ],
      ),
    );
  }

  void changeMenu(String menu, BuildContext context) {
    if (!mounted) return;
    setState(() {
      selectedMenu = menu;
      widget.onSelectedMenu(selectedMenu, hasWellnessRecord, hasDewRecord);
    });
  }

  Widget topScrollElement(BuildContext context, String text,
      {bool selected = false, void Function() onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: selected
            ? Color(MyColors.other3)
            : Color(MyColors.defaultTextInField).withOpacity(0.3),
        borderRadius: BorderRadius.circular(10.0)
      ),
      padding: EdgeInsets.only(right: 20, left: 20, top: 10.0, bottom: 10.0),
      margin: EdgeInsets.only(right: 15.0),
      child: GestureDetector(
        onTap: onTap ?? () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: selected
                      ? Color(MyColors.primaryColor)
                      : Color(MyColors.titleTextColor)),
            ),
          ],
        ),
      ),
    );
  }
}