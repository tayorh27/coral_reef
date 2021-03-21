import 'package:coral_reef/Utils/colors.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Color(MyColors.primaryColor),
        onPressed: press,
        child: Text(text,
            style: Theme.of(context).textTheme.headline2.copyWith(
                  fontSize: getProportionateScreenWidth(18),
                  color: Colors.white,
                )),
      ),
    );
  }
}

class DefaultButton2 extends StatelessWidget {
  const DefaultButton2({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 0.6,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: FlatButton(
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        //color: kPrimaryColor,
        onPressed: press,
        child: Text(text,
            style: Theme.of(context).textTheme.headline2.copyWith(
                  fontSize: getProportionateScreenWidth(18),
                  color: Theme.of(context).primaryColor,
                )),
      ),
    );
  }
}

class Button extends StatelessWidget {
  const Button({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getProportionateScreenWidth(100),
      height: getProportionateScreenHeight(50),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Color(MyColors.primaryColor),
        onPressed: press,
        child: Text(text,
            style: Theme.of(context).textTheme.headline2.copyWith(
                  fontSize: getProportionateScreenWidth(18),
                  color: Colors.white,
                )),
      ),
    );
  }
}

class Button2 extends StatelessWidget {
  const Button2({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getProportionateScreenWidth(100),
      height: getProportionateScreenHeight(50),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: kPrimaryColor.withOpacity(0.2),
        onPressed: press,
        child: Text(text,
            style: Theme.of(context).textTheme.headline2.copyWith(
                  fontSize: getProportionateScreenWidth(18),
                  color: Theme.of(context).primaryColor,
                )),
      ),
    );
  }
}
