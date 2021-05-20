import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StartCommunity extends StatefulWidget {
  static final routeName = "startCommunity";
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<StartCommunity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios)),
            ],
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/exercise/speed_run_2.svg",
                          height: 150.0),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'February 5 km race',
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: getProportionateScreenWidth(20),
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset("assets/exercise/female.svg",
                                    height: 12.0),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '2-12 peoples',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                          fontSize:
                                              getProportionateScreenWidth(10),
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 40,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset("assets/exercise/calender.svg",
                                    height: 12.0),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '2 days',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                          fontSize:
                                              getProportionateScreenWidth(10),
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ]),
                      Divider(
                        thickness: 2,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(MyColors.primaryColor).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: getProportionateScreenWidth(
                            MediaQuery.of(context).size.width / 1.5),
                        height: getProportionateScreenHeight(130),
                        child:
                        Padding(
                          padding: EdgeInsets.all(20),
                          child:
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Rules",
                              textAlign: TextAlign.start,
                              style:
                              TextStyle(color: Color(MyColors.primaryColor), fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Divider(thickness: 2, color: Color(MyColors.primaryColor),),
                            Text(
                              "Only GPS tracked walks, runs and hikes only",
                              textAlign: TextAlign.start,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                            Text(
                              "Excludes manually recorded activities",
                              textAlign: TextAlign.start,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ],
                        ),)
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 5,
                      ),
                      DefaultButton(
                        press: () {},
                        text: 'Join',
                      )
                    ]))));
  }
}
