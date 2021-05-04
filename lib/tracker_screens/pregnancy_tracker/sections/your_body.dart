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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pregnancyServices = new PregnancyServices();
    setState(() {
      week = widget.week;
      bodyInfo = pregnancyServices.getPregnancyInfoData().firstWhere((element) => element.week == widget.weekNumber);
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
                    onTap: playVideo,
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

  Future<void> playVideo() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text("Week ${widget.weekNumber}", textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText1.copyWith(
            color: Color(MyColors.titleTextColor),
            fontSize: getProportionateScreenWidth(20),),),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                VideoDisplayWidget(bodyInfo.videoUrl, "https://firebasestorage.googleapis.com/v0/b/coraltrackerapp.appspot.com/o/pregnancy-asset-files%2Fyour_body.png?alt=media&token=7829b866-d643-486c-a3bf-47398c24b758", showControls: false, aspectRatio: 4/3, looping: true,)
              ],
            ),
          ),
          actions: [
            new TextButton(
              child: new Text('DONE', style: TextStyle(color: Color(MyColors.primaryColor)),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
