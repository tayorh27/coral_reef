import 'dart:io';

import 'package:akvelon_flutter_share_plugin/akvelon_flutter_share_plugin.dart';
import 'package:coral_reef/ListItem/model_baby_body_info.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/constants.dart';
import 'package:coral_reef/g_chat_screen/components/video_display_widget.dart';
import 'package:coral_reef/size_config.dart';
import 'package:coral_reef/tracker_screens/pregnancy_tracker/components/list_card.dart';
import 'package:coral_reef/tracker_screens/pregnancy_tracker/services/pregnancy_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readmore/readmore.dart';
import 'package:shot_widget/shot_service.dart';
import 'package:shot_widget/shot_widget.dart';
import 'package:path_provider/path_provider.dart';

class YourBody extends StatefulWidget {
  static final routeName = "yourbody";

  final String week;
  final int weekNumber;
  YourBody({this.week, this.weekNumber});
  @override
  _YourBodyState createState() => _YourBodyState();
}

class _YourBodyState extends State<YourBody> {
  String week = "";

  PregnancyServices pregnancyServices;

  PregnancyBBInfo bodyInfo;

  GlobalKey key =  GlobalKey();
  ShotService service =  ShotService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pregnancyServices = new PregnancyServices();
    setState(() {
      week = widget.week;
      bodyInfo = pregnancyServices
          .getPregnancyInfoData()
          .firstWhere((element) => element.week == widget.weekNumber);
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
            "Your Body",
            style: Theme.of(context).textTheme.headline2.copyWith(
                  color: Color(MyColors.titleTextColor),
                  fontSize: getProportionateScreenWidth(18),
                ),
          )),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Your body at the $week Week",
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Color(MyColors.titleTextColor),
                        fontWeight: FontWeight.bold,
                        fontSize: getProportionateScreenWidth(16),
                      )),
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  InkWell(
                    onTap: viewImage,
                    child: Image.asset(
                      "assets/images/your_body.png",
                      height: 200.0,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: getProportionateScreenHeight(30),
              ),
              ReadMoreText(
                bodyInfo.bodyText,
                trimLines: 6,
                colorClickableText: Color(MyColors.primaryColor),
                trimMode: TrimMode.Line,
                trimCollapsedText: 'more',
                trimExpandedText: 'less',
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                    fontSize: 14.0, color: Color(MyColors.titleTextColor)),
                moreStyle: Theme.of(context).textTheme.headline2.copyWith(
                    fontSize: 14.0, color: Color(MyColors.primaryColor)),
                lessStyle: Theme.of(context).textTheme.headline2.copyWith(
                    fontSize: 14.0, color: Color(MyColors.primaryColor)),
              ),
              SizedBox(
                height: 39,
              ),
              // Divider(
              //   thickness: 2,
              // ),
              // PregListCard(
              //   title: "Lorem Ipsum",
              //   title2: "Some text about something goes here",
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Divider(
              //   thickness: 2,
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // PregListCard(
              //   title: "Lorem Ipsum",
              //   title2: "Some text about something goes here",
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Divider(
              //   thickness: 2,
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // PregListCard(
              //   title: "Lorem Ipsum",
              //   title2: "Some text about something goes here",
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Divider(
              //   thickness: 2,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> viewImage() {
    double minusValue = (widget.weekNumber >= 28) ? 0.0 : 30.0;
    String imagePath = (widget.weekNumber <= 12) ? "assets/images/share_preg_1_12.png" : (widget.weekNumber > 12 && widget.weekNumber <= 27) ? "assets/images/share_preg_13_27.png" : "assets/images/share_preg_28_40.png";
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return  ShotWidget(
            shotKey: key,
            child:  Padding(
          padding: EdgeInsets.only(left: 30.0, right: 30.0),
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(imagePath),
                        fit: BoxFit.contain)),
              ),
              Padding(padding: EdgeInsets.only(bottom:30.0), child: Align(
                alignment: Alignment.bottomRight,
                child: TextButton.icon(onPressed: () async {
                  File file =  await service.takeWidgetShot(key, '${(await getTemporaryDirectory()).path}/${new DateTime.now().toString()}.png', pixelRatio: 16/9);
                  print(file.path);
                  shareImage(file.path);
                }, icon: Icon(Icons.share_rounded, color: Colors.white,), label: Text("SHARE",
                    style: Theme.of(context).textTheme.headline2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: getProportionateScreenWidth(15)))),
              ),),
              Padding(padding: EdgeInsets.only(bottom:30.0), child: Align(
                alignment: Alignment.bottomLeft,
                child: TextButton(onPressed: () async {
                  Navigator.of(context).pop();
                }, child: Text("CANCEL",
                    style: Theme.of(context).textTheme.headline2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: getProportionateScreenWidth(15)))),
              ),),
              Container(
                margin: EdgeInsets.only(top: (MediaQuery.of(context).size.height / 2) - minusValue),
                child: Center(
                  child: Column(
                    children: [
                      Text("Pregnancy",
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Colors.white,
                              fontSize: getProportionateScreenWidth(15))),
                      Text(
                        "Week ${widget.weekNumber}",
                        style: Theme.of(context).textTheme.headline1.copyWith(
                            color: Colors.white,
                            fontSize: getProportionateScreenWidth(20)),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
      },
    );
  }

  shareImage(String path) {
    AkvelonFlutterSharePlugin.shareSingle(path, ShareType.IMAGE,
        text: "Hello",
        subject: "Pregnancy: Week ${widget.weekNumber}");
  }
}

class ListCard extends StatelessWidget {
  const ListCard({
    Key key,
    @required this.title,
    @required this.title2,
  }) : super(key: key);

  final String title, title2;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Row(
              children: [
                Text(
                  title2,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
