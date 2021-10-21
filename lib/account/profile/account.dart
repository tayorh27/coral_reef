import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/Utils/daily_notification_sercives.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/account/components/account_header.dart';
import 'package:coral_reef/account/services/account_services.dart';
import 'package:coral_reef/constants.dart';
import 'package:coral_reef/onboarding/sign_in/sign_in_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/account/profile/components/goal_selector.dart';
import 'package:coral_reef/account/profile/components/profile_menu_list.dart';
import 'package:coral_reef/account/profile/components/profile_pic.dart';
import 'package:coral_reef/account/about.dart';
import 'package:coral_reef/account/analysis.dart';
import 'package:coral_reef/account/settings/cycle.dart';
import 'package:coral_reef/account/help.dart';
import 'package:coral_reef/account/notifications/notification.dart';
import 'package:coral_reef/account/reminders.dart';
import 'package:coral_reef/account/settings.dart';
import 'package:coral_reef/size_config.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';

class Account extends StatefulWidget {
  static String routeName = "account";

  @override
  State<StatefulWidget> createState() => _Account();
}

class _Account extends State<Account> {

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AccountHeader("Account - $username").build(context),
      body: Body(email),
    );
  }
}

class Body extends StatefulWidget {
  final String email;
  Body(this.email);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {

  AccountServices accountServices;
  StorageSystem ss = new StorageSystem();

  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    accountServices = new AccountServices();
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
                Stack(
                  children: [
                    UserProfilePic(),
                    Container(
                      height: 115,
                      width: 115,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(115)
                      ),
                      child: IconButton(icon: Icon(Icons.edit, color: Colors.white,), onPressed: () {
                        selectImage();
                      },),
                    )
                  ],
                ),
                SizedBox(height: 5),
                Text(widget.email,
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: Color(MyColors.primaryColor),
                      fontSize: getProportionateScreenWidth(16),
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 20),
                Divider(height: 3.0,),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                        "Preferred goal",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Color(MyColors.titleTextColor),
                          fontSize: getProportionateScreenWidth(16),
                        )
                    ),
                  ],
                ),
                SizedBox(height: 5),
                GoalScrollingOptions(),
                SizedBox(height: 20),
                Divider(height: 3.0,),
                // AccountProfileMenu(
                //   text: "Contact info",
                //   icon: Icon(Icons.person_outline_rounded, color: Color(MyColors.titleTextColor),),
                //   press: () => {Navigator.pushNamed(context, ContactInfo.routeName)},
                // ),
                // AccountProfileMenu(
                //   text: "Graphs and reports",
                //   icon: Icon(Icons.analytics_outlined, color: Color(MyColors.titleTextColor),),
                //   press: () {
                //     // Navigator.pushNamed(context, Notifications.routeName);
                //   },
                // ),
                AccountProfileMenu(
                  text: "Settings",
                  icon: Icon(Icons.settings_outlined, color: Color(MyColors.titleTextColor),),
                  press: () {
                    // Navigator.pushNamed(context, Settings.routeName);
                  },
                ),
                AccountProfileMenu(
                  text: "Notifications",
                  icon: Icon(Icons.alarm, color: Color(MyColors.titleTextColor),),
                  press: () {
                    Navigator.pushNamed(context, Reminders.routeName);
                  },
                ),
                AccountProfileMenu(
                  text: "Cycle and Ovulation",
                  icon: Icon(Icons.whatshot_outlined, color: Color(MyColors.titleTextColor),),
                  press: () {
                    Navigator.pushNamed(context, SettingsCycle.routeName);
                  },
                ),
                AccountProfileMenu(
                  text: "Help",
                  icon: Icon(Icons.help_outline_rounded, color: Color(MyColors.titleTextColor),),
                  press: () {
                    // Navigator.pushNamed(context, Help.routeName);
                  },
                ),
                AccountProfileMenu(
                  text: "Contact Support",
                  icon: Icon(Icons.chat_bubble_outline_rounded, color: Color(MyColors.titleTextColor),),
                  press: () {
                    // Navigator.pushNamed(context, Analysis.routeName);
                  },
                ),
                AccountProfileMenu(
                  text: "About CoralReef",
                  icon: Icon(Icons.info_outline, color: Color(MyColors.titleTextColor),),
                  press: () {
                    // Navigator.pushNamed(context, About.routeName);
                  },
                ),
                AccountProfileMenu(
                  text: "Log out",
                  icon: Icon(Icons.logout, color: Color(MyColors.titleTextColor),),
                  press: () async {
                    try {
                      final verify = await new GeneralUtils()
                          .displayReturnedValueAlertDialog(context, "Attention",
                          "Are you sure you want to logout?",
                          confirmText: "YES");
                      if (verify) {
                        await ss.clearPref();
                        await FirebaseAuth.instance.signOut();
                        await new DailyNotificationServices(null).cancelAllNotification();
                        final GoogleSignIn _googleSignIn = GoogleSignIn(
                          scopes: [
                            'email',
                            'profile'
                          ],
                        );
                        await _googleSignIn.signOut();
                        final facebookLogin = FacebookLogin();
                        await facebookLogin.logOut();
                      }
                    }catch (e) {
                      await ss.clearPref();
                      await FirebaseAuth.instance.signOut();
                    } finally {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (
                              BuildContext context) => new SignInScreen()));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> selectImage() async {
    FilePickerResult result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);
    if (result != null) {
      File file = File(result.files.first.path);

      File croppedFile = await ImageCropper.cropImage(
          sourcePath: file.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            // CropAspectRatioPreset.ratio3x2,
            // CropAspectRatioPreset.original,
            // CropAspectRatioPreset.ratio4x3,
            // CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Crop Profile Image',
              toolbarColor: Color(MyColors.primaryColor),
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          )
      );

      //compress image

      File picFile = await accountServices.compressAndGetFile(croppedFile);
      setState(() {
        loading = true;
      });

      //upload image to storage

      String url = await accountServices.uploadProfileImageToStorage(picFile);


      //save url to database
      await FirebaseFirestore.instance.collection("users").doc(user.uid).update(
          {
            "picture": url,
          });
      print("h3");
      //save locally
      String _user = await ss.getItem("user");
      dynamic json = jsonDecode(_user);
      json["picture"] = url;
      await ss.setPrefItem("user", jsonEncode(json));
      setState(() {
        loading = false;
      });
    }
  }
}
