import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pedometer/pedometer.dart';

import '../Utils/storage.dart';

class StepService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Geolocator geolocator;
  String _status = '0';
  String get status => _status;
  String _steps = '0';
  String get steps => _steps;
    double _stepsGoal = 0;
  double get stepsGoal => _stepsGoal;
  Position _currentLocation;
  Position get currentLocation => _currentLocation;

  StorageSystem ss = new StorageSystem();

  //final User user = auth.currentUser;
  String formatDate(DateTime d) {
    return d.toString().substring(0, 19);
  }

  Stream<StepCount> _stepCountStream;
  Stream<PedestrianStatus> _pedestrianStatusStream;

  void onStepCount(StepCount event) {
    print(event);
    _steps = event.steps.toString();
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    _status = event.status;
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');

    _status = 'Pedestrian Status not available';

    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    _steps = '0';
  }

  Future<Position> getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return position;
  }

  void initPlatformState() {

    geolocator = Geolocator();
    getCurrentLocation().then((newLocation) {
      if (newLocation != null){
        _currentLocation = newLocation;
        //Get distance between two coord
        //double distanceInMeters = Geolocator.distanceBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838);
           }else{
        _currentLocation =Position(
          latitude: 3.32,
          longitude:2.3,
          timestamp: DateTime.now(),
          altitude:  0.0,
          accuracy:  0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
          isMocked:false,
        );
      }
      });
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);
    _stepCountStream = Pedometer.stepCountStream;
    getSteps();
    //if (!mounted) return;
  }

  saveSteps(Map<dynamic, dynamic> payload) async {
    getSteps();
    final User user = auth.currentUser;
    final result = await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .collection("exercise")
        .doc("steps-data")
        .set(payload)
        .then((value) {
      return true;
    }).catchError((err) {
      return false;
    });
    print(result);
    return result;
  }


  getSteps() async {
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
    final User user = auth.currentUser;
    DocumentSnapshot doc = await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .collection("exercise")
        .doc("steps-data")
        .get();
    Map<String, dynamic> goal = doc.data();
    print(goal["stepGoal"]);
    print(doc.data());
    String goals = goal["stepGoal"];
    _stepsGoal = double.parse(goals);
    return goal["stepGoal"];

//var dataResult = data['stepGoal'];
    //   print(dataResult);
    // return dataResult;

    // print(result);
    //return result;
  }
}
