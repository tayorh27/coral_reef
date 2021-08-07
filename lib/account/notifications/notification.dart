import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/ListItem/model_notifications.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/account/components/account_header.dart';
import 'package:coral_reef/shared_screens/EmptyScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../constants.dart';
import '../../size_config.dart';

class Notifications extends StatelessWidget {
  static String routeName = "notification";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AccountHeader("Notifications").build(context),
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {

  List<NotificationsModel> notifications = [];

  @override
  void initState() {
    super.initState();
    getNotifications();
  }

  getNotifications() async {
    QuerySnapshot query = await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("notifications")
        .orderBy("timestamp", descending: true)
        .get();
    if (query.docs.isEmpty) return;

    if (!mounted) return;
    query.docs.forEach((notification) {
      NotificationsModel nt = NotificationsModel.fromSnapshot(notification.data());
      setState(() {
        notifications.add(nt);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: (notifications.isEmpty)
            ? EmptyScreen("No recent notifications.")
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: buildNotificationsLayout(),
            )
          ),
        ),
      ),
    );
  }

  List<Widget> buildNotificationsLayout() {
    if (notifications.isEmpty) {
      return [];
    }
    List<Widget> layout = [];

    Map<String, dynamic> categorizedNotifications = new Map();

    //categorize the rewards based on month year

    //first loop
    notifications.forEach((nt) {
      if (categorizedNotifications[nt.header] == null) {
        categorizedNotifications[nt.header] = [nt];
      } else {
        List<dynamic> rws = categorizedNotifications[nt.header];
        rws.add(nt);
        categorizedNotifications[nt.header] = rws;
      }
    });

    //second loop through the map
    categorizedNotifications.forEach((key, value) {
      List<dynamic> rws = value;
      layout.add(headerLayout(key));
      layout.add(SizedBox(
        height: 20,
      ));
      layout.add(innerLayout(rws));
      layout.add(SizedBox(
        height: 20,
      ));
    });

    return layout;
  }

  Widget headerLayout(String value) {
    return Text(value ?? "",
        style: Theme.of(context).textTheme.bodyText1.copyWith(
          fontSize: 15,
          color: Color(MyColors.primaryColor),
        ));
  }

  Widget innerLayout(List<dynamic> rws) {
    return Padding(
        padding: EdgeInsets.all(0),
        child: Column(
            children: buildNotificationDetails(rws)));
  }

  List<Widget> buildNotificationDetails(List<dynamic> rws) {
    List<Widget> layout = [];

    rws.forEach((r) {
      layout.add(
        NoteTile(
          title: r.title,
          title2: r.message,
          icon: 'assets/icons/Shape.svg',
        ),
      );
      layout.add(SizedBox(height: 15.0,));
    });

    return layout;
  }
}

class NoteTile extends StatelessWidget {
  const NoteTile({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.title2,
    this.press,
  }) : super(key: key);
  final String icon, title, title2;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        title2,
        style: Theme.of(context).textTheme.bodyText1.copyWith(
          fontSize: 12,
        ),
      ),
      leading: Icon(Icons.circle_notifications, size: 32.0, color: Color(MyColors.primaryColor),),
        // SvgPicture.asset(
        //   icon,
        //   height: 25,
        // )
    );
  }
}

/*
Column(
              children: [
                Text('Today - 24 February, 2021',
                    style: TextStyle(
                      fontSize: 15,
                      color: kPrimaryColor,
                    )),
                SizedBox(height: 10),
                NoteTile(
                  title: 'Drink more water',
                  title2: 'you drank less than 250ml today',
                  icon: 'assets/icons/Shape.svg',
                ),
                Divider(),
                NoteTile(
                  title: 'Sleep reminder',
                  title2: 'It is 30 mins to your bedtime',
                  icon: 'assets/icons/Shape.svg',
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                Text('Tuesday - 22 February, 2021',
                    style: TextStyle(
                      fontSize: 15,
                      color: kPrimaryColor,
                    )),
                SizedBox(height: 10),
                NoteTile(
                  title: 'Leaderboard',
                  title2: 'you came second among your friends',
                  icon: 'assets/icons/Shape.svg',
                ),
                Divider(),
                NoteTile(
                  title: 'Drink more water',
                  title2: 'you drank less than 250ml today',
                  icon: 'assets/icons/Shape.svg',
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                Text('Wednesday - 21 February, 2021',
                    style: TextStyle(
                      fontSize: 15,
                      color: kPrimaryColor,
                    )),
                SizedBox(height: 10),
                NoteTile(
                  title: 'Leaderboard',
                  title2: 'you came second among your friends',
                  icon: 'assets/icons/Shape.svg',
                ),
                Divider(),
                NoteTile(
                  title: 'Drink more water',
                  title2: 'you drank less than 250ml today',
                  icon: 'assets/icons/Shape.svg',
                ),
              ],
            ),
* */
