
import 'dart:convert';

import 'package:coral_reef/Utils/storage.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class UserProfilePic extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserProfilePic();
}

class _UserProfilePic extends State<UserProfilePic> {

  StorageSystem ss = new StorageSystem();

  String picture = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUerData();
  }

  getUerData() async {
    String user = await ss.getItem("user");
    dynamic json = jsonDecode(user);
    print("pic = ${json["picture"]}");
    setState(() {
      picture = json["picture"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.hardEdge,
        children: [
          (picture == null || picture.isEmpty) ? CircleAvatar(backgroundImage: AssetImage("assets/images/default_avatar.png"),) : CircleAvatar(backgroundImage: NetworkImage(picture),),
          // Positioned(
          //   right: 30,
          //   bottom: 30,
          //   child: SizedBox(
          //     height: 32,
          //     width: 32,
          //     child: FlatButton(
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(50),
          //         side: BorderSide(color: Colors.white),
          //       ),
          //       color: Color(0xFFF5F6F9),
          //       onPressed: () {},
          //       child: Icon(Icons.edit),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}