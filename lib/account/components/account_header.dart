
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/components/coral_back_button.dart';
import 'package:flutter/material.dart';

import '../../size_config.dart';

class AccountHeader extends StatelessWidget {

  final String _title;
  AccountHeader(this._title);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(_title,
          style: Theme.of(context).textTheme.headline2.copyWith(
            color: Color(MyColors.titleTextColor),
            fontSize: getProportionateScreenWidth(18),
          )),
      centerTitle: true,
      toolbarHeight: 100.0,
      leading: Container(
        margin: EdgeInsets.only(left: 20.0),
        child: CoralBackButton(
          icon: Icon(
            Icons.clear,
            size: 32.0,
            color: Color(MyColors.titleTextColor),
          ),
        ),
      )
    );
  }
}