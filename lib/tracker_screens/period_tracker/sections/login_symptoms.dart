import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/components/coral_back_button.dart';
import 'package:coral_reef/constants.dart';
import 'package:coral_reef/tracker_screens/period_tracker/components/close_header.dart';
import 'package:coral_reef/tracker_screens/period_tracker/components/symptoms_grid_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import '../../../size_config.dart';

class LoginSymptoms extends StatefulWidget {
  static final routeName = "log-symptoms";

  final String logType;
  final String weekData;

  LoginSymptoms({this.logType = "period", this.weekData});

  @override
  State<StatefulWidget> createState() => _LoginSymptoms();
}

class _LoginSymptoms extends State<LoginSymptoms> {

  String cycleDay = "";

  List<String> moodOptions = [
    "Calm",
    "Happy",
    "Energetic",
    "Frisky",
    "Sad",
    "Anxious",
    "Feeling guilty",
    "Confused",
    "Irritated",
    "Self critical"
  ];

  List<String> symptomsOptions = [
    "All good",
    "Cramps",
    "Tender breasts",
    "Headache",
    "Acne",
    "Backache",
    "Nausea",
    "Fatigue",
    "Bloating",
    "Diarrhea"
  ];

  List<String> vaginalDischargeOptions = [
    "No discharge",
    "Spotting",
    "Sticky",
    "Creamy",
    "Eggwhite"
  ];

  List<String> selectedMoods = [];
  List<String> selectedSymptoms = [];
  List<String> selectedDischarge = [];

  TextEditingController _textEditingController = new TextEditingController(text: "");

  // List<String> selectedOptions = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    cycleDay = ModalRoute.of(context).settings.arguments as String ?? "";
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(MyColors.primaryColor),
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 32.0,
        ),
        onPressed: saveSymptoms,
        tooltip: "Save",
      ),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(24)),
            child: SingleChildScrollView(
                child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.05),
                CloseHeader(subtitle: (widget.weekData == null) ? "Cycle day $cycleDay" : "Pregnancy Week ${widget.weekData}"),
                SizedBox(height: SizeConfig.screenHeight * 0.05),
                Row(
                  children: [
                    Text("Mood",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Color(MyColors.titleTextColor),
                            fontSize: getProportionateScreenWidth(15),
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.01),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 0.0,
                  childAspectRatio: 0.7,
                  crossAxisCount: 5,
                  primary: false,
                  children: moodOptions
                      .map((opt) => SymptomsGridOptions(
                            backgroundColor: Color(MyColors.stroke2Color),
                            title: opt,
                            image:
                                "assets/symptoms/${opt.toLowerCase().replaceAll(" ", "-")}.svg",
                            selected:
                                (selectedMoods.contains(opt)) ? true : false,
                            returnSelected: (_selectedOptions) {
                              print(_selectedOptions);
                              if (selectedMoods.contains(opt)) {
                                setState(() {
                                  selectedMoods.remove(opt);
                                });
                              } else {
                                setState(() {
                                  selectedMoods.add(opt);
                                });
                              }
                            },
                          ))
                      .toList(),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.01),
                Row(
                  children: [
                    Text("Symptoms",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Color(MyColors.titleTextColor),
                            fontSize: getProportionateScreenWidth(15),
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.01),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 0.0,
                  childAspectRatio: 0.6,
                  crossAxisCount: 5,
                  primary: false,
                  children: symptomsOptions
                      .map((opt) => SymptomsGridOptions(
                            backgroundColor: Color(MyColors.stroke3Color),
                            title: opt,
                            image:
                                "assets/symptoms/${opt.toLowerCase().replaceAll(" ", "-")}.svg",
                            selected:
                                (selectedSymptoms.contains(opt)) ? true : false,
                            returnSelected: (_selectedOptions) {
                              if (selectedSymptoms.contains(opt)) {
                                setState(() {
                                  selectedSymptoms.remove(opt);
                                });
                              } else {
                                setState(() {
                                  selectedSymptoms.add(opt);
                                });
                              }
                            },
                          ))
                      .toList(),
                ),
                Row(
                  children: [
                    Text("Vaginal Discharge",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Color(MyColors.titleTextColor),
                            fontSize: getProportionateScreenWidth(15),
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.01),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 0.0,
                  childAspectRatio: 0.7,
                  crossAxisCount: 5,
                  primary: false,
                  children: vaginalDischargeOptions
                      .map((opt) => SymptomsGridOptions(
                            backgroundColor: Color(MyColors.stroke1Color),
                            title: opt,
                            image:
                                "assets/symptoms/${opt.toLowerCase().replaceAll(" ", "-")}.svg",
                            selected: (selectedDischarge.contains(opt))
                                ? true
                                : false,
                            returnSelected: (_selectedOptions) {
                              if (selectedDischarge.contains(opt)) {
                                setState(() {
                                  selectedDischarge.remove(opt);
                                });
                              } else {
                                setState(() {
                                  selectedDischarge.add(opt);
                                });
                              }
                            },
                          ))
                      .toList(),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.05),
                Row(
                  children: [
                    Text("Notes",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Color(MyColors.titleTextColor),
                            fontSize: getProportionateScreenWidth(15),
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      height: 80.0,
                      width: MediaQuery.of(context).size.width - 100.0,
                      padding: EdgeInsets.only(top: 10.0),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        controller: _textEditingController,
                        maxLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Log a symptom or make a note",
                            hintStyle: Theme.of(context).textTheme.subtitle1.copyWith(
                                color: Colors.grey
                            ),
                            labelStyle: Theme.of(context).textTheme.subtitle1.copyWith(
                                color: Colors.grey, fontWeight: FontWeight.bold
                            )
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
              ],
            )),
          ),
        ),
      ),
    );
  }

  saveSymptoms() async {
    new GeneralUtils().showToast(context, "Saving Record...");

    final today = DateTime.now();
    String _date = "${today.year}-${today.month}-${today.day}";

    Map<String, dynamic> data = new Map();
    data["moods"] = selectedMoods;
    data["symptoms"] = selectedSymptoms;
    data["discharge"] = selectedDischarge;
    data["note"] = _textEditingController.text;

    if(widget.weekData == null) {
      await FirebaseFirestore.instance.collection("users").doc(user.uid)
          .collection("period-symptoms").doc(_date)
          .set(data);
    }else {
      await FirebaseFirestore.instance.collection("users").doc(user.uid)
          .collection("pregnancy-symptoms").doc("week-${widget.weekData}")
          .set(data);
    }

    new GeneralUtils().showToast(context, "Record saved.");
    Navigator.of(context).pop();
  }
}
