import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/coral_back_button.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/models/step_goal_model.dart';
import 'package:coral_reef/shared_screens/pill_icon.dart';
import 'package:coral_reef/size_config.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/services/exercise_service.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/view_models/step_view_model.dart';
import 'package:coral_reef/tracker_screens/well_being_tracker/components/diet_header.dart';
import 'package:direct_select/direct_select.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Steps extends StatefulWidget {
  static final routeName = "stepsGoal";
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Steps> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  String stepsGoal = "0", currentTakenSteps = "0";

  ExerciseService exerciseService;

  StorageSystem ss = new StorageSystem();

  @override
  void initState() {
    super.initState();
    getStepsLocalData();
  }

  getStepsLocalData() async {
    final date = DateTime.now();
    final months = ["JAN", "FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];

    String formatDate = "${date.year}_${months[date.month - 1]}_${date.day}";

    String goal = await ss.getItem("stepsGoal") ?? "0";
    String current = await ss.getItem("stepsCurrent_$formatDate") ?? "0";

    setState(() {
      stepsGoal = goal;
      currentTakenSteps = current;
    });
  }

  double getPointerValue() {
    return ((int.parse(currentTakenSteps) / int.parse(stepsGoal)) * 100);
  }

  // _showGoalDialog(StepViewModel model) {
  //   showDialog(
  //       context: context,
  //       barrierDismissible: true,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Column(
  //             children: [
  //               Text(
  //                 "Set daily step goal",
  //                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200),
  //               ),
  //               SizedBox(
  //                 height: 20,
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text(
  //                     "Date",
  //                     style: TextStyle(fontSize: 12),
  //                   ),
  //                   Text(
  //                     model.outputFormat.format(DateTime.now()).toString(),
  //                     style: TextStyle(
  //                         fontSize: 12,
  //                         color: Color(MyColors.primaryColor).withOpacity(0.8)),
  //                   ),
  //                 ],
  //               )
  //             ],
  //           ),
  //           content: Container(
  //             height: 150,
  //             child: Column(
  //               children: [
  //                 DirectSelect(
  //                     itemExtent: 35.0,
  //                     // selectedColor: Color(MyColors.primaryColor).withOpacity(0.1),
  //                     selectedIndex: model.selectedIndex,
  //                     child: MySelectionItem(
  //                       isForList: false,
  //                       title: model.stepsGoal.floor().toString(),
  //                     ),
  //                     onSelectedItemChanged: (index) {
  //                       setState(() {
  //                         model.selectedIndex = index;
  //                         Navigator.pop(context);
  //                         Navigator.pop(context);
  //                         model.stepsGoal =
  //                             double.parse(model.elements[model.selectedIndex]);
  //                         print(model.selectedIndex);
  //                         _showGoalDialog(model);
  //                       });
  //                     },
  //                     mode: DirectSelectMode.tap,
  //                     items: model.buildItems1()),
  //                 SizedBox(
  //                   height: 40,
  //                 ),
  //                 Container(
  //                     height: 40,
  //                     child: DefaultButton(
  //                       text: 'Save',
  //                       press: () {
  //                         model.setStepGoal(
  //                             StepGoalModel(
  //                                 stepGoal: model.stepsGoal.floor().toString()),
  //                             model.stepsGoal.floor().toString());
  //                         Navigator.pop(context);
  //                       },
  //                     ))
  //               ],
  //             ),
  //           ),
  //           shape: RoundedRectangleBorder(
  //               borderRadius: new BorderRadius.circular(15)),
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StepViewModel>.reactive(
        viewModelBuilder: () => StepViewModel(),
        onModelReady: (viewModel) {
          viewModel.currentStep();
        },
        builder: (context, model, child) {
          if(mounted) {
            model.currentStep();
          }
          model.currentStep();
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: DietHeader("Steps").appBar(context),
              body: SafeArea(
               child: SingleChildScrollView(
                 child: Padding(
                   padding: EdgeInsets.all(30.0),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Container(
                           padding: EdgeInsets.all(20),
                           child: Column(
                               crossAxisAlignment: CrossAxisAlignment.center,
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Text(
                                       'Goal',
                                       style:
                                       Theme
                                           .of(context)
                                           .textTheme
                                           .bodyText1
                                           .copyWith(
                                         fontSize: getProportionateScreenWidth(18),
                                       ),
                                     ),
                                     SizedBox(
                                       height: 10,
                                     ),
                                     Text(stepsGoal,
                                         style: Theme
                                             .of(context)
                                             .textTheme
                                             .subtitle1
                                             .copyWith(
                                             color: Color(MyColors.primaryColor),
                                             fontSize: getProportionateScreenWidth(25),
                                             fontWeight: FontWeight.bold)),
                                     Padding(
                                       padding: EdgeInsets.all(20.0),
                                       child:  SfRadialGauge(
                                           axes: <RadialAxis>[
                                             RadialAxis(
                                                 interval: 10,
                                                 startAngle: 0,
                                                 endAngle: 360,
                                                 showTicks: false,
                                                 showLabels: false,
                                                 axisLineStyle: AxisLineStyle(thickness: 30, color: Color(MyColors.stroke2Color).withOpacity(0.2)),
                                                 pointers: <GaugePointer>[
                                                   RangePointer(
                                                       value: getPointerValue() > 100 ? 100 : getPointerValue(),
                                                       width: 30,
                                                       color: Color(MyColors.stroke2Color),
                                                       enableAnimation: true,
                                                       cornerStyle: CornerStyle.bothCurve)
                                                 ],
                                                 annotations: <GaugeAnnotation>[
                                                   GaugeAnnotation(
                                                       widget: Container(
                                                         width: 200.0,
                                                         height: 200.0,
                                                         child:  Column(
                                                           crossAxisAlignment:
                                                           CrossAxisAlignment.center,
                                                           mainAxisAlignment: MainAxisAlignment
                                                               .center,
                                                           children: [
                                                             SvgPicture.asset(
                                                               "assets/exercise/purple_foot.svg",
                                                               height: 40.0,
                                                             ),
                                                             SizedBox(
                                                               height: 10,
                                                             ),
                                                             Text(currentTakenSteps,
                                                                 style: Theme
                                                                     .of(context)
                                                                     .textTheme
                                                                     .subtitle1
                                                                     .copyWith(
                                                                     color: Colors.black,
                                                                     fontSize:
                                                                     getProportionateScreenWidth(
                                                                         20),
                                                                     fontWeight: FontWeight.bold)),
                                                             SizedBox(
                                                               height: 10,
                                                             ),
                                                             Text("Steps",
                                                                 style: Theme
                                                                     .of(context)
                                                                     .textTheme
                                                                     .subtitle1
                                                                     .copyWith(
                                                                     color: Colors.black,
                                                                     fontSize:
                                                                     getProportionateScreenWidth(
                                                                         15),
                                                                     fontWeight: FontWeight.bold)),
                                                           ],
                                                         )
                                                       ),
                                                       angle: 270,
                                                       positionFactor: 0.1)
                                                 ])
                                           ]),
                                     ),
                                     Container(
                                         padding: EdgeInsets.all(0),
                                         child: Row(
                                           mainAxisAlignment:
                                           MainAxisAlignment.spaceBetween,
                                           children: [
                                             Column(
                                               children: [
                                                 SvgPicture.asset(
                                                   "assets/exercise/fire.svg",
                                                   height: 40.0,
                                                 ),
                                                 Text(
                                                     (double.parse(currentTakenSteps) / 63.4)
                                                         .floor()
                                                         .toString() +
                                                         "kcal",
                                                     style: Theme
                                                         .of(context)
                                                         .textTheme
                                                         .subtitle1
                                                         .copyWith(
                                                       color: Color(MyColors.titleTextColor),
                                                       fontSize:
                                                       getProportionateScreenWidth(
                                                           15),
                                                     )),
                                               ],
                                             ),
                                             Column(children: [
                                               SvgPicture.asset(
                                                 "assets/exercise/location.svg",
                                                 height: 40.0,
                                               ),
                                               Text(
                                                   (double.parse(currentTakenSteps) * 0.000762)
                                                       .roundToDouble()
                                                       .toString() +
                                                       'km',
                                                   style: Theme
                                                       .of(context)
                                                       .textTheme
                                                       .subtitle1
                                                       .copyWith(
                                                     color: Color(MyColors.titleTextColor),
                                                     fontSize:
                                                     getProportionateScreenWidth(
                                                         15),
                                                   )),
                                             ]),
                                             Column(children: [
                                               SvgPicture.asset(
                                                 "assets/exercise/time.svg",
                                                 height: 40.0,
                                               ),
                                               Text(
                                                   (double.parse(currentTakenSteps) / 100)
                                                       .round()
                                                       .toString() +
                                                       "Min",
                                                   style: Theme
                                                       .of(context)
                                                       .textTheme
                                                       .subtitle1
                                                       .copyWith(
                                                     color: Color(MyColors.titleTextColor),
                                                     fontSize:
                                                     getProportionateScreenWidth(
                                                         15),
                                                   )),
                                             ]),
                                           ],
                                         )),
                                     SizedBox(
                                       height: 50,
                                     ),
                                     DefaultButton(
                                       text: 'Set daily goal',
                                       press: displayDialog,
                                     )
                                   ],
                                 )
                               ]))
                     ],
                   ),
                 ),
               ),
              )
          );
        }
    );
  }

  Future<bool> displayDialog() {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialogPage(
              title: "Set daily step goal",
              initialValue: stepsGoal,
              onOptionSelected: (val) {
                if (!mounted) return;
                setState(() {
                  stepsGoal = val;
                });
              });
        });
  }
}

class AlertDialogPage extends StatefulWidget {
  const AlertDialogPage(
      {Key key, this.onOptionSelected, this.title, this.initialValue = ""})
      : super(key: key);

  final Function(String value) onOptionSelected;
  final String title;
  final String initialValue;

  @override
  _AlertDialogPageState createState() => _AlertDialogPageState();
}

class _AlertDialogPageState extends State<AlertDialogPage> {

  TextEditingController _textEditingController;
  ExerciseService exerciseService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String init = (widget.initialValue == "0") ? "" : widget.initialValue;
    _textEditingController = new TextEditingController(text: init);
    exerciseService = new ExerciseService();
  }

  rewriteTimeValue(int value) {
    return value < 10 ? "0$value" : "$value";
  }

  getCurrentDateTime() {
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    DateTime date = DateTime.now();
    return "${rewriteTimeValue(date.day)} ${months[date.month - 1]} ${date.year}, ${rewriteTimeValue(date.hour)}:${rewriteTimeValue(date.minute)}";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          Text(widget.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: Color(MyColors.titleTextColor),
                  fontSize: getProportionateScreenWidth(18))),
          Divider()
          // (widget.description.isEmpty) ? SizedBox() : Text(
          //     widget.description,
          //     textAlign: TextAlign.center,
          //     style: Theme.of(context).textTheme.subtitle1.copyWith(
          //         color: Colors.grey,
          //         fontSize: getProportionateScreenWidth(13)
          //     )
          // ),
        ],
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Container(
        height: 300,
        width: MediaQuery.of(context).size.width - 100.0,
        child: SingleChildScrollView(
          child: Container(
            child: Center(
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      autofocus: true,
                      controller: _textEditingController,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline2.copyWith(
                          fontSize: getProportionateScreenWidth(45),
                          color: Color(MyColors.primaryColor)
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 15,
                          ),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,hintText: "0"
                      ),
                    ),
                  ),
                  // Divider(),
                  // Text(
                  //   "1 glass of water is 250 ml",
                  //   style: Theme.of(context).textTheme.subtitle1.copyWith(
                  //     color: Colors.grey,
                  //     fontSize: getProportionateScreenWidth(12),
                  //   ),
                  // ),
                  Divider(thickness: 2.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Date",
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Color(MyColors.titleTextColor),
                          fontSize: getProportionateScreenWidth(12),
                        ),
                      ),
                      Text(
                        getCurrentDateTime(),
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Color(MyColors.primaryColor),
                          fontSize: getProportionateScreenWidth(12),
                        ),
                      ),
                    ],
                  ),
                  Divider(thickness: 2.0,),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  DefaultButton(
                      text: 'Save',
                      press: () async {
                        if(_textEditingController.text.isEmpty) return;
                        if(!new GeneralUtils().isNumberFormatted(_textEditingController.text)) {
                          new GeneralUtils().showToast(context, "Enter a valid number.");
                          return;
                        }
                        await exerciseService.saveStepsGoal(_textEditingController.text);
                        widget.onOptionSelected(_textEditingController.text);
                        Navigator.of(context).pop(false);
                      }),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text(
                        "Cancel",
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: Color(MyColors.primaryColor),
                            fontSize: getProportionateScreenWidth(16)),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

