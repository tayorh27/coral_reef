import 'dart:async';
import 'dart:convert';

import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/g_chat_screen/GChatScreen.dart';
import 'package:coral_reef/g_chat_screen/gchat_home_screen.dart';
import 'package:coral_reef/size_config.dart';
import 'package:coral_reef/tracker_screens/tracker_landing.dart';
import 'package:coral_reef/wallet_screen/wallet_home_screen.dart';
import 'package:coral_reef/wallet_screen/wallet_setup_screen.dart';
import 'package:coral_reef/wellness/wellness_tracker_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CoralBottomNavigationBar extends StatefulWidget {
  static final routeName = 'bottom-nav-bar';

  final bool isGChat;
  final bool hasGChatSetup;
  final bool goToWallet;
  CoralBottomNavigationBar({this.isGChat, this.hasGChatSetup, this.goToWallet = false});

  @override
  State<StatefulWidget> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<CoralBottomNavigationBar> {

  String wellnessSetup = "", walletSetup = "";
  StorageSystem ss = new StorageSystem();

  int currentIndex = 0;
  bool hasGChatSetup = false;

  /// Set a type current number a layout class
  Widget callPage(int current) {
    switch (current) {
      case 0:
        return (wellnessSetup.isEmpty) ? WellnessTrackerOptions() : TrackerLanding();
      case 1:
        return (hasGChatSetup) ? GChatHomeScreen() : GChatScreen();
      case 2:
        return (walletSetup.isEmpty) ? WalletSetupScreen() : WalletHomeScreen();
      default:
        return (wellnessSetup.isEmpty) ? WellnessTrackerOptions() : TrackerLanding();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bool gChat = widget.isGChat ?? false;
    bool hasGChat = widget.hasGChatSetup ?? false;
    ss.getItem("wellnessSetup").then((value) {
      String v = value ?? "";
      setState(() {
        wellnessSetup = v;
      });
    });
    ss.getItem("walletSetup").then((value) {
      String v = value ?? "";
      setState(() {
        walletSetup = v;
      });
    });
    if(gChat) {
      setState(() {
        currentIndex = 1;
        hasGChatSetup = hasGChat;
      });
      return;
    }
    if(widget.goToWallet) {
      setState(() {
        currentIndex = 2;
      });
    }
  }

  /// Build BottomNavigationBar Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: callPage(currentIndex),
      bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
              textTheme: Theme.of(context).textTheme.copyWith(
                  caption: TextStyle(color: Color(MyColors.bottomNavTextColor)))),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            currentIndex: currentIndex,
            fixedColor: Color(MyColors.primaryColor),
            selectedLabelStyle: TextStyle(color: Color(MyColors.primaryColor)),
            onTap: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            items: [
              BottomNavigationBarItem(
                  icon: SvgPicture.asset("assets/icons/dash_home.svg",
                      height: 30.0),
                  title: Text(
                    "Dashboard",
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                        letterSpacing: 0.5,
                        fontSize: getProportionateScreenWidth(12)),
                  )),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset("assets/icons/dash_g_chat.svg",
                      height: 30.0),
                  activeIcon: SvgPicture.asset("assets/icons/active_dash_g_chat.svg",
                      height: 30.0),
                  title: Text(
                    "G-Chat",
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                        letterSpacing: 0.5,
                        fontSize: getProportionateScreenWidth(12)),
                  )),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset("assets/icons/dash_wallet.svg",
                      height: 30.0),
                  activeIcon: SvgPicture.asset("assets/icons/active_dash_wallet.svg",
                      height: 30.0),
                  title: Text(
                    "Wallet",
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                        letterSpacing: 0.5,
                        fontSize: getProportionateScreenWidth(12)),
                  )),
            ],
          )),
    );
  }
}
