import 'package:coral_reef/Utils/colors.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../size_config.dart';

class EmailField extends StatelessWidget {
  const EmailField({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
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
      child:TextField(
        keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
      contentPadding: EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 15,),
      border: InputBorder.none,
      suffixIcon:Icon(Icons.mail, color: kPrimaryColor,),
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      hintText: 'Enter your email',
      ),  
     ), 
    );
  }
}