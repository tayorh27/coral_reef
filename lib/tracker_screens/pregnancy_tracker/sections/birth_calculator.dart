
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/coral_back_button.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import '../../../size_config.dart';

class BirthCalculator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BirthCalculator();
}

class _BirthCalculator extends State<BirthCalculator> {

  TextEditingController _textEditingController = new TextEditingController(text: "");
  StorageSystem ss = new StorageSystem();

  final format = DateFormat("yyyy-MM-dd");

  bool isNew = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ss.getItem("pregnancyCalculatorDate").then((value) {
      if (value == null) return;
      isNew = false;
      _textEditingController.text = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CoralBackButton(
                      icon: Icon(
                        Icons.clear,
                        size: 32.0,
                        color: Color(MyColors.titleTextColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                Text(
                  "Due Date Calculator",
                  style: Theme.of(context).textTheme.headline2.copyWith(
                    color: Color(MyColors.titleTextColor),
                    fontSize: getProportionateScreenWidth(20),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 90.0),
                    width: double.infinity,
                    height: getProportionateScreenHeight(300),
                    child: Column(
                      children: [
                        dateField(),
                        YourNameText(title: "Enter the first day of your last period and get info about your due date."),
                        SizedBox(height: getProportionateScreenHeight(5)),
                      ],
                    )),
                Align(
                  child: DefaultButton(
                    text: 'Submit',
                    press: () async {
                      if(_textEditingController.text.isEmpty) {
                        new GeneralUtils().displayAlertDialog(context, "Attention", "Please end the requested date.");
                        return;
                      }
                      final selectedDate = DateTime.parse(_textEditingController.text);
                      final diff = selectedDate.difference(DateTime.now()).inDays;
                      if(diff > 0) {
                        new GeneralUtils().displayAlertDialog(context, "Attention", "Please select a past date.");
                        return;
                      }
                      await ss.setPrefItem("pregnancyCalculatorDate", _textEditingController.text);
                      await displayDueDate();
                      showNotification();
                      Navigator.of(context).pop(true);
                    },
                  ),
                  alignment: Alignment.bottomCenter,
                )
              ],
            ),
          ),
        ),
      ));
  }

  Widget dateField() {
    return Container(
      decoration: BoxDecoration(
        color: Color(MyColors.formFillColor),
        border: Border.all(
          color: Color(MyColors.primaryColor),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: DateTimeField(
        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100),
            builder: (context, child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  primaryColor: Color(MyColors.primaryColor),
                  accentColor: Color(MyColors.primaryColor),
                  colorScheme: ColorScheme.light(primary: Color(MyColors.primaryColor)),
                  buttonTheme: ButtonThemeData(
                      textTheme: ButtonTextTheme.primary
                  ),
                ),
                child: child,
              );
            }
          );
        },
        keyboardType: TextInputType.datetime,
        obscureText: false,
        controller: _textEditingController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 15,
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          prefixIcon: Icon(Icons.calendar_today_rounded, color: Color(MyColors.primaryColor),)
          //hintText: '',
        ),
      ),
    );
  }

  getBirthDate() {
    List<String> months = ["Jan", "Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];

    final calculatorDate = DateTime.parse(_textEditingController.text);

    final dueDateInWeeks = calculatorDate.add(Duration(days: 252)); ///adding 36weeks to the last period date

    return "${months[dueDateInWeeks.month]} ${dueDateInWeeks.day}, ${dueDateInWeeks.year}";
  }

  Future<bool> displayDueDate() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new CoralBackButton(
            icon: IconButton(icon: Icon(Icons.close), iconSize: 32.0, onPressed: (){Navigator.of(context).pop();},),
          ),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                Container(
                  height: getProportionateScreenHeight(200),
                  width: getProportionateScreenWidth(250),
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage("assets/images/due_popup.png"), fit: BoxFit.contain),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Container(height: 50.0,),
                        Text(
                          "Your Due date is",textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Color(MyColors.primaryColor),
                            fontSize: getProportionateScreenWidth(15),),
                        ),
                        Text(
                          getBirthDate(), textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline2.copyWith(
                            color: Color(MyColors.primaryColor),
                            fontSize: getProportionateScreenWidth(20),),
                        )
                      ],
                    ),
                  )
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  showNotification() {
    if(isNew) {

    }
  }
}

class YourNameText extends StatelessWidget {
  const YourNameText({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        title,
        style: Theme
            .of(context)
        .textTheme
        .subtitle1
        .copyWith(color: Color(MyColors.titleTextColor)),
    )
    );
  }
}