
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class CircularSlider extends StatelessWidget {

  CircularSlider();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 200.0,
      height: 200.0,
      decoration: BoxDecoration(
          color: Color(MyColors.primaryColor),
          borderRadius: BorderRadius.circular(100.0)
      ),
      child: SleekCircularSlider(
          appearance: CircularSliderAppearance(
            angleRange: 360.0,
            customColors: CustomSliderColors(
              progressBarColors: [
                Color(MyColors.stroke1Color),
                Color(MyColors.stroke2Color),
              ],
              trackColor: Color(MyColors.progressSliderColor),
                dynamicGradient: true,
            ),
            customWidths: CustomSliderWidths(
              trackWidth: 15.0
            )
          ),
          initialValue: 5,
          min: 1,
          max: 31,
          innerWidget: (double value){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Period:", style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: Colors.white,
                  fontSize: getProportionateScreenWidth(12),
                )),
                Text("Day ${value.ceil()}", style: Theme.of(context).textTheme.subtitle1.copyWith(
                    color: Colors.white,
                    fontSize: getProportionateScreenWidth(24),
                    fontWeight: FontWeight.bold
                )),
              ],
            );
          },
          onChange: (double value) {
            print(value);
          }),
    );
  }
}