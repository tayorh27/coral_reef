import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/size_config.dart';
import 'package:flutter/material.dart';

class TaskCompletedScreen extends StatelessWidget {
  final String text;
  // final bool showButton;

  TaskCompletedScreen(this.text);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                      padding:
                      EdgeInsets.only(top: mediaQueryData.padding.top + 150.0)),
                  Container(
                    width: 300.0,
                    height: 300.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(MyColors.primaryColor), width: 30.0,),
                      borderRadius: BorderRadius.circular(150.0),
                    ),
                    child: Center(
                      child: Text(
                        "100%",
                        style: Theme.of(context).textTheme.headline2.copyWith(
                          color: Color(MyColors.titleTextColor),
                          fontSize: getProportionateScreenWidth(36),
                          letterSpacing: 2.1,
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 25.0)),
                  Text(
                    text,
                    style: Theme.of(context).textTheme.headline2.copyWith(
                      color: Color(MyColors.titleTextColor),
                      fontSize: getProportionateScreenWidth(25),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
