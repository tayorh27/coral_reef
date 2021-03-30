
import 'package:coral_reef/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class HorizontalProgressSlider extends StatelessWidget {

  final List<double> sliderProgressBar;
  final double maxValue;

  HorizontalProgressSlider(this.sliderProgressBar, {this.maxValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 100.0,
      child: FlutterSlider(
        values: sliderProgressBar,
        max: (maxValue == null) ? 100 : maxValue,
        min: 0,
        trackBar: FlutterSliderTrackBar(
          inactiveTrackBar: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black12,
            border: Border.all(width: 1, color: Colors.black12),
          ),
          activeTrackBar: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Color(MyColors.primaryColor)),
        ),
        handler: FlutterSliderHandler(
          disabled: true,
          opacity: 0.0,
          decoration: BoxDecoration(),
          child: Material(
            type: MaterialType.transparency,
            color: Colors.orange,
            elevation: 3,
            child: Container(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.adjust,
                  size: 25,
                )),
          ),
        ),
        step: FlutterSliderStep(
            step: 25, // default
            isPercentRange:
            true, // ranges are percents, 0% to 20% and so on... . default is true
            rangeList: [
              FlutterSliderRangeStep(from: 0, to: 100, step: 25),
            ]),
        tooltip: FlutterSliderTooltip(
          disabled: true,
        ),
      ),
    );
  }
}