import 'dart:convert';

import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/coral_back_button.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/g_chat_screen/components/avatar_selection.dart';
import 'package:coral_reef/size_config.dart';
import 'package:flutter/material.dart';

import 'interested_topics.dart';

class AvatarFinalSection extends StatefulWidget {
  static final routeName = "avatar-final-section";

  AvatarFinalSection();//this.selectedAvatar

  @override
  State<StatefulWidget> createState() => _AvatarFinalSection();
}

class _AvatarFinalSection extends State<AvatarFinalSection> {

  StorageSystem ss = new StorageSystem();

  List<String> avatarImages = [
    "avatar1",
    "avatar2",
    "avatar3",
    "avatar4",
    "avatar5",
    "avatar6",
    "avatar7",
    "avatar8",
    "avatar9"
  ];

  List<int> colors = [
    MyColors.avatarColor1,
    MyColors.avatarColor2,
    MyColors.avatarColor3,
    MyColors.avatarColor4,
    MyColors.avatarColor5,
    MyColors.avatarColor6,
    MyColors.avatarColor7,
    MyColors.avatarColor8,
  ];

  String selectedAvatar = "avatar1";
  int selectedColor = 0xFFB0BEFF;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ss.getItem("selectedAvatar").then((value) {
      String v = value ?? "";
      setState(() {
        selectedAvatar = v;
      });
    });
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
            "Choose your Avatar Color",
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
                  SizedBox(
                    height: 30.0,
                  ),
                  Center(
                    child: Container(
                      width: 150.0,
                        height: 150.0,
                        padding: EdgeInsets.all(30.0),
                        decoration: BoxDecoration(
                            color: Color(selectedColor),
                            borderRadius: BorderRadius.circular(75.0),),
                        child: Image.asset(
                          "assets/images/$selectedAvatar.png",
                          height: 50.0,
                          width: 50.0,
                        )),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    height: 40.0,
                    child: ListView.builder(itemBuilder: (context, index) {
                      return InkWell(
                        onTap: (){
                          setState(() {
                            selectedColor = colors[index];
                          });
                        },
                        child: Container(
                          width: 40.0,
                          height: 40.0,
                          margin: EdgeInsets.only(right: 15.0),
                          decoration: BoxDecoration(
                            color: Color(colors[index]),
                            borderRadius: BorderRadius.circular(20.0),
                          border: (selectedColor == colors[index]) ? Border.all(color: Color(MyColors.primaryColor), width: 2.0) : Border()),
                        ),
                      );
                    },scrollDirection: Axis.horizontal, itemCount: colors.length,shrinkWrap: true,),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 20.0,
                    childAspectRatio: 0.9,
                    crossAxisCount: 3,
                    primary: false,
                    children: avatarImages
                        .map((opt) => AvatarSelection(
                              image: "assets/images/$opt.png",
                              avatarName: opt,
                              isSelected:
                                  (selectedAvatar == opt) ? true : false,
                      returnSelected: (item) {},
                            ))
                        .toList(),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  DefaultButton(
                    text: "Save",
                    press: () async {
                      await ss.deletePref("selectedAvatar");
                      Map<String, dynamic> gChat = new Map();
                      gChat["selectedAvatar"] = selectedAvatar;
                      gChat["selectedColor"] = selectedColor;
                      await ss.setPrefItem("avatar", jsonEncode(gChat));
                      Navigator.pushNamed(context, InterestedTopics.routeName);
                    },
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                ],
              )),
            ),
          ),
        )));
  }
}
