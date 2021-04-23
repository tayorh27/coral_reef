
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/shared_screens/pill_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../size_config.dart';

class WaterCard extends StatelessWidget {
  const WaterCard({
    Key key,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, VitaminScreen.routeName);
      },
      child: Container(
          decoration: BoxDecoration(
            color: Color(MyColors.other2),
            borderRadius: BorderRadius.circular(10),
          ),
          width: double.infinity,
          padding: EdgeInsets.all(20.0),
          height: 130,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Water", textAlign: TextAlign.start, style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: getProportionateScreenWidth(18),
                      color: Colors.white
                  ),),
                  Container(height: 20.0,),
                  Row(
                    children: [
                      PillIcon(
                        icon: 'assets/well_being/Subtract.svg',
                        size: 25,
                        svgColor: Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: Container(
                          height: getProportionateScreenWidth(30),
                          width: getProportionateScreenWidth(30),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset("assets/diet/glass.svg",),
                        ),
                      ),
                      PillIcon(
                        icon: 'assets/well_being/add.svg',
                        size: 25,
                        svgColor: Colors.white,
                      ),
                    ],)
                ],
              ),
              Column(
                children: [
                  SizedBox(height: 20.0,),
                  Text('7/10',
                    style: Theme.of(context).textTheme.headline2.copyWith(
                      color: Colors.white,
                      fontSize: getProportionateScreenWidth(18),
                    ),),
                ],
              )
            ],
          )
      ),
    );
  }
}