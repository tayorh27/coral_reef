import 'dart:math';

import 'package:coral_reef/ListItem/model_jobs.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/g_chat_screen/components/shimmer_effects.dart';
import 'package:coral_reef/size_config.dart';
import 'package:flutter/material.dart';

class JobOpportunitiesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _JobOpportunitiesScreen();
}

class _JobOpportunitiesScreen extends State<JobOpportunitiesScreen> {
  bool hasLoadedContent = false;
  var imageNetwork = NetworkImage(
      "https://firebasestorage.googleapis.com/v0/b/taconlinegiftshop.appspot.com/o/logo-3.png?alt=media&token=92f27f22-efdb-4455-9628-8e9ac7ae99c6");

  List<int> colors = [
    MyColors.stroke1Color,
    MyColors.stroke2Color,
    MyColors.stroke3Color,
    MyColors.other4,
    MyColors.other5
  ];

  List<JobOpportunity> jobs = [
    JobOpportunity(
        "001",
        "Full Stack Mobile App Developer",
        "Full Time",
        "Feb 15, 2021",
        "San Francisco, CA",
        "https://google.com/",
        "Experienced Level",
        "timestamp"),
    JobOpportunity(
        "001",
        "Front-End Web Developer",
        "Contractor",
        "Feb 15, 2021",
        "San Francisco, CA",
        "https://google.com/",
        "Senior Level",
        "timestamp"),
    JobOpportunity("001", "Back-End Web Developer", "Full Time", "Feb 15, 2021",
        "San Francisco, CA", "https://google.com/", "Junior Level", "timestamp"),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imageNetwork.resolve(new ImageConfiguration()).addListener(
        new ImageStreamListener((ImageInfo image, bool synchronousCall) {
      if (!mounted) return;
      print(synchronousCall);
      setState(() {
        hasLoadedContent = true;
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (!hasLoadedContent)
        ? ShimmerEffects(LoadingJobOpportunities(), 2.3)
        : Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(top: 30.0),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(jobs[index].title,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: Color(MyColors.titleTextColor),
                              fontSize: getProportionateScreenWidth(17))),
                      subtitle: dateText(
                        jobs[index].created_date,
                      ),
                      isThreeLine: true,
                      trailing: jobTypeContainer(jobs[index].job_type),
                      onTap: () {
                        openJobLink(jobs[index].link);
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Text(
                            jobs[index].misc,
                            style:
                                Theme.of(context).textTheme.subtitle1.copyWith(
                                      color: Color(MyColors.titleTextColor),
                                      fontSize: getProportionateScreenWidth(13),
                                    ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(right: 15.0),
                            child: Text(
                              jobs[index].location,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                    color: Color(MyColors.titleTextColor),
                                    fontSize: getProportionateScreenWidth(13),
                                  ),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Divider(
                      height: 1.0,
                      color: Colors.grey[200],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                );
              },
              itemCount: jobs.length,
              scrollDirection: Axis.vertical,
            ),
          );
  }

  Widget dateText(String jobDate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Posted on ",
          style: Theme.of(context).textTheme.subtitle1.copyWith(
                color: Color(MyColors.titleTextColor),
                fontSize: getProportionateScreenWidth(13),
              ),
        ),
        Text(
          jobDate,
          style: Theme.of(context).textTheme.subtitle1.copyWith(
              fontSize: getProportionateScreenWidth(13),
              fontWeight: FontWeight.bold,
              color: Color(MyColors.titleTextColor)),
        ),
        IconButton(icon: Icon(Icons.open_in_new_rounded, size: 20.0,), onPressed: (){openJobLink("");})//jobs[index].link
      ],
    );
  }

  Widget jobTypeContainer(String jobType) {
    final colorIndex = Random().nextInt(4);
    return Container(
      height: 30.0,
      decoration: BoxDecoration(
          color: Color(colors[colorIndex]).withOpacity(0.5),//MyColors.other3
          borderRadius: BorderRadius.circular(10.0)),
      padding: EdgeInsets.only(right: 10, left: 10, top: 0.0, bottom: 0.0),
      margin: EdgeInsets.only(right: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(jobType,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: Color(MyColors.primaryColor))),
        ],
      ),
    );
  }

  openJobLink(String jobLink) {}
}
