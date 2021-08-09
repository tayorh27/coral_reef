import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/ListItem/model_challenge.dart';
import 'package:coral_reef/ListItem/route.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/homescreen/Home.dart';
import 'package:coral_reef/services/challenge_step_service.dart';
import 'package:coral_reef/size_config.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/community_challenge_details.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/map_utils.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/post_complete_challenge.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/records_activities.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/save_activities.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/services/challenge_service.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/services/exercise_service.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:location/location.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:screen/screen.dart';

import '../../../constants.dart';

class TrackChallengeActivities extends StatefulWidget {
  static final routeName = "trackChallengeActivities";
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<TrackChallengeActivities> {

  var _startLocation;
  LocationData _currentLocation;

  StreamSubscription<LocationData> _locationSubscription;
  var mLocation = new Location();
  LocationData _locationData;

  bool _permission = false;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;
  int _markerIdCounter = 1;

  GoogleMapController mapController;

  Future<void> _onMapCreated(GoogleMapController controller) async {
      mapController = controller;
      controller.setMapStyle(Utils.mapStyles);
      if(_controller.isCompleted) return;
      _controller.complete(controller);
  }

  LatLng user_location;
  double _userLat = 0, _userLng = 0;

  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  int _polylineIdCounter = 1;
  PolylineId selectedPolyline;

  bool _serviceEnabled = false, _physicalActivityEnabled = false;
  PermissionStatus _permissionGranted;

  /////////////////////////////////////////////////////////////


  geo.Geolocator geolocator;
  geo.Position currentLocation;
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

  VirtualChallenge ch;

  StorageSystem ss = new StorageSystem();

  ExerciseService exerciseService;

  ChallengeStepService challengeStepService;

  MyChallengeService myChallengeService;

  String get timerText => (timerMaxSeconds - currentSeconds).toString();

  DateTime lastRecord;

  startTimeout([int milliseconds]) {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      setState(() {
        print(timer.tick);
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) {
          counting = false;
          onChallengeStarted();
          timer.cancel();
        }
      });
    });
  }

  Timer _timerSubscription;

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/exercise/details_pin.png');
  }

  Future<geo.Position> getCurrentLocation() async {
    final position = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high);

    return position;
  }



  @override
  void initState() {
    super.initState();
    exerciseService = new ExerciseService();
    myChallengeService = new MyChallengeService(context);

    setCustomMapPin();
    // geolocator = Geolocator();
    // setupCurrentLocation();
    // initPlatformState();
    getActivityData();
    locationSetup();
    // preSetupLocationPermission(); //timer
    setupPhysicalActivityTracking();
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
    // String startTime = await ss.getItem("startTime");
    // DateTime st = DateTime.parse(startTime);
    if(Platform.isAndroid) {
      if (await ph.Permission.activityRecognition
          .request()
          .isGranted) {
        // print("i dey here");
        _physicalActivityEnabled = true;
        if(Platform.isAndroid) {
          continuePhysicalActivitySetupAndroid();
        }else {
          continuePhysicalActivitySetupIOS();
        }
        // return;
      }
      // _physicalActivityEnabled = true;
      // continuePhysicalActivitySetup();
    }else {
      if (await ph.Permission.sensors
          .request()
          .isGranted) {
        _physicalActivityEnabled = true;
        if(Platform.isAndroid) {
          continuePhysicalActivitySetupAndroid();
        }else {
          continuePhysicalActivitySetupIOS();
        }
      }
    }
  }

  int initSteps = 0;
  int userTime = 0;

  Future<void> continuePhysicalActivitySetupAndroid() async {
    // challengeStepService = new ChallengeStepService(
    //     context, onStepChange: (steps, distance, timestamp) async {
    //   // String running = await ss.getItem("running");
    //   // print("iRunning = $running");
    //   //     print("i dey here - here $steps");
    //   // if (running == null) {
    //   //   initSteps = steps;
    //   //   if(Platform.isIOS) await ss.setPrefItem("init_step_count", initSteps.toString());
    //   //   return;
    //   // }
    //   // if (steps != null || distance != null || timestamp != null) {
    //   //   // if(!mounted) return;
    //   //   print("here too");
    //   //   setState(() {
    //   //     distanceCovered = distance;
    //   //   });
    //   //   // new GeneralUtils().showToast(context, "Step number: $steps");
    //   //   if (ch == null) return;
    //   //
    //   //   await exerciseService.updateUserChallengeData(ch, distance);
    //   //
    //   //   if (distance == double.parse(ch.distance) / 2) {
    //   //     String activityText = "has completed ${double.parse(ch.distance) /
    //   //         2} km.";
    //   //     await exerciseService.logActivity(ch, activityText);
    //   //   }
    //   //
    //   //   if (distance >= double.parse(ch.distance)) {
    //   //     currentChallengeEnded(true);
    //   //   }
    //   // }
    // });
    // challengeStepService.stopCounting();
    String running = await ss.getItem("running");
    if(running == null) return;

    Map<String, dynamic> data = await myChallengeService.getCurrentSteps();
    if (data.isNotEmpty) {
      // if(!mounted) return;
      print("here too");
      totalSteps = data["steps"];
      setState(() {
        distanceCovered = data["distance"];
      });
      // new GeneralUtils().showToast(context, "Step number: $steps");
      if (ch == null) return;

      await exerciseService.updateUserChallengeData(ch, data["distance"]);

      // if (distance == double.parse(ch.distance) / 2) {
      //   String activityText = "has completed ${double.parse(ch.distance) /
      //       2} km.";
      //   await exerciseService.logActivity(ch, activityText);
      // }

      if (data["distance"] >= double.parse(ch.distance)) {
        currentChallengeEnded(true);
      }
    }
  }

  Future<void> continuePhysicalActivitySetupIOS() async {
    challengeStepService = new ChallengeStepService(
        context, onStepChange: (steps, distance, timestamp) async {
      String running = await ss.getItem("running");
      String init_step_count = await ss.getItem("init_step_count");
      print("iRunning = $running");
          print("i dey here - here $steps");
      if (init_step_count == null || running == null) {
        initSteps = steps;
        if(Platform.isIOS) await ss.setPrefItem("init_step_count", initSteps.toString());
        return;
      }
      if (steps != null || distance != null || timestamp != null) {
        // if(!mounted) return;
        print("here too");
        setState(() {
          distanceCovered = distance;
        });
        // new GeneralUtils().showToast(context, "Step number: $steps");
        if (ch == null) return;

        await exerciseService.updateUserChallengeData(ch, distance);

        if (distance == double.parse(ch.distance) / 2) {
          String activityText = "has completed ${double.parse(ch.distance) /
              2} km.";
          await exerciseService.logActivity(ch, activityText);
        }

        if (distance >= double.parse(ch.distance)) {
          currentChallengeEnded(true);
        }
      }
    });
    // challengeStepService.stopCounting();
  }

  int totalSteps = 0;
  double distanceCovered = 0.0;
  String timeCovered = "0D:0H:0M:0S";

  updateChallengeForegroundData(LocationData result) async {
    String running = await ss.getItem("running");
    if(running == null) return;
    // String startPosition = await ss.getItem("startPosition");
    // Map<String, dynamic> sp = jsonDecode(startPosition);

    // double lat = sp["latitude"];
    // double lng = sp["longitude"];

    // double distance = ExerciseService.distance(lat, result.latitude, lng, result.longitude); later

    // Map<String, dynamic> userLocation = new Map();
    // userLocation["latitude"] = result.latitude;
    // userLocation["longitude"] = result.longitude;
    // await ss.setPrefItem("currentPosition", jsonEncode(userLocation), isStoreOnline: false);

    String startTime = await ss.getItem("startTime");
    if(startTime == null) return;

    DateTime st = DateTime.parse(startTime);

    String currentTime = await ss.getItem("currentTime");
    DateTime ct = DateTime.parse(currentTime);

    // DateTime today = DateTime.now();
    int diff = ct.difference(st).inSeconds;

    await ss.setPrefItem("currentTime", ct.add(Duration(seconds: 1)).toString());

    if(!mounted) return;

    setState(() {
      // distanceCovered = distance;
      userTime = diff;
      timeCovered = ExerciseService.formatTimeCovered(st, ct.add(Duration(seconds: 1)));
    });

    if(ch == null) return;

    await exerciseService.updateUserChallengeDataTime(ch, diff);
    //
    // if(distance == double.parse(ch.distance) / 2) {
    //   String activityText = "has completed ${double.parse(ch.distance) / 2} km.";
    //   await exerciseService.logActivity(ch, activityText);
    // }
    //
    // if(distance >= double.parse(ch.distance)) {
    //   currentChallengeEnded(true);
    // }

  }

  Future<void> preSetupLocationPermission() async {
    _timerSubscription = new Timer.periodic(Duration(seconds: 5), (callback){
      // print("paused: ${challengeStepService.isPaused()}");
      // if(challengeStepService.isPaused()) {
      //   challengeStepService.resumeCounting();
      // }
      updateChallengeForegroundData(null);
      if(Platform.isAndroid) {
        continuePhysicalActivitySetupAndroid();
      }
      // else {
      //   continuePhysicalActivitySetupIOS();
      // }
    });
    return;
    // var status = await ph.Permission.locationWhenInUse.status;
    //     if(status.isGranted) {
    //       initPlatformState();
    //       return;
    //     }
    //     final allowPermission = await new GeneralUtils().requestPermission(context, "Location", "Allow Coral Reef to access your location in order to calculate your distance effectively.");
    //     if(allowPermission) {
    //       initPlatformState();
    //     }
  }

  initPlatformState() async {
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
          // updateChallengeForegroundData(result);
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

  //not used
  // setupCurrentLocation() async {
  //   if (await ph.Permission.locationWhenInUse.request().isGranted) {
  //     geo.Position newLocation = await getCurrentLocation();
  //     setState(() {
  //       currentLocation = newLocation;
  //       mapToggle = true;
  //     });
  //   }
  // }

  //not used
  void onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    controller.setMapStyle(Utils.mapStyles);
    _controller.complete(controller);
    setState(() {
      /// origin marker
      _markers.add(Marker(
          markerId: MarkerId('first'),
          position: LatLng(currentLocation.latitude, currentLocation.longitude),
          icon: pinLocationIcon));
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    saveDataAndCancelSubscription();
  }
  
  saveDataAndCancelSubscription() async {
    // Map<String, dynamic> userLocation = new Map();
    // userLocation["latitude"] = _currentLocation.latitude;
    // userLocation["longitude"] = _currentLocation.longitude;
    // await ss.setPrefItem("currentPosition", jsonEncode(userLocation));
    if(_locationSubscription != null) _locationSubscription.cancel();
    if(_timerSubscription != null) _timerSubscription.cancel();
    if(challengeStepService != null) challengeStepService.stopCounting();
    if(await Screen.isKeptOn) await Screen.keepOn(false);
  }

  @override
  Widget build(BuildContext context) {
    ch = ModalRoute.of(context).settings.arguments as VirtualChallenge;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios)),
          title: Text(
            'Track Activities',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontSize: getProportionateScreenWidth(15),
            ),
          ),
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
                    : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Color(MyColors.other3),
                            borderRadius:
                            BorderRadius.circular(10.0)),
                        padding: EdgeInsets.only(
                            right: 20,
                            left: 20,
                            top: 10.0,
                            bottom: 10.0),
                        margin: EdgeInsets.only(right: 15.0),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Text(
                              ch.activity_type,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                  color: Color(MyColors.primaryColor)),
                            ),
                          ],
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
                  margin: EdgeInsets.only(right: 0.0, bottom: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ch.activity_type,
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
                                  myLocationButtonEnabled: true,
                                  zoomControlsEnabled: false,
                                  markers: Set<Marker>.of(markers.values),
                                  // polylines: Set<Polyline>.of(polylines.values),
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
                                        InkWell(
                                          onTap: (){
                                            Navigator.pushNamed(
                                                context, CommunityChallengeDetails.routeName, arguments: ch);
                                          },
                                          child: SvgPicture.asset(
                                            "assets/exercise/white_r_location.svg",
                                            height: 100.0,
                                          ),
                                        ),
    InkWell(
    onTap: (){

    },
    child: SvgPicture.asset(
                                          "assets/exercise/white_music.svg",
                                          height: 100.0,
                                        )),
        InkWell(
          onTap: (){

          },
          child: SvgPicture.asset(
                                          "assets/exercise/white_camera.svg",
                                          height: 100.0,
                                        )),
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
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: 10.0,
                              color: Color(MyColors.titleTextColor)
                          ),
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
                          ),
                        )
                      ],
                    ),
                    InkWell(
                        onTap: (){
                          Navigator.pushNamed(
                              context, CommunityChallengeDetails.routeName, arguments: ch);
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
                              'Details',
                              style: Theme.of(context).textTheme.bodyText1.copyWith(
                                fontSize: 10.0,
                                color: Color(MyColors.titleTextColor)
                              ),
                            )
                          ],
                        ) ),
                  ],
                ) : Column(
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
                      // if(!_serviceEnabled) {
                      //   initPlatformState();
                      // }
                      if (!_physicalActivityEnabled) {
                        setupPhysicalActivityTracking();
                        // return;
                      }
                      // setupPhysicalActivityTracking();
                      // if(Platform.isAndroid) {
                      //
                      // }else {
                      //   setupPhysicalActivityTracking();
                      // }
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
                              bool res = await new GeneralUtils().displayReturnedValueAlertDialog(context, "Attention", "Are you sure you want to end this challenge?");
                              if(!res) return;
                              // if(_locationSubscription != null) _locationSubscription.pause();
                              if(_timerSubscription != null) _timerSubscription.cancel();
                              if(challengeStepService != null) challengeStepService.stopCounting();
                              currentChallengeEnded(false);
                              // Navigator.pushNamed(
                              //     context, SaveActivities.routeName);
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
                              await ss.setPrefItem("statusCH", "play");
                              // if(Platform.isAndroid) {
                              //   Map<String, dynamic> data = await myChallengeService.getCurrentSteps();
                              //   await ss.setPrefItem("resumedSteps", "${data["steps"]}");
                              // }
                              // if(_locationSubscription != null) _locationSubscription.resume();
                              if(challengeStepService != null) challengeStepService.resumeCounting();
                              preSetupLocationPermission();
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
                      await ss.setPrefItem("statusCH", "pause");
                      // if(Platform.isAndroid) {
                      //   await ss.setPrefItem("pausedSteps", "$totalSteps");
                      // }
                      // if(_locationSubscription != null) _locationSubscription.pause();
                      if(_timerSubscription != null) _timerSubscription.cancel();
                      if(challengeStepService != null) challengeStepService.pauseCounting();
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
            ))));
  }

  currentChallengeEnded(bool success) async {
    // FlutterBackgroundService().sendData(
    //   {"action": "stopService"},
    // );
    setState(() {
      _inAsyncCall = true;
    });
    new GeneralUtils().showToast(context, "Please wait...");
    String getStartLocation = await ss.getItem("startPosition");
    await ss.deletePref("currentChallenge");
    await ss.deletePref("running");
    await ss.deletePref("statusCH");
    await ss.deletePref("startPosition");
    await ss.deletePref("currentPosition");
    await ss.deletePref("startTime");
    await ss.deletePref("currentTime");
    await ss.deletePref("init_step_count");
    await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("setups").doc("user-data").update(
        {
          "currentChallenge": FieldValue.delete(),
          "running": FieldValue.delete(),
          "statusCH": FieldValue.delete(),
          "startPosition": FieldValue.delete(),
          "currentPosition": FieldValue.delete(),
          "startTime": FieldValue.delete(),
          "currentTime": FieldValue.delete(),
          "init_step_count": FieldValue.delete(),
          "user_ch_id": FieldValue.delete(),
        });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("my-challenges")
        .doc(ch.id)
        .update({
      "km_covered": distanceCovered,
      "time_taken": userTime,
      "steps_taken": totalSteps,
    });
    if(distanceCovered >= double.parse(ch.distance)) {
      if(ch.funding_type == "Sponsor") {
        if(ch.winner_reward_type == "All Completed Participants") {
          await exerciseService.onChallengeParticipation(ch.id);
        }else {
          //winners reward
          await exerciseService.onWinnersReward(ch.id);
        }
      }else {
        //pool funding
        await exerciseService.onWinnersReward(ch.id);
      }
    }
    String activityText = "has finished the challenge.";
    await exerciseService.logActivity(ch, activityText);
    String text = (success) ? "You have successfully completed your challenge." : "Thank you for participating.";
    new GeneralUtils().showToast(context, text);
    setState(() {
      _inAsyncCall = false;
    });
    if(getStartLocation == null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => new HomeScreen()));
      return;
    }
    Map<String, dynamic> startLoc = jsonDecode(getStartLocation);
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => new PostCompleteChallenge(ch, "$distanceCovered", timeCovered, "$totalSteps", startLoc, _currentLocation)));
  }

  getActivityData() async {
    String running = await ss.getItem("running");
    print("running = $running");
    if(running == null) return;


    String statusCH = await ss.getItem("statusCH");

    // String startPosition = await ss.getItem("startPosition");
    // String currentPosition = await ss.getItem("currentPosition");
    //
    //

    setState(() {
      actionButton = statusCH;
    });

    if(actionButton == "pause") {
      // print("pausseeeeeeee");
      // if(_locationSubscription != null) _locationSubscription.pause();
      if(_timerSubscription != null) _timerSubscription.cancel();
      if(challengeStepService != null) challengeStepService.pauseCounting();
    }

    if(actionButton == "play") {
      // print("playyyyyy");
      preSetupLocationPermission();
      if(challengeStepService != null) challengeStepService.resumeCounting();
      // if(challengeStepService != null) challengeStepService.resumeCounting();
    }

    Screen.keepOn(true);
  }

  //initialize challenge start
  void onChallengeStarted() async {
    Map<String, dynamic> userLocation = new Map();
    userLocation["latitude"] = _currentLocation.latitude;
    userLocation["longitude"] = _currentLocation.longitude;
    String startSteps = await myChallengeService.initPlatformState();
    print("startSteps: $startSteps");
    await ss.setPrefItem("startSteps", startSteps);
    await ss.setPrefItem("running", "true");
    await ss.setPrefItem("statusCH", "play");
    await ss.setPrefItem("startPosition", jsonEncode(userLocation));
    await ss.setPrefItem("currentPosition", jsonEncode(userLocation));

    await ss.setPrefItem("startTime", DateTime.now().toString());
    await ss.setPrefItem("currentTime", DateTime.now().toString());

    // if(Platform.isIOS) ss.setPrefItem("init_step_count", initSteps.toString());

    preSetupLocationPermission();
    if(Platform.isIOS) {
      if(challengeStepService != null) challengeStepService.resumeCounting();
    }

    // await exerciseService.getRequiredTime(_currentLocation, ch);

    // FlutterBackgroundService.initialize(onStart);
  }
}

void onStart() async{
  // WidgetsFlutterBinding.ensureInitialized();
  // final service = FlutterBackgroundService();
  // service.onDataReceived.listen((event) {
  //   if (event["action"] == "setAsForeground") {
  //     service.setForegroundMode(true);
  //     return;
  //   }
  //
  //   if (event["action"] == "setAsBackground") {
  //     service.setForegroundMode(false);
  //   }
  //
  //   if (event["action"] == "stopService") {
  //     service.stopBackgroundService();
  //   }
  // });

  StorageSystem ss = new StorageSystem();

  final position = await geo.Geolocator.getCurrentPosition(
      desiredAccuracy: geo.LocationAccuracy.high);

  String running = await ss.getItem("running");
  if(running == null) return;
  String startPosition = await ss.getItem("startPosition");
  Map<String, dynamic> sp = jsonDecode(startPosition);

  double lat = sp["latitude"];
  double lng = sp["longitude"];

  double distance = ExerciseService.distance(lat, position.latitude, lng, position.longitude);

  // Map<String, dynamic> userLocation = new Map();
  // userLocation["latitude"] = result.latitude;
  // userLocation["longitude"] = result.longitude;
  // await ss.setPrefItem("currentPosition", jsonEncode(userLocation), isStoreOnline: false);

  String startTime = await ss.getItem("startTime");
  DateTime st = DateTime.parse(startTime);

  DateTime today = DateTime.now();
  int diff = today.difference(st).inMilliseconds;

  String currentCH = await ss.getItem("currentChallenge");
  if(currentCH == null) return;

  Map<String, dynamic> getData = jsonDecode(currentCH);

  VirtualChallenge ch = VirtualChallenge.fromSnapshot(getData);

  if(ch == null) return;

  // await new ExerciseService().updateUserChallengeData(ch, distance, diff);

  if(distance >= double.parse(ch.distance)) {
    await ss.deletePref("currentChallenge");
    await ss.deletePref("running");
    await ss.deletePref("statusCH");
    await ss.deletePref("startPosition");
    await ss.deletePref("currentPosition");
    await ss.deletePref("startTime");
    await ss.deletePref("currentTime");
    await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("setups").doc("user-data").update(
        {
          "currentChallenge": FieldValue.delete(),
          "running": FieldValue.delete(),
          "statusCH": FieldValue.delete(),
          "startPosition": FieldValue.delete(),
          "currentPosition": FieldValue.delete(),
          "startTime": FieldValue.delete(),
          "currentTime": FieldValue.delete(),
        });

    // service.setNotificationInfo(
    //       title: "Challenge Alert",
    //       content: "You have reached your goal in this challenge. Thank you for participating.",
    // );

    // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    // FlutterLocalNotificationsPlugin();
    //
    // var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    //     'high_importance_channel',
    //     'High Importance Notifications', // title
    //     'This channel is used for important notifications.', // description
    //     importance: Importance.high,
    // );
    // var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    // var platformChannelSpecifics = NotificationDetails(
    //     android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    // flutterLocalNotificationsPlugin.show(
    //     0,
    //     "Challenge Alert",
    //     "You have reached your goal in this challenge. Thank you for participating.",
    //     platformChannelSpecifics
    // );

  }

  // bring to foreground
  // service.setForegroundMode(true);
  // Timer.periodic(Duration(seconds: 1), (timer) async {
  //   if (!(await service.isServiceRunning())) timer.cancel();
  //   service.setNotificationInfo(
  //     title: "My App Service",
  //     content: "Updated at ${DateTime.now()}",
  //   );
  //
  //   service.sendData(
  //     {"current_date": DateTime.now().toIso8601String()},
  //   );
  // });
}

/*
GoogleMap(
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
                                  rotateGesturesEnabled: true,
                                  tiltGesturesEnabled: true,
                                  zoomControlsEnabled: true,
                                  zoomGesturesEnabled: true,
                                  scrollGesturesEnabled: true,
                                  markers: _markers,
                                )
* */
