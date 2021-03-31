
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:flutter/material.dart';

import '../../size_config.dart';

class GChatScrollingOptions extends StatefulWidget {
  final Function(String selectedMenu) onSelectedMenu;

  GChatScrollingOptions({this.onSelectedMenu});

  @override
  State<StatefulWidget> createState() => _GChatScrollingOptions();
}

class _GChatScrollingOptions extends State<GChatScrollingOptions> {

  String selectedMenu = "G-chat";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
          topScrollElement(context, "G-chat",
              selected: selectedMenu == "G-chat", onTap: () {
                changeMenu('G-chat', context);
              }),
          topScrollElement(context, "Blog post",
              selected: selectedMenu == "Blog post", onTap: () {
                changeMenu('Blog post', context);
              }),
          topScrollElement(context, "Job opportunities",
              selected: selectedMenu == "Job opportunities", onTap: () {
                changeMenu('Job opportunities', context);
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