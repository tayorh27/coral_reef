import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/ListItem/model_challenge.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/constants.dart';
import 'package:coral_reef/size_config.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/active_challenge/track_challenge_activities.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/chal_participants.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/map_utils.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/services/exercise_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class CommunityChallengeDetails extends StatefulWidget {
  static final routeName = "communityChallengeDetails";
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<CommunityChallengeDetails> {
  GoogleMapController mapController;
  Geolocator geolocator;
  Position currentLocation;
  BitmapDescriptor sourceIcon;
  bool mapToggle = false;
  bool clientsToggle = false;
  String url;
  BitmapDescriptor pinLocationIcon;
  BitmapDescriptor startIcon;
  BitmapDescriptor stopIcon;
  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();
  double _originLatitude = 26.48424, _originLongitude = 50.04551;
  double _destLatitude = 26.46423, _destLongitude = 50.06358;
  Map<MarkerId, Marker> markers = {};

  VirtualChallenge ch;
  List<VirtualChallengeMembers> members = [];
  List<VirtualChallengeActivities> activities = [];
  StreamSubscription<QuerySnapshot> memberStream;
  bool loadedMembers = false;

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 0.5, size: Size(14, 14)),
        'assets/exercise/details_pin.png');
  }

  Future<Position> getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return position;
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    controller.setMapStyle(Utils.mapStyles);
    _controller.complete(controller);
    setState(() {
      /// origin marker
      _markers.add(Marker(
          markerId: MarkerId('first'),
          position: LatLng(currentLocation.latitude, currentLocation.longitude),
          icon: pinLocationIcon));

      /// destination marker
      _markers.add(Marker(
          markerId: MarkerId('last'),
          position: LatLng(
              currentLocation.latitude - 3, currentLocation.longitude + 30),
          icon: pinLocationIcon));

      /// destination marker
      _markers.add(Marker(
          markerId: MarkerId('mid'),
          position: LatLng(
              currentLocation.latitude - 1, currentLocation.longitude + 10),
          icon: pinLocationIcon));
    });
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  StorageSystem ss = new StorageSystem();
  bool isTrackAllowed = true;


  @override
  void initState() {
    super.initState();
    // setCustomMapPin();
    // geolocator = Geolocator();
    // setupCurrentLocation();
  }

  checkIfCurrentChallengeHasEnded() async {
    String currentCH = await ss.getItem("currentChallenge");
    if (currentCH == null) return;

    Map<String, dynamic> myCh = jsonDecode(currentCH);

    VirtualChallenge vc = VirtualChallenge.fromSnapshot(myCh);

    if(vc.id == ch.id) {
      setState(() {
        isTrackAllowed = true;
      });
    }
  }

  setupCurrentLocation() async {
    if (await Permission.locationWhenInUse.request().isGranted) {
      Position newLocation = await getCurrentLocation();
      setState(() {
        currentLocation = newLocation;
        mapToggle = true;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(memberStream != null) {
      memberStream.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    ch = ModalRoute.of(context).settings.arguments as VirtualChallenge;
    if(!loadedMembers) {
      checkIfCurrentChallengeHasEnded();
      getMembers();
      getChallengeActivities();
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios)),
          elevation: 0,
          title: Text(
            ch.title,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: getProportionateScreenWidth(15),
            ),
          ),
          centerTitle: false,
          actions: [
            TextButton(
              child: Text("Track Your Challenge", style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Color(MyColors.primaryColor),
                fontSize: 14.0
              ),),
              onPressed: () {
                Navigator.pushNamed(
                    context, TrackChallengeActivities.routeName, arguments: ch);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                "${(ch.funding_type == "Sponsor") ? ch.reward_value : ch.winner_amount} CRL to be won for \n${ch.distance}Km ${ch.activity_type} challenge.\n",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText1.copyWith(
                                  color: Color(MyColors.primaryColor),
                                  fontSize: getProportionateScreenWidth(15),
                                ),
                              ),
                              Stack(
                                children: [ //'assets/exercise/group_people.png',
                                  (members.length >= 1) ? CircleAvatar(backgroundImage: NetworkImage(members[0].image)) : SizedBox(),
                                  (members.length >= 2) ? Container(
                                    margin: EdgeInsets.only(left: 30.0),
                                    child: CircleAvatar(backgroundImage: NetworkImage(members[1].image)),
                                  ) : SizedBox(),
                                  (members.length >= 3) ? Container(
                                    margin: EdgeInsets.only(left: 60.0),
                                    child: CircleAvatar(backgroundImage: NetworkImage(members[2].image)),
                                  ) : SizedBox(),
                                  (members.length > 3) ? Container(
                                    margin: EdgeInsets.only(left: (members.length == 1) ? 50.0 : (members.length == 2) ? 80.0 : 110.0, top: 10.0),
                                    child: Text("+${members.length - 3}",
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .headline1
                                            .copyWith(
                                          fontSize:
                                          getProportionateScreenWidth(
                                              15),
                                        )),
                                  ) : SizedBox(),
                                ],
                              ),
                              SizedBox(height: 5.0,),
                              CountdownTimer(
                                endTime: DateTime.parse(ch.end_date).millisecondsSinceEpoch + 1000 * 30,
                                widgetBuilder: (_, CurrentRemainingTime time) {
                                  if (time == null) {
                                    return Text('Finished');
                                  }
                                  return Text('Ending in ${time.days ?? 0}D:${time.hours ?? 0}H:${time.min ?? 0}M:${time.sec ?? 0}S',
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                        fontSize:
                                        getProportionateScreenWidth(
                                            10),
                                      ));
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Rank',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                color: Colors.grey,
                                fontSize: getProportionateScreenWidth(12),
                              ),
                            ),
                            Text(
                              'KM Covered',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                color: Colors.grey,
                                fontSize: getProportionateScreenWidth(12),
                              ),
                            ),
                          ]),
                      SizedBox(
                        height: 20,
                      ),
                      ...buildMembersLayout(),

                      SizedBox(
                        height: 20,
                      ),
                      SvgPicture.asset("assets/exercise/track_race.svg"),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                            width: 190,
                            height: 30,
                            child: DefaultButton(
                              press: () {
                                Navigator.pushNamed(
                                    context, TrackChallengeActivities.routeName, arguments: ch);
                              },
                              loading: false,
                              fontSize: 12,
                              text: 'Track Your Challenge',
                            )),
                      ),
                          // (isTrackAllowed) ? : Text(""),
                      SizedBox(
                        height: 30,
                      ),
                      Divider(thickness: 3,),
                      ...buildActivitiesLayout()
                    ]))));
  }

  Map<String, dynamic> isUserAWinner(String uid) {
    Map<String, dynamic> result = new Map();
    if(ch.funding_type == "Sponsor") {
      if(ch.winner_reward_type == "First Winner Only" && ch.winner_rewarded) {
        List<dynamic> winners = ch.winners;
        if(winners.contains(uid)) {
          result["id"] = uid;
          result["position"] = 1;
        }
      }else if(ch.winner_reward_type == "Top 3 Winners") {
        List<dynamic> winners = ch.winners;
        int position = winners.indexWhere((element) => element == uid);
        if(position >= 0 ) {
          result["id"] = uid;
          result["position"] = position+1;
        }
      }
    }else { //this is a pool challenge
      if(ch.winner_rewarded) {
        List<dynamic> winners = ch.winners;
        if(winners.contains(uid)) {
          result["id"] = uid;
          result["position"] = 1;
        }
      }
    }
    return result;
  }

  Widget winnersBadge(String uid) {
    Map<String, dynamic> winnersCheck = isUserAWinner(uid);
    if(winnersCheck.isEmpty) {
      return SizedBox();
    }
    String imageAsset = "";
    if(winnersCheck["position"] == 1) {
      imageAsset = "assets/icons/gold.svg";
    }else if(winnersCheck["position"] == 2) {
      imageAsset = "assets/icons/silver.svg";
    }else {
      imageAsset = "assets/icons/bronze.svg";
    }
    return SvgPicture.asset(imageAsset, width: 25.0, height: 25.0,);
  }

  List<Widget> buildMembersLayout() {
    List<Widget> memWidget = [];

    // members.sort((a, b) => b.time_taken.compareTo(a.time_taken));

    int index = 1;

    members.forEach((mem) {

      memWidget.add(
        Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(

                    children: [
                      Text(
                        '$index.',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(
                          color: Colors.grey,
                          fontSize:
                          getProportionateScreenWidth(12),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Stack(
                        clipBehavior: Clip.hardEdge,
                        alignment: Alignment.bottomRight,
                        fit: StackFit.passthrough,
                        children: [
                          CircleAvatar(backgroundImage: NetworkImage(mem.image)),
                          winnersBadge(mem.user_uid),
                        ],
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        mem.username,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(
                          fontSize:
                          getProportionateScreenWidth(14),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${mem.km_covered} Km',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(
                          fontSize: getProportionateScreenWidth(12),
                        ),
                      ),
                      Text(
                        "in ${ExerciseService.formatTimeCoveredBySeconds(double.parse("${mem.time_taken}"))}",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(
                          fontSize: getProportionateScreenWidth(9),
                          color: Color(MyColors.titleTextColor)
                        ),
                      ),
                    ],
                  )
                ])),
      );

      memWidget.add(
        SizedBox(
          height: 10,
        ),
      );

      index++;

    });

    return memWidget;
  }

  List<Widget> buildActivitiesLayout() {
    List<Widget> acts = [];

    activities.forEach((act) {

      acts.add(
        ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(act.image),),
          title: Text(
            act.text,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(
              fontSize: getProportionateScreenWidth(12),
            ),
          ),
          subtitle: Text(new GeneralUtils().returnFormattedDate(act.created_date, act.time_zone), //time_zone
              style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(
            fontSize: getProportionateScreenWidth(12),
                color: Colors.grey
          )),
        )
      );

    });

    return acts;
  }

  getMembers() async {
    print(ch == null);
    memberStream = FirebaseFirestore.instance.collection("challenges").doc(ch.id).collection("joined-users").snapshots().listen((query) {
      loadedMembers = true;
      if(query.docs.isEmpty) return;
      members = [];
      query.docs.forEach((mem) {
        VirtualChallengeMembers vcm = VirtualChallengeMembers.fromSnapshot(mem.data());
        if(!mounted) return;
        setState(() {
          members.add(vcm);
        });
      });

      sortMembers();
    });

  }

  sortMembers() {
    List<VirtualChallengeMembers> buildMembers = members;

    buildMembers.sort((a, b) => b.km_covered.compareTo(a.km_covered));

    List<VirtualChallengeMembers> topMembers = members.where((element) => double.parse("${element.km_covered}") >= double.parse(ch.distance)).toList(); // get the top members that have completed the challenge

    if(topMembers.isNotEmpty) {
      topMembers.sort((a, b) =>
          a.time_taken.compareTo(b
              .time_taken)); // sort by the time. user with a lower time tops this list

      topMembers.forEach((tm) {
        buildMembers.removeWhere((element) => element.user_uid == tm.user_uid);
      });
    }

    List<VirtualChallengeMembers> newMembersList = [];

    // print("top = ${topMembers.length}");

    if(topMembers.isNotEmpty) {
      newMembersList.addAll(topMembers);
    }
    newMembersList.addAll(buildMembers);

    members = newMembersList;
  }

  getChallengeActivities() async {
    QuerySnapshot query = await FirebaseFirestore.instance.collection("challenges").doc(ch.id).collection("activities").limit(5).orderBy("timestamp", descending: true).get();
    if(query.docs.isEmpty) return;
    activities.clear();
    query.docs.forEach((act) {
      VirtualChallengeActivities vca = VirtualChallengeActivities.fromSnapshot(act.data());
      if(!mounted) return;
      setState(() {
        activities.add(vca);
      });
    });
  }
}

/*

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '12:34 PM',
                            style:
                            Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: getProportionateScreenWidth(12),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/exercise/end.png",
                                  height: 30.0),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '3255 more steps to go for Dupe',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                  fontSize: getProportionateScreenWidth(12),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '12:34 PM',
                            style:
                            Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: getProportionateScreenWidth(12),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/exercise/end.png",
                                  height: 30.0),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '3255 more steps to go for Dupe',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                  fontSize: getProportionateScreenWidth(12),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),


                      Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '1.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                        color: Colors.grey,
                                        fontSize:
                                        getProportionateScreenWidth(12),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Image.asset("assets/exercise/end.png",
                                        height: 40.0),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Elie',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                        fontSize:
                                        getProportionateScreenWidth(14),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '12345',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                    fontSize: getProportionateScreenWidth(12),
                                  ),
                                ),
                              ])),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '2.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                        color: Colors.grey,
                                        fontSize:
                                        getProportionateScreenWidth(12),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Image.asset("assets/exercise/end.png",
                                        height: 40.0),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Elie',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                        fontSize:
                                        getProportionateScreenWidth(14),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '12345',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                    fontSize: getProportionateScreenWidth(12),
                                  ),
                                ),
                              ])),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '3.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                        color: Colors.grey,
                                        fontSize:
                                        getProportionateScreenWidth(12),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Image.asset("assets/exercise/end.png",
                                        height: 40.0),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Elie',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                        fontSize:
                                        getProportionateScreenWidth(14),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '12345',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                    fontSize: getProportionateScreenWidth(12),
                                  ),
                                ),
                              ])),



                              Container(
                          height: MediaQuery.of(context).size.height / 4,
                          width: MediaQuery.of(context).size.width / 1.3,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                    child: Stack(children: <Widget>[
                                      mapToggle
                                          ? GoogleMap(
                                        onMapCreated: _onMapCreated,
                                        initialCameraPosition: CameraPosition(
                                          zoom: 10,
                                          target: LatLng(
                                              currentLocation.latitude,
                                              currentLocation.longitude),
                                        ),rotateGesturesEnabled: true,
                                        tiltGesturesEnabled: true,
                                        zoomControlsEnabled: true,
                                        zoomGesturesEnabled: true,scrollGesturesEnabled: true,
                                        markers: _markers,
                                      )
                                          : Center(
                                        child: Text(
                                          'Loading...',
                                          style: TextStyle(fontSize: 28),
                                        ),
                                      ),
                                    ])),
                              ])),
* */
