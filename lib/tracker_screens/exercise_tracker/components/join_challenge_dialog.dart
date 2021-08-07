
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/ListItem/model_challenge.dart';
import 'package:coral_reef/ListItem/model_gchat_report.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';

class JoinChallengeDialog {

  BuildContext context;

  TextEditingController _controller = new TextEditingController(text: "");

  StorageSystem ss = new StorageSystem();

  bool isLoading = false;

  JoinChallengeDialog(BuildContext _context) {
    this.context = _context;
  }

  Future<bool> displayEnterCodeDialog(
      BuildContext context, String _title, String _body) async {
    return showDialog<bool>(
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
                        YourCodeText(),
                        SizedBox(height: getProportionateScreenHeight(5)),
                        yourCodeField(),
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
              child: new Text('ENTER', style: TextStyle(color: Color(MyColors.primaryColor)),),
              onPressed: () async {
                String currentCH = await ss.getItem("currentChallenge");
                if (currentCH != null) {
                  new GeneralUtils().displayAlertDialog(context, "Attention",
                      "Please complete your current challenge before joining another.");
                  Navigator.of(context).pop(false);
                  return;
                }
                final res = await submitCode();
                Navigator.of(context).pop(res);
              },
            ),
          ],
        );
      },
    );
  }

  Widget yourCodeField() {
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
        textCapitalization: TextCapitalization.words,
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

  Future<bool> submitCode() async {
    //get the code entered
    if(_controller.text.isEmpty) {
      return false;
    }
    new GeneralUtils().showToast(context, "Checking code validity...");
    QuerySnapshot query = await FirebaseFirestore.instance.collection("challenges").where("join_code", isEqualTo: _controller.text.toUpperCase()).get();
    if(query.docs.isEmpty) {
      new GeneralUtils().showToast(context, "Invalid challenge code.");
      return false;
    }
    final data = query.docs[0].data();
    VirtualChallenge vc = VirtualChallenge.fromSnapshot(data);
    List<dynamic> friends = vc.friends_list;
    if(friends.contains(user.uid)) {
      new GeneralUtils().showToast(context, "You have joined this challenge already.");
      return false;
    }
    await FirebaseFirestore.instance.collection("challenges").doc(vc.id).update({
      "friends_list": FieldValue.arrayUnion([user.uid]),
    });
    new GeneralUtils().showToast(context, "Joined challenge successfully.");
    return true;
  }
}

class YourCodeText extends StatelessWidget {
  const YourCodeText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Enter the challenge code",
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