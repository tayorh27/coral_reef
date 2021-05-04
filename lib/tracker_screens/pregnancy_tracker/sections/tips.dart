import 'package:akvelon_flutter_share_plugin/akvelon_flutter_share_plugin.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/coral_back_button.dart';
import 'package:coral_reef/shared_screens/tracker_screen_header.dart';
import 'package:coral_reef/size_config.dart';
import 'package:coral_reef/tracker_screens/period_tracker/components/border_filled_card.dart';
import 'package:coral_reef/tracker_screens/period_tracker/components/call_to_action.dart';
import 'package:coral_reef/tracker_screens/period_tracker/components/symptoms_grid_options.dart';
import 'package:coral_reef/tracker_screens/period_tracker/sections/login_symptoms.dart';
import 'package:coral_reef/tracker_screens/pregnancy_tracker/components/appbar.dart';
import 'package:coral_reef/tracker_screens/pregnancy_tracker/components/borderless_card.dart';
import 'package:coral_reef/tracker_screens/pregnancy_tracker/services/pregnancy_services.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readmore/readmore.dart';

import '../../bottom_navigation_bar.dart';

class TipsScreen extends StatefulWidget {
  static final routeName = "tipsscreen";

  final String currentWeek;
  TipsScreen({this.currentWeek});

  @override
  _TipsScreenState createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {

  PregnancyServices pregnancyServices;

  List<String> symptomsData = [];
  String symptomsDataNote = "";

  StorageSystem ss = new StorageSystem();

  int currentWeek = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    pregnancyServices = new PregnancyServices();
    currentWeek = int.parse(widget.currentWeek);

    getSymptoms(widget.currentWeek);
  }

  getSymptoms(String weekNumber) async {
    Map<String, dynamic> _get = await pregnancyServices.getSymptomsByDate(weekNumber);
    if(_get.isEmpty) {
      if(!mounted) return;
      setState(() {
        symptomsData = [];
        symptomsDataNote = "";
      });
      return;
    }
    _get["msd"].forEach((element) {
      setState(() {
        symptomsData.add("$element");
      });
    });
    if(!mounted) return;
    setState(() {
      symptomsDataNote = "${_get["note"]}";
    });
  }

  displayPregnancyImageByWeek() {
    if(currentWeek <= 12) {
      return "assets/gifs/preg_week_1_12.gif";
    }
    if(currentWeek > 12 && currentWeek <= 27) {
      return "assets/gifs/preg_week_13_27.gif";
    }
    if(currentWeek > 27 && currentWeek <= 40) {
      return "assets/gifs/preg_week_28_40.gif";
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(10)),
            child: Column(
              children: [
                SizedBox(
                  height: 50.0,
                ),
                TrackerScreenHeader(
                  child: CoralBackButton(),
                  titleHeight: 30.0,
                ),
                SizedBox(
                  height: 20.0,
                ),
                DatePicker(
                  DateTime.now(),
                  height: 95.0,
                  initialSelectedDate: DateTime.now(),
                  selectionColor: Color(MyColors.primaryColor),
                  selectedTextColor: Colors.white,
                  dateTextStyle: Theme.of(context).textTheme.headline2.copyWith(
                      fontSize: getProportionateScreenWidth(15),
                      color: Color(MyColors.titleTextColor)),
                  monthTextStyle: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(
                          fontSize: getProportionateScreenWidth(10),
                          color: Color(MyColors.titleTextColor)),
                  dayTextStyle: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontSize: getProportionateScreenWidth(10),
                      color: Color(MyColors.titleTextColor)),
                  onDateChange: (date) {
                    // New date selected
                    print("my date is $date");
                    setState(() {
                      // _selectedValue = date;
                    });
                  },
                ),
                SizedBox(
                  height: getProportionateScreenHeight(0),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 400,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Image.asset(
                            displayPregnancyImageByWeek(),//"assets/images/pregback.png",
                            height: 300.0,
                          ),
                          Container(
                            height: 150.0,
                            margin: EdgeInsets.only(top: 150.0, left: 90.0),
                            child: Column(
                              children: [
                                Text("Pregnancy",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(
                                        color: Colors.white,
                                        fontSize:
                                        getProportionateScreenWidth(15))),
                                Text(
                                  "Week $currentWeek",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .copyWith(
                                      color: Colors.white,
                                      fontSize:
                                      getProportionateScreenWidth(18)),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BorderlessCard(
                      borderColor: Color(MyColors.stroke1Color),
                      image: "assets/icons/vback.svg",
                      text: ("Previous \n Week"),
                      onPress: (){
                        if((currentWeek - 1) <= 0) {
                          return;
                        }
                        setState(() {
                          currentWeek = (currentWeek - 1);
                        });
                        getSymptoms("$currentWeek");
                        },
                    ),
                    SizedBox(width: 20.0,),
                    BorderlessCard(
                      borderColor: Color(MyColors.stroke2Color),
                      image: "assets/icons/blog.svg",
                      text: ("G-Chat /\nBlog"),
                      onPress: () async {
                        String _checkSetup = await ss.getItem("gchatSetup");// check if user has set up gchat settings
                        bool hasSetup = _checkSetup != null;
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => new CoralBottomNavigationBar(isGChat: true, hasGChatSetup: hasSetup,)));
                      },
                    ),
                    SizedBox(width: 20.0,),
                    BorderlessCard(
                      borderColor: Color(MyColors.stroke3Color),
                      image: "assets/icons/vnext.svg",
                      text: ("Next \nWeek"),
                      onPress: (){
                        int initCurrentWeek = int.parse(widget.currentWeek);
                        if((currentWeek + 1) > initCurrentWeek) {
                          new GeneralUtils().displayAlertDialog(context, "Attention", "You cannot view week ${(currentWeek + 1)} yet.");
                          return;
                        }
                        setState(() {
                          currentWeek = (currentWeek + 1);
                        });
                        getSymptoms("$currentWeek");
                      },
                    ),
                  ],
                ),
                CallToAction(
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginSymptoms(logType: "pregnancy", weekData: widget.currentWeek,)),
                    );
                    // Navigator.pushNamed(context, LoginSymptoms.routeName);
                  },
                ),
                SizedBox(
                  height: 30.0,
                ),
                (symptomsData.isNotEmpty) ? Row(
                  children: [
                    Text("Your recorded symptoms",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Color(MyColors.primaryColor),
                            fontSize: getProportionateScreenWidth(15))),
                  ],
                ) : SizedBox(),
                (symptomsDataNote.isNotEmpty) ? Container(
                  margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: ReadMoreText(
                    symptomsDataNote,
                    trimLines: 2,
                    colorClickableText: Color(MyColors.primaryColor),
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'more',
                    trimExpandedText: 'less',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 14.0, color: Color(MyColors.titleTextColor)),
                    moreStyle: Theme.of(context).textTheme.headline2.copyWith(fontSize: 14.0, color: Color(MyColors.primaryColor)),
                    lessStyle: Theme.of(context).textTheme.headline2.copyWith(fontSize: 14.0, color: Color(MyColors.primaryColor)),
                  ),
                ) : SizedBox(),
                SizedBox(
                  height: 10.0,
                ),
                (symptomsData.isNotEmpty) ? Container(
                  height: 100.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: symptomsData
                        .map((opt) => SymptomsGridOptions(
                      backgroundColor: Color(MyColors.stroke1Color),
                      title: opt,
                      image:
                      "assets/symptoms/${opt.toLowerCase().replaceAll(" ", "-")}.svg",
                      selected: false,
                      marginRight: true,
                    )).toList(),
                  ),
                ) :  SizedBox(),
                SizedBox(
                  height: 50.0,
                ),
              ],
            ),
          ),
        ));
  }

  shareImage() {
    AkvelonFlutterSharePlugin.shareSingle("", ShareType.IMAGE,
        text: "share image title",
        subject: "share image subject");
  }
}

/***
 *Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    BorderlessCard(
    borderColor: Color(MyColors.stroke1Color),
    image: "assets/icons/vback.svg",
    text: ("Previous \n Week"),
    ),
    BorderlessCard(
    borderColor: Color(MyColors.stroke2Color),
    image: "assets/icons/blog.svg",
    text: ("Blog"),
    ),
    BorderlessCard(
    borderColor: Color(MyColors.stroke2Color),
    image: "assets/icons/vfront.svg",
    text: ("Next week"),
    ),
    ],
    ),


    Row(
    children: [
    Text("Your cycles",
    style: Theme.of(context).textTheme.bodyText1.copyWith(
    color: Color(MyColors.primaryColor),
    fontWeight: FontWeight.w600,
    fontSize: getProportionateScreenWidth(16))),
    ],
    ),
    SizedBox(
    height: 10.0,
    ),
    Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    BorderFilledCard(
    title: "Previous cycle length",
    subtitle: "14 days",
    textNearIcon: "Abnormal",
    fillColor: Color(MyColors.stroke1Color),
    borderColor: Color(MyColors.stroke1Color),
    textColor: Colors.white,
    icon: Icon(
    Icons.warning_rounded,
    size: 12.0,
    color: Colors.yellow,
    ),
    ),
    BorderFilledCard(
    title: "Previous period length",
    subtitle: "14 days",
    textNearIcon: "Normal",
    fillColor: Colors.white,
    borderColor: Colors.grey,
    textColor: Color(MyColors.primaryColor),
    icon: Icon(
    Icons.check_circle,
    size: 12.0,
    color: Colors.green,
    ),
    ),
    ]),
 */
