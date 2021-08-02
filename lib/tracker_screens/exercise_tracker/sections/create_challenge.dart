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
  String challengeFundingType = "Sponsor";
  String challengeFundingValue = "";

  String challengeWinnerRewardType = "First Winner Only";
  int sharingAmount = 0;

  String challengeType = "";

  bool _loading = false;

  String crlxBalance = "0";

  int maxUsers = 20;

  WalletServices walletServices;
  Map<String, dynamic> addresses = new Map();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    walletServices = new WalletServices();
    setupInitWallet();
    getMaxUsersForChallenges();
  }

  getMaxUsersForChallenges() async {
    DocumentSnapshot query = await FirebaseFirestore.instance.collection("db").doc("global-settings").get();
    Map<String, dynamic> dt = query.data();
    maxUsers = dt["max_challenge_users"];
  }

  setupInitWallet() async {
    addresses = await walletServices.getUserAddresses();
    Map<String, dynamic> resp = await walletServices.getTokenBalance(addresses["public"]);
    crlxBalance = resp["crl"];
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
                                child: Text('FUNDING',
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
                        return AlertDialogPage(title: "Select Funding type", options: ["Sponsor", "Pool"], description: "Sponsor: This means the winner(s) of this challenge gets to be rewarded from your CRL wallet.\nPool: This means everyone gets to pay a certain amount to join this challenge. Winner takes all.", onOptionSelected: (val){
                          if(!mounted) return;
                          setState(() {
                            challengeFundingType = val;
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
                                  child: Text('Select funding type',
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
                                      Text((challengeFundingType.isEmpty) ? 'Funding type' : challengeFundingType,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                              fontSize:
                                              getProportionateScreenWidth(
                                                  13),
                                              color: (challengeFundingType.isEmpty) ? Colors.grey : Color(MyColors.primaryColor)
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
                        return AlertDialogPage(title: "Select Funding amount", options: List.generate(1000, (index) => "${index + 1}"), onOptionSelected: (val){
                          if(!mounted) return;
                          setState(() {
                            challengeFundingValue = val;
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
                                    child: Text('Select $challengeFundingType amount',
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
                                        Text((challengeFundingValue.isEmpty) ? 'Funding amount' : '$challengeFundingValue CRL',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                fontSize:
                                                getProportionateScreenWidth(
                                                    13),
                                                color: (challengeFundingValue.isEmpty) ? Colors.grey : Color(MyColors.primaryColor)
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
                  (challengeFundingType == "Pool") ? SizedBox() : Container(
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
                  (challengeFundingType == "Pool") ? SizedBox() : InkWell(
                    onTap: (){
                      return showDialog<bool>(
                          context: context,
                          barrierDismissible: false,
                          //context: _scaffoldKey.currentContext,
                          builder: (context) {
                            return AlertDialogPage(title: "Select Reward type", options: ["First Winner Only", "Top 3 Winners", "All Completed Participants"], description: "First Winner Only: Only the first person to finish the challenge will be rewarded from your CRL wallet.\nTop 3 Winners: This means only the top 3 persons to finish the challenge will be rewarded from your CRL wallet.\nAll Completed Participants: Every participant that completes the challenge will be rewarded.", onOptionSelected: (val){
                              if(!mounted) return;
                              setState(() {
                                challengeWinnerRewardType = val;
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
                                          Text((challengeWinnerRewardType.isEmpty) ? 'Reward type' : challengeWinnerRewardType,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .copyWith(
                                                  fontSize:
                                                  getProportionateScreenWidth(
                                                      13),
                                                  color: (challengeWinnerRewardType.isEmpty) ? Colors.grey : Color(MyColors.primaryColor)
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
                  (challengeFundingType == "Pool") ? SizedBox() : Divider(
                    thickness: 2,
                    indent: 20,
                    endIndent: 20,
                  ),
                  (challengeWinnerRewardType != "All Completed Participants") ? SizedBox() : InkWell(
                    onTap: (){
                      return showDialog<bool>(
                          context: context,
                          barrierDismissible: false,
                          //context: _scaffoldKey.currentContext,
                          builder: (context) {
                            return AlertDialogPage(title: "Select sharing amount", options: List.generate(1000, (index) => "${index + 1}"), onOptionSelected: (val){
                              if(!mounted) return;
                              setState(() {
                                sharingAmount = int.parse(val);
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
                                      child: Text('Select sharing amount',
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
                                          Text((sharingAmount == 0) ? 'Sharing amount' : '$sharingAmount CRL',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .copyWith(
                                                  fontSize:
                                                  getProportionateScreenWidth(
                                                      13),
                                                  color: (sharingAmount == 0) ? Colors.grey : Color(MyColors.primaryColor)
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
    double crlx = double.parse(crlxBalance);
    double chanValue = double.parse(challengeFundingValue);
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
    if(challengeWinnerRewardType.isEmpty) {
      new GeneralUtils().displayAlertDialog(context, "Attention", "Please select winner reward type.");
      return;
    }
    if(challengeFundingType.isEmpty || challengeFundingValue.isEmpty) {
      new GeneralUtils().displayAlertDialog(context, "Attention", "Please select funding details.");
      return;
    }
    if(challengeWinnerRewardType == "All Completed Participants") {
      if(sharingAmount == 0) {
        new GeneralUtils().displayAlertDialog(context, "Attention", "Please specify the amount to be shared among participants.");
        return;
      }
      if((sharingAmount * maxUsers).toDouble() > double.parse(challengeFundingValue)) {
        new GeneralUtils().displayAlertDialog(context, "Attention", "Your funding amount cannot fund 15 participants. Please increase it.");
        return;
      }
    }
    if(challengeWinnerRewardType == "Top 3 Winners") {
      if((chanValue * 3) > crlx) {
        new GeneralUtils().displayAlertDialog(context, "Attention", "Your funding amount cannot fund the top 3 winners.");
        return;
      }
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

    bool allowDebitForSponsor = false;

    if(challengeFundingType == "Sponsor") {
      double amountToDeduct = (challengeWinnerRewardType == "Top 3 Winners") ? chanValue * 3 : chanValue; //challengeFundingValue

      bool isAllowed = await new GeneralUtils().displayReturnedValueAlertDialog(context, "Attention", "$amountToDeduct CRL will be deducted from your wallet for sponsoring this challenge.");
      if(!isAllowed) return;

      if(crlxBalance == "0" || crlx < chanValue) {
        new GeneralUtils().displayAlertDialog(context, "Attention", "Sorry, you do not have enough CRL to sponsor this challenge. You can select the Pool reward type instead.");
        return;
      }

      allowDebitForSponsor = true;
    }

    setState(() {
      _loading = true;
    });

    if(allowDebitForSponsor) {
      //debit user crlx account
      double amountToDeduct = (challengeWinnerRewardType == "Top 3 Winners") ? chanValue * 3 : chanValue; //challengeFundingValue

      Map<String, dynamic> resp = await walletServices.transferAdmin(addresses["public"], "$amountToDeduct CRL has been deducted from your wallet for being a sponsor.", "$amountToDeduct");
      if(!resp["status"]) {
        setState(() {
          _loading = false;
        });
        new GeneralUtils().displayAlertDialog(context, "Attention", resp["message"]);
        return;
      }
    }

    String id = FirebaseDatabase.instance.reference().push().key;

    //get user data
    String localUser = await ss.getItem('user');
    Map<String, dynamic> json = jsonDecode(localUser);

    int winnerAmount = (challengeFundingType == "Sponsor") ? int.parse(challengeFundingValue) : 0;

    //get dynamic link
    // String dynamicLink = await exer.createDynamicLink(key, _controllerTitle.text, _controllerBody.text, fileUrl);

    try {
      String timeZone = await new GeneralUtils().currentTimeZone();
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
          challengeFundingType,
          challengeFundingValue,
          new DateTime.now().toString(),
          "link",
          json["msgId"],
          FieldValue.serverTimestamp(), 0, "pending",winnerAmount, id.substring(2,8),0,0,
          challengeWinnerRewardType, sharingAmount, false,false,false,false,[], timeZone, []
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
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Color(MyColors.primaryColor),
                            fontWeight: FontWeight.bold,
                            fontSize: getProportionateScreenWidth(30),
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
