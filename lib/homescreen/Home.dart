import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/onboarding/sign_in/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../homescreen/components/body.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";
  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {

  StorageSystem ss = new StorageSystem();

  StreamSubscription<DocumentSnapshot> blockListen;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    listenForBlockedUser();
  }

  Future<void> listenForBlockedUser() async {
    String user = await ss.getItem("user");
    if(user != null) {
      dynamic json = jsonDecode(user);
      String uid = json["uid"];

      blockListen = FirebaseFirestore.instance.collection("users").doc(uid).snapshots().listen((query) async {
        if(query.exists) {
          dynamic dt = query.data();
          bool isBlocked = dt["blocked"];
          if(isBlocked) {
            await FirebaseAuth.instance.signOut();
            await ss.clearPref();
            await ss.setPrefItem("boarded", "true");
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => new SignInScreen()));
          }
        }
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(blockListen != null) {
      print("you are disposed");
      blockListen.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(backgroundColor: Colors.white,elevation: 0.1,),
      body: Body(),
    );
  }
}