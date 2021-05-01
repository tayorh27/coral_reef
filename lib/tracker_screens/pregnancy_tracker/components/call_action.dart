import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CallToAction extends StatelessWidget {
  final Function onPress;
  CallToAction({this.onPress});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
        onTap: onPress,
        child: Container(
            height: 80.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Color(MyColors.other4)),
            child: Center(
              child: ListTile(
                leading: Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text("Log in symptoms",
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Color(MyColors.primaryColor),
                          fontSize: getProportionateScreenWidth(15),
                          fontWeight: FontWeight.bold)),
                ),
                trailing: TextButton.icon(
                    onPressed: onPress,
                    icon: Icon(
                      Icons.add_circle_outlined,
                      color: Color(MyColors.primaryColor),
                      size: 32.0,
                    ),
                    label: Text("")),
              ),
            )));
  }
}