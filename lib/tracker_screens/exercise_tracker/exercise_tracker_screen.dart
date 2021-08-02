import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/constants.dart';
import 'package:coral_reef/shared_screens/header_name.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/components/challenge_card.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/components/insight_card.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/components/populate_exercise_summary.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/view_models/step_view_model.dart';
// import 'package:coral_reef/screens/insightscreen/insight.dart';
import 'package:flutter/material.dart';
import 'package:coral_reef/size_config.dart';
import 'package:stacked/stacked.dart';

// import '../../screens/sleepscreen/sleep.dart';
// import '../../screens/moodscreen/moodscreen.dart';
// import '../../screens/vitaminscreen/vitamin.dart';

class ExerciseTrackerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ExerciseTrackerScreen();
}

class _ExerciseTrackerScreen extends State<ExerciseTrackerScreen> {
  /*
  ViewModelBuilder<StepViewModel>.reactive(
        viewModelBuilder: () => StepViewModel(),
        onModelReady: (viewModel) {
          viewModel.currentStep();
        },
        builder: (context, model, child) =>
   * */
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(10)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: SizeConfig.screenHeight * 0.02),
                        Heading(
                          body: "Select a card to get started.",
                        ),
                        SizedBox(height: SizeConfig.screenHeight * 0.02),
                        PopulateExerciseSummary(),
                        SizedBox(height: SizeConfig.screenHeight * 0.02),
                        ChallengeCard(),
                        SizedBox(height: SizeConfig.screenHeight * 0.02),
                        ExerciseInsightCard(),
                        SizedBox(height: SizeConfig.screenHeight * 0.05),
                      ],
                    ),
                  ),
                ),
              ),
            );
  }
}

class Categories extends StatelessWidget {
  const Categories({
    Key key,
    @required this.category,
    this.press,
    this.color,
  }) : super(key: key);

  final String category;
  final Color color;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: getProportionateScreenWidth(0),
          right: getProportionateScreenWidth(5)),
      child: GestureDetector(
        onTap: press,
        child: Container(
          width: getProportionateScreenWidth(150),
          height: getProportionateScreenWidth(50),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.1),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              category,
              style: TextStyle(
                color: color,
                fontSize: getProportionateScreenWidth(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
