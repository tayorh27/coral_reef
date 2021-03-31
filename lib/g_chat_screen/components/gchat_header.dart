import 'dart:convert';

import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GChatHeader extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GChatHeader();
}

class _GChatHeader extends State<GChatHeader> {

  StorageSystem ss = new StorageSystem();

  Map<String, dynamic> gChat = new Map();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    gChat["selectedAvatar"] = "avatar1";
    gChat["selectedColor"] = 0xFFB0BEFF;

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
    // TODO: implement build
    final date = DateTime.now();
    final months = ["JAN", "FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];
    final days = ["MON","TUE","WED","THU","FRI","SAT","SUN"];
    return ListTile(
      title: Container(height: 15.0,),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50.0,
            height: 50.0,
            margin: EdgeInsets.only(top: 15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Color(gChat["selectedColor"])
            ),
            child: Image.asset("assets/images/${gChat["selectedAvatar"]}.png"),
          )
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SvgPicture.asset("assets/icons/daylight.svg", height: 22.0),
          Container(width: 10.0,),
          Text("${days[date.weekday - 1]} ${date.day} ${months[date.month - 1]}", style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Color(MyColors.primaryColor),
              fontSize: getProportionateScreenWidth(12)
          ),),
          Container(width: 10.0,),
          SvgPicture.asset("assets/icons/clarity_notification-outline-badged.svg", height: 22.0),
        ],
      ),
    );
  }
}

// class TrackerScreenHeader {
//
//   PreferredSizeWidget appBar() {
//     return AppBar(
//       backgroundColor: Colors.white,
//       toolbarHeight: 200.0,
//       leading: Container(
//         margin: EdgeInsets.only(left: 20.0),
//         child: CircleAvatar(
//           child: SvgPicture.asset("assets/icons/default_avatar.svg", height: 32.0),
//         ),
//       ),
//       actions: [
//         SvgPicture.asset("assets/icons/daylight.svg", height: 32.0),
//         SvgPicture.asset("assets/icons/clarity_notification-outline-badged.svg", height: 32.0),
//       ],
//     );
//   }
// }
