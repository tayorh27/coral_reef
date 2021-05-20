import 'dart:async';

import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/size_config.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/map_utils.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/records_activities.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/save_activities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class TrackActivities extends StatefulWidget {
  static final routeName = "trackActivities";
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<TrackActivities> {
  String selected = 'walk';
  GoogleMapController mapController;
  Geolocator geolocator;
  Position currentLocation;
  BitmapDescriptor sourceIcon;
  bool mapToggle = false;
  bool clientsToggle = false;
  String url;
  BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();
  String actionButton = 'go';
  bool counting = false;
  final interval = const Duration(seconds: 1);

  final int timerMaxSeconds = 6;

  int currentSeconds = 0;

  String get timerText => (timerMaxSeconds - currentSeconds).toString();
  startTimeout([int milliseconds]) {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      setState(() {
        print(timer.tick);
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) {
          timer.cancel();
          counting = false;
        }
      });
    });
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/exercise/my_location.png');
  }

  Future<Position> getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return position;
  }

  @override
  void initState() {
    super.initState();
    setCustomMapPin();
    geolocator = Geolocator();
    getCurrentLocation().then((newLocation) {
      setState(() {
        currentLocation = newLocation;
        mapToggle = true;
      });
    });
  }

  void onMapCreated(GoogleMapController controller) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios)),
              Text(
                'Track activities',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: getProportionateScreenWidth(15),
                    ),
              ),
              Text('')
            ],
          ),
        ),
        body: counting
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Container(
                        height: MediaQuery.of(context).size.height / 1.25,
                        color: Color(MyColors.primaryColor).withOpacity(0.3),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                  child: Text(
                                '$timerText',
                                style: TextStyle(
                                    fontSize: 50,
                                    color: Color(MyColors.primaryColor),
                                    fontWeight: FontWeight.bold),
                              )),
                            ]))
                  ])
            : Container(
                padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(children: [
                    actionButton != 'go'
                        ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                    SizedBox(
                      height: 30,
                    ),
                    actionButton == 'go'
                        ? Container()
                        : Container(
                            decoration: BoxDecoration(
                                color: Color(MyColors.other3),
                                borderRadius: BorderRadius.circular(10.0)),
                            padding: EdgeInsets.only(
                                right: 20, left: 20, top: 10.0, bottom: 10.0),
                            margin: EdgeInsets.only(right: 15.0),
                            child: GestureDetector(
                              onTap: () {},
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    selected.toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                            color:
                                                Color(MyColors.primaryColor)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    Container(
                        height: MediaQuery.of(context).size.height / 2.3,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                  child: Stack(children: <Widget>[
                                mapToggle
                                    ? GoogleMap(
                                        onMapCreated:
                                            (GoogleMapController controller) {
                                          controller
                                              .setMapStyle(Utils.mapStyles);
                                          _controller.complete(controller);
                                          setState(() {
                                            _markers.add(Marker(
                                                markerId: MarkerId('100'),
                                                position: LatLng(
                                                    currentLocation.latitude,
                                                    currentLocation.longitude),
                                                icon: pinLocationIcon));
                                          });
                                        },
                                        initialCameraPosition: CameraPosition(
                                          zoom: 10,
                                          target: LatLng(
                                              currentLocation.latitude,
                                              currentLocation.longitude),
                                        ),
                                        markers: _markers,
                                      )
                                    : Center(
                                        child: Text(
                                          'Loading...',
                                          style: TextStyle(fontSize: 28),
                                        ),
                                      ),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 60,
                                        ),
                                        SvgPicture.asset(
                                          "assets/exercise/white_music.svg",
                                          height: 40.0,
                                        ),
                                        SvgPicture.asset(
                                          "assets/exercise/white_r_location.svg",
                                          height: 40.0,
                                        ),
                                        SvgPicture.asset(
                                          "assets/exercise/white_camera.svg",
                                          height: 40.0,
                                        ),
                                      ],
                                    )),
                              ])),
                            ])),
                    SizedBox(
                      height: 30,
                    ),
                    actionButton == 'go'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  SvgPicture.asset(
                                    "assets/exercise/reset_location.svg",
                                    height: 40.0,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'GPS',
                                    style: TextStyle(fontSize: 10),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  SvgPicture.asset(
                                    "assets/exercise/music.svg",
                                    height: 40.0,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Music',
                                    style: TextStyle(fontSize: 10),
                                  )
                                ],
                              ),
                              InkWell(
                                onTap: (){
                                  Navigator.pushNamed(
                                      context, RecordsActivities.routeName);
                                },
                                child:
                              Column(
                                children: [
                                  SvgPicture.asset(
                                    "assets/exercise/records.svg",
                                    height: 40.0,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Records',
                                    style: TextStyle(fontSize: 10),
                                  )
                                ],
                              ) ),
                            ],
                          )
                        : Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '5.03',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        Text('km'),
                                      ]),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '00:21:12',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        Text('Time'),
                                      ]),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '09:12',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        Text('Current pace'),
                                      ]),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '07:59',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        Text('Average pace'),
                                      ]),
                                ],
                              ),
                            ],
                          ),
                    SizedBox(
                      height: 30,
                    ),
                    actionButton == 'go'
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                counting = true;
                                startTimeout();
                                actionButton = 'play';
                              });
                            },
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/exercise/go.svg",
                                height: 66.0,
                              ),
                            ))
                        : actionButton == 'pause'
                            ? Center(
                                child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, SaveActivities.routeName);
                                      },
                                      child: SvgPicture.asset(
                                        "assets/exercise/finish.svg",
                                        height: 66.0,
                                      )),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          actionButton = 'play';
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        "assets/exercise/resume.svg",
                                        height: 66.0,
                                      )),
                                ],
                              ))
                            : InkWell(
                                onTap: () {
                                  setState(() {
                                    actionButton = 'pause';
                                  });
                                },
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/exercise/pause.svg",
                                    height: 66.0,
                                  ),
                                ))
                  ]),
                )));
  }
}
