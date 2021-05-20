import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/account/components/account_header.dart';
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
      appBar: AccountHeader("Notification").build(context),
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
          ),
        ),
      ),
    );
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
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        title2,
        style: TextStyle(
          fontSize: 12,
        ),
      ),
      leading: SvgPicture.asset(
        icon,
        height: 25,
      ),
    );
  }
}
