import 'dart:convert';

import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/coral_back_button.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/g_chat_screen/components/avatar_selection.dart';
import 'package:coral_reef/g_chat_screen/components/topics_selection.dart';
import 'package:coral_reef/size_config.dart';
import 'package:coral_reef/tracker_screens/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class InterestedTopics extends StatefulWidget {
  static final routeName = "interested-topics";

  @override
  State<StatefulWidget> createState() => _InterestedTopics();
}

class _InterestedTopics extends State<InterestedTopics> {
  StorageSystem ss = new StorageSystem();

  List<String> topics = [
    "Sex life",
    "Relationships",
    "My body",
    "Health",
    "Period and cycle",
    "Parenting",
    "Pregnancy",
    "Entertainment",
    "Harmony",
    "Trying to conceive"
  ];

  List<String> selectedTopics = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Container(
            margin: EdgeInsets.only(left: 30.0),
            child: CoralBackButton(),
          ),
          centerTitle: true,
          toolbarHeight: 120.0,
          title: Text(
            "Select interested topics",
            style: Theme.of(context).textTheme.headline2.copyWith(
                color: Color(MyColors.titleTextColor),
                fontSize: getProportionateScreenWidth(15)),
          ),
        ),
        body: SafeArea(
            child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(30)),
            child: Container(
              child: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Center(
                      child: Text(
                          "Add topics you'll be interested in.\nInterest are private to you",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Colors.grey,
                              fontSize: getProportionateScreenWidth(14)))),
                  SizedBox(
                    height: 50.0,
                  ),
                  // GridView.count(
                  //   shrinkWrap: true,
                  //   addRepaintBoundaries: false,
                  //   addAutomaticKeepAlives: false,
                  //   clipBehavior: Clip.none,
                  //   crossAxisSpacing: 10.0,
                  //   mainAxisSpacing: 10.0,
                  //   childAspectRatio: 1,
                  //   crossAxisCount: 3,
                  //   primary: false,
                  //   children: topics
                  //       .map((opt) => TopicsSelection(
                  //             text: opt,
                  //             selected:
                  //                 (selectedTopics.contains(opt)) ? true : false,
                  //             onTap: () {
                  //               if(selectedTopics.contains(opt)) {
                  //                 setState(() {
                  //                   selectedTopics.remove(opt);
                  //                 });
                  //               }else {
                  //                 setState(() {
                  //                   selectedTopics.add(opt);
                  //                 });
                  //               }
                  //               // print(selectedTopics);
                  //             },
                  //           ))
                  //       .toList(),
                  // ),
                  // ListView.builder(
                  //     itemBuilder: (context, index) {
                  //       return Row(
                  //         children: [
                  //           TopicsSelection(
                  //             text: topics[index],
                  //             selected: (selectedTopics.contains(topics[index]))
                  //                 ? true
                  //                 : false,
                  //             onTap: () {
                  //               if (selectedTopics.contains(topics[index])) {
                  //                 setState(() {
                  //                   selectedTopics.remove(topics[index]);
                  //                 });
                  //               } else {
                  //                 setState(() {
                  //                   selectedTopics.add(topics[index]);
                  //                 });
                  //               }
                  //               // print(selectedTopics);
                  //             },
                  //           )
                  //         ],
                  //       );
                  //     },
                  //     scrollDirection: Axis.vertical,
                  //     shrinkWrap: true,
                  //     reverse: true,
                  //     semanticChildCount: 3,
                  //     itemCount: topics.length),
                  Column(
                    children: [
                      Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: listTopics(0, 2)),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: listTopics(2, 4)),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: listTopics(4, 6)),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: listTopics(6, 8)),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: listTopics(8, 10)),
                    ],
                  ),
                  SizedBox(
                    height: 100.0,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: DefaultButton(
                      text: "Continue",
                      press: () async {
                        if (selectedTopics.isEmpty) {
                          new GeneralUtils().displayAlertDialog(
                              context,
                              "Info Message",
                              "Please select at least one topic.");
                          return;
                        }
                        Map<String, dynamic> gTopics = new Map();
                        gTopics["selectedTopics"] = selectedTopics;
                        await ss.setPrefItem("topics", jsonEncode(gTopics));
                        await ss.setPrefItem("gchatSetup", "true");
                        // Navigator.pushNamed(context, HomeScreen.routeName);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new CoralBottomNavigationBar(
                                  isGChat: true,
                                  hasGChatSetup: true,
                                )));
                      },
                    ),
                  ),
                ],
              )),
            ),
          ),
        )));
  }

  List<Widget> listTopics(int start, int end) {
    List<Widget> tops = [];
    topics.sublist(start, end).forEach((opt) {
      tops.add(TopicsSelection(
        text: opt,
        selected: (selectedTopics.contains(opt)) ? true : false,
        onTap: () {
          if (selectedTopics.contains(opt)) {
            setState(() {
              selectedTopics.remove(opt);
            });
          } else {
            setState(() {
              selectedTopics.add(opt);
            });
          }
          print(selectedTopics);
        },
      ));
    });
    return tops;
  }

  checkIfExists(String optItem) {
    selectedTopics.contains(optItem);
  }
}
