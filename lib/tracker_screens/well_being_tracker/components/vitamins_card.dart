
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/shared_screens/pill_icon.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';

class VitaminCard extends StatelessWidget {
  const VitaminCard({
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
            color: Colors.purpleAccent.withOpacity(0.1),
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
                  Text("Vitamins", textAlign: TextAlign.start, style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: getProportionateScreenWidth(18),
                      color: Color(MyColors.primaryColor)
                  ),),
                  Container(height: 20.0,),
                  Row(
                    children: [
                      PillIcon(
                        icon: 'assets/well_being/Subtract.svg',
                        size: 30,
                      ),
                      PillIcon(
                        icon: 'assets/well_being/pill.svg',
                        size: 20,
                      ),
                      PillIcon(
                        icon: 'assets/well_being/add.svg',
                        size: 30,
                      ),
                    ],)
                ],
              ),
              Column(
                children: [
                  SizedBox(height: 20.0,),
                  Text('2/4.0',
                    style: Theme.of(context).textTheme.headline2.copyWith(
                      color: Color(MyColors.primaryColor),
                      fontSize: getProportionateScreenWidth(18),
                    ),),
                  Text('TODAY',
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Color(MyColors.titleTextColor),
                      fontSize: getProportionateScreenWidth(13),
                    ),),
                ],
              )
            ],
          )
      ),
    );
  }
}