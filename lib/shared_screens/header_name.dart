
import 'dart:convert';

import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:flutter/material.dart';

import '../size_config.dart';

class Heading extends StatefulWidget {

  const Heading({
    Key key,this.body
  }) : super(key: key);
  final String body;

  @override
  State<StatefulWidget> createState() => _Heading();
}

class _Heading extends State<Heading> {

  StorageSystem ss = new StorageSystem();
  String username = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ss.getItem("user").then((value) {
      Map<String, dynamic> user = jsonDecode(value);
      setState(() {
        username = user["firstname"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Hi $username,",
              style: Theme.of(context).textTheme.headline1.copyWith(
                  color: Color(MyColors.titleTextColor), fontSize: getProportionateScreenWidth(25)
              ),
            ),
          ],
        ),
        (widget.body.isNotEmpty) ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.body,
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: Color(MyColors.titleTextColor), fontSize: getProportionateScreenWidth(13)
              ),
            ),
          ],
        ) : SizedBox(),
      ],
    );
  }
}