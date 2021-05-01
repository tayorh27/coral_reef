
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../constants.dart';

class PeriodServices {

  PeriodServices();

  Future<Map<String, dynamic>> getSymptomsByDate(DateTime today) async {

    Map<String, dynamic> syms = new Map();

    List<dynamic> msd = [];

    String _date = "${today.year}-${today.month}-${today.day}";
    DocumentSnapshot query = await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("period-symptoms").doc(_date).get();

    if(query.exists) {
      Map<String, dynamic> data = query.data();
      List<dynamic> m = data["moods"];
      List<dynamic> s = data["symptoms"];
      List<dynamic> d = data["discharge"];
      String note = data["note"];

      msd.addAll(m);
      msd.addAll(s);
      msd.addAll(d);

      syms["msd"] = msd;
      syms["note"] = note;
    }

    return syms;
  }

  Future<Map<String, dynamic>> getLastPeriodData() async {
    QuerySnapshot query = await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("periods").orderBy("timestamp", descending: true).limit(1).get();
    if(query.size > 0) {
      Map<String, dynamic> data = query.docs[0].data();
      return data;
    }
    return new Map();
  }
}