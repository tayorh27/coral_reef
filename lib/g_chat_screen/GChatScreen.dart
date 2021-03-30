
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/size_config.dart';
import 'package:flutter/material.dart';

class GChatScreen extends StatefulWidget {

  static final routeName = "g-chat-screen";

  @override
  State<StatefulWidget> createState() => _GChatScreen();

}

class _GChatScreen extends State<GChatScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Text(""),
        centerTitle: true,
        toolbarHeight: 120.0,
        title: Text("G-Chat", style: Theme.of(context).textTheme.headline2.copyWith(
          color: Color(MyColors.titleTextColor),
          fontSize: getProportionateScreenWidth(18)
        ),),
      ),
      body: Container(),
    );
  }
}