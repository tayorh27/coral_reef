import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/g_chat_screen/sections/avatar_final_section.dart';
import 'package:coral_reef/size_config.dart';
import 'package:flutter/material.dart';

import 'components/avatar_selection.dart';

class GChatScreen extends StatefulWidget {
  static final routeName = "g-chat-screen";

  @override
  State<StatefulWidget> createState() => _GChatScreen();
}

class _GChatScreen extends State<GChatScreen> {

  StorageSystem ss = new StorageSystem();

  List<String> avatarImages = ["avatar1","avatar2","avatar3","avatar4","avatar5","avatar6","avatar7","avatar8","avatar9"];
  String selectedAvatar = "";

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
        title: Text(
          "G-Chat",
          style: Theme.of(context).textTheme.headline2.copyWith(
              color: Color(MyColors.titleTextColor),
              fontSize: getProportionateScreenWidth(18)),
        ),
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(30)),
        child: Container(
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text("Choose your Avatar",
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.headline2.copyWith(
                      color: Color(MyColors.titleTextColor),
                      fontSize: getProportionateScreenWidth(20))),
              Text(
                  "Coral wants you to be free to discuss anything and everything about your lady part life with other beautiful women in the reef!",
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: Colors.grey,
                      fontSize: getProportionateScreenWidth(14))),
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
                          isSelected: (selectedAvatar == opt) ? true : false,
                          returnSelected: (_selectedOptions) {
                            print(_selectedOptions);
                            setState(() {
                              selectedAvatar = _selectedOptions;
                            });
                            // selectedOptions = _selectedOptions;
                          },
                        ))
                    .toList(),
              ),
              SizedBox(
                height: 20.0,
              ),
              DefaultButton(
                text: "Continue",
                press: () async {
                  await ss.setPrefItem("selectedAvatar", selectedAvatar);
                  Navigator.pushNamed(context, AvatarFinalSection.routeName);
                  // Navigator.of(context).pushReplacement(MaterialPageRoute(
                  //     builder: (BuildContext context) => new AvatarFinalSection(selectedAvatar)));
                },
              ),
              SizedBox(
                height: 50.0,
              ),
            ],
          )),
        ),
      ),
    );
  }
}
