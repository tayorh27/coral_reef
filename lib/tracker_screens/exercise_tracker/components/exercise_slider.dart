
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class ExerciseSlider extends StatelessWidget {

  ExerciseSlider();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 120.0,
      height: 120.0,
      decoration: BoxDecoration(
          color: Color(MyColors.primaryColor),
          borderRadius: BorderRadius.circular(100.0)
      ),
      child: SleekCircularSlider(
          appearance: CircularSliderAppearance(
              angleRange: 360.0,
              customColors: CustomSliderColors(
                progressBarColors: [
                  Colors.deepPurpleAccent,
                  Color(MyColors.dietSliderTrackColor),
                ],
                trackColor: Color(MyColors.dietSliderBgColor),
                dynamicGradient: true,
              ),
              customWidths: CustomSliderWidths(
                  trackWidth: 8.0
              )
          ),
          initialValue: 6400,
          min: 1,
          max: 10000,
          innerWidget: (double value){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/exercise/foot_white.svg", height: 40.0,),
                Text("", style: Theme.of(context).textTheme.subtitle1.copyWith(
                    color: Colors.white,
                    fontSize: getProportionateScreenWidth(15),
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