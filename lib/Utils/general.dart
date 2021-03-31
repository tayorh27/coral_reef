import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../size_config.dart';
import 'colors.dart';

class GeneralUtils {
  GeneralUtils();

  // String formattedMoney(double price, String currency) {
  //   MoneyFormatterOutput mfo = FlutterMoneyFormatter(
  //           amount: price,
  //           settings: MoneyFormatterSettings(
  //               symbol: currency,
  //               thousandSeparator: ',',
  //               decimalSeparator: '.',
  //               symbolAndNumberSeparator: '',
  //               fractionDigits: 2,
  //               compactFormatType: CompactFormatType.short))
  //       .output;
  //   return mfo.symbolOnLeft;
  // }

  Future<Null> displayAlertDialog(
      BuildContext context, String _title, String _body) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
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
                Padding(
                    padding: const EdgeInsets.only(left:30.0, right: 30.0, top: 30.0),
                    child: new Text(
                      _body,
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Color(MyColors.titleTextColor),
                          fontSize: getProportionateScreenWidth(15),),
                    )),
              ],
            ),
          ),
          actions: <Widget>[
            new TextButton(
              child: new Text('OK', style: TextStyle(color: Color(MyColors.primaryColor)),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showToast(BuildContext context, String msg) {
    Fluttertoast.showToast(
        msg: "$msg",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: Theme.of(context).primaryColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  final String serverToken =
      'AAAA0pPB70Y:APA91bFfVENthJfYjW3hBfBcU2yxmDOBG2L-qHzQQfoa80tGwC-ckKzx3r6xy51DhHg-zlAAZVk9-L7LjuvDuoY_SZqJxJAJSkUTfYMzRUWwg0PX6TxXIBVkRyq6lQjtI_YaD8U3dgyT';
  // final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  Future<void> sendAndRetrieveMessage(
      String _body, String _title, List<dynamic> _ids) async {
    // _ids.forEach((id) async {
    //   http.Response r = await http.post(
    //     'https://fcm.googleapis.com/fcm/send',
    //     headers: <String, String>{
    //       'Content-Type': 'application/json',
    //       'Authorization': 'key=$serverToken',
    //     },
    //     body: jsonEncode(
    //       <String, dynamic>{
    //         'notification': <String, dynamic>{
    //           'body': _body,
    //           'title': _title
    //         },
    //         'priority': 'high',
    //         // 'data': <String, dynamic>{
    //         //   'click_action': 'FLUTTER_NOTIFICATION_CLICK',
    //         //   'id': '1',
    //         //   'status': 'done'
    //         // },
    //         'to': id,
    //       },
    //     ),
    //   );
    //   print(r.body);
    // });

    // http.Response r = await http.post(
    //   'https://us-central1-my-coffeeapp.cloudfunctions.net/sendnt?title=$_title&message=$_body',
    //   body: jsonEncode(
    //     <String, dynamic>{
    //       'id': _ids,
    //     },
    //   ),
    // );
    // print(r.body);
  }

  // Future<void> sendNotificationToTopic(String _body, String _title, String topic) async {
  //   http.Response r = await http.get(
  //     'https://us-central1-my-coffeeapp.cloudfunctions.net/sendtopic?topic=$topic&title=$_title&message=$_body',
  //   );
  //   print(r.body);
  // }
  //
  // Future<void> subscribeToTopic(String _topic, List<dynamic> _ids) async {
  //
  //   http.Response r = await http.post(
  //     'https://us-central1-my-coffeeapp.cloudfunctions.net/subtopic?topic=$_topic',
  //     body: jsonEncode(
  //       <String, dynamic>{
  //         'id': _ids,
  //       },
  //     ),
  //   );
  //   print(r.body);
  // }

  String returnFormattedDate(String createdDate) {
    var secs = DateTime.now().difference(DateTime.parse(createdDate)).inSeconds;
    if (secs > 60) {
      var mins =
          DateTime.now().difference(DateTime.parse(createdDate)).inMinutes;
      if (mins > 60) {
        var hrs =
            DateTime.now().difference(DateTime.parse(createdDate)).inHours;
        if (hrs > 24) {
          var days =
              DateTime.now().difference(DateTime.parse(createdDate)).inDays;
          return (days > 1) ? '$days days ago' : '$days day ago';
        } else {
          return (hrs > 1) ? '$hrs hrs ago' : '$hrs hr ago';
        }
      } else {
        return '$mins mins ago';
      }
    } else {
      return '$secs secs ago';
    }
  }
}
