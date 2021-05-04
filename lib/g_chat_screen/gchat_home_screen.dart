import 'dart:async';

import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/g_chat_screen/components/gchat_header.dart';
import 'package:coral_reef/g_chat_screen/sections/blog_post_screen.dart';
import 'package:coral_reef/g_chat_screen/sections/create_new_gchat.dart';
import 'package:coral_reef/g_chat_screen/sections/gchat_screen.dart';
import 'package:coral_reef/g_chat_screen/sections/job_opportunities.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../size_config.dart';
import 'components/gchat_scrolling_options.dart';

class GChatHomeScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _GChatHomeScreen();
}

StreamController<bool> controller = BehaviorSubject<bool>();

void updateHideFloat(bool float) {
  controller.add(float);
}

class _GChatHomeScreen extends State<GChatHomeScreen> {

  List<Map<String, dynamic>> screens = [
    {"screen_name": "G-chat", "screen_class": GChatTimelineScreen((hideFloat){
      updateHideFloat(hideFloat);
    })},
    {"screen_name": "Blog post", "screen_class": BlogPostScreen()},
    {
      "screen_name": "Job opportunities",
      "screen_class": JobOpportunitiesScreen()
    },
  ];

  Widget selectedScreen = GChatTimelineScreen((bool hideFloat) {
    updateHideFloat(hideFloat);
  });

  String selectedMenu = "G-chat";

  bool hideFloatingActionButton = false;

  Stream stream = controller.stream;
  StreamSubscription<bool> streamSubscription;

  bool isListening = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("hello -- ${controller.stream}");

    // if(controller.stream.isBroadcast){
    //   print("--__----hello -- ${controller.stream.isBroadcast}");
    //   return;
    // }

    streamSubscription = stream.listen((event) {
      isListening = true;
      if(!mounted) return;
      setState(() {
        hideFloatingActionButton = event;
      });
    });
    // print("my data = mee");
    // stream.asBroadcastStream(onListen: (event) {
    //     event.onData((data) {
    //       print("my data = $data");
    //       if(!mounted) return;
    //       setState(() {
    //         hideFloatingActionButton = data;
    //       });
    //     });
    // });
  }

  @override
  void didUpdateWidget(covariant GChatHomeScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print("i guess");
  }

  @override
  void reassemble() {
    // TODO: implement reassemble
    super.reassemble();
    print("reassumble");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("dispose in gchat");
    // controller.close();
    streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.grey[50],
        floatingActionButton: (selectedMenu == "G-chat") ? Visibility(visible: !hideFloatingActionButton,child: FloatingActionButton(
          backgroundColor: Color(MyColors.primaryColor),
          child: Icon(Icons.add, color: Colors.white, size: 32.0,),
          onPressed: (){
            Navigator.pushNamed(context, CreateNewGChat.routeName);
          },
          tooltip: "Create New Post",
        )) : null,
        body: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 40.0),
                child: GChatHeader(),
              ),
              Container(
                margin: EdgeInsets.only(top: 140.0),
                child: GChatScrollingOptions(
                  onSelectedMenu: (String selectedMenu) {
                    getTrackerScreen(selectedMenu);
                  },
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                margin: EdgeInsets.only(top: 220.0),
                child: selectedScreen,
              )
            ],
          ),
        ));
  }

  /*
   * get the tracker screen to display once the user selects a tracker item
   * if no wellness record found, user goes to wellness setup screen
   */
  getTrackerScreen(String _selectedMenu) {
    // print(selectedMenu);
    Map<String, dynamic> findScreen =
        screens.firstWhere((element) => element["screen_name"] == _selectedMenu);
    if (findScreen == null) {
      return;
    }
    String route = findScreen["screen_route"];
    setState(() {
      selectedScreen = findScreen["screen_class"];
      selectedMenu = _selectedMenu;
    });
  }
}
