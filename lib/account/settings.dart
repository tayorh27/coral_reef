import 'package:coral_reef/components/default_button.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../size_config.dart';

class Settings extends StatelessWidget {
  static String routeName = "settings";
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
                  text: "Current weight",
                  text2: "70 kg",
                  press: () => {_showTestDialog5(context)},
                ),
                ProfileMenu(
                  text: "Weight goal",
                  text2: "100 kg",
                  press: () {
                    _showTestDialog4(context);
                  },
                ),
                ProfileMenu(
                  text: "Height",
                  text2: "170 cm",
                  press: () {
                    _showTestDialog7(context);
                  },
                ),
                ProfileMenu(
                  text: "Daily calories",
                  text2: "2,230 kcal",
                  press: () {
                    _showTestDialog6(context);
                  },
                ),
                ProfileMenu(
                  text: "Sleep duration",
                  text2: "6 hrs",
                  press: () {},
                ),
                ProfileMenu(
                  text: "Step goal",
                  text2: "10,000",
                  press: () {
                    _showTestDialog(context);
                  },
                ),
                ProfileMenu(
                  text: "Daily water intake",
                  text2: "10 glass",
                  press: () {
                    _showTestDialog3(context);
                  },
                ),
                ProfileMenu(
                  text: "Daily vitamin intake",
                  text2: "2",
                  press: () {
                    _showTestDialog2(context);
                  },
                ),
                Health(
                  text: "Health insights",
                  press: () {},
                ),
                Unit(
                  text: "Units",
                ),
              ],
            ),
          ),
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
                    fontSize: 12,
                    color: Colors.black,
                  )),
              trailing: Text(text2,
                  style: TextStyle(
                    fontSize: 10,
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

class Health extends StatelessWidget {
  const Health({
    Key key,
    @required this.text,
    this.press,
  }) : super(key: key);

  final String text;
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
                    fontSize: 12,
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
      child: Text('Settings',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          )),
    );
  }
}

class Unit extends StatelessWidget {
  const Unit({
    Key key,
    @required this.text,
    this.press,
  }) : super(key: key);

  final String text;
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
                    fontSize: 12,
                    color: Colors.black,
                  )),
              trailing: CategoriesTile(),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}

class CategoriesTile extends StatelessWidget {
  const CategoriesTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Categories(
              category: "Metric",
              color: kPrimaryColor,
              press: () {},
            ),
            SizedBox(width: SizeConfig.screenWidth * 0.02),
            Categories2(
              category: "Imperial",
              press: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class Categories extends StatelessWidget {
  const Categories({
    Key key,
    @required this.category,
    this.press,
    this.color,
  }) : super(key: key);

  final String category;
  final Color color;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: getProportionateScreenWidth(0),
          right: getProportionateScreenWidth(5)),
      child: GestureDetector(
        onTap: press,
        child: Container(
          width: getProportionateScreenWidth(70),
          height: getProportionateScreenWidth(40),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.1),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              category,
              style: TextStyle(
                color: color,
                fontSize: getProportionateScreenWidth(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Categories2 extends StatelessWidget {
  const Categories2({
    Key key,
    @required this.category,
    this.press,
    this.color,
  }) : super(key: key);

  final String category;
  final Color color;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: getProportionateScreenWidth(0),
          right: getProportionateScreenWidth(5)),
      child: GestureDetector(
        onTap: press,
        child: Container(
          width: getProportionateScreenWidth(70),
          height: getProportionateScreenWidth(40),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              category,
              style: TextStyle(
                color: Colors.black,
                fontSize: getProportionateScreenWidth(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _showTestDialog(context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      //context: _scaffoldKey.currentContext,
      builder: (context) {
        return AlertDialogPage();
      });
}

class AlertDialogPage extends StatefulWidget {
  const AlertDialogPage({
    Key key,
  }) : super(key: key);

  @override
  _AlertDialogPageState createState() => _AlertDialogPageState();
}

class _AlertDialogPageState extends State<AlertDialogPage> {
  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //contentPadding: EdgeInsets.only(left: 20, right: 20),
      title: Text(
        'Step goal',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: getProportionateScreenWidth(20),
          fontWeight: FontWeight.bold,
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Container(
        height: 200,
        width: 300,
        child: SingleChildScrollView(
          child: Container(
            child: Center(
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '10,000',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: getProportionateScreenWidth(30),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Button2(
                        text: 'lbs',
                      )
                    ],
                  ),
                  Divider(),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'DATE: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(13),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text(
                        now.toString(),
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: getProportionateScreenWidth(13),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Divider(),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  DefaultButton(
                      text: 'Save',
                      press: () {
                        Navigator.pop(context);
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _showTestDialog2(context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      //context: _scaffoldKey.currentContext,
      builder: (context) {
        return AlertDialogPage2();
      });
}

class AlertDialogPage2 extends StatefulWidget {
  const AlertDialogPage2({
    Key key,
  }) : super(key: key);

  @override
  _AlertDialogPage2State createState() => _AlertDialogPage2State();
}

class _AlertDialogPage2State extends State<AlertDialogPage2> {
  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //contentPadding: EdgeInsets.only(left: 20, right: 20),
      title: Text(
        'Daily vitamin intake',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: getProportionateScreenWidth(20),
          fontWeight: FontWeight.bold,
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Container(
        height: 200,
        width: 300,
        child: SingleChildScrollView(
          child: Container(
            child: Center(
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '4.0',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: getProportionateScreenWidth(30),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Button2(
                        text: 'lbs',
                      )
                    ],
                  ),
                  Divider(),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'DATE: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(13),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text(
                        now.toString(),
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: getProportionateScreenWidth(13),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Divider(),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  DefaultButton(
                      text: 'Save',
                      press: () {
                        Navigator.pop(context);
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _showTestDialog3(context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      //context: _scaffoldKey.currentContext,
      builder: (context) {
        return AlertDialogPage3();
      });
}

class AlertDialogPage3 extends StatefulWidget {
  const AlertDialogPage3({
    Key key,
  }) : super(key: key);

  @override
  _AlertDialogPage3State createState() => _AlertDialogPage3State();
}

class _AlertDialogPage3State extends State<AlertDialogPage3> {
  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //contentPadding: EdgeInsets.only(left: 20, right: 20),
      title: Text(
        'Daily water intake',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: getProportionateScreenWidth(20),
          fontWeight: FontWeight.bold,
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Container(
        height: 200,
        width: 300,
        child: SingleChildScrollView(
          child: Container(
            child: Center(
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '10.0',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: getProportionateScreenWidth(30),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Button2(
                        text: 'lbs',
                      )
                    ],
                  ),
                  Divider(),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Text(
                    '1 glass of water is 250 ml',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(10),
                    ),
                  ),
                  Divider(),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'DATE: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(13),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text(
                        now.toString(),
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: getProportionateScreenWidth(13),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Divider(),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  DefaultButton(
                      text: 'Save',
                      press: () {
                        Navigator.pop(context);
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _showTestDialog4(context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      //context: _scaffoldKey.currentContext,
      builder: (context) {
        return AlertDialogPage4();
      });
}

class AlertDialogPage4 extends StatefulWidget {
  const AlertDialogPage4({
    Key key,
  }) : super(key: key);

  @override
  _AlertDialogPage4State createState() => _AlertDialogPage4State();
}

class _AlertDialogPage4State extends State<AlertDialogPage4> {
  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //contentPadding: EdgeInsets.only(left: 20, right: 20),
      title: Text(
        'Weight goal',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: getProportionateScreenWidth(20),
          fontWeight: FontWeight.bold,
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Container(
        height: 200,
        width: 300,
        child: SingleChildScrollView(
          child: Container(
            child: Center(
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '100.0',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: getProportionateScreenWidth(30),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Button2(
                        text: 'lbs',
                      )
                    ],
                  ),
                  Divider(),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'DATE: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(13),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text(
                        now.toString(),
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: getProportionateScreenWidth(13),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Divider(),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  DefaultButton(
                      text: 'Save',
                      press: () {
                        Navigator.pop(context);
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _showTestDialog5(context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      //context: _scaffoldKey.currentContext,
      builder: (context) {
        return AlertDialogPage5();
      });
}

class AlertDialogPage5 extends StatefulWidget {
  const AlertDialogPage5({
    Key key,
  }) : super(key: key);

  @override
  _AlertDialogPage5State createState() => _AlertDialogPage5State();
}

class _AlertDialogPage5State extends State<AlertDialogPage5> {
  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //contentPadding: EdgeInsets.only(left: 20, right: 20),
      title: Text(
        'Current weight',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: getProportionateScreenWidth(20),
          fontWeight: FontWeight.bold,
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Container(
        height: 200,
        width: 300,
        child: SingleChildScrollView(
          child: Container(
            child: Center(
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '70.0',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: getProportionateScreenWidth(30),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Button2(
                        text: 'lbs',
                      )
                    ],
                  ),
                  Divider(),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'DATE: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(13),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text(
                        now.toString(),
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: getProportionateScreenWidth(13),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Divider(),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  DefaultButton(
                      text: 'Save',
                      press: () {
                        Navigator.pop(context);
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _showTestDialog6(context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      //context: _scaffoldKey.currentContext,
      builder: (context) {
        return AlertDialogPage6();
      });
}

class AlertDialogPage6 extends StatefulWidget {
  const AlertDialogPage6({
    Key key,
  }) : super(key: key);

  @override
  _AlertDialogPage6State createState() => _AlertDialogPage6State();
}

class _AlertDialogPage6State extends State<AlertDialogPage6> {
  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //contentPadding: EdgeInsets.only(left: 20, right: 20),
      title: Text(
        'Daily calories',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: getProportionateScreenWidth(20),
          fontWeight: FontWeight.bold,
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Container(
        height: 200,
        width: 300,
        child: SingleChildScrollView(
          child: Container(
            child: Center(
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '1,520',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: getProportionateScreenWidth(30),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Button2(
                        text: 'lbs',
                      )
                    ],
                  ),
                  Divider(),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'DATE: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(13),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text(
                        now.toString(),
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: getProportionateScreenWidth(13),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Divider(),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  DefaultButton(
                      text: 'Save',
                      press: () {
                        Navigator.pop(context);
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _showTestDialog7(context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      //context: _scaffoldKey.currentContext,
      builder: (context) {
        return AlertDialogPage7();
      });
}

class AlertDialogPage7 extends StatefulWidget {
  const AlertDialogPage7({
    Key key,
  }) : super(key: key);

  @override
  _AlertDialogPage7State createState() => _AlertDialogPage7State();
}

class _AlertDialogPage7State extends State<AlertDialogPage7> {
  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //contentPadding: EdgeInsets.only(left: 20, right: 20),
      title: Text(
        'Add height',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: getProportionateScreenWidth(20),
          fontWeight: FontWeight.bold,
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Container(
        height: 200,
        width: 300,
        child: SingleChildScrollView(
          child: Container(
            child: Center(
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '170',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: getProportionateScreenWidth(30),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Button2(
                        text: 'lbs',
                      )
                    ],
                  ),
                  Divider(),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'DATE: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(13),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text(
                        now.toString(),
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: getProportionateScreenWidth(13),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Divider(),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  DefaultButton(
                      text: 'Save',
                      press: () {
                        Navigator.pop(context);
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
