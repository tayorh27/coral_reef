
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/components/coral_back_button.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';

class DietHeader {

  final String titleText;
  final bool showAction;
  final Function onPress;
  DietHeader(this.titleText, {this.showAction = false, this.onPress});

  Widget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: Container(
        margin: EdgeInsets.only(left: 30.0),
        child: CoralBackButton(),
      ),
      centerTitle: true,
      toolbarHeight: 80.0, //120
      title: Text(
        titleText,
        style: Theme.of(context).textTheme.headline2.copyWith(
            color: Color(MyColors.titleTextColor),
            fontSize: getProportionateScreenWidth(15)),
      ),
      actions: (showAction) ? [
      Container(
        margin: EdgeInsets.only(right: 30.0),
        child: TextButton(
            child: Text("Reset", style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Color(MyColors.primaryColor),
                fontSize: 14.0
            ),),
            onPressed: onPress
        ),
      )
      ] : [],
    );
  }
}