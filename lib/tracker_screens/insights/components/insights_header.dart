
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';

class InsightsHeader extends StatefulWidget {

  final Function(String selectedMenu) onSelectedMenu;
  final String currentSelected;

  InsightsHeader({this.currentSelected = "Sleep", this.onSelectedMenu});

  @override
  State<StatefulWidget> createState() => _InsightsHeader();
}

class _InsightsHeader extends State<InsightsHeader> {

  String selectedMenu = "Sleep";
  StorageSystem ss = new StorageSystem();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedMenu = widget.currentSelected;
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
          topScrollElement(context, "Sleep",
              selected: selectedMenu == "Sleep", onTap: () {
                changeMenu('Sleep', context);
              }),
          topScrollElement(context, "Vitamins",
              selected: selectedMenu == "Vitamins", onTap: () {
                changeMenu('Vitamins', context);
              }),
          topScrollElement(context, "Steps",
              selected: selectedMenu == "Steps", onTap: () {
                changeMenu('Steps', context);
              }),
          topScrollElement(context, "Calories",
              selected: selectedMenu == "Calories", onTap: () {
                changeMenu('Calories', context);
              }),
          topScrollElement(context, "Weight",
              selected: selectedMenu == "Weight", onTap: () {
                changeMenu('Weight', context);
              }),
          topScrollElement(context, "Water",
              selected: selectedMenu == "Water", onTap: () {
                changeMenu('Water', context);
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
    return InkWell(onTap: onTap ?? (){}, child: Container(
      decoration: BoxDecoration(
          color: selected
              ? Color(MyColors.other3)
              : Color(MyColors.defaultTextInField).withOpacity(0.3),
          borderRadius: BorderRadius.circular(10.0)
      ),
      padding: EdgeInsets.only(right: 20, left: 20, top: 10.0, bottom: 10.0),
      margin: EdgeInsets.only(right: 15.0),
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
    ));
  }
}