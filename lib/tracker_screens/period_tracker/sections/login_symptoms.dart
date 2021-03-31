import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/components/coral_back_button.dart';
import 'package:coral_reef/tracker_screens/period_tracker/components/close_header.dart';
import 'package:coral_reef/tracker_screens/period_tracker/components/symptoms_grid_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import '../../../size_config.dart';

class LoginSymptoms extends StatefulWidget {
  static final routeName = "log-symptoms";

  @override
  State<StatefulWidget> createState() => _LoginSymptoms();
}

class _LoginSymptoms extends State<LoginSymptoms> {
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

  List<String> selectedOptions = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(MyColors.primaryColor),
        child: Icon(Icons.check, color: Colors.white, size: 32.0,),
        onPressed: (){},
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
                CloseHeader(),
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
                            returnSelected: (_selectedOptions) {
                              print(_selectedOptions);
                              selectedOptions = _selectedOptions;
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
                            returnSelected: (_selectedOptions) {
                              print("hello");
                              print(_selectedOptions);
                              selectedOptions = _selectedOptions;
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
                            returnSelected: (_selectedOptions) {
                              print(_selectedOptions);
                              selectedOptions = _selectedOptions;
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
                    Text("Log a symptom or make a note",
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: Colors.grey,
                            fontSize: getProportionateScreenWidth(11)))
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
}
