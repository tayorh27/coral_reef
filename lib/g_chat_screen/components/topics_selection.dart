
import 'package:coral_reef/Utils/colors.dart';
import 'package:flutter/material.dart';

class TopicsSelection extends StatelessWidget {

  final String text;
  final bool selected;
  final void Function() onTap;

  TopicsSelection({this.text, this.selected, this.onTap});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
          color: selected
              ? Color(MyColors.other3)
              : Color(MyColors.defaultTextInField).withOpacity(0.3),
          borderRadius: BorderRadius.circular(15.0)
      ),
      padding: EdgeInsets.only(right: 20, left: 20, top: 10.0, bottom: 10.0),
      margin: EdgeInsets.only(right: 10.0),
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