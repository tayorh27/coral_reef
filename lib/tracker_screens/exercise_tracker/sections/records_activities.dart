import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/ListItem/model_exercise_activity.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/shared_screens/EmptyScreen.dart';
import 'package:coral_reef/size_config.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/map_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../constants.dart';

class RecordsActivities extends StatefulWidget {
  static final routeName = "recordsActivities";
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<RecordsActivities> {
  String selected = 'all';
  String googleAPiKey = "AIzaSyCRrfbYY6rhh2qfMPo-My7y_gUfsl2eP14";

  @override
  void initState() {
    super.initState();
    getAllActivities();
  }

  List<ExerciseActivity> allActivities = [];
  List<ExerciseActivity> myActivities = [];
  int totalActivities = 0;
  double totalKm = 0.0;

  Future<void> getAllActivities() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("my-activities").orderBy("timestamp", descending: true)
        .get();
    if (query.docs.isEmpty) return;

    if (!mounted) return;
    setState(() {
      totalActivities = query.docs.length;
    });
    myActivities.clear();
    allActivities.clear();

    query.docs.forEach((act) {
      Map<String, dynamic> ch = act.data();
      ExerciseActivity ea = ExerciseActivity.fromSnapshot(ch);
      setState(() {
        myActivities.add(ea);
        allActivities.add(ea);
        totalKm += (ea.km_covered == null) ? 0.0 : ea.km_covered;
      });
    });
  }

  filterActivityByType() {
    totalKm = 0.0;
    if(selected == "all") {
      setState(() {
        myActivities = allActivities;
        totalActivities = allActivities.length;
        allActivities.forEach((e) {
          totalKm += e.km_covered;
        });
      });
      return;
    }
    List<ExerciseActivity> filterAct = allActivities.where((act) => act.activity_type == selected.toLowerCase()).toList();
    setState(() {
      myActivities = filterAct;
      totalActivities = filterAct.length;
      filterAct.forEach((e) {
        totalKm += e.km_covered;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios)),
          title: Text(
            "Records",
            style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontSize: getProportionateScreenWidth(15),
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 45.0,
                  child: Align(
                    alignment: Alignment.center,
                    child: ListView(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: selected == 'all'
                                    ? Color(MyColors.other3)
                                    : Color(MyColors.defaultTextInField)
                                    .withOpacity(0.3),
                                borderRadius:
                                BorderRadius.circular(10.0)),
                            padding: EdgeInsets.only(
                                right: 20,
                                left: 20,
                                top: 10.0,
                                bottom: 10.0),
                            margin: EdgeInsets.only(right: 15.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selected = 'all';
                                });
                                filterActivityByType();
                              },
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'All',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                        color: selected == 'all'
                                            ? Color(
                                            MyColors.primaryColor)
                                            : Color(MyColors
                                            .titleTextColor)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: selected == 'walk'
                                    ? Color(MyColors.other3)
                                    : Color(MyColors.defaultTextInField)
                                    .withOpacity(0.3),
                                borderRadius:
                                BorderRadius.circular(10.0)),
                            padding: EdgeInsets.only(
                                right: 20,
                                left: 20,
                                top: 10.0,
                                bottom: 10.0),
                            margin: EdgeInsets.only(right: 15.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selected = 'walk';
                                });
                                filterActivityByType();
                              },
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Walk',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                        color: selected == 'walk'
                                            ? Color(
                                            MyColors.primaryColor)
                                            : Color(MyColors
                                            .titleTextColor)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: selected == 'run'
                                    ? Color(MyColors.other3)
                                    : Color(MyColors.defaultTextInField)
                                    .withOpacity(0.3),
                                borderRadius:
                                BorderRadius.circular(10.0)),
                            padding: EdgeInsets.only(
                                right: 20,
                                left: 20,
                                top: 10.0,
                                bottom: 10.0),
                            margin: EdgeInsets.only(right: 15.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selected = 'run';
                                });
                                filterActivityByType();
                              },
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Run',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                        color: selected == 'run'
                                            ? Color(
                                            MyColors.primaryColor)
                                            : Color(MyColors
                                            .titleTextColor)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: selected == 'ride'
                                    ? Color(MyColors.other3)
                                    : Color(MyColors.defaultTextInField)
                                    .withOpacity(0.3),
                                borderRadius:
                                BorderRadius.circular(10.0)),
                            padding: EdgeInsets.only(
                                right: 20,
                                left: 20,
                                top: 10.0,
                                bottom: 10.0),
                            margin: EdgeInsets.only(right: 15.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selected = 'ride';
                                });
                                filterActivityByType();
                              },
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Ride',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                        color: selected == 'ride'
                                            ? Color(
                                            MyColors.primaryColor)
                                            : Color(MyColors
                                            .titleTextColor)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: selected == 'hike'
                                    ? Color(MyColors.other3)
                                    : Color(MyColors.defaultTextInField)
                                    .withOpacity(0.3),
                                borderRadius:
                                BorderRadius.circular(10.0)),
                            padding: EdgeInsets.only(
                                right: 20,
                                left: 20,
                                top: 10.0,
                                bottom: 10.0),
                            margin: EdgeInsets.only(right: 15.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selected = 'hike';
                                });
                                filterActivityByType();
                              },
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Hike',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                        color: selected == 'hike'
                                            ? Color(
                                            MyColors.primaryColor)
                                            : Color(MyColors
                                            .titleTextColor)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(children: [
                      Text(
                        '$totalActivities',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text('Total Activity', style: Theme
                          .of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(
                        color: Color(MyColors.titleTextColor),
                        fontSize:
                        getProportionateScreenWidth(
                            15),
                      )),
                    ]),
                    Column(children: [
                      Text(
                        '${totalKm.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text('Total Km', style: Theme
                          .of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(
                        color: Color(MyColors.titleTextColor),
                        fontSize:
                        getProportionateScreenWidth(
                            15),
                      )),
                    ]),
                  ],
                ),
                SizedBox(
                  height: 0,
                ),
                if(myActivities.isEmpty)
                  EmptyScreen("No record available yet!")
                else
                  ...buildActivities()
                // (myActivities.isEmpty) ? EmptyScreen("No record available yet!") : buildActivities()
              ]),
            )));
  }

  List<Widget> buildActivities() {
    List<Widget> layout = [];
    List<String> months = ["January", "February", "March", "April", "May", "june", "july", "August", "September", "October", "November", "December"];
    myActivities.forEach((act) {
      // print("=====================ddd${MediaQuery.of(context).size.height / 5}");
      DateTime dt = DateTime.parse(act.created_date);
      //'8 February 2021,10:25 AM'
      String date = "${dt.day} ${months[dt.month - 1]} ${dt.year}, ${dt.hour}:${dt.minute}";
      layout.add(
        InkWell(
          onLongPress: () async {
            final confirm = await new GeneralUtils().displayReturnedValueAlertDialog(context, "Attention", "Are you sure you want to delete this activity?", confirmText: "DELETE");
            if(!confirm) return;
            await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("my-activities").doc(act.id).delete();
            new GeneralUtils().showToast(context, "Activity deleted successfully.");
          },
          child: Row(children: [
            Container(
                height: MediaQuery.of(context).size.height / 5,
                width: MediaQuery.of(context).size.width / 2.7,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      (myActivities.isNotEmpty) ? Image.network(
                        "https://maps.googleapis.com/maps/api/staticmap?center=${act.start_location["latitude"]},${act.start_location["longitude"]}&zoom=15&size=300x200&maptype=roadmap&markers=size:tiny%7Ccolor:green%7C${act.start_location["latitude"]},${act.start_location["longitude"]}&markers=size:tiny%7Ccolor:red%7C${act.end_location["latitude"]},${act.end_location["longitude"]}&key=$googleAPiKey",
                        repeat: ImageRepeat.noRepeat,
                      ) : SizedBox(),
                    ])),
            Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset("assets/exercise/run.svg",
                            height: 13.0),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          date,
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(
                            color: Color(MyColors.titleTextColor),
                            fontSize:
                            getProportionateScreenWidth(
                                12),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${act.km_covered}km',
                      style: Theme
                          .of(context)
                          .textTheme
                          .headline2
                          .copyWith(
                        color: Color(MyColors.titleTextColor),
                        fontSize:
                        getProportionateScreenWidth(
                            20),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${act.time_covered}',
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(
                            color: Color(MyColors.titleTextColor),
                            fontSize:
                            getProportionateScreenWidth(
                                12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ))
          ]),
        )
      );
    });

    layout.add(SizedBox(
      height: 0,
    ),);

    return layout;
  }

  /*
  Row(children: [
                  Container(
                      height: MediaQuery.of(context).size.height / 7,
                      width: MediaQuery.of(context).size.width / 2.3,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                child: Stack(children: <Widget>[
                              mapToggle
                                  ? GoogleMap(
                                      onMapCreated: _onMapCreated,
                                      initialCameraPosition: CameraPosition(
                                        zoom: 10,
                                        target: LatLng(currentLocation.latitude,
                                            currentLocation.longitude),
                                      ),
                                      //markers: _markers,
                                      polylines:
                                          Set<Polyline>.of(polylines.values),
                                    )
                                  : Center(
                                      child: Text(
                                        'Loading...',
                                        style: TextStyle(fontSize: 28),
                                      ),
                                    ),
                            ])),
                          ])),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset("assets/exercise/run.svg",
                                  height: 13.0),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '8 February 2021,10:25 AM',
                                style: TextStyle(
                                    fontWeight: FontWeight.w200, fontSize: 12),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '5.54km',
                            style: TextStyle(
                                fontWeight: FontWeight.w200, fontSize: 20),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '21:12',
                                style: TextStyle(
                                    fontWeight: FontWeight.w200, fontSize: 12),
                              ),
                              Text(
                                '09:12',
                                style: TextStyle(
                                    fontWeight: FontWeight.w200, fontSize: 12),
                              ),
                              Text(
                                '07:59',
                                style: TextStyle(
                                    fontWeight: FontWeight.w200, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ))
                ]),
  * */
}
