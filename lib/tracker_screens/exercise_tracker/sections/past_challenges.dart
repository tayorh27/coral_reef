import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/ListItem/model_challenge.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/shared_screens/EmptyScreen.dart';
import 'package:coral_reef/size_config.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/services/exercise_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:readmore/readmore.dart';

import '../../../constants.dart';
import 'community_challenge_details.dart';

class PastChallenges extends StatefulWidget {
  static final routeName = "pastChallenges";
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<PastChallenges> {

  List<VirtualChallenge> challenges = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChallenges();
  }

  getChallenges() async {
    QuerySnapshot query = await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("my-challenges").orderBy("timestamp", descending: true).get();
    if(query.docs.isEmpty) return;

    if(!mounted) return;
    query.docs.forEach((chan) {
      VirtualChallenge ch = VirtualChallenge.fromSnapshot(chan.data());
      setState(() {
        challenges.add(ch);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios)),
          elevation: 0,
          title: Text(
            'My Recent Challenges',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                fontSize: getProportionateScreenWidth(15),
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(20),
                child: (challenges.isEmpty) ? EmptyScreen("No recent challenges.") : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: buildPastChallengesLayout()
                )
            )
        )
    );
  }

  List<Widget> buildPastChallengesLayout() {

    List<Widget> pastWidgets = [];

    challenges.forEach((ch) {

      double requiredDistance = double.parse(ch.distance);
      double coveredDistance = (ch.km_covered == null) ? 0.0 : double.parse("${ch.km_covered}");

      double percentDistance = ((coveredDistance / requiredDistance) * 100) / 100;

      // print(ch.toJSON());

      pastWidgets.add(InkWell(
          onTap: () async {
            new GeneralUtils().showToast(context, "Fetching challenge data...");
            VirtualChallenge vc = await getChallengeData(ch.id);
            if(vc == null) return;
            Navigator.pushNamed(
                context,
                CommunityChallengeDetails
                    .routeName, arguments: vc);
          },
          child: ListTile(
            leading: SvgPicture.asset("assets/exercise/foot.svg",
                height: 50.0),
            title: Text(ch.title,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(
                  fontSize:
                  getProportionateScreenWidth(13),
                )),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReadMoreText(
                  ch.description,
                  trimLines: 1,
                  colorClickableText: Color(MyColors.primaryColor),
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'more',
                  trimExpandedText: 'less',
                  style: Theme
                      .of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(fontSize: 12.0,
                      color: Color(MyColors.titleTextColor)),
                  moreStyle: Theme
                      .of(context)
                      .textTheme
                      .headline2
                      .copyWith(fontSize: 12.0,
                      color: Color(MyColors.primaryColor)),
                  lessStyle: Theme
                      .of(context)
                      .textTheme
                      .headline2
                      .copyWith(fontSize: 12.0,
                      color: Color(MyColors.primaryColor)),
                ),
                SizedBox(height: 10.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // SvgPicture.asset(
                        //     "assets/exercise/female.svg",
                        //     height: 12.0),
                        // SizedBox(
                        //   width: 5,
                        // ),
                        Text(getCreatedDate(ch.created_date),
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                              fontSize:
                              getProportionateScreenWidth(
                                  10),
                            )),
                      ],
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(ExerciseService.formatTimeCoveredBySeconds(double.parse("${ch.time_taken}")),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(
                          color: Colors.grey,
                          fontSize:
                          getProportionateScreenWidth(10),
                        )),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    LinearPercentIndicator(
                      padding: EdgeInsets.zero,
                      width: MediaQuery.of(context).size.width / 2.2,
                      lineHeight: 4.0,
                      percent: percentDistance,
                      progressColor: Color(MyColors.primaryColor),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text("${ch.km_covered} / ${ch.distance} km",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(
                          color: Colors.grey,
                          fontSize:
                          getProportionateScreenWidth(10),
                        )),
                  ],
                )
              ],
            ),
            isThreeLine: true,
          )));

      pastWidgets.add(Divider(thickness: 3,));

    });

    return pastWidgets;

  }

  Future<VirtualChallenge> getChallengeData(String id) async {
    DocumentSnapshot query = await FirebaseFirestore.instance.collection("challenges").doc(id).get();
    if(!query.exists) return null;
    VirtualChallenge vc = VirtualChallenge.fromSnapshot(query.data());
    return vc;
  }

  getCreatedDate(String date) {
    List<String> months = ["Jan", "Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];

    final cd = DateTime.parse(date);

    return "${months[cd.month - 1]} ${cd.day}, ${cd.year}";
  }
}
