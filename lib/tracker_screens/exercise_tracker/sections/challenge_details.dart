import 'dart:async';

import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/size_config.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/chal_participants.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/map_utils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class ChallengeDetails extends StatefulWidget {
  static final routeName = "challengeDetails";
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<ChallengeDetails> {
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

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/exercise/details_pin.png');
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
          markerId: MarkerId('first'),
          position: LatLng(currentLocation.latitude, currentLocation.longitude),
          icon: pinLocationIcon));

      /// destination marker
      _markers.add(Marker(
          markerId: MarkerId('last'),
          position: LatLng(
              currentLocation.latitude - 3, currentLocation.longitude + 30),
          icon: pinLocationIcon));

      /// destination marker
      _markers.add(Marker(
          markerId: MarkerId('mid'),
          position: LatLng(
              currentLocation.latitude - 1, currentLocation.longitude + 10),
          icon: pinLocationIcon));
    });
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  @override
  void initState() {
    super.initState();
    setCustomMapPin();
    geolocator = Geolocator();
    setupCurrentLocation();
  }

  setupCurrentLocation() async {
    if (await Permission.locationWhenInUse.request().isGranted) {
      Position newLocation = await getCurrentLocation();
      setState(() {
        currentLocation = newLocation;
        mapToggle = true;
      });
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios)),
              Text(
                'Weekday Challenge',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontWeight: FontWeight.bold,
                      fontSize: getProportionateScreenWidth(15),
                    ),
              ),
              Text('')
            ],
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Image.asset(
                                'assets/exercise/group_people.png',
                                height: 40,
                              ),
                              Text(
                                '3 days 20 hr 44 min left',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      color: Colors.grey,
                                      fontSize: getProportionateScreenWidth(10),
                                    ),
                              ),
                            ],
                          ),
                          Container(
                              width: 100,
                              height: 30,
                              child: DefaultButton2(
                                press: (){
                                  Navigator.pushNamed(
                                      context, ChallengeParticipant.routeName);
                                },
                                text: 'Details',
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Rank',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    color: Colors.grey,
                                    fontSize: getProportionateScreenWidth(12),
                                  ),
                            ),
                            Text(
                              'Steps',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    color: Colors.grey,
                                    fontSize: getProportionateScreenWidth(12),
                                  ),
                            ),
                          ]),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                            Row(
                              children: [
                                Text(
                                  '1.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                        color: Colors.grey,
                                        fontSize:
                                            getProportionateScreenWidth(12),
                                      ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Image.asset("assets/exercise/end.png",
                                    height: 40.0),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Elie',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                        fontSize:
                                            getProportionateScreenWidth(14),
                                      ),
                                ),
                              ],
                            ),
                            Text(
                              '12345',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    fontSize: getProportionateScreenWidth(12),
                                  ),
                            ),
                          ])),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                            Row(
                              children: [
                                Text(
                                  '2.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                        color: Colors.grey,
                                        fontSize:
                                            getProportionateScreenWidth(12),
                                      ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Image.asset("assets/exercise/end.png",
                                    height: 40.0),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Elie',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                        fontSize:
                                            getProportionateScreenWidth(14),
                                      ),
                                ),
                              ],
                            ),
                            Text(
                              '12345',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    fontSize: getProportionateScreenWidth(12),
                                  ),
                            ),
                          ])),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                            Row(
                              children: [
                                Text(
                                  '3.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                        color: Colors.grey,
                                        fontSize:
                                            getProportionateScreenWidth(12),
                                      ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Image.asset("assets/exercise/end.png",
                                    height: 40.0),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Elie',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                        fontSize:
                                            getProportionateScreenWidth(14),
                                      ),
                                ),
                              ],
                            ),
                            Text(
                              '12345',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    fontSize: getProportionateScreenWidth(12),
                                  ),
                            ),
                          ])),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          height: MediaQuery.of(context).size.height / 4,
                          width: MediaQuery.of(context).size.width / 1.3,
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
                                                currentLocation.latitude,
                                                currentLocation.longitude),
                                          ),rotateGesturesEnabled: true,
                                          tiltGesturesEnabled: true,
                                          zoomControlsEnabled: true,
                                          zoomGesturesEnabled: true,scrollGesturesEnabled: true,
                                          markers: _markers,
                                        )
                                      : Center(
                                          child: Text(
                                            'Loading...',
                                            style: TextStyle(fontSize: 28),
                                          ),
                                        ),
                                ])),
                              ])),
                      SizedBox(
                        height: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '12:34 PM',
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      fontSize: getProportionateScreenWidth(12),
                                    ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/exercise/end.png",
                                  height: 30.0),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '3255 more steps to go for Dupe',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      fontSize: getProportionateScreenWidth(12),
                                    ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '12:34 PM',
                            style:
                            Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: getProportionateScreenWidth(12),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/exercise/end.png",
                                  height: 30.0),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '3255 more steps to go for Dupe',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                  fontSize: getProportionateScreenWidth(12),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Divider(thickness: 3,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/exercise/end.png",
                              height: 40.0),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Fatima has joined this challenge',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                              fontSize: getProportionateScreenWidth(12),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/exercise/end.png",
                              height: 40.0),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Fatima has joined this challenge',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                              fontSize: getProportionateScreenWidth(12),
                            ),
                          ),
                        ],
                      )
                    ]))));
  }
}
