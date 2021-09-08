import 'package:coral_reef/Utils/daily_notification_sercives.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/account/settings/components/cycle_list_item.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'components/account_header.dart';
import 'components/reminder_flutter_switch.dart';

class Reminders extends StatelessWidget {
  static String routeName = "reminder";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AccountHeader("Notifications - Settings").build(context),
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  StorageSystem ss = new StorageSystem();
  DailyNotificationServices dailyNotificationServices;
  bool isSleep = false, isVitamin = false, isWater = false, isCalories = false, isSteps = false, isPeriod = false, isPregnancy = false, isGeneral = false;

  @override
  void initState() {
    super.initState();
    dailyNotificationServices = new DailyNotificationServices(null);
    getNotificationSettings();
  }

  Future<void> getNotificationSettings() async {
    String check = await ss.getItem("generalNotificationAllowed") ?? "false";
    String check2 = await ss.getItem("waterNotificationAllowed") ?? "false";
    String check3 = await ss.getItem("caloriesNotificationAllowed") ?? "false";
    String check4 = await ss.getItem("stepsNotificationAllowed") ?? "false";
    String check5 = await ss.getItem("pregnancyNotificationAllowed") ?? "false";
    String check6 = await ss.getItem("periodNotificationAllowed") ?? "false";
    String check7 = await ss.getItem("sleepNotificationAllowed") ?? "false";
    String check8 = await ss.getItem("vitaminsNotificationAllowed") ?? "false";

    setState(() {
      isGeneral = (check == "false") ? false : true;
      isWater = (check2 == "false") ? false : true;
      isCalories = (check3 == "false") ? false : true;
      isSteps = (check4 == "false") ? false : true;
      isPregnancy = (check5 == "false") ? false : true;
      isPeriod = (check6 == "false") ? false : true;
      isSleep = (check7 == "false") ? false : true;
      isVitamin = (check8 == "false") ? false : true;
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
                RemindersListItem(
                    text: "Turn ${(!isGeneral) ? "on": "off"} all daily notifications",
                    subText: "If turned OFF, you won't receive daily notifications or reminders.",
                    type: "switch",
                    icon: null,
                    trailingText: "",
                    switchValue: isGeneral,
                    press: (toggle) async {
                      String value = (toggle) ? "true" : "false";
                      await ss.setPrefItem("generalNotificationAllowed", value);
                      setState(() {
                        isGeneral = !isGeneral;
                      });
                    }
                ),
                RemindersListItem(
                    text: "Turn ${(!isWater) ? "on": "off"} water intake daily notifications",
                    subText: "If turned OFF, you won't receive daily water intake reminders.",
                    type: "switch",
                    icon: null,
                    trailingText: "",
                    switchValue: isWater,
                    press: (toggle) async {
                      String value = (toggle) ? "true" : "false";
                      await ss.setPrefItem("waterNotificationAllowed", value);
                      await dailyNotificationServices.displayDailyWaterNotification(toggle);
                      setState(() {
                        isWater = !isWater;
                      });
                    }
                ),
                RemindersListItem(
                    text: "Turn ${(!isCalories) ? "on": "off"} daily calories notifications",
                    subText: "If turned OFF, you won't receive daily calories reminders.",
                    type: "switch",
                    icon: null,
                    trailingText: "",
                    switchValue: isCalories,
                    press: (toggle) async {
                      String value = (toggle) ? "true" : "false";
                      await ss.setPrefItem("caloriesNotificationAllowed", value);
                      await dailyNotificationServices.displayDailyCaloriesNotification(toggle);
                      setState(() {
                        isCalories = !isCalories;
                      });
                    }
                ),
                RemindersListItem(
                    text: "Turn ${(!isSteps) ? "on": "off"} daily steps notifications",
                    subText: "If turned OFF, you won't receive daily steps insight.",
                    type: "switch",
                    icon: null,
                    trailingText: "",
                    switchValue: isSteps,
                    press: (toggle) async {
                      String value = (toggle) ? "true" : "false";
                      await ss.setPrefItem("stepsNotificationAllowed", value);
                      await dailyNotificationServices.displayDailyStepsNotification(toggle);
                      setState(() {
                        isSteps = !isSteps;
                      });
                    }
                ),
                RemindersListItem(
                    text: "Turn ${(!isPregnancy) ? "on": "off"} weekly pregnancy notifications",
                    subText: "If turned OFF, you won't receive weekly information about your pregnancy.",
                    type: "switch",
                    icon: null,
                    trailingText: "",
                    switchValue: isPregnancy,
                    press: (toggle) async {
                      String value = (toggle) ? "true" : "false";
                      await ss.setPrefItem("pregnancyNotificationAllowed", value);
                      await dailyNotificationServices.displayWeeklyPregnancyNotification(toggle);
                      setState(() {
                        isPregnancy = !isPregnancy;
                      });
                    }
                ),
                RemindersListItem(
                    text: "Turn ${(!isPeriod) ? "on": "off"} period notifications",
                    subText: "If turned OFF, you won't receive period reminders.",
                    type: "switch",
                    icon: null,
                    trailingText: "",
                    switchValue: isPeriod,
                    press: (toggle) async {
                      String value = (toggle) ? "true" : "false";
                      await ss.setPrefItem("periodNotificationAllowed", value);
                      await dailyNotificationServices.displayDailyPeriodNotification(toggle);
                      setState(() {
                        isPeriod = !isPeriod;
                      });
                    }
                ),
                RemindersListItem(
                    text: "Turn ${(!isSleep) ? "on": "off"} daily sleep notifications",
                    subText: "If turned OFF, you won't receive daily sleep reminders.",
                    type: "switch",
                    icon: null,
                    trailingText: "",
                    switchValue: isSleep,
                    press: (toggle) async {
                      String value = (toggle) ? "true" : "false";
                      await ss.setPrefItem("sleepNotificationAllowed", value);
                      await dailyNotificationServices.displayDailySleepNotification(toggle);
                      setState(() {
                        isSleep = !isSleep;
                      });
                    }
                ),
                RemindersListItem(
                    text: "Turn ${(!isVitamin) ? "on": "off"} daily vitamin intake notifications",
                    subText: "If turned OFF, you won't receive daily reminders to take your vitamins.",
                    type: "switch",
                    icon: null,
                    trailingText: "",
                    switchValue: isVitamin,
                    press: (toggle) async {
                      String value = (toggle) ? "true" : "false";
                      await ss.setPrefItem("vitaminsNotificationAllowed", value);
                      await dailyNotificationServices.displayDailyVitaminsNotification(toggle);
                      setState(() {
                        isVitamin = !isVitamin;
                      });
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileMenu2 extends StatelessWidget {
  const ProfileMenu2({
    Key key,
    @required this.text,
    @required this.text2,
    @required this.text3,
    this.press,
  }) : super(key: key);

  final String text, text2, text3;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: FlatButton(
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Color(0xFFF5F6F9),
        onPressed: press,
        child: Column(
          children: [
            ListTile(
              title: Text(text,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  )),
              subtitle: Text(text2,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  )),
              trailing: Text(text3,
                  style: TextStyle(
                    fontSize: 14,
                    color: kPrimaryColor,
                  )),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key key,
    @required this.text,
    @required this.text2,
    this.press,
  }) : super(key: key);

  final String text, text2;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: FlatButton(
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Color(0xFFF5F6F9),
        onPressed: press,
        child: Column(
          children: [
            ListTile(
              title: Text(text,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  )),
              subtitle: Text(text2,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  )),
              trailing: Switch(
                activeColor: kPrimaryColor,
                value: false,
                onChanged: (bool value) {},
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}

class Title extends StatelessWidget {
  const Title({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Reminders',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          )),
    );
  }
}
