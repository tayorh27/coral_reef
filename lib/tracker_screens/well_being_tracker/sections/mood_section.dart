import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/ListItem/model_vitamins_data.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/constants.dart';
import 'package:coral_reef/g_chat_screen/components/topics_selection.dart';
import 'package:coral_reef/shared_screens/pill_icon.dart';
import 'package:coral_reef/tracker_screens/well_being_tracker/components/diet_header.dart';
import 'package:coral_reef/tracker_screens/well_being_tracker/services/vitamins_services.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../size_config.dart';

class MoodSection extends StatefulWidget {
  static final routeName = "mood-section";

  @override
  State<StatefulWidget> createState() => _MoodSection();
}

class _MoodSection extends State<MoodSection> {

  bool _loading = false;

  String currentMood = "Happy";

  WellBeingServices vitaminServices;

  StorageSystem ss = new StorageSystem();

  List<String> selectMoods = ["Happy", "Meh", "Sad", "Angry","Tired"];

  double selectIndex = 0.0;

  MoodData md;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vitaminServices = new WellBeingServices();
    getMoodLocalData();
  }

  getMoodLocalData() async {
    final date = DateTime.now();
    final months = ["JAN", "FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];

    String formatDate = "${date.year}_${months[date.month - 1]}_${date.day}";

    String current = await ss.getItem("moodCurrent_$formatDate") ?? "Happy";

    String currentSliderValue = await ss.getItem("moodSliderValue") ?? "0.0";

    setState(() {
      currentMood = current;
      selectIndex = double.parse(currentSliderValue);
    });
  }

  double getPointerValue() {
    // return ((int.parse(currentTakenVitamins) / int.parse(vitaminsGoal)) * 100);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DietHeader("Mood").appBar(context),
      body: SafeArea(
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(30)),
                  child: Container(
                      child: SingleChildScrollView(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(height: SizeConfig.screenHeight * 0.03),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "What is your mood?", textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.headline2.copyWith(
                                        color: Color(MyColors.titleTextColor),
                                        fontSize: getProportionateScreenWidth(15)),
                                  ),
                                ),
                                SizedBox(height: SizeConfig.screenHeight * 0.0),
                                Padding(
                                  padding: EdgeInsets.all(0.0),
                                  child:  SfRadialGauge(
                                      axes: <RadialAxis>[
                                        RadialAxis(
                                            interval: 20,
                                            startAngle: 180,
                                            endAngle: 360,
                                            showTicks: true,
                                            showLabels: false,
                                            canScaleToFit: true,
                                            axisLineStyle: AxisLineStyle(thickness: 30, color: Color(MyColors.stroke1Color)),
                                            pointers: <GaugePointer>[
                                              WidgetPointer(
                                                  child: Container(
                                                    width: 50.0,
                                                    height: 50.0,
                                                    margin: EdgeInsets.only(left: 0.0),
                                                    decoration: BoxDecoration(
                                                      color: Color(MyColors.stroke1Color),
                                                      borderRadius: BorderRadius.circular(25.0),
                                                      border: Border.all(color: Colors.white, width: 3.0)
                                                    ),
                                                    child: Stack(
                                                      children: [
                                                        Positioned(
                                                          left: 10.0,
                                                          top: 10.0,
                                                          child: PillIcon(
                                                            icon: 'assets/well_being/${currentMood.toLowerCase()}.svg',
                                                            size: 20,
                                                            paddingRight: 0,
                                                            svgColor: Colors.white,
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ),
                                                value: selectIndex,enableDragging: true,enableAnimation: true, onValueChanged: (double value) async {
                                                    int v = value.ceil();

                                                    int index = 0;

                                                    if(v >= 0 && v <= 20) {
                                                      index = 0;
                                                    }
                                                    if(v >= 21 && v <= 40) {
                                                      index = 1;
                                                    }
                                                    if(v >= 41 && v <= 60) {
                                                      index = 2;
                                                    }
                                                    if(v >= 61 && v <= 80) {
                                                      index = 3;
                                                    }
                                                    if(v >= 81 && v <= 100) {
                                                      index = 4;
                                                    }
                                                    setState(() {
                                                      currentMood = selectMoods[index];
                                                      selectIndex = value;
                                                    });
                                              },
                                              )
                                            ],
                                            annotations: <GaugeAnnotation>[
                                              GaugeAnnotation(
                                                  widget: Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    height: 200.0,
                                                    child:  Align(
                                                      alignment: Alignment.center,
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.max,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          Container(
                                                            margin: EdgeInsets.only(left: 50.0),
                                                            child: PillIcon(
                                                              icon: 'assets/well_being/${currentMood.toLowerCase()}.svg',
                                                              size: 40,
                                                              svgColor: Color(MyColors.stroke1Color),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.only(left: 20.0),
                                                            child: Text('$currentMood',textAlign: TextAlign.center,
                                                              style: Theme.of(context).textTheme.headline1.copyWith(
                                                                color: Colors.black,
                                                                fontSize: getProportionateScreenWidth(27),
                                                              ),),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ),
                                                  angle: 180,
                                                  positionFactor: 0.25)
                                            ])
                                      ]),
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: TopicsSelection(text: "Previous mood", selected: true, onTap: getPreviousMood,),
                                ),
                                SizedBox(height: SizeConfig.screenHeight * 0.1),
                                DefaultButton(
                                  text: "Save",
                                  loading: _loading,
                                  press: () async {
                                    setState(() {
                                      _loading = true;
                                    });
                                    await ss.setPrefItem("moodSliderValue", "$selectIndex");
                                    await vitaminServices.updateMoodData(currentMood);
                                    setState(() {
                                      _loading = false;
                                    });
                                    new GeneralUtils().showToast(context, "Mood saved successfully.");
                                  },
                                )
                              ])))))),
    );
  }

  getPreviousMood() async {
    if(md != null) {
      displayDialog(md);
      return;
    }
    QuerySnapshot query = await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("moods").orderBy("timestamp", descending: true).limit(1).get();
    if(query.docs.isEmpty) {
      new GeneralUtils().showToast(context, "No previous mood available!");
      return;
    }
    md = MoodData.fromSnapshot(query.docs[0].data());
    displayDialog(md);

  }

  Future<bool> displayDialog(MoodData md) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialogPage(
              title: "Previous mood",
              md: md);
        });
  }
}

class AlertDialogPage extends StatefulWidget {
  const AlertDialogPage(
      {Key key, this.title, this.md})
      : super(key: key);
  final String title;
  final MoodData md;

  @override
  _AlertDialogPageState createState() => _AlertDialogPageState();
}

class _AlertDialogPageState extends State<AlertDialogPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PillIcon(
                          icon: 'assets/well_being/${widget.md.mood_type.toLowerCase()}.svg',
                          size: 60,
                        ),
                        SizedBox(height: SizeConfig.screenHeight * 0.03),
                        Text('${widget.md.mood_type}',textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline1.copyWith(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(27),
                          ),),
                        SizedBox(height: SizeConfig.screenHeight * 0.07),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PillIcon(
                              icon: 'assets/well_being/sleep.svg',
                              size: 20,
                              paddingRight: 0.0,
                            ),
                            SizedBox(width: 20.0,),
                            Text(
                              "${widget.md.week} ${widget.md.day} ${widget.md.month}, ${widget.md.year}",
                              style: Theme.of(context).textTheme.subtitle1.copyWith(
                                color: Color(MyColors.primaryColor),
                                fontSize: getProportionateScreenWidth(12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
