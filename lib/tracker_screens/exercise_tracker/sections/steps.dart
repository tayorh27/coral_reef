import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/size_config.dart';
import 'package:direct_select/direct_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:intl/intl.dart';

class Steps extends StatefulWidget {
  static final routeName = "steps";
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Steps> {
  double steps = 5000;
  final elements = [
    "5000",
    "8000",
    "10000",
    "11000",
    "12000",
    "15000",
    "18000",
    "20000",
    "22000",
    "25000",
    "28000",
    "30000",
    "33000",
  ];

  var outputFormat = DateFormat('dd MMM yyyy hh:mm a');
  int selectedIndex = 0;
  List<Widget> _buildItems1() {
    return elements
        .map((val) => MySelectionItem(
      title: val,
    ))
        .toList();
  }
  _showGoalDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
            Column(
              children: [
                Text("Set daily step goal", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200),),
SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Date", style: TextStyle(fontSize: 12),),
                    Text( outputFormat.format(DateTime.now()).toString(), style: TextStyle(fontSize: 12,color:Color(MyColors.primaryColor).withOpacity(0.8)),),

                ],)

              ],
            ),
            content:
                Container(
                  height: 150,
                  child:
            Column(
              children: [

            DirectSelect(
                itemExtent: 35.0,
                selectionColor:  Color(MyColors.primaryColor).withOpacity(0.1),
                selectedIndex: selectedIndex,
                child: MySelectionItem(
                  isForList: false,
                  title: elements[selectedIndex],
                ),
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedIndex = index;
                   Navigator.pop(context);
                    Navigator.pop(context);
                    steps = double.parse(elements[selectedIndex]);
                    print(selectedIndex);
                    _showGoalDialog();
                  });
                },
                mode: DirectSelectMode.tap,
                items: _buildItems1()),
                SizedBox(height: 40,),
                Container(
                  height: 40,
                  child:
                DefaultButton(
                  text: 'Save',
                  press: () {
                   Navigator.pop(context);
                  },
                ))
              ],
            ),),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(15)),
          );
        });
  }
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
                                max: 33000,
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
                                  //print(value);
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
                                      Text((steps / 63.4).roundToDouble().toString() +"kcal",
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
                                    Text((steps * 0.000762).roundToDouble().toString() + 'km',
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
                                    Text((steps / 100).round().toString()  +"Min",
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
                            press: () {
                              _showGoalDialog();
                            },
                          )
                        ],
                      )
                    ])));
  }
}
//You can use any Widget
class MySelectionItem extends StatelessWidget {
  final String title;
  final bool isForList;

  const MySelectionItem({Key key, this.title, this.isForList = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child: isForList
          ? Padding(
        child: _buildItem(context),
        padding: EdgeInsets.all(10.0),
      )
          : Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: Stack(
          children: <Widget>[
            _buildItem(context),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.arrow_drop_down),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: FittedBox(
          child: Text(
            title,style: TextStyle(color:Color(MyColors.primaryColor).withOpacity(0.8), fontWeight: FontWeight.w500, fontSize: 30),
          )),
    );
  }
}