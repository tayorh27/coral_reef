import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/ListItem/model_challenge.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/constants.dart';
import 'package:coral_reef/size_config.dart';
import 'package:coral_reef/wallet_screen/services/wallet_service.dart';
import 'package:direct_select/direct_select.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CreateChallengePage extends StatefulWidget {
  static final routeName = "createChallengePage";
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<CreateChallengePage> {

  shareDialog() {
    return showDialog(

        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(15)),
            content: Container(
                height: MediaQuery.of(context).size.height / 2,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(''),
                          Text(
                            'Invite friends',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    fontSize: getProportionateScreenWidth(15),
                                    fontWeight: FontWeight.w500),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.clear,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/exercise/group_people.png",
                            height: 70,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Send a link to your friends and family',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    fontSize: getProportionateScreenWidth(15),
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'to join your friendly challenge',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    fontSize: getProportionateScreenWidth(15),
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) {
                              //widget.onTextChanged(value, error);
                            },
                            validator: (value) {
                              setState(() {
                                //  error = value.isEmpty;
                              });
                              //idget.onTextChanged(value, error);
                              return value.isEmpty ? '' : null;
                            },
                            decoration: InputDecoration(
                              fillColor: Colors.grey,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 15,
                              ),
                              border: InputBorder.none,
                              hintText: 'https://coralreef.com/Sv89Cm',
                              hintStyle: TextStyle(fontSize: 12),
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                            ),
                          ),
                          Text(
                            'Copy link',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    fontSize: getProportionateScreenWidth(15),
                                    color: Color(MyColors.primaryColor),
                                    fontWeight: FontWeight.w300),
                          ),
                          Container(
                              padding: EdgeInsets.all(20),
                              child: DefaultButton(
                                loading: false,
                                text: 'Share Link',
                              ))
                        ],
                      )
                    ])),
          );
        });
  }

  TextEditingController controller = new TextEditingController(text: "");
  TextEditingController controllerDetails = new TextEditingController(text: "");

  StorageSystem ss = new StorageSystem();

  String activityType = "Run";
  String challengeDistance = "0";
  String challengeStartDate = "";
  String challengeEndDate = "";
  String challengeRewardType = "Sponsor";
  String challengeRewardValue = "";

  String challengeType = "";

  bool _loading = false;

  String crlxBalance = "0";

  WalletServices walletServices;
  Map<String, dynamic> addresses = new Map();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    walletServices = new WalletServices();
    setupInitWallet();
  }

  setupInitWallet() async {
    addresses = await walletServices.getUserAddresses();
    Map<String, dynamic> resp = await walletServices.getTokenBalance(addresses["public"]);
    crlxBalance = resp["crlx"];
  }


  @override
  Widget build(BuildContext context) {
    challengeType = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          leading: (!_loading) ? InkWell(child: Icon(Icons.arrow_back_ios), onTap: (){Navigator.of(context).pop();},) : SizedBox(),
          elevation: 0,
          title: Text(
            'Create virtual challenge',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                fontSize: getProportionateScreenWidth(15),
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
              SizedBox(height: 40),
              Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey[100],
                  height: 50,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            padding: EdgeInsets.only(left: 20),
                            child: Text('TITLE',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      fontSize: getProportionateScreenWidth(13),
                                    )))
                      ])),
              TextFormField(
                obscureText: false,
                controller: controller,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontSize: 12.0,
                  color: Color(MyColors.titleTextColor)
              ),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    border: InputBorder.none,
                    hintText: 'Type your challenge title here',
                    hintStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: 12.0,
                      color: Colors.grey
                    ),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    // suffixIcon: Icon(
                    //   Icons.cancel,
                    //   color: Colors.grey[400],
                    //   size: 20,
                    // )
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey[100],
                  height: 50,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            padding: EdgeInsets.only(left: 20),
                            child: Text('RULES',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      fontSize: getProportionateScreenWidth(13),
                                    )))
                      ])),
              InkWell(
                onTap: (){
                  return showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      //context: _scaffoldKey.currentContext,
                      builder: (context) {
                        return AlertDialogPage(title: "Select your challenge type", options: ["Walk", "Run", "Hike"], onOptionSelected: (val){
                          if(!mounted) return;
                          setState(() {
                            activityType = val;
                          });
                        },);
                      });
                },
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    //  color: Colors.grey[100],
                    height: 40,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text('Select your challenge type',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                        fontSize:
                                        getProportionateScreenWidth(13),
                                      ))),
                              Container(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Row(
                                    children: [
                                      Text(activityType,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                              fontSize:
                                              getProportionateScreenWidth(
                                                  13),
                                              color: Color(
                                                  MyColors.primaryColor))),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Color(MyColors.primaryColor),
                                      )
                                    ],
                                  ))
                            ],
                          )
                        ])),
              ),
              Divider(
                thickness: 2,
                indent: 20,
                endIndent: 20,
              ),
              InkWell(
                onTap: (){
                  return showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      //context: _scaffoldKey.currentContext,
                      builder: (context) {
                        return AlertDialogPage(title: "Select GPS distance", options: List.generate(35, (index) => "${index + 1}"), onOptionSelected: (val){
                          if(!mounted) return;
                          setState(() {
                            challengeDistance = val;
                          });
                        },);
                      });
                },
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    //  color: Colors.grey[100],
                    height: 40,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text('GPS distance',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                        fontSize:
                                        getProportionateScreenWidth(13),
                                      ))),
                              Container(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Row(
                                    children: [
                                      Text('$challengeDistance km',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                              fontSize:
                                              getProportionateScreenWidth(
                                                  13),
                                              color: Color(
                                                  MyColors.primaryColor))),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Color(MyColors.primaryColor),
                                      )
                                    ],
                                  ))
                            ],
                          ),
                        ])),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey[100],
                  height: 50,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            padding: EdgeInsets.only(left: 20),
                            child: Text('START AND END DATE',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      color: Colors.grey,
                                      fontSize: getProportionateScreenWidth(13),
                                    )))
                      ])),
              InkWell(
                onTap: () async {
                  DateTime getStartDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: DateTime.now(),
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
                  if(getStartDate == null) return;
                  TimeOfDay getStartTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
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
                  setState(() {
                    challengeStartDate = "${getStartDate.toString().split(" ")[0]} ${returnFormattedNumber(getStartTime.hour)}:${returnFormattedNumber(getStartTime.minute)}:00";
                  });
                },
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    //  color: Colors.grey[100],
                    height: 40,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text('Start date',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                        fontSize:
                                        getProportionateScreenWidth(13),
                                      ))),
                              Container(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Row(
                                    children: [
                                      Text((challengeStartDate.isEmpty) ? 'Choose date' : challengeStartDate,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                              fontSize:
                                              getProportionateScreenWidth(
                                                  13),
                                              color: (challengeStartDate.isEmpty) ? Colors.grey : Color(MyColors.primaryColor)
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Color(MyColors.primaryColor),
                                      )
                                    ],
                                  ))
                            ],
                          )
                        ])),
              ),
              Divider(
                thickness: 2,
                indent: 20,
                endIndent: 20,
              ),
            InkWell(
                onTap: () async {
                  DateTime getEndDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: DateTime.now(),
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
                  if(getEndDate == null) return;
                  TimeOfDay getEndTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
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
                  setState(() {
                    challengeEndDate = "${getEndDate.toString().split(" ")[0]} ${returnFormattedNumber(getEndTime.hour)}:${returnFormattedNumber(getEndTime.minute)}:00";
                  });
                },
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  //  color: Colors.grey[100],
                  height: 40,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                padding: EdgeInsets.only(left: 20),
                                child: Text('End date',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                          fontSize:
                                              getProportionateScreenWidth(13),
                                        ))),
                            Container(
                                padding: EdgeInsets.only(right: 20),
                                child: Row(
                                  children: [
                                    Text((challengeEndDate.isEmpty) ? 'Set end date' : challengeEndDate,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        13),
                                                color: (challengeEndDate.isEmpty) ? Colors.grey : Color(MyColors.primaryColor)
                                        )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(MyColors.primaryColor),
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ])),
            ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey[100],
                  height: 50,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            padding: EdgeInsets.only(left: 20),
                            child: Text('DETAILS',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      color: Colors.grey,
                                      fontSize: getProportionateScreenWidth(13),
                                    ))),
                      ])),
              Container(
                  padding: EdgeInsets.only(left: 10),
                  child: TextFormField(
                    obscureText: false,
                    controller: controllerDetails,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 3,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontSize: 15.0,
                        color: Color(MyColors.titleTextColor)
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                      border: InputBorder.none,
                      hintText: 'Short description',
                      hintStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: 15.0,
                          color: Colors.grey
                      ),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  )),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey[100],
                      height: 50,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                padding: EdgeInsets.only(left: 20),
                                child: Text('REWARD',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                      color: Colors.grey,
                                      fontSize: getProportionateScreenWidth(13),
                                    ))),
                          ])),
              InkWell(
                onTap: (){
                  return showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      //context: _scaffoldKey.currentContext,
                      builder: (context) {
                        return AlertDialogPage(title: "Select Reward type", options: ["Sponsor", "Pool"], description: "Sponsor: This means the winner of this challenge gets to be rewarded from your XCRL wallet.\nPool: This means everyone gets to pay a certain amount to join this challenge. Winner takes all.", onOptionSelected: (val){
                          if(!mounted) return;
                          setState(() {
                            challengeRewardType = val;
                          });
                        },);
                      });
                },
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    //  color: Colors.grey[100],
                    height: 40,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text('Select reward type',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                        fontSize:
                                        getProportionateScreenWidth(13),
                                      ))),
                              Container(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Row(
                                    children: [
                                      Text((challengeRewardType.isEmpty) ? 'Reward type' : challengeRewardType,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                              fontSize:
                                              getProportionateScreenWidth(
                                                  13),
                                              color: (challengeRewardType.isEmpty) ? Colors.grey : Color(MyColors.primaryColor)
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Color(MyColors.primaryColor),
                                      )
                                    ],
                                  ))
                            ],
                          ),
                        ])),
              ),
                  Divider(
                    thickness: 2,
                    indent: 20,
                    endIndent: 20,
                  ),
            InkWell(
                onTap: (){
                  return showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      //context: _scaffoldKey.currentContext,
                      builder: (context) {
                        return AlertDialogPage(title: "Select Reward amount", options: List.generate(1000, (index) => "${index + 1}"), onOptionSelected: (val){
                          if(!mounted) return;
                          setState(() {
                            challengeRewardValue = val;
                          });
                        },);
                      });
                },
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      //  color: Colors.grey[100],
                      height: 40,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text('Select $challengeRewardType amount',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                          fontSize:
                                          getProportionateScreenWidth(13),
                                        ))),
                                Container(
                                    padding: EdgeInsets.only(right: 20),
                                    child: Row(
                                      children: [
                                        Text((challengeRewardValue.isEmpty) ? 'Reward amount' : '$challengeRewardValue XCRL',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                fontSize:
                                                getProportionateScreenWidth(
                                                    13),
                                                color: (challengeRewardValue.isEmpty) ? Colors.grey : Color(MyColors.primaryColor)
                                            )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: Color(MyColors.primaryColor),
                                        )
                                      ],
                                    ))
                              ],
                            ),
                          ])),
            ),
              Container(
                  padding: EdgeInsets.all(20),
                  child: DefaultButton(
                    loading: _loading,
                    press: () {
                      // shareDialog();
                      publishChallenge();
                    },
                    text: 'Publish',
                  ))
            ])));
  }

  String returnFormattedNumber(int number) {
    if(number < 10) {
      return "0$number";
    }
    return "$number";
  }

  publishChallenge() async {
    if(controller.text.isEmpty || controllerDetails.text.isEmpty) {
      new GeneralUtils().displayAlertDialog(context, "Attention", "Please enter challenge title and a short description.");
      return;
    }
    if(challengeDistance.isEmpty || challengeDistance == "0") {
      new GeneralUtils().displayAlertDialog(context, "Attention", "Please select the GPS distance.");
      return;
    }
    if(challengeStartDate.isEmpty || challengeEndDate.isEmpty) {
      new GeneralUtils().displayAlertDialog(context, "Attention", "Please select both start and end dates.");
      return;
    }
    DateTime today = DateTime.now();
    DateTime start = DateTime.parse(challengeStartDate);
    DateTime end = DateTime.parse(challengeEndDate);

    int diffStart = start.difference(today).inMilliseconds;
    int diffEnd = end.difference(start).inMilliseconds;

    if(diffStart < 0) {
      new GeneralUtils().displayAlertDialog(context, "Attention", "Please select a future or today's date for your start date.");
      return;
    }

    if(diffEnd < 0) {
      new GeneralUtils().displayAlertDialog(context, "Attention", "Please select a future date for your end date.");
      return;
    }

    if(challengeRewardType.isEmpty || challengeRewardValue.isEmpty) {
      new GeneralUtils().displayAlertDialog(context, "Attention", "Please select reward details.");
      return;
    }

    bool allowDebitForSponsor = false;

    if(challengeRewardType == "Sponsor") {

      bool isAllowed = await new GeneralUtils().displayReturnedValueAlertDialog(context, "Attention", "$challengeRewardValue CRLX will be deducted from your wallet for sponsoring this challenge.");
      if(!isAllowed) return;

      double crlx = double.parse(crlxBalance);
      double chanValue = double.parse(challengeRewardValue);

      if(crlxBalance == "0" || crlx < chanValue) {
        new GeneralUtils().displayAlertDialog(context, "Attention", "Sorry, you do not have enough XCRL to sponsor this challenge. You can select the Pool reward type instead.");
        return;
      }

      allowDebitForSponsor = true;
    }

    setState(() {
      _loading = true;
    });

    if(allowDebitForSponsor) {
      //debit user crlx account
      await walletServices.transferAdmin(addresses["public"], "$challengeRewardValue XCRL has been deducted from your wallet for being a sponsor.", challengeRewardValue);
    }

    String id = FirebaseDatabase.instance.reference().push().key;

    //get user data
    String localUser = await ss.getItem('user');
    Map<String, dynamic> json = jsonDecode(localUser);

    int winnerAmount = (challengeRewardType == "Sponsor") ? int.parse(challengeRewardValue) : 0;

    try {
      VirtualChallenge vc = new VirtualChallenge(
          id,
          user.uid,
          challengeType,
          controller.text,
          activityType,
          challengeDistance,
          challengeStartDate,
          challengeEndDate,
          controllerDetails.text,
          challengeRewardType,
          challengeRewardValue,
          new DateTime.now().toString(),
          "link",
          json["msgId"],
          FieldValue.serverTimestamp(), 0, "pending",winnerAmount, id.substring(2,8),0,0
      );
      await FirebaseFirestore.instance.collection("challenges").doc(id).set(
          vc.toJSON());

      setState(() {
        _loading = false;
      });
      new GeneralUtils().showToast(context, "Challenge created.");
      Navigator.of(context).pop();
    }catch (err) {
      setState(() {
        _loading = false;
      });
      new GeneralUtils().displayAlertDialog(context, "Attention", "$err");
    }

  }
}

class AlertDialogPage extends StatefulWidget {
  const AlertDialogPage({
    Key key,
    this.onOptionSelected,
    this.options,
    this.title,
    this.description = ""
  }) : super(key: key);

  final Function(String value) onOptionSelected;
  final List<String> options;
  final String title;
  final String description;

  @override
  _AlertDialogPageState createState() => _AlertDialogPageState();
}

class _AlertDialogPageState extends State<AlertDialogPage> {

  int selectedIndex = 0;

  List<Widget> buildItems() {
    return widget.options.map((e) => Container(height: 60.0, child: Text(
        e,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline2.copyWith(
            color: Color(MyColors.primaryColor),
            fontSize: getProportionateScreenWidth(35),
            height: 2.0
        )),)
    ).toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          Text(
              widget.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: Color(MyColors.titleTextColor),
                  fontSize: getProportionateScreenWidth(18)
              )
          ),
          (widget.description.isEmpty) ? SizedBox() : Text(
              widget.description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: Colors.grey,
                  fontSize: getProportionateScreenWidth(13)
              )
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Container(
        height: 250,
        width: 300,
        child: SingleChildScrollView(
          child: Container(
            child: Center(
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Divider(),
                  DirectSelect(
                      itemExtent: 70.0,
                      selectedIndex: selectedIndex,
                      child: Text(
                        widget.options[selectedIndex],
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline2.copyWith(
                            color: Color(MyColors.primaryColor),
                            fontSize: getProportionateScreenWidth(35),
                            height: 2.0
                        ),
                      ),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      mode: DirectSelectMode.tap,
                      items: buildItems()),
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0, top: 0.0),
                    child: Text(
                      "Tap to select your preferred option",
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Colors.grey,
                        fontSize: getProportionateScreenWidth(12),
                      ),
                    ),
                  ),
                  Divider(),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  DefaultButton(
                      text: 'Save',
                      press: () {
                        widget.onOptionSelected(widget.options[selectedIndex]);
                        Navigator.of(context).pop(false);
                      }
                  ),
                  TextButton(onPressed: (){
                    Navigator.of(context).pop(false);
                  }, child: Text(
                    "Cancel",
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Color(MyColors.primaryColor),
                        fontSize: getProportionateScreenWidth(16)
                    ),
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
