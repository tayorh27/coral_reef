
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/ListItem/model_gchat_report.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../size_config.dart';

class ReportDialog {

  BuildContext context;

  TextEditingController _controller = new TextEditingController(text: "");

  StorageSystem ss = new StorageSystem();

  String type = "", gchat_id = "";

  ReportDialog(BuildContext _context, String _gchat_id, String _type) {
    this.context = _context;
    this.gchat_id = _gchat_id;
    this.type = _type;
  }

  Future<Null> displayReportDialog(
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
                    child: Column(
                      children: [
                        YourReportText(),
                        SizedBox(height: getProportionateScreenHeight(5)),
                        yourReportField(),
                      ],
                    )),
              ],
            ),
          ),
          actions: <Widget>[
            new TextButton(
              child: new Text('CANCEL', style: TextStyle(color: Colors.redAccent),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new TextButton(
              child: new Text('REPORT', style: TextStyle(color: Color(MyColors.primaryColor)),),
              onPressed: () {
                Navigator.of(context).pop();
                submitReport();
              },
            ),
          ],
        );
      },
    );
  }

  Widget yourReportField() {
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
      child: TextFormField(
        keyboardType: TextInputType.text,
        maxLines: 1,
        obscureText: false,
        controller: _controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 15,
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          //hintText: '',
        ),
      ),
    );
  }
  
  submitReport() async {

    String key = FirebaseDatabase.instance.reference().push().key;

    //get user data
    String user = await ss.getItem('user');
    Map<String, dynamic> json = jsonDecode(user);

    //get avatar settings
    String avatar = await ss.getItem("avatar");
    dynamic avatarData = jsonDecode(avatar);

    //get username and topics
    String topics = await ss.getItem("topics");
    Map<String, dynamic> topicsData = jsonDecode(topics);
    String username = topicsData["username"];

    GChatReport gChatReport = new GChatReport(key, gchat_id, json["uid"], username, avatarData, _controller.text, type, new DateTime.now().toString(), FieldValue.serverTimestamp());

    await FirebaseFirestore.instance.collection("reports").doc(key).set(gChatReport.toJSON());

    new GeneralUtils().showToast(context, "Report submitted");
  }
}

class YourReportText extends StatelessWidget {
  const YourReportText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Reason for this report",
          style: Theme.of(context)
              .textTheme
              .subtitle1
              .copyWith(color: Color(MyColors.titleTextColor)),
        ),
        Spacer(),
      ],
    );
  }
}