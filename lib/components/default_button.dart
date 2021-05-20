import 'package:coral_reef/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:progress_bars/progress_bars.dart';

import '../constants.dart';
import '../size_config.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key key,
    this.text,
    this.press,
    this.loading = false,
    this.fontSize = 18,
  }) : super(key: key);
  final String text;
  final Function press;
  final bool loading;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Color(MyColors.primaryColor),
        disabledColor: Color(MyColors.primaryColor).withAlpha(100),
        onPressed: (loading) ? null : press,
        child: (loading) ? Center(
          child: Container(
            width: 20.0,
            height: 20,
            margin: EdgeInsets.only(bottom: 20.0, right: 20.0),
            child: CircleProgressBar(
              child: Text(""),
              size: 20.0,
              progressColor: Colors.white,
              backgroundColor: Color(MyColors.primaryColor).withAlpha(100),
            ),
          ),
        ) : Text(text,
            style: Theme.of(context).textTheme.headline2.copyWith(
                  fontSize: getProportionateScreenWidth(fontSize),
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

class SwitchButtons extends StatelessWidget {
  const SwitchButtons({
    Key key,
    this.text,
    this.press,
    this.selected,
    this.mWidth = 100,
    this.mHeight = 50,
    this.textSize = 18,
  }) : super(key: key);
  final String text;
  final Function press;
  final bool selected;
  final double mWidth, mHeight;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getProportionateScreenWidth(mWidth),
      height: getProportionateScreenHeight(mHeight),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: (selected) ? Color(MyColors.primaryColor) : kPrimaryColor.withOpacity(0.2),
        onPressed: press,
        child: Text(text,
            style: Theme.of(context).textTheme.headline2.copyWith(
              fontSize: getProportionateScreenWidth(textSize),
              color: (selected) ? Colors.white : Theme.of(context).primaryColor,
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
