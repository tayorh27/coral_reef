import 'package:flutter/material.dart';

import '../size_config.dart';

class CoralBackButton extends StatelessWidget {
  const CoralBackButton({
    Key key,
    this.icon,
    this.onPress
  }) : super(key: key);

  final Widget icon;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getProportionateScreenHeight(30),
      width: getProportionateScreenWidth(30),
      child: InkWell(
        onTap: (onPress == null) ? () {Navigator.of(context).pop(false);} : onPress,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              //margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(5)),
              //padding: EdgeInsets.all(getProportionateScreenWidth(0)),

              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: (icon == null) ? Icon(Icons.arrow_back_ios) : icon,//Image.asset('assets/images/backbutton.png', width: 22.0, height: 22.0,)
            ),
          ],
        ),
      ),
    );
  }
}