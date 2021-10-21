
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class MealNutritionSlider extends StatefulWidget {

  final double sliderValue;
  final double height;
  final String icon;
  final String percentValue;
  final String title;
  final Color trackColor;
  final Color progressColor;

  MealNutritionSlider(this.sliderValue, {this.trackColor, this. progressColor, this.icon = "assets/diet/kcal.svg", this.percentValue = "100%", this.title, this.height = 20.0});

  @override
  State<StatefulWidget> createState() => _MealNutritionSlider();
}

class _MealNutritionSlider extends State<MealNutritionSlider> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Container(
          width: 80.0,
          height: 80.0,
          margin: EdgeInsets.only(top: 5.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0)
          ),
          child: SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                    interval: 10,
                    startAngle: 0,
                    endAngle: 360,
                    showTicks: false,
                    showLabels: false,
                    axisLineStyle: AxisLineStyle(thickness: 8, color: widget.trackColor),
                    pointers: <GaugePointer>[
                      RangePointer(
                          value: widget.sliderValue > 100 ? 100 : widget.sliderValue,
                          width: 10,
                          color: widget.progressColor,
                          enableAnimation: true,
                          cornerStyle: CornerStyle.bothCurve)
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                          widget: Container(
                            width: 80.0,
                            height: 80.0,
                            child:  Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // (widget.height == 40.0) ? SizedBox(height: 20,) : SizedBox(),
                                // SvgPicture.asset(widget.icon, height: widget.height),
                                Text(widget.percentValue, style: Theme.of(context).textTheme.subtitle1.copyWith(
                                    color: Color(MyColors.titleTextColor),
                                    fontSize: getProportionateScreenWidth(14),
                                    fontWeight: FontWeight.bold
                                )),
                              ],
                            ),
                          ),
                          angle: 270,
                          positionFactor: 0.1)
                    ])
              ]),
        ),
        Text(widget.title, style: Theme.of(context).textTheme.subtitle1.copyWith(
            color: Color(MyColors.titleTextColor),
            fontSize: getProportionateScreenWidth(14),
        )),
      ],
    );
  }
}

/*
SleekCircularSlider(
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
          initialValue: 5,
          min: 1,
          max: 5000,
          innerWidget: (double value){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/diet/kcal.svg", height: 20.0,),
                Text("kcal", style: Theme.of(context).textTheme.subtitle1.copyWith(
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
* */