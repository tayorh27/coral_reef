
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/size_config.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/view_models/step_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:stacked/stacked.dart';

import '../../../locator.dart';
import '../../../services/step_service.dart';

class ExerciseSlider extends StatelessWidget {

  ExerciseSlider();
  final StepService _stepService = locator<StepService>();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ViewModelBuilder<StepViewModel>.reactive(
    viewModelBuilder: () => StepViewModel(),
    onModelReady: (viewModel) {
    viewModel.currentStep();
    },
    builder: (context, model, child) {
      model.currentStep();
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
            initialValue: _stepService.steps != null?  double.parse(
                _stepService.steps.toString()):4,
            min: 0,
            max:model.stepsGoal != null ?model.stepsGoal:10,
            innerWidget: (double value) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/exercise/foot_white.svg", height: 40.0,),
                  Text("", style: Theme
                      .of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(
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
    );
  }
}