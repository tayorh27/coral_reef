
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CaloriesSlider extends StatefulWidget {

  final double sliderValue;
  final double height;
  final String icon;
  final String text;

  CaloriesSlider(this.sliderValue, {this.icon = "assets/diet/kcal.svg", this.text = "kcal", this.height = 20.0});

  @override
  State<StatefulWidget> createState() => _CaloriesSlider();
}

class _CaloriesSlider extends State<CaloriesSlider> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 120.0,
      height: 120.0,
      margin: EdgeInsets.only(top: 5.0),
      decoration: BoxDecoration(
          color: Color(MyColors.primaryColor),
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
                axisLineStyle: AxisLineStyle(thickness: 10, color: Color(MyColors.dietSliderBgColor)),
                pointers: <GaugePointer>[
                  RangePointer(
                      value: widget.sliderValue > 100 ? 100 : widget.sliderValue,
                      width: 10,
                      color: Color(MyColors.dietSliderTrackColor),
                      enableAnimation: true,
                      cornerStyle: CornerStyle.bothCurve)
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                      widget: Container(
                        width: 200.0,
                        height: 200.0,
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            (widget.height == 40.0) ? SizedBox(height: 20,) : SizedBox(),
                            SvgPicture.asset(widget.icon, height: widget.height),
                            Text(widget.text, style: Theme.of(context).textTheme.subtitle1.copyWith(
                                color: Colors.white,
                                fontSize: getProportionateScreenWidth(15),
                                fontWeight: FontWeight.bold
                            )),
                          ],
                        ),
                      ),
                      angle: 270,
                      positionFactor: 0.1)
                ])
          ]),
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