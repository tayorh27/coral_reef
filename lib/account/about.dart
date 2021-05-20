import 'package:flutter/material.dart';

import '../constants.dart';

class About extends StatelessWidget {
  static String routeName = "about";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.1,
        title: Title(),
        leading: Icon(
          Icons.cancel,
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
                Text('Witty Coal',
                    style: TextStyle(
                      fontSize: 15,
                      color: kPrimaryColor,
                    )),
              ],
            ),
          ),
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
      child: Text('About',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          )),
    );
  }
}
