import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/ListItem/model_exercise_activity.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/homescreen/Home.dart';
import 'package:coral_reef/size_config.dart';
import 'package:coral_reef/tracker_screens/diet_tracker_screen/components/water_card.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/map_utils.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/post_complete_challenge.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/records_activities.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/save_activities.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/services/challenge_service.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/services/exercise_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:screen/screen.dart';
import 'package:rive/rive.dart';

import '../../../constants.dart';

class TrackActivities extends StatefulWidget {
  static final routeName = "trackActivities";
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<TrackActivities> with SingleTickerProviderStateMixin {

  var _startLocation;
  LocationData _currentLocation;

  StreamSubscription<LocationData> _locationSubscription;
  var mLocation = new Location();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;
  int _markerIdCounter = 1;

  LatLng user_location;
  double _userLat = 0, _userLng = 0;

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    controller.setMapStyle(Utils.mapStyles);
    if(_controller.isCompleted) return;
    _controller.complete(controller);
  }

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
  bool counting = false, _inAsyncCall = false;
  final interval = const Duration(seconds: 1);

  final int timerMaxSeconds = 3;

  int currentSeconds = 0;
  bool _serviceEnabled = false, _physicalActivityEnabled = false;
  PermissionStatus _permissionGranted;

  StorageSystem ss = new StorageSystem();

  ExerciseService exerciseService;
  MyChallengeService myChallengeService;

  int initSteps = 0;
  int userTime = 0;
  int totalSteps = 0;
  double distanceCovered = 0.0;
  String timeCovered = "0D:0H:0M:0S";
  bool showWaterCard = false;

  Timer _timerSubscription;

  Animation<double> _animation;
  AnimationController _animationController;

  String get timerText => (timerMaxSeconds - currentSeconds).toString();
  startTimeout([int milliseconds]) {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      setState(() {
        print(timer.tick);
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) {
          onActivityStarted();
          timer.cancel();
          counting = false;
        }
      });
    });
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/exercise/details_pin.png');
  }

  // Future<Position> getCurrentLocation() async {
  //   final position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   return position;
  // }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation = CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    super.initState();
    exerciseService = new ExerciseService();
    myChallengeService = new MyChallengeService(context);
    setCustomMapPin();
    locationSetup();
    setupPhysicalActivityTracking();
    getActivityData();
    geolocator = Geolocator();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    saveDataAndCancelSubscription();
  }

  Future<void> saveCurrentGPSPosition() async {
    if(_currentLocation == null) return;
    Map<String, dynamic> userLocation = new Map();
    userLocation["latitude"] = _currentLocation.latitude;
    userLocation["longitude"] = _currentLocation.longitude;
    await ss.setPrefItem("currentPosition", jsonEncode(userLocation), isStoreOnline: false);
  }

  saveDataAndCancelSubscription() async {
    await saveCurrentGPSPosition();
    if(_locationSubscription != null) _locationSubscription.cancel();
    if(_timerSubscription != null) _timerSubscription.cancel();
    if(await Screen.isKeptOn) await Screen.keepOn(false);
    if(actionButton == "play") {
      await ss.setPrefItem("activityStatusCH", "pause");
      await saveCurrentGPSPosition();
    }
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
            "Track activities",
            style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontSize: getProportionateScreenWidth(15),
            ),
          ),
          centerTitle: true,
          actions: [
            Container(
              margin: EdgeInsets.only(right: 10.0),
              child: TextButton(
                child: Text("Records", style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Color(MyColors.primaryColor),
                    fontSize: 14.0
                ),),
                onPressed: () {
                  Navigator.pushNamed(
                      context, RecordsActivities.routeName);
                },
              ),
            )
          ],
        ),
        body: ModalProgressHUD(
        inAsyncCall: _inAsyncCall,
        opacity: 0.6,
    progressIndicator: CircularProgressIndicator(),
    color: Color(MyColors.titleTextColor),
    child: counting
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
                        : Container(
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
                      ),
                    ),
                    SizedBox(
                      height: (actionButton == 'go') ? 30.0 : 0.0,
                    ),
                    actionButton == 'go'
                        ? Container()
                        : Container(
                            decoration: BoxDecoration(
                                color: Color(MyColors.other3),
                                borderRadius: BorderRadius.circular(10.0)),
                            padding: EdgeInsets.only(
                                right: 20, left: 20, top: 10.0, bottom: 10.0),
                            margin: EdgeInsets.only(bottom: 20.0,),
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
                                  initialCameraPosition:
                                  CameraPosition(target: LatLng(0.0, 0.0)),
                                  onMapCreated: _onMapCreated,
                                  compassEnabled: false,
                                  // mapType: MapType.normal,
                                  myLocationEnabled: true,
                                  rotateGesturesEnabled: true,
                                  scrollGesturesEnabled: true,
                                  tiltGesturesEnabled: true,
                                  zoomGesturesEnabled: true,
                                  myLocationButtonEnabled: false,
                                  zoomControlsEnabled: false,
                                  markers: Set<Marker>.of(markers.values),
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
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            // InkWell(
                                            //     onTap: (){
                                            //
                                            //     },
                                            //     child: SvgPicture.asset(
                                            //       "assets/exercise/white_music.svg",
                                            //       height: 100.0,
                                            //     )),
                                            InkWell(
                                                onTap: (){
                                                  setState(() {
                                                    showWaterCard = !showWaterCard;
                                                  });
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.only(right: 10.0),
                                                  child: Container(
                                                    width: 55,
                                                    height: 55,
                                                    padding: EdgeInsets.all(5.0),
                                                    decoration: BoxDecoration(
                                                      color: Color(MyColors.primaryColor),
                                                      borderRadius: BorderRadius.circular(55.0),
                                                      boxShadow: [
                                                        BoxShadow(color: Colors.black, blurRadius: 2)
                                                      ]
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        SvgPicture.asset(
                                                          "assets/diet/glass.svg",
                                                        ),
                                                        Text(
                                                            'Water',
                                                            style: Theme.of(context).textTheme.bodyText1.copyWith(
                                                                fontSize: 6.0,
                                                                color: Colors.white
                                                            )
                                                        )
                                                      ],
                                                    )
                                                  )
                                                ),
                                            ),
                                            Visibility(visible: showWaterCard, child: Stack(
                                              alignment: Alignment.centerRight,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context).size.width - 0.0,
                                                  margin: EdgeInsets.only(top: 10.0),
                                                  child: WaterCard(),
                                                )
                                              ],
                                            ))
                                          ],
                                        ))
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
                                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                                          fontSize: 10.0,
                                          color: Color(MyColors.titleTextColor)
                                      )
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
                                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                                          fontSize: 10.0,
                                          color: Color(MyColors.titleTextColor)
                                      )
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
                                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                                          fontSize: 10.0,
                                          color: Color(MyColors.titleTextColor)
                                      )
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
                                          "$distanceCovered",
                                          style: Theme.of(context).textTheme.headline2.copyWith(
                                              fontSize: getProportionateScreenWidth(18),
                                              color: Color(MyColors.titleTextColor)
                                          ),
                                        ),
                                        Text('km', style: Theme.of(context).textTheme.bodyText1.copyWith(
                                            fontSize: 10.0,
                                            color: Color(MyColors.titleTextColor)
                                        ),),
                                      ]),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          timeCovered,
                                          style: Theme.of(context).textTheme.headline2.copyWith(
                                              fontSize: getProportionateScreenWidth(18),
                                              color: Color(MyColors.titleTextColor)
                                          ),
                                        ),
                                        Text('Time', style: Theme.of(context).textTheme.bodyText1.copyWith(
                                            fontSize: 10.0,
                                            color: Color(MyColors.titleTextColor)
                                        ),),
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
                              if (!_physicalActivityEnabled) {
                                setupPhysicalActivityTracking();
                                return;
                              }
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
                                      onTap: () async {
                                        bool res = await new GeneralUtils().displayReturnedValueAlertDialog(context, "Attention", "Are you sure you want to end this activity?");
                                        if(!res) return;
                                        if(_locationSubscription != null) _locationSubscription.pause();
                                        if(_timerSubscription != null) _timerSubscription.cancel();
                                        currentActivityEnded(true);
                                      },
                                      child: SvgPicture.asset(
                                        "assets/exercise/finish.svg",
                                        height: 66.0,
                                      )),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  InkWell(
                                      onTap: () async {
                                        await ss.setPrefItem("activityStatusCH", "play");
                                        await initPlatformState();
                                        await saveCurrentGPSPosition();
                                        await preSetupLocationPermission();
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
                                onTap: () async {
                                  await ss.setPrefItem("activityStatusCH", "pause");
                                  await saveCurrentGPSPosition();
                                  if(_locationSubscription != null) _locationSubscription.pause();
                                  if(_timerSubscription != null) _timerSubscription.cancel();
                                  setState(() {
                                    actionButton = 'pause';
                                  });
                                },
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/exercise/pause.svg",
                                    height: 66.0,
                                  ),
                                )),
                    // AnimatedContainer(
                    //   width: MediaQuery.of(context).size.width,
                    //   height: 400.0,
                    //   duration: Duration(seconds: 5),
                    //   child: Column(children: [
                    //     Container(
                    //       height: 200.0,
                    //       child: RiveAnimation.asset("assets/rive/518-984-or-switch-it-up.riv"),
                    //     ),
                    //     Text("Record"),
                    //   ])
                    // )
                  ]),
                ))));
  }

  Future<void> locationSetup() async {
    var status = await ph.Permission.locationWhenInUse.status;
    if(status.isGranted) {
      initPlatformState();
      return;
    }
    final allowPermission = await new GeneralUtils().requestPermission(context, "Location", "Allow Coral Reef to access your location in order to calculate your distance effectively.");
    if(allowPermission) {
      initPlatformState();
    }
  }

  setupPhysicalActivityTracking() async {
    if(Platform.isAndroid) {
      if (await ph.Permission.activityRecognition
          .request()
          .isGranted) {
        _physicalActivityEnabled = true;
      }
    }else {
      if (await ph.Permission.sensors
          .request()
          .isGranted) {
        _physicalActivityEnabled = true;
      }
    }
  }

  Future<void> initPlatformState() async {
    if(_locationSubscription != null) {
      await _locationSubscription.cancel();
      _locationSubscription = null;
    }
    _serviceEnabled = await mLocation.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await mLocation.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await mLocation.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await mLocation.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    if (!mounted) return;
    var location = await mLocation.getLocation();
    setState(() {
      mapToggle = true;
      _startLocation = location;
    });
    // updateMapCamera(location.latitude, location.longitude);
    // start listening to change is location
    _locationSubscription =
        mLocation.onLocationChanged.listen((LocationData result) {
          double lat = result.latitude;
          double lng = result.longitude;

          _userLat = result.latitude;
          _userLng = result.longitude;

          user_location = LatLng(_userLat, _userLng);
          if(!mounted) return;
          setState(() {
            if (mapController != null) {
              updateMapCamera(lat, lng);
            }
            _currentLocation = result;
          });
          updateActivityForegroundData(result);
        });
  }

  updateActivityForegroundData(LocationData result) async {
    String running = await ss.getItem("activityRunning");
    if(running == null) return;
    double distance = await myChallengeService.calculateActivityGPSDistance(result);

    print("$distance");

    if(!mounted) return;

    setState(() {
      distanceCovered = distance;
    });
  }

  Future<void> updateActivityTime() async {
    String running = await ss.getItem("activityRunning");
    if(running == null) return;

    String startTime = await ss.getItem("activityStartTime");
    if(startTime == null) return;

    DateTime st = DateTime.parse(startTime);

    String currentTime = await ss.getItem("activityCurrentTime");
    DateTime ct = DateTime.parse(currentTime);

    // DateTime today = DateTime.now();
    int diff = ct.difference(st).inSeconds;

    await ss.setPrefItem("activityCurrentTime", ct.add(Duration(seconds: 1)).toString(), isStoreOnline: false);

    if(!mounted) return;

    setState(() {
      userTime = diff;
      timeCovered = ExerciseService.formatTimeCovered(st, ct.add(Duration(seconds: 1)));
    });

    // await exerciseService.updateUserChallengeDataTime(ch, diff);
  }

  Future<void> preSetupLocationPermission() async {
    _timerSubscription = new Timer.periodic(Duration(seconds: 1), (callback) {
      updateActivityTime();
    });
  }

  void updateMapCamera(double lat, double lng) {
    markers.clear();
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 90.0,
        target: LatLng(lat, lng),
        tilt: 30.0,
        zoom: 15.0,
      ),
    ));
    final MarkerId markerId = MarkerId('user');
    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
            title: 'Your location',
            snippet: ''),
        icon: pinLocationIcon,
        alpha: 1.0,
        draggable: false);
    markers[markerId] = marker;
  }

  currentActivityEnded(bool success) async {
    setState(() {
      _inAsyncCall = true;
    });
    new GeneralUtils().showToast(context, "Please wait...");
    String getStartLocation = await ss.getItem("activityStartPosition");
    Map<String, dynamic> startLoc = jsonDecode(getStartLocation);
    Map<String, dynamic> endLoc = new Map();
    endLoc["latitude"] = _currentLocation.latitude;
    endLoc["longitude"] = _currentLocation.longitude;

    await ss.deletePref("activitySelected");
    await ss.deletePref("currentActivity");
    await ss.deletePref("activityCurrentKm");
    await ss.deletePref("activityRunning");
    await ss.deletePref("activityStatusCH");
    await ss.deletePref("activityStartPosition");
    await ss.deletePref("activityCurrentPosition");
    await ss.deletePref("activityStartTime");
    await ss.deletePref("activityCurrentTime");
    await ss.deletePref("activity_init_step_count");
    await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("setups").doc("user-data").update(
        {
          "currentActivity": FieldValue.delete(),
          "activityRunning": FieldValue.delete(),
          "activityStatusCH": FieldValue.delete(),
          "activityStartPosition": FieldValue.delete(),
          "activityCurrentPosition": FieldValue.delete(),
          "activityStartTime": FieldValue.delete(),
          "activityCurrentTime": FieldValue.delete(),
          "activity_init_step_count": FieldValue.delete(),
        });
    String key = FirebaseDatabase.instance.reference().push().key;
    ExerciseActivity ea = new ExerciseActivity(key, user.uid, selected.toLowerCase(), new DateTime.now().toString(), FieldValue.serverTimestamp(), distanceCovered, userTime, timeCovered, totalSteps, startLoc, endLoc);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("my-activities")
        .doc(key)
        .set(ea.toJSON());
    String text = (success) ? "You have successfully completed your activity." : "Thank you for participating.";
    new GeneralUtils().showToast(context, text);
    setState(() {
      _inAsyncCall = false;
    });
    if(getStartLocation == null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => new HomeScreen()));
      return;
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => new SaveActivities(ea, "$distanceCovered", timeCovered, "$totalSteps", startLoc, _currentLocation)));
  }

  getActivityData() async {
    String running = await ss.getItem("activityRunning");
    if(running == null) return;


    String statusCH = await ss.getItem("activityStatusCH");
    String selectedAct = await ss.getItem("activitySelected");

    setState(() {
      actionButton = statusCH;
      selected = selectedAct;
    });

    await saveCurrentGPSPosition();

    if(actionButton == "pause") {
      if(_locationSubscription != null) _locationSubscription.pause();
      if(_timerSubscription != null) _timerSubscription.cancel();
    }

    if(actionButton == "play") {
      preSetupLocationPermission();
    }

    Screen.keepOn(true);
  }

  //initialize challenge start
  void onActivityStarted() async {
    Map<String, dynamic> userLocation = new Map();
    userLocation["latitude"] = _currentLocation.latitude;
    userLocation["longitude"] = _currentLocation.longitude;
    await ss.setPrefItem("activitySelected", selected);
    await ss.setPrefItem("activityRunning", "true");
    await ss.setPrefItem("activityStatusCH", "play");
    await ss.setPrefItem("activityStartPosition", jsonEncode(userLocation));
    await ss.setPrefItem("activityCurrentPosition", jsonEncode(userLocation));

    await ss.setPrefItem("activityStartTime", DateTime.now().toString());
    await ss.setPrefItem("activityCurrentTime", DateTime.now().toString());

    preSetupLocationPermission();
  }
}
