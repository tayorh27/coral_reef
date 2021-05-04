
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/size_config.dart';
import 'package:flutter/material.dart';



class ExerciseScrollingOptions extends StatefulWidget {
  final Function(String selectedMenu) onSelectedMenu;

  ExerciseScrollingOptions({this.onSelectedMenu});

  @override
  State<StatefulWidget> createState() => _TrackerScrollingOptions();
}

class _TrackerScrollingOptions extends State<ExerciseScrollingOptions> {

  String selectedMenu = "Steps";
  StorageSystem ss = new StorageSystem();

  bool isStep = false;
  bool isCalories = false;
  bool isWeight = false; //not used
  bool isSleep = false; //diet, exercise, well-being

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // widget.onSelectedMenu(selectedMenu, hasWellnessRecord);
    //get the goal of the user and dynamically change what the user sees.

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
         topScrollElement(context, "Steps", selected: selectedMenu == "Steps",
              onTap: () {
                changeMenu('Steps', context);
              }),
      topScrollElement(context, "Calories",
              selected: selectedMenu == "Calories", onTap: () {
                changeMenu('Calories', context);
              }),
          topScrollElement(context, "Weight",
              selected: selectedMenu == "isWeight", onTap: () {
                changeMenu('isWeight', context);
              }),
          topScrollElement(context, "Sleep",
              selected: selectedMenu == "Sleep", onTap: () {
                changeMenu('Sleep', context);
              }),
        ],
      ),
    );
  }

  void changeMenu(String menu, BuildContext context) {
    if (!mounted) return;
    setState(() {
      selectedMenu = menu;
      widget.onSelectedMenu(selectedMenu);
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