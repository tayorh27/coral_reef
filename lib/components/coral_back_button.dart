import 'package:flutter/material.dart';

import '../size_config.dart';

class CoralBackButton extends StatelessWidget {
  const CoralBackButton({
    Key key,
    this.icon,
    this.onPress
  }) : super(key: key);

  final Icon icon;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (onPress == null) ? () {Navigator.of(context).pop();} : onPress,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            //margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(5)),
            //padding: EdgeInsets.all(getProportionateScreenWidth(0)),
            height: getProportionateScreenHeight(20),
            width: getProportionateScreenWidth(20),
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: (icon == null) ? Image.asset('assets/images/backbutton.png') : icon,
          ),
        ],
      ),
    );
  }
}