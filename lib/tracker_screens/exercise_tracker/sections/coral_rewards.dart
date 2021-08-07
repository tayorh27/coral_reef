import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/ListItem/model_challenge.dart';
import 'package:coral_reef/ListItem/model_challenge_rewards.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/shared_screens/EmptyScreen.dart';
import 'package:coral_reef/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';
import 'community_challenge_details.dart';

class CoralRewards extends StatefulWidget {
  static final routeName = "coralRewards";
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<CoralRewards> {
  List<ChallengeRewards> rewards = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRewards();
  }

  getRewards() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("my-rewards")
        .orderBy("timestamp", descending: true)
        .get();
    if (query.docs.isEmpty) return;

    if (!mounted) return;
    query.docs.forEach((reward) {
      ChallengeRewards rw = ChallengeRewards.fromSnapshot(reward.data());
      setState(() {
        rewards.add(rw);
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
            'My Coral Rewards',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                fontSize: getProportionateScreenWidth(15),
                fontWeight: FontWeight.bold),
          ),
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    SvgPicture.asset(
                      "assets/exercise/coral_reward.svg",
                      height: 100,
                    ),
                    Text(
                      'You have earned',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: getProportionateScreenWidth(15),
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      '${rewards.length}',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: getProportionateScreenWidth(18),
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'Coral reward(s)',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: getProportionateScreenWidth(15),
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ]),
              (rewards.isEmpty)
                  ? EmptyScreen("No recent rewards.")
                  : SizedBox(),
              ...buildRewardsLayout()
            ],
        ));
  }

  List<Widget> buildRewardsLayout() {
    if (rewards.isEmpty) {
      return [];
    }
    List<Widget> layout = [];

    Map<String, dynamic> categorizedRewards = new Map();

    //categorize the rewards based on month year

    //first loop
    rewards.forEach((reward) {
      if (categorizedRewards[reward.month_year] == null) {
        categorizedRewards[reward.month_year] = [reward];
      } else {
        List<dynamic> rws = categorizedRewards[reward.month_year];
        rws.add(reward);
        categorizedRewards[reward.month_year] = rws;
      }
    });

    //second loop through the map
    categorizedRewards.forEach((key, value) {
      List<dynamic> rws = value;
      layout.add(headerLayout(key));
      layout.add(SizedBox(
        height: 20,
      ));
      layout.add(innerLayout(rws));
      layout.add(SizedBox(
        height: 20,
      ));
    });

    return layout;
  }

  Widget headerLayout(String value) {
    return Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.grey[100],
        height: 40,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(value,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Colors.grey,
                            fontSize: getProportionateScreenWidth(13),
                          ))),
            ]));
  }

  Widget innerLayout(List<dynamic> rws) {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: buildAwardsRewarded(rws)));
  }

  List<Widget> buildAwardsRewarded(List<dynamic> rws) {
    List<Widget> layout = [];

    rws.forEach((r) {
      layout.add(Column(children: [
        InkWell(
          child: winnersBadge(r.position),
          onTap: () async {
            new GeneralUtils().showToast(context, "Fetching challenge data...");
            VirtualChallenge vc = await getChallengeData(r.challenge_id);
            if (vc == null) return;
            Navigator.pushNamed(context, CommunityChallengeDetails.routeName,
                arguments: vc);
          },
        )
      ]));
    });

    return layout;
  }

  Widget winnersBadge(int position) {
    String imageAsset = "";
    if (position == 1) {
      imageAsset = "assets/icons/gold.svg";
    } else if (position == 2) {
      imageAsset = "assets/icons/silver.svg";
    } else {
      imageAsset = "assets/icons/bronze.svg";
    }
    return SvgPicture.asset(
      imageAsset,
      height: 50.0,
    );
  }

  Future<VirtualChallenge> getChallengeData(String id) async {
    DocumentSnapshot query =
        await FirebaseFirestore.instance.collection("challenges").doc(id).get();
    if (!query.exists) return null;
    VirtualChallenge vc = VirtualChallenge.fromSnapshot(query.data());
    return vc;
  }
}

/*

              Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey[100],
                  height: 40,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            padding: EdgeInsets.only(left: 20),
                            child: Text('MARCH 2021',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      color: Colors.grey,
                                      fontSize: getProportionateScreenWidth(13),
                                    ))),
                      ])),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SvgPicture.asset(
                            "assets/exercise/silver.svg",
                            height: 50,
                          ),
                          Text('12617 steps',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    color: Colors.grey,
                                    fontSize: getProportionateScreenWidth(13),
                                  ))
                        ],
                      ),
                      Column(
                        children: [
                          SvgPicture.asset(
                            "assets/exercise/bronze.svg",
                            height: 50,
                          ),
                          Text('12617 steps',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    color: Colors.grey,
                                    fontSize: getProportionateScreenWidth(13),
                                  ))
                        ],
                      ),
                      Text('')
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey[100],
                  height: 40,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            padding: EdgeInsets.only(left: 20),
                            child: Text('FEBRUARY 2021',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      color: Colors.grey,
                                      fontSize: getProportionateScreenWidth(13),
                                    ))),
                      ])),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SvgPicture.asset(
                            "assets/exercise/bronze.svg",
                            height: 50,
                          ),
                          Text('12617 steps',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    color: Colors.grey,
                                    fontSize: getProportionateScreenWidth(13),
                                  ))
                        ],
                      ),
                      Column(
                        children: [
                          SvgPicture.asset(
                            "assets/exercise/gold.svg",
                            height: 50,
                          ),
                          Text('12617 steps',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    color: Colors.grey,
                                    fontSize: getProportionateScreenWidth(13),
                                  ))
                        ],
                      ),
                      Column(
                        children: [
                          SvgPicture.asset(
                            "assets/exercise/gold.svg",
                            height: 50,
                          ),
                          Text('12617 steps',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    color: Colors.grey,
                                    fontSize: getProportionateScreenWidth(13),
                                  ))
                        ],
                      ),
                    ],
                  ))
* */
