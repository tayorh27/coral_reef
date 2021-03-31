import 'dart:convert';

import 'package:coral_reef/Utils/storage.dart';
import 'package:flutter/material.dart';

class GChatUserAvatar extends StatefulWidget {

  final double avatarSize;
  final Map<String, dynamic> avatarData;

  GChatUserAvatar(this.avatarSize, {this.avatarData});

  @override
  State<StatefulWidget> createState() => _GChatUserAvatar();
}

class _GChatUserAvatar extends State<GChatUserAvatar> {

  StorageSystem ss = new StorageSystem();

  Map<String, dynamic> gChat = new Map();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    gChat["selectedAvatar"] = "avatar1";
    gChat["selectedColor"] = 0xFFB0BEFF;

    if(widget.avatarData != null) {
      gChat = widget.avatarData;
      return;
    }

    ss.getItem("avatar").then((value) {
      if(value != null) {
        setState(() {
          gChat = jsonDecode(value);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build\
    return Container(
      width: widget.avatarSize,
      height: widget.avatarSize,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.avatarSize/2),
          color: Color(gChat["selectedColor"])
      ),
      child: Image.asset("assets/images/${gChat["selectedAvatar"]}.png"),
    );
  }
}
