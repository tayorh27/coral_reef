// import 'package:coral_reef/models/period.dart';
// import 'package:coral_reef/services/database.dart';
// import 'package:flutter/material.dart';
// import 'package:uuid/uuid.dart';

// class PeriodDetailProvider with ChangeNotifier {
//   final firestoreService = FirestoreService();

//   String _detailsId;
//   String _birthYear;
//   String _lastPeriod;
//   String _length;
//   String _cycle;
//   var uuid = Uuid();

// //Getters
//   String get birthYear => _birthYear;
//   String get lastPeriod => _lastPeriod;
//   String get length => _length;
//   String get cycle => _cycle;

// //Setters
//   changeBirthYear(String value) {
//     _birthYear = value;
//     notifyListeners();
//   }

//   changeLastPeriod(String value) {
//     _lastPeriod = value;
//     notifyListeners();
//   }

//   changeLength(String value) {
//     _length = value;
//     notifyListeners();
//   }

//   changeCycle(String value) {
//     _cycle = value;
//     notifyListeners();
//   }

//   loadValues(PeriodDetail perioddetails) {
//     _birthYear = perioddetails.birthYear;
//     _lastPeriod = perioddetails.lastPeriod;
//     _length = perioddetails.length;
//     _cycle = perioddetails.cycle;
//     _detailsId = perioddetails.detailsId;
//   }

//   savePeriodDetail() {
//     print(_detailsId);
//     if (_detailsId == null) {
//       var newPeriodDetail = PeriodDetail(
//         birthYear: birthYear,
//         lastPeriod: lastPeriod,
//         length: length,
//         cycle: cycle,
//         detailsId: uuid.v4(),
//       );
//       firestoreService.savePeriodDetail(newPeriodDetail);
//     } else {
//       //Update
//       var updatedPeriodDetail = PeriodDetail(
//         birthYear: birthYear,
//         lastPeriod: lastPeriod,
//         length: length,
//         cycle: cycle,
//         detailsId: _detailsId,
//       );
//       firestoreService.savePeriodDetail(updatedPeriodDetail);
//     }
//   }
// }
