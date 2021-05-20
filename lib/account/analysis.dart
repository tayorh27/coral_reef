import 'package:coral_reef/components/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../size_config.dart';

class Analysis extends StatelessWidget {
  static String routeName = "analysis";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.1,
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
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                Text('What would you like to analyse?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 10),
                NoteTile(
                  title: 'Cycle length',
                  icon: 'assets/icons/Shape.svg',
                ),
                NoteTile(
                  title: 'Period Length and Intensity',
                  icon: 'assets/icons/Shape.svg',
                ),
                NoteTile(
                  title: 'Graphs of events',
                  icon: 'assets/icons/Shape.svg',
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.3),
                DefaultButton(
                  text: 'Report for an expert',
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
    this.press,
  }) : super(key: key);
  final String icon, title;
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
      leading: SvgPicture.asset(
        icon,
        height: 20,
      ),
      trailing: Icon(Icons.arrow_forward_ios),
    );
  }
}
