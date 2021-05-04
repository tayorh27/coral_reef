import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class Steps extends StatefulWidget {
  static final routeName = "steps";
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Steps> {
  double steps = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child:
              Icon(Icons.arrow_back_ios)),
              Text(
                'Steps',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: getProportionateScreenWidth(15),
                    ),
              ),
              SvgPicture.asset(
                  "assets/icons/clarity_notification-outline-badged.svg",
                  height: 22.0),
            ],
          ),
        ),
        body:  Container(
                padding: EdgeInsets.all(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Goal',
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      fontSize: getProportionateScreenWidth(18),
                                    ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(steps.round().toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                      color: Color(MyColors.primaryColor),
                                      fontSize: getProportionateScreenWidth(25),
                                      fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            width: 200.0,
                            height: 200.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100.0)),
                            child: SleekCircularSlider(
                                appearance: CircularSliderAppearance(
                                    angleRange: 360.0,
                                    customColors: CustomSliderColors(
                                      progressBarColors: [
                                        Colors.deepPurpleAccent,
                                        Color(MyColors.dietSliderTrackColor),
                                      ],
                                      trackColor:
                                          Color(MyColors.dietSliderBgColor),
                                      dynamicGradient: true,
                                    ),
                                    customWidths:
                                        CustomSliderWidths(trackWidth: 8.0)),
                                initialValue: steps,
                                min: 1,
                                max: 10000,
                                innerWidget: (double value) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/exercise/purple_foot.svg",
                                        height: 40.0,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(steps.round().toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .copyWith(
                                                  color: Colors.black,
                                                  fontSize:
                                                      getProportionateScreenWidth(
                                                          20),
                                                  fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("Steps",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .copyWith(
                                                  color: Colors.black,
                                                  fontSize:
                                                      getProportionateScreenWidth(
                                                          15),
                                                  fontWeight: FontWeight.bold)),
                                    ],
                                  );
                                },
                                onChange: (double value) {
                                  print(value);
                                  setState(() {
                                    steps = value;
                                  });
                                }),
                          ),
                          Container(
                              padding: EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/exercise/fire.svg",
                                        height: 40.0,
                                      ),
                                      Text("406 kcal",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .copyWith(
                                                color: Colors.black,
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        15),
                                              )),
                                    ],
                                  ),
                                  Column(children: [
                                    SvgPicture.asset(
                                      "assets/exercise/location.svg",
                                      height: 40.0,
                                    ),
                                    Text("1.6 km",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                              color: Colors.black,
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      15),
                                            )),
                                  ]),
                                  Column(children: [
                                    SvgPicture.asset(
                                      "assets/exercise/time.svg",
                                      height: 40.0,
                                    ),
                                    Text("45 Min",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                              color: Colors.black,
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      15),
                                            )),
                                  ]),
                                ],
                              )),
                          SizedBox(height: 50,),
                          DefaultButton(
                            text: 'Set daily goal',
                            press: () {},
                          )
                        ],
                      )
                    ])));
  }
}
