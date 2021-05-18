import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pedometer/pedometer.dart';

import '../Utils/storage.dart';

class StepService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  String _status = '0';
  String get status => _status;
  String _steps = '0';
  String get steps => _steps;
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

  void initPlatformState() {

    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream.listen(onPedestrianStatusChanged).onError(onPedestrianStatusError);
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
    //if (!mounted) return;
  }

  saveSteps(Map<dynamic, dynamic> payload) async {
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
}
