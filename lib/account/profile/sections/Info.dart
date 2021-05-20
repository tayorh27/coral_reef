import 'dart:convert';

import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/account/components/account_header.dart';
import 'package:coral_reef/account/profile/components/profile_menu_list.dart';
import 'package:coral_reef/account/profile/components/profile_pic.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class ContactInfo extends StatelessWidget {
  static String routeName = "info";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AccountHeader("Profile").build(context),
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {

  StorageSystem ss = new StorageSystem();

  String username = "", email = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUerData();

  }

  getUerData() async {
    String user = await ss.getItem("user");
    dynamic json = jsonDecode(user);
    setState(() {
      username = "${json["firstname"]} ${json["lastname"]}";
      email = json["email"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                UserProfilePic(),
                Text(username,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Color(MyColors.primaryColor),
                      fontSize: getProportionateScreenWidth(16),
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 20),
                AccountProfileMenu(
                  text: "Full Name\n$username",
                  icon: null,
                  press: null,
                  showLeading: false,
                  showTrailing: false,
                ),
                AccountProfileMenu(
                  text: "Email Address\n$email",
                  icon: null,
                  press: null,
                  showLeading: false,
                  showTrailing: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
