
import 'package:coral_reef/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BorderFilledCard extends StatelessWidget {

  final Color fillColor;
  final String title;
  final String subtitle;
  final Icon icon;
  final Color borderColor;
  final Color textColor;
  final String textNearIcon;
  BorderFilledCard({this.fillColor, this.title, this.subtitle, this.icon, this.borderColor, this.textColor, this.textNearIcon});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        height: 170.0,
        width: getProportionateScreenWidth(150),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.0),
            color: fillColor,
          border: Border.all(color: borderColor)
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 100.0,
                    child: Text(title, style: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: textColor, height: 1.1,
                      fontSize: getProportionateScreenWidth(15),
                    )),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Icon(Icons.info_outline_rounded,color: textColor, size: 10.0,),
                  )
                ],
              ),
              SizedBox(height: 15.0,),
              Text(subtitle, style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: textColor,
                  fontSize: getProportionateScreenWidth(18),
                  fontWeight: FontWeight.bold
              )),
              SizedBox(height: 10.0,),
              Row(
                children: [
                  icon,
                  Container(
                    margin: EdgeInsets.only(top: 1.0, left: 5.0),
                    child: Text(textNearIcon, style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: textColor,
                        fontSize: getProportionateScreenWidth(10)
                    )),
                  )
                ],
              )
            ],
          ),
        )
    );
  }
}