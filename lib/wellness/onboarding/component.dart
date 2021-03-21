import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:coral_reef/components/default_button.dart';

import '../../size_config.dart';

class BuildCard extends StatelessWidget {
const BuildCard({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.color,
    @required this.onPress,

  }) : super(key: key);
  final String icon, title;
  final Color color;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    var _height = (title.toLowerCase().startsWith("track period")) ? 20.0 : (title.toLowerCase().startsWith("trying")) ? 30.0 : 40.0;
    return Container(
      decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      height: 80,
      child: Center(
        child: Container(
          child: ListTile(
            title: Text(title,
              style: Theme.of(context).textTheme.headline2.copyWith(
                  color: Color(MyColors.primaryColor),
                  fontSize: getProportionateScreenWidth(16)
              ),),
            leading: SvgPicture.asset(icon, height: _height),
            onTap: onPress,
          ),
          padding: EdgeInsets.only(left: 30.0),
        )
      ),
    );
  }
}

class BuildCard2 extends StatelessWidget {
const BuildCard2({
    Key key,
    @required this.icon,
    @required this.title,
    
  }) : super(key: key);
  final String icon, title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
      color: Colors.blueAccent.withOpacity(0.2),
      borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      height: 80,
      child: Center(
        child: ListTile(
          title: Text(title,
          style: TextStyle(
          fontSize: 20,
          color: kPrimaryColor,
          fontWeight: FontWeight.bold,
          ),),
          leading: SvgPicture.asset(icon,height: 30,),
        ),
      ),
    );
  }
}

class BuildCard3 extends StatelessWidget {
const BuildCard3({
    Key key,
    @required this.icon,
    @required this.title,
    
  }) : super(key: key);
  final String icon, title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
      color: Colors.orangeAccent.withOpacity(0.2),
      borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      height: 80,
      child: Center(
        child: ListTile(
          title: Text(title,
          style: TextStyle(
          fontSize: 20,
          color: kPrimaryColor,
          fontWeight: FontWeight.bold,
          ),),
          leading: SvgPicture.asset(icon,height: 40),
        ),
      ),
    );
  }
}


class HeadingText extends StatefulWidget {
  const HeadingText({
    Key key,

  }) : super(key: key);
  @override
  _HeadingTextState createState() => _HeadingTextState();
}

class _HeadingTextState extends State<HeadingText> {

  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text.rich(
        TextSpan(
          //style: TextStyle(color: Colors.white),
          children: [
            TextSpan(
              text: 'Add Your Weight \n',
              style: TextStyle(
                fontSize: getProportionateScreenWidth(20),
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
            text: 'DATE: ',
            style: TextStyle(
                fontSize: getProportionateScreenWidth(15),
                color: Colors.purple,
              ),),
            TextSpan(
            text: now.toString(),
            style: TextStyle(
                fontSize: getProportionateScreenWidth(15),
                color: Colors.purple,
              ),)
          ],
        ),
      ),
      ],
    );
  }
}

class HeadingText2 extends StatefulWidget {
  const HeadingText2({
    Key key,

  }) : super(key: key);
  @override
  _HeadingText2State createState() => _HeadingText2State();
}

class _HeadingText2State extends State<HeadingText2> {

  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text.rich(
        TextSpan(
          //style: TextStyle(color: Colors.white),
          children: [
            TextSpan(
              text: 'Add Desired Weight \n',
              style: TextStyle(
                fontSize: getProportionateScreenWidth(20),
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
            text: 'DATE: ',
            style: TextStyle(
                fontSize: getProportionateScreenWidth(15),
                color: Colors.purple,
              ),),
            TextSpan(
            text: date.toString(),
            style: TextStyle(
                fontSize: getProportionateScreenWidth(15),
                color: Colors.purple,
              ),)
          ],
        ),
      ),
      ],
    );
  }
}

class HeadingText3 extends StatefulWidget {
  const HeadingText3({
    Key key,

  }) : super(key: key);
  @override
  _HeadingText3State createState() => _HeadingText3State();
}

class _HeadingText3State extends State<HeadingText3> {

  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text.rich(
        TextSpan(
          //style: TextStyle(color: Colors.white),
          children: [
            TextSpan(
              text: 'Add Your Height \n',
              style: TextStyle(
                fontSize: getProportionateScreenWidth(20),
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
            text: 'DATE: ',
            style: TextStyle(
                fontSize: getProportionateScreenWidth(15),
                color: Colors.purple,
              ),),
            TextSpan(
            text: date.toString(),
            style: TextStyle(
                fontSize: getProportionateScreenWidth(15),
                color: Colors.purple,
              ),)
          ],
        ),
      ),
      ],
    );
  }
}

class Buttons extends StatelessWidget {
  const Buttons({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Button(
          text: 'kg',
           press: (){ }
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Button2(
          text: 'lbs',
           press: (){}
          ),
        ),
      ],
    );
  }
}