import 'package:coral_reef/Library/FlutterDatePicker/flutter_datepicker_custom.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../size_config.dart';

class LastPeriodScreen extends StatelessWidget {

  final String currentValue;
  final Function(String date, bool clicked) onPress;
  LastPeriodScreen(this.currentValue,{this.onPress});

  String _selectedDate = "";

  String initialDate = "";

  @override
  Widget build(BuildContext context) {
    //display the value that was selected if the go back button was displayed on the next page
    initialDate = (currentValue == null) ? "${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}" : currentValue;
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
                        initialDate: initialDate,
                        dateChangeListener: (String selectedDate) {
                          print(selectedDate);
                          _selectedDate = selectedDate;
                        },
                        showDay: true, //false -> only select year & month
                        fontFamily: 'AvenirNextDemiBold',
                        showLabels:
                        true, // to show column captions, eg. year, month, etc.
                        yearText: "Year",
                        monthText: "Month",
                        dayText: "Day",
                        textColor: Color(MyColors.titleTextColor),
                        selectedColor: Color(MyColors.primaryColor),
                        unselectedColor: Colors.blueGrey,
                        showMonth: true,
                        showYear: true,
                        showMonthName: true,
                        columnWidth: 100.0,
                        isJalaali: false // false -> Gregorian
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: getProportionateScreenHeight(56),
                  decoration: BoxDecoration(
                    color: Color(MyColors.primaryColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () {
                      onPress(_selectedDate, true);
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
