import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/ListItem/model_challenge.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/constants.dart';
import 'package:coral_reef/onboarding/sign_in/sign_in_screen.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/active_challenge/track_challenge_activities.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/community_challenge_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instant/instant.dart';
import '../homescreen/components/body.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


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
    getUserTimeZone();
    getCurrentChallenge();
    listenForBlockedUser();

    // timeZoneTest();
  }

  getUserTimeZone() async {
    String tz = await new GeneralUtils().currentTimeZone();
    userCurrentTimeZone.add(tz);
  }

  tz.TZDateTime convertFireBaseToLocal(tz.TZDateTime tzDateTime, String locationLocal) {
    tz.TZDateTime nowLocal = new tz.TZDateTime.now(tz.getLocation(locationLocal));
    int difference = nowLocal.timeZoneOffset.inHours;
    tz.TZDateTime newTzDateTime;
    newTzDateTime = tzDateTime.add(Duration(hours: difference));
    return newTzDateTime;
  }

  timeZoneTest() async {
    final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    final String dateTimeZone = DateTime.now().timeZoneName;
    // print(tz.);
    tz.initializeTimeZones();

    DateTime myDT = DateTime.now(); //Current DateTime
    tz.TZDateTime cDT = new tz.TZDateTime(tz.getLocation(currentTimeZone), myDT.year, myDT.month, myDT.day, myDT.hour, myDT.minute, myDT.second, myDT.millisecond, myDT.microsecond);

    tz.TZDateTime newDT = convertFireBaseToLocal(cDT, "America/New_York");
    // DateTime eastCoast = dateTimeToZone(zone: "EST", datetime: myDT);

    print("zone a = $currentTimeZone");
    print("zone b = $dateTimeZone");

    print("east = ${newDT.toString()}");
  }

  List<int> newList = [];

  solveQuestion(List<int> score, int team_size, int k) {
    List<int> a1 = score.sublist(0, (k-1));
    a1.sort((a,b) => b-a);
    List<int> a2 = score.sublist(score.length - (k-1),score.length - 1);
    a2.sort((a,b) => b-a);

    int m1 = a1.last;
    int m2 = a2.last;

    if(m1 > m2 || m1 == m2) {
      a1.remove(m1);
    } else {
      a2.remove(m2);
    }

    newList = List.from(a1);
    newList.addAll(a2);

    if(newList.length == 2) {
      int result = newList[0] + newList[1];
    } else {
      solveQuestion(newList, team_size, k);
    }
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
          // Navigator.pushNamed(context, CommunityChallengeDetails.routeName, arguments: vc); //****
          Navigator.pushNamed(context, TrackChallengeActivities.routeName, arguments: vc); //****
        },
        tooltip: "Current Challenge",
      ),
      body: Body(),
    );
  }
}