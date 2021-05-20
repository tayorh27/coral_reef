
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';

class GoalScrollingOptions extends StatefulWidget {
  final Function(String selectedMenu, bool hasWellnessRecord, bool hasDewRecord) onSelectedMenu;

  GoalScrollingOptions({this.onSelectedMenu});

  @override
  State<StatefulWidget> createState() => _GoalScrollingOptions();
}

class _GoalScrollingOptions extends State<GoalScrollingOptions> {

  String selectedMenu = "";
  StorageSystem ss = new StorageSystem();

  bool hasWellnessRecord = false; //not used
  bool hasDewRecord = false; //diet, exercise, well-being

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // widget.onSelectedMenu(selectedMenu, hasWellnessRecord);
    //get the goal of the user and dynamically change what the user sees.
    ss.getItem("dashboardGoal").then((value) {
      if(value == null) return;
      changeMenu("Track $value", value, context);
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
      margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(0)),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          topScrollElement(context, "Track period", selected: selectedMenu == "Track period",
              onTap: () {
                changeMenu('Track period', "period", context);
              }),
          topScrollElement(context, "Track pregnancy",
              selected: selectedMenu == "Track pregnancy", onTap: () {
                changeMenu('Track pregnancy', "pregnancy", context);
              }),
          topScrollElement(context, "Track diet",
              selected: selectedMenu == "Track diet", onTap: () {
                changeMenu('Track diet', "diet", context);
              }),
          topScrollElement(context, "Track exercise",
              selected: selectedMenu == "Track exercise", onTap: () {
                changeMenu('Track exercise', "exercise", context);
              }),
          topScrollElement(context, "Track well-being",
              selected: selectedMenu == "Track well-being", onTap: () {
                changeMenu('Track well-being', "well-being", context);
              }),
        ],
      ),
    );
  }

  void changeMenu(String menu, String dashboardGoal, BuildContext context) async {
    if (!mounted) return;
    setState(() {
      selectedMenu = menu;
      // widget.onSelectedMenu(selectedMenu, hasWellnessRecord, hasDewRecord);
    });
    await ss.setPrefItem("dashboardGoal", dashboardGoal);
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