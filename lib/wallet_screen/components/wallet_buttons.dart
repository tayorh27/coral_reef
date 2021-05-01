import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../size_config.dart';

class WalletButton extends StatelessWidget {
  const WalletButton({
    Key key,
    this.text,
    this.press, this.icon,
  }) : super(key: key);
  final String text;
  final Function press;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          // border: Border.all(
          //   color: Colors.white,
          //   width: 0.5,
          // ),
          borderRadius: BorderRadius.circular(30),
        ),
        width: getProportionateScreenWidth(120),
        height: getProportionateScreenHeight(45),
        child: FlatButton.icon(
          onPressed: press,
          icon: SvgPicture.asset(icon),
          label: Text(
            text,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(12),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}