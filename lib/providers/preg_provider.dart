// import 'package:coral_reef/models/pregnancy.dart';
// import 'package:coral_reef/services/database.dart';
// import 'package:flutter/material.dart';
// import 'package:uuid/uuid.dart';

// class PregDetailProvider with ChangeNotifier {
//   final firestoreService = FirestoreService();

//   String _detailsId;
//   String _birthInfo;
//   String _activityLevel;
//   String _stressLevel;
//   String _stressOften;
//   String _diet;
//   var uuid = Uuid();

// //Getters
//   String get birthInfo => _birthInfo;
//   String get activityLevel => _activityLevel;
//   String get stressLevel => _stressLevel;
//   String get stressOften => _stressOften;
//   String get diet => _diet;

// //Setters
//   changebirthInfo(String value) {
//     _birthInfo = value;
//     notifyListeners();
//   }

//   changeactivityLevel(String value) {
//     _activityLevel = value;
//     notifyListeners();
//   }

//   changestressLevel(String value) {
//     _stressLevel = value;
//     notifyListeners();
//   }

//   changestressOften(String value) {
//     _stressOften = value;
//     notifyListeners();
//   }

//   changediet(String value) {
//     _diet = value;
//     notifyListeners();
//   }

//   loadValues(PregDetail pregDetails) {
//     _birthInfo = pregDetails.birthInfo;
//     _activityLevel = pregDetails.activityLevel;
//     _stressLevel = pregDetails.stressLevel;
//     _stressOften = pregDetails.stressOften;
//     _diet = pregDetails.diet;
//     _detailsId = pregDetails.detailsId;
//   }

//   savePregDetail() {
//     print(_detailsId);
//     if (_detailsId == null) {
//       var newPregDetail = PregDetail(
//         birthInfo: birthInfo,
//         activityLevel: activityLevel,
//         stressLevel: stressLevel,
//         stressOften: stressOften,
//         diet: diet,
//         detailsId: uuid.v4(),
//       );
//       firestoreService.savePregDetail(newPregDetail);
//     } else {
//       //Update
//       var updatedPregDetail = PregDetail(
//         birthInfo: birthInfo,
//         activityLevel: activityLevel,
//         stressLevel: stressLevel,
//         stressOften: stressOften,
//         diet: diet,
//         detailsId: _detailsId,
//       );
//       firestoreService.savePregDetail(updatedPregDetail);
//     }
//   }
// }
