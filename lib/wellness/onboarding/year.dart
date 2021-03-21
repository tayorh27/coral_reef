import 'package:coral_reef/Library/FlutterDatePicker/flutter_datepicker_custom.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/wellness/onboarding/weight.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../size_config.dart';

// class YearScreen extends StatelessWidget {
//   // static String routeName = "/year";
//   final Function(String date) onPress;
//   YearScreen(this.onPress);
//
//   @override
//   Widget build(BuildContext context) {
//     return Body(onPress);
//   }
// }
//
// class Body extends StatefulWidget {
//   final Function(String date) onPress;
//   Body(this.onPress);
//
//   @override
//   _BodyState createState() => _BodyState();
// }

class YearScreen extends StatefulWidget {
  final String currentValue;
  final Function(String date, bool clicked) onPress;
  YearScreen(this.currentValue, {this.onPress});
  @override
  State<StatefulWidget> createState() => _YearScreen();
}

class _YearScreen extends State<YearScreen> {


  String _selectedDate = "2008/3";

  int initialYear = 0;


  @override
  Widget build(BuildContext context) {
    print(widget.currentValue);
    //display the value that was selected if the go back button was displayed on the next page
    initialYear = (widget.currentValue == null) ? DateTime.now().year - 13 : int.parse(widget.currentValue);
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20),
              vertical: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: double.infinity,
                    child: LinearDatePicker(
                        startDate: "1900/01/01", //yyyy/mm/dd
                        endDate:
                            "${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}",
                        initialDate:
                            "$initialYear/${DateTime.now().month}/${DateTime.now().day}",
                        dateChangeListener: (String selectedDate) {
                          print(selectedDate);
                          _selectedDate = selectedDate;
                        },
                        showDay: false, //false -> only select year & month
                        fontFamily: 'AvenirNextDemiBold',
                        showLabels:
                            false, // to show column captions, eg. year, month, etc.
                        textColor: Color(MyColors.titleTextColor),
                        selectedColor: Color(MyColors.primaryColor),
                        unselectedColor: Colors.blueGrey,
                        showMonth: false,
                        showMonthName: false,
                        columnWidth: 100.0,
                        isJalaali: false // false -> Gregorian
                        ),
                    // child: CupertinoDatePicker(
                    //   maximumYear: 2100,
                    //   minimumYear: 1900,
                    //   mode: CupertinoDatePickerMode.date,
                    //   initialDateTime: DateTime.now(),
                    //   onDateTimeChanged: (val){
                    //   setState(() {
                    //   chosenDateTime = val;
                    // });}),
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.1),
                Container(
                  width: double.infinity,
                  height: getProportionateScreenHeight(56),
                  decoration: BoxDecoration(
                    color: Color(MyColors.primaryColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () {
                      print('yeahhh');
                      widget.onPress(_selectedDate, true);
                    },
                    child: Text('Continue',
                        style: Theme.of(context).textTheme.headline2.copyWith(
                              fontSize: getProportionateScreenWidth(16),
                              color: Colors.white,
                            )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
