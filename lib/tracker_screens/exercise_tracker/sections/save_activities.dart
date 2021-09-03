import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/ListItem/model_exercise_activity.dart';
import 'package:coral_reef/ListItem/route.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/constants.dart';
import 'package:coral_reef/homescreen/Home.dart';
import 'package:coral_reef/size_config.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/map_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:http/http.dart' as http;

class SaveActivities extends StatefulWidget {
  static final routeName = "saveActivities";
  final ExerciseActivity activity;
  final String distance, timeTaken, currentTakenSteps;
  final LocationData endLocation;
  final Map<String, dynamic> startLocation;

  SaveActivities(this.activity, this.distance, this.timeTaken, this.currentTakenSteps,
      this.startLocation, this.endLocation);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<SaveActivities> {
  GoogleMapController mapController;
  Geolocator geolocator;
  Position currentLocation;
  BitmapDescriptor sourceIcon;
  bool mapToggle = true;
  bool clientsToggle = false;
  String url;
  BitmapDescriptor pinLocationIcon;
  BitmapDescriptor startIcon;
  BitmapDescriptor stopIcon;
  // Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();
  // Map<MarkerId, Marker> markers = {};
  // Map<PolylineId, Polyline> polylines = {};
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyCRrfbYY6rhh2qfMPo-My7y_gUfsl2eP14";

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/exercise/my_location.png');
  }

  void setStartMapPin() async {
    startIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/exercise/details_pin.png');
    // startIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
  }

  void setStopMapPin() async {
    // stopIcon = await BitmapDescriptor.fromAssetImage(
    //     ImageConfiguration(devicePixelRatio: 2.5), 'assets/exercise/end.png');
    stopIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    controller.setMapStyle(Utils.mapStyles);
    if(_controller.isCompleted) return;
    _controller.complete(controller);
    print("asdfghjkl");
    setState(() {
      addMarker(LatLng(widget.startLocation["latitude"],
          widget.startLocation["longitude"]), "origin", "Start Position", startIcon);
      addMarker(LatLng(widget.endLocation.latitude, widget.endLocation.longitude), "destination", "Finish Position", stopIcon);
    });
  }

  void addMarker(LatLng position, String id, String infoWindow, BitmapDescriptor descriptor) {
    final MarkerId markerId = MarkerId(id);
    final Marker marker = Marker(
        markerId: markerId,
        position: position,
        infoWindow: InfoWindow(title: infoWindow, snippet: ''),
        icon: descriptor,
        alpha: 1.0,
        draggable: false);
    _markers[markerId] = marker;
  }

  @override
  void initState() {
    super.initState();
    setStopMapPin();
    setStartMapPin();
    LatLng start = new LatLng(widget.startLocation["latitude"],
        widget.startLocation["longitude"]);
    LatLng end = new LatLng(widget.endLocation.latitude, widget.endLocation.longitude);
    addPolyLineToMap(start, end);
    geolocator = Geolocator();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios)),
          elevation: 0,
          title: Text(
            'Save Activity',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontSize: getProportionateScreenWidth(15),
            ),
          ),
          centerTitle: true,
          actions: [
            InkWell(
              onTap: () async {
                final confirm = await new GeneralUtils().displayReturnedValueAlertDialog(context, "Attention", "Are you sure you want to delete this activity?", confirmText: "DELETE");
                if(!confirm) return;
                await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("my-activities").doc(widget.activity.id).delete();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => new HomeScreen()));
              },
              child: Container(
                margin: EdgeInsets.only(right: 20.0),
                child: SvgPicture.asset(
                  "assets/exercise/bin.svg",
                  height: 20.0,
                ),
              ),
            )
          ],
        ),
        body: Container(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(children: [
                Container(
                    height: MediaQuery.of(context).size.height / 3,
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
                                target: LatLng(
                                    widget.endLocation.latitude,
                                    widget.endLocation.longitude),
                              ),
                              markers: Set<Marker>.of(_markers.values),
                              polylines:
                              Set<Polyline>.of(polylines.values),
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
                                    Column(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/exercise/white_r_location.svg",
                                          height: 70.0,
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                          ])),
                        ])),
                SizedBox(
                  height: 30,
                ),
                Column(
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${widget.distance}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30),
                          ),
                          Text('Km', style: Theme
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
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(children: [
                          Text(
                            '${widget.timeTaken}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          Text('Time', style: Theme
                              .of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(
                            color: Color(MyColors.titleTextColor),
                            fontSize:
                            getProportionateScreenWidth(
                                15),
                          )),
                        ])
                      ],
                    ),
                  ],
                ),
                Container(
                    padding: EdgeInsets.only(top:20),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            SvgPicture.asset(
                              "assets/exercise/fire.svg",
                              height: 40.0,
                            ),
                            Text(
                                (double.parse(widget.currentTakenSteps) / 63.4)
                                    .floor()
                                    .toString() +
                                    " kcal",
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                  color: Color(MyColors.titleTextColor),
                                  fontSize:
                                  getProportionateScreenWidth(
                                      15),
                                )),
                          ],
                        ),
                      ],
                    )),
                SizedBox(
                  height: 20,
                ),
                ToggleSwitch(
                  minWidth: 150.0,
                  minHeight: 40.0,
                  fontSize: 16.0,
                  initialLabelIndex: 1,
                  activeBgColor:
                  Color(MyColors.primaryColor).withOpacity(0.1),
                  activeFgColor: Color(MyColors.primaryColor),
                  inactiveBgColor:
                  Color(MyColors.primaryColor).withOpacity(0.3),
                  inactiveFgColor: Color(MyColors.primaryColor),
                  labels: [
                    'Activity type',
                    '${widget.activity.activity_type.toUpperCase()}'
                  ],
                  onToggle: (index) {
                    print('switched to: $index');
                  },
                ),
                SizedBox(
                  height: 40,
                ),
                DefaultButton(
                  text: 'Save',
                  press: () {
                    Navigator.pop(context);
                  },
                )
              ]),
            )));
  }

  void addPolyLineToMap(LatLng start, LatLng end) {
    try {
      List<MyRoute> mRoutes = [];
      String url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=AIzaSyCRrfbYY6rhh2qfMPo-My7y_gUfsl2eP14';
      http.get(Uri.parse(url)).then((res) {
        Map<String, dynamic> resp = json.decode(res.body);
        //Map<dynamic, dynamic> routes = resp['routes'];
        MyRoute route = new MyRoute();
        Map<dynamic, dynamic> jsonRoute = resp['routes'][0];
        Map<dynamic, dynamic> overview_polylineJson =
        jsonRoute['overview_polyline'];
        route.points =
            decodePolyLine(overview_polylineJson['points'].toString());
        mRoutes.add(route);
        for (MyRoute myR in mRoutes) {
          final PolylineId polylineId = PolylineId('routes');
          final Polyline polyline = Polyline(
              polylineId: polylineId,
              color: Color(MyColors.primaryColor),
              width: 20,
              points: myR.points, visible: true
          );
          if(!mounted) return;
          setState(() {
            polylines[polylineId] = polyline;
          });
        }
      });
    } catch (e) {
    }
  }

  List<LatLng> decodePolyLine(final String poly) {
    int len = poly.length;
    int index = 0;
    List<LatLng> decoded = new List<LatLng>();
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;
      do {
        b = poly.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = poly.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      decoded.add(new LatLng(
          (lat / double.parse('100000')), (lng / double.parse('100000'))));
    }
    //print('decodePolyLine: length = ${decoded.length} and LatLng = ${decoded[0].latitude},${decoded[0].longitude}');

    return decoded;
  }
}
