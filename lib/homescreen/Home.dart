import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/ListItem/model_challenge.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/onboarding/sign_in/sign_in_screen.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/community_challenge_details.dart';
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

  VirtualChallenge vc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentChallenge();
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

  getCurrentChallenge() async {
    String currentCH = await ss.getItem("currentChallenge");
    if(currentCH == null) return;

    Map<String, dynamic> ch = jsonDecode(currentCH);

    setState(() {
      vc = VirtualChallenge.fromSnapshot(ch);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(backgroundColor: Colors.white,elevation: 0.1,),
      floatingActionButton: (vc == null) ? null : FloatingActionButton(
        backgroundColor: Color(MyColors.primaryColor),
        child: Icon(Icons.directions_run_rounded, color: Colors.white, size: 32.0,),
        onPressed: (){
          Navigator.pushNamed(context, CommunityChallengeDetails.routeName, arguments: vc); //****
        },
        tooltip: "Current Challenge",
      ),
      body: Body(),
    );
  }
}