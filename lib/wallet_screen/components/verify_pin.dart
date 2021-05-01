
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/ListItem/model_gchat_report.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/wallet_screen/components/pin_input_form.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../size_config.dart';

class VerifyPinDialog {

  BuildContext context;

  String userPin = "", typedPin = "";

  VerifyPinDialog(BuildContext _context, String _userPin) {
    this.context = _context;
    this.userPin = _userPin;
  }

  Future<bool> displayVerifyPinDialog(
      BuildContext context, String _title, String _body) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(_title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText1.copyWith(
            color: Color(MyColors.titleTextColor),
            fontSize: getProportionateScreenWidth(20),),),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                Container(
                  height: getProportionateScreenHeight(50),
                  width: getProportionateScreenWidth(50),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F6F9),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset('assets/images/logo2.png'),
                ),
                SizedBox(height: 15.0,),
                Text(_body, textAlign: TextAlign.center, style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: Color(MyColors.titleTextColor),
                  fontSize: getProportionateScreenWidth(15),),),
                Padding(
                    padding: const EdgeInsets.only(left:0.0, right: 0.0, top: 0.0),
                    child: Column(
                      children: [
                        SetupForm1(onFinish: (String pin) {
                          typedPin = pin;
                        })
                      ],
                    )),
              ],
            ),
          ),
          actions: <Widget>[
            new TextButton(
              child: new Text('CANCEL', style: TextStyle(color: Colors.redAccent),),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            new TextButton(
              child: new Text('DONE', style: TextStyle(color: Color(MyColors.primaryColor)),),
              onPressed: () {
                if(userPin != typedPin) {
                  new GeneralUtils().showToast(context, "Incorrect pin.");
                  Navigator.of(context).pop(false);
                  return;
                }
                Navigator.of(context).pop(true);
                // submitReport();
              },
            ),
          ],
        );
      },
    );
  }
}