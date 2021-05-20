import 'package:coral_reef/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CoralRewards extends StatefulWidget {
  static final routeName = "coralRewards";
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<CoralRewards> {
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
              Text(
                'My coral rewards',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: getProportionateScreenWidth(15),
                    fontWeight: FontWeight.bold),
              ),
              Text('')
            ],
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 30,),
                      SvgPicture.asset(
                        "assets/exercise/coral_reward.svg",
                        height: 100,
                      ),
                      Text(
                        'You have earned',
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: getProportionateScreenWidth(15),
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        '5',
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: getProportionateScreenWidth(15),
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        'Coral rewards',
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: getProportionateScreenWidth(15),
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 20,),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.grey[100],
                          height: 40,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text('MARCH 2021',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                          color: Colors.grey,
                                          fontSize: getProportionateScreenWidth(13),
                                        ))),

                              ])),
                      SizedBox(height: 20,),
                      Padding(
                          padding: EdgeInsets.all(20),
                          child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(children: [
                            SvgPicture.asset(
                              "assets/exercise/silver.svg",
                              height: 50,
                            ),
                            Text('12617 steps',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                  color: Colors.grey,
                                  fontSize: getProportionateScreenWidth(13),
                                ))
                          ],),
                          Column(children: [
                            SvgPicture.asset(
                              "assets/exercise/bronze.svg",
                              height: 50,
                            ),
                            Text('12617 steps',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                  color: Colors.grey,
                                  fontSize: getProportionateScreenWidth(13),
                                ))
                          ],),
                          Text('')


                        ],
                      )),
                      SizedBox(height: 20,),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.grey[100],
                          height: 40,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text('FEBRUARY 2021',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                          color: Colors.grey,
                                          fontSize: getProportionateScreenWidth(13),
                                        ))),

                              ])),
                      SizedBox(height: 20,),
                      Padding(
                          padding: EdgeInsets.all(20),
                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(children: [
                                SvgPicture.asset(
                                  "assets/exercise/bronze.svg",
                                  height: 50,
                                ),
                                Text('12617 steps',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                      color: Colors.grey,
                                      fontSize: getProportionateScreenWidth(13),
                                    ))
                              ],),
                              Column(children: [
                                SvgPicture.asset(
                                  "assets/exercise/gold.svg",
                                  height: 50,
                                ),
                                Text('12617 steps',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                      color: Colors.grey,
                                      fontSize: getProportionateScreenWidth(13),
                                    ))
                              ],),
                              Column(children: [
                                SvgPicture.asset(
                                  "assets/exercise/gold.svg",
                                  height: 50,
                                ),
                                Text('12617 steps',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                      color: Colors.grey,
                                      fontSize: getProportionateScreenWidth(13),
                                    ))
                              ],),


                            ],
                          ))

                    ]))));
  }
}
