import 'package:flutter/material.dart';
import 'package:coral_reef/size_config.dart';

class Logo extends StatelessWidget {
  const Logo({
    Key key,
    this.icon,
  }) : super(key: key);

  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(5)),
      //padding: EdgeInsets.all(getProportionateScreenWidth(0)),
      height: getProportionateScreenHeight(50),
      width: getProportionateScreenWidth(50),
      decoration: BoxDecoration(
        color: Color(0xFFF5F6F9),
        shape: BoxShape.circle,
      ),
      child: Image.asset('assets/images/logo2.png'),
    );
  }
}

class CheckIcon extends StatelessWidget {
  const CheckIcon({
    Key key,
    this.icon,
  }) : super(key: key);

  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(5)),
      //padding: EdgeInsets.all(getProportionateScreenWidth(0)),
      height: getProportionateScreenHeight(50),
      width: getProportionateScreenWidth(50),
      decoration: BoxDecoration(
        color: Colors.purple,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.check,
        color: Colors.white,
      ),
    );
  }
}

class AlertDialogPage extends StatelessWidget {
  const AlertDialogPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //contentPadding: EdgeInsets.only(left: 20, right: 20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Container(
        height: 250,
        width: 300,
        child: SingleChildScrollView(
          child: Container(
            child: Center(
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: CheckIcon(),
                  ),
                  Text(
                    'You are all set!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(25),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Logo(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
