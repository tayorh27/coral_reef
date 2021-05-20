import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StartWeekdays extends StatefulWidget {
  static final routeName = "startWeekdays";
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<StartWeekdays> {
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
                      SvgPicture.asset("assets/exercise/hill.svg",
                          height: 150.0),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Weekday steps',
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
                                SizedBox(width: 5,),
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
                                SizedBox(width: 5,),
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
                        height: 50,
                      ),
                      Text(
                        'Challenge your friends and family this week',
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: getProportionateScreenWidth(15),
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        'by taking the most steps monday to friday.',
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: getProportionateScreenWidth(15),
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 5,
                      ),
                      DefaultButton(
                        press: () {},
                        text: 'Start now',
                      ),
                      SizedBox(height: 30,),
                      DefaultButton(
                        press: () {},
                        text: 'Start next monday',
                      )
                    ]))));
  }
}
