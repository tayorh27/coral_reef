import 'package:coral_reef/ListItem/model_tips.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/shared_screens/EmptyScreen.dart';
import 'package:coral_reef/tracker_screens/pregnancy_tracker/components/tips_list_card.dart';
import 'package:coral_reef/tracker_screens/pregnancy_tracker/services/pregnancy_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:truncate/truncate.dart';

import '../../../size_config.dart';

class YourTips extends StatefulWidget {
  static final routeName = "yourtips";
  @override
  _YourTipsState createState() => _YourTipsState();
}

class _YourTipsState extends State<YourTips> {

  PregnancyServices pregnancyServices;

  List<PregnancyTips> tips = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pregnancyServices = new PregnancyServices();
    getMyTips();
  }

  getMyTips() async {
    var _tips = await pregnancyServices.getTips();

    setState(() {
      tips = _tips;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.only(left: 25.0),
          child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 100,
          centerTitle: true,
          title: Text(
            "Tips",
            style: Theme.of(context).textTheme.headline2.copyWith(
              color: Color(MyColors.titleTextColor),
              fontSize: getProportionateScreenWidth(18),
            ),
          )
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: 10,
              ),
              ...buildTipsColumn(), //(tips.isEmpty) ? EmptyScreen("") :
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildTipsColumn() {

    List<Widget> widgetTips = [];

    tips.forEach((pt) {
      widgetTips.add(
        ListCard(
          image: pt.image,
          title: pt.title,
          title2: pt.body,
          onPress: (){
            displayAlertDialog(pt.image,pt.title,pt.body);
          },
        ),
      );
    });

    widgetTips.add(
      SizedBox(
        height: 10,
      ),
    );

    widgetTips.add(
      Divider(
        thickness: 2,
      ),
    );

    widgetTips.add(
      SizedBox(
        height: 10,
      ),
    );

    return widgetTips;
  }

  Future<Null> displayAlertDialog(String icon, String _title, String _body) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Container(
            height: getProportionateScreenHeight(50),
            width: getProportionateScreenWidth(50),
            decoration: BoxDecoration(
              color: Color(0xFFF5F6F9),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(icon),
          ),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text(_title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: Color(MyColors.titleTextColor),
                  fontSize: getProportionateScreenWidth(20),),),
                Padding(
                    padding: const EdgeInsets.only(left:10.0, right: 10.0, top: 30.0, bottom: 30.0),
                    child: new Text(
                      _body,textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Color(MyColors.titleTextColor),
                        fontSize: getProportionateScreenWidth(15),),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}


/*
* ListCard(
                image: "assets/images/tips_pregnancy.svg",
                title: "Lorem Ipsum",
                title2: "Some text about something goes here",
                onPress: (){
                  displayAlertDialog("assets/images/tips_pregnancy.svg","Lorem Ipsum","Some text about something goes here. Some text about something goes here. Some text about something goes here");
                },
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: 10,
              ),
              ListCard(
                image: "assets/images/tips_drug.svg",
                title: "Lorem Ipsum",
                title2: "Some text about something goes here. Some text about something goes here. Some text about something goes here",
                onPress: (){
                  displayAlertDialog("assets/images/tips_drug.svg","Lorem Ipsum","Some text about something goes here. Some text about something goes here. Some text about something goes here");
                },
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: 10,
              ),
              ListCard(
                image: "assets/images/tips_pregnancy.svg",
                title: "Lorem Ipsum",
                title2: "Some text about something goes here",
                onPress: (){
                  displayAlertDialog("assets/images/tips_drug.svg","Lorem Ipsum","Some text about something goes here. Some text about something goes here. Some text about something goes here");
                },
              ),
              SizedBox(
                height: 10,
              ),
* **/