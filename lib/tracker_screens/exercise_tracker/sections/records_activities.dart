import 'dart:async';

import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/size_config.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/map_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:toggle_switch/toggle_switch.dart';

class RecordsActivities extends StatefulWidget {
  static final routeName = "recordsActivities";
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<RecordsActivities> {
  String selected = 'walk';
  GoogleMapController mapController;
  Geolocator geolocator;
  Position currentLocation;
  BitmapDescriptor sourceIcon;
  bool mapToggle = false;
  bool clientsToggle = false;
  String url;
  BitmapDescriptor pinLocationIcon;
  BitmapDescriptor startIcon;
  BitmapDescriptor stopIcon;
  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();
  double _originLatitude = 26.48424, _originLongitude = 50.04551;
  double _destLatitude = 26.46423, _destLongitude = 50.06358;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
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
        ImageConfiguration(devicePixelRatio: 7.5, size: Size(2, 2)),
        'assets/exercise/start.png');
  }

  void setStopMapPin() async {
    stopIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/exercise/end.png');
  }

  Future<Position> getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return position;
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    controller.setMapStyle(Utils.mapStyles);
    _controller.complete(controller);
    setState(() {
      /// origin marker
      _markers.add(Marker(
          markerId: MarkerId('origin'),
          position: LatLng(currentLocation.latitude, currentLocation.longitude),
          icon: startIcon));

      /// destination marker
      _markers.add(Marker(
          markerId: MarkerId('destination'),
          position: LatLng(
              currentLocation.latitude - 1, currentLocation.longitude + 10),
          icon: stopIcon));
      _getPolyline();
    });
    //   setState(() {
    //     _markers.add(Marker(
    //         markerId: MarkerId('100'),
    //         position: LatLng(
    //             currentLocation.latitude,
    //             currentLocation.longitude),
    //         icon: pinLocationIcon));
    // });
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(currentLocation.latitude, currentLocation.longitude),
      PointLatLng(currentLocation.latitude - 10, currentLocation.latitude - 10),
      travelMode: TravelMode.walking,
      // wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")]
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
      print(result.status);
    }
    _addPolyLine();
  }

  @override
  void initState() {
    super.initState();
    setStopMapPin();
    setStartMapPin();
    geolocator = Geolocator();
    getCurrentLocation().then((newLocation) {
      setState(() {
        currentLocation = newLocation;
        mapToggle = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                'Records',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: getProportionateScreenWidth(15),
                    ),
              ),
              SvgPicture.asset(
                  "assets/icons/clarity_notification-outline-badged.svg",
                  height: 22.0),
            ],
          ),
        ),
        body: Container(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(children: [
                ToggleSwitch(
                  minWidth: 150.0,
                  minHeight: 40.0,
                  fontSize: 16.0,
                  initialLabelIndex: 1,
                  activeBgColor: Color(MyColors.primaryColor).withOpacity(0.1),
                  activeFgColor: Color(MyColors.primaryColor),
                  inactiveBgColor:
                      Color(MyColors.primaryColor).withOpacity(0.3),
                  inactiveFgColor: Color(MyColors.primaryColor),
                  labels: ['Activity type', 'Walk'],
                  onToggle: (index) {
                    print('switched to: $index');
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(children: [
                      Text(
                        '3',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text('Total Steps'),
                    ]),
                    Column(children: [
                      Text(
                        '16.09',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text('Total Km'),
                    ]),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
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
                              SvgPicture.asset(
                                  "assets/icons/clarity_notification-outline-badged.svg",
                                  height: 22.0),
                              Text(
                                '8 February 2021,10:25 AM',
                                style: TextStyle(
                                    fontWeight: FontWeight.w200, fontSize: 12),
                              ),
                            ],
                          ),
                          Text(
                            '5.54km',
                            style: TextStyle(
                                fontWeight: FontWeight.w200, fontSize: 20),
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
                SizedBox(
                  height: 30,
                ),
              ]),
            )));
  }
}
