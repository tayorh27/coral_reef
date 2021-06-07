
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/components/coral_back_button.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';

class DietHeader {

  final String titleText;
  DietHeader(this.titleText);

  Widget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: Container(
        margin: EdgeInsets.only(left: 30.0),
        child: CoralBackButton(),
      ),
      centerTitle: true,
      toolbarHeight: 120.0,
      title: Text(
        titleText,
        style: Theme.of(context).textTheme.headline2.copyWith(
            color: Color(MyColors.titleTextColor),
            fontSize: getProportionateScreenWidth(15)),
      ),
    );
  }
}