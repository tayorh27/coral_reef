import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/models/period.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants.dart';

class FirestoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  // getsData() async {
  //   String userId = await FirebaseAuth.instance.currentUser.uid;
  //   return FirebaseFirestore.instance.collection('perioddetails').doc(userId);
  // }

}
