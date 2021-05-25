import 'dart:async';
import 'package:location/location.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

class LocationService{
  var _startLocation;
  LocationData _currentLocation;
  LocationData get currentLocation => _currentLocation;
  bool _serviceEnabled = false, _physicalActivityEnabled = false;
  PermissionStatus _permissionGranted;

  StreamSubscription<LocationData> _locationSubscription;
  var mLocation = new Location();
  LocationData _locationData;
  LatLng user_location;
  double _userLat = 0, _userLng = 0;


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
    var location = await mLocation.getLocation();
      _startLocation = location;
    //start listening to change is location
    _locationSubscription =
        mLocation.onLocationChanged.listen((LocationData result) {
          double lat = result.latitude;
          double lng = result.longitude;

          _userLat = result.latitude;
          _userLng = result.longitude;

          user_location = LatLng(_userLat, _userLng);

            _currentLocation = result;
        });
  }

}