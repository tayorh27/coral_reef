import 'package:flutter/material.dart';
import '../constants.dart';

class Reminders extends StatelessWidget {
  static String routeName = "reminder";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.1,
        title: Title(),
        leading: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
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
                ProfileMenu(
                  text: "Reminder",
                  text2: "Get personal reminders to help alert you of things",
                  press: () => {},
                ),
                ProfileMenu2(
                  text: "Weight",
                  text2: "Remind me to weight myself",
                  text3: '9:00am',
                  press: () {},
                ),
                ProfileMenu2(
                  text: "Gender",
                  text2: "male",
                  text3: '11:30pm',
                  press: () {},
                ),
                ProfileMenu(
                  text: "Water",
                  text2: "Remind me to drink water",
                  press: () {},
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
