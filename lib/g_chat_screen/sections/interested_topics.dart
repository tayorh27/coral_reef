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

  bool loading = false;

  TextEditingController _textEditingController = new TextEditingController(text: "");

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
                          "Add topics you'll be interested in.\nInterest are private to you.",
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
                    height: 50.0,
                  ),
                  YourNameText(),
                  SizedBox(height: getProportionateScreenHeight(5)),
                  yourNameField(),
                  SizedBox(
                    height: 70.0,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: DefaultButton(
                      text: "Continue",
                      loading: loading,
                      press: () async {
                        if (selectedTopics.isEmpty) {
                          new GeneralUtils().displayAlertDialog(
                              context,
                              "Info Message",
                              "Please select at least one topic.");
                          return;
                        }
                        if(_textEditingController.text.isEmpty) {
                          new GeneralUtils().displayAlertDialog(
                              context,
                              "Info Message",
                              "Please enter your anonymous username.");
                          return;
                        }
                        setState(() {
                          loading = true;
                        });
                        Map<String, dynamic> gTopics = new Map();
                        gTopics["selectedTopics"] = selectedTopics;
                        gTopics["username"] = _textEditingController.text;
                        await ss.setPrefItem("topics", jsonEncode(gTopics));
                        await ss.setPrefItem("gchatSetup", "true");
                        // Navigator.pushNamed(context, HomeScreen.routeName);
                        //subscribe to topics
                        String getUser = await ss.getItem("user");
                        Map<String, dynamic> userData = jsonDecode(getUser);
                        selectedTopics.forEach((topic) async {
                          await new GeneralUtils().subscribeToTopic(topic, userData["msgId"]);
                        });
                        setState(() {
                          loading = false;
                        });
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

  Widget yourNameField() {
    return Container(
      decoration: BoxDecoration(
        color: Color(MyColors.formFillColor),
        border: Border.all(
          color: Color(MyColors.primaryColor),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: TextFormField(
        keyboardType: TextInputType.name,
        obscureText: false,
        controller: _textEditingController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 15,
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          //hintText: '',
        ),
      ),
    );
  }
}

class YourNameText extends StatelessWidget {
  const YourNameText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Enter your anonymous username",
          style: Theme.of(context)
              .textTheme
              .subtitle1
              .copyWith(color: Color(MyColors.titleTextColor)),
        ),
        Spacer(),
      ],
    );
  }
}
