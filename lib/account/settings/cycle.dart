import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/account/components/account_header.dart';
import 'package:coral_reef/account/profile/components/profile_menu_list.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:direct_select/direct_select.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../size_config.dart';
import 'components/cycle_list_item.dart';

class SettingsCycle extends StatefulWidget {
  static String routeName = "settings-cycle";

  @override
  State<StatefulWidget> createState() => _SettingsCycle();
}

class _SettingsCycle extends State<SettingsCycle> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AccountHeader("Cycle and Ovulation").build(context),
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {

  StorageSystem ss = new StorageSystem();

  int lengthPeriod = 0, cyclePeriod = 0;

  @override
  void initState() {
    super.initState();
    getInitialValues();
  }

  getInitialValues() async {
    String periodRecord = await ss.getItem("periodRecord") ?? "";
    if(periodRecord.isEmpty){
      return;
    }
    Map<String, dynamic> record = jsonDecode(periodRecord);
    print(record);
    setState(() {
      lengthPeriod = int.parse(record["length"]);
      cyclePeriod = int.parse(record["cycle"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                CycleListItem(
                  text: "Period cycle",
                  subText: "",
                  type: "arrow",
                  icon: null,
                  trailingText: "$cyclePeriod",
                  press: () async {
                    bool res = await _showTestDialog(context, "$cyclePeriod");
                    if(res) {
                      getInitialValues();
                    }
                  },
                ),
                SizedBox(height: 20.0,),
                CycleListItem(
                  text: "Period length",
                  subText: "This app makes forecasts dependent on your cycle and period length settings. Be that as it may, on the off chance that you routinely log your period in the app, forecasts will be founded on the logged information.",
                  type: "arrow",
                  icon: null,
                  trailingText: "$lengthPeriod",
                  press: () async {
                    bool res = await _showTestDialog2(context, "$lengthPeriod");
                    if(res) {
                      getInitialValues();
                    }
                  },
                ),
                SizedBox(height: 20.0,),
                CycleListItem(
                  text: "Chance of getting pregnant",
                  subText: "If turned OFF, only period days and current phase will be displayed.",
                  type: "switch",
                  icon: null,
                  trailingText: "",
                  press: null
                ),
                // CycleTile(
                //   text: "Cycle length",
                //   text2: "28",
                //   press: () => {_showTestDialog(context)},
                // ),
                // CycleTile(
                //   text: "Period length",
                //   text2: "100 kg",
                //   press: () {
                //     _showTestDialog2(context);
                //   },
                // ),
                // CycleTile2(
                //   text: "Chance of getting pregnant",
                //   press: () {},
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> _showTestDialog(context, String val) async {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      //context: _scaffoldKey.currentContext,
      builder: (context) {
        return AlertDialogPage(currentValue: val,);
      });
}

class AlertDialogPage extends StatefulWidget {
  const AlertDialogPage({
    Key key,
    this.currentValue
  }) : super(key: key);

  final String currentValue;

  @override
  _AlertDialogPageState createState() => _AlertDialogPageState();
}

class _AlertDialogPageState extends State<AlertDialogPage> {

  DateTime now = DateTime.now();
  List<String> months = ["Jan", "Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
  final arrayCount = List.generate(35, (index) => "${index + 1}");
  int selectedIndex = 0;

  List<Widget> buildItems() {
    return arrayCount.map((e) => Container(height: 60.0, child: Text(
        e,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline2.copyWith(
            color: Color(MyColors.primaryColor),
            fontSize: getProportionateScreenWidth(35),
            height: 2.0
        )),)
    ).toList();
  }

  StorageSystem ss = new StorageSystem();

  getInitIndex() {
    dynamic res =  arrayCount.indexWhere((element) => element == widget.currentValue);
    setState(() {
      selectedIndex = res;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInitIndex();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //contentPadding: EdgeInsets.only(left: 20, right: 20),
      title: Text(
        'Period Cycle',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.subtitle1.copyWith(
          color: Color(MyColors.titleTextColor),
          fontSize: getProportionateScreenWidth(18)
        )
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Container(
        height: 350,
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
                        arrayCount[selectedIndex],
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
                      "Tap number to select new period cycle",
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Colors.grey,
                          fontSize: getProportionateScreenWidth(12),
                      ),
                    ),
                  ),
                  Divider(),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Date',
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: Color(MyColors.titleTextColor),
                            fontSize: getProportionateScreenWidth(18)
                        ),
                      ),
                      Spacer(),
                      Text(
                        "${now.day} ${months[now.month - 1]} ${now.year}, ${(now.hour < 10) ? '0${now.hour}' : '${now.hour}'}:${(now.minute < 10) ? '0${now.minute}' : '${now.minute}'}",
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: Color(MyColors.primaryColor),
                            fontSize: getProportionateScreenWidth(16)
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Divider(),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  DefaultButton(
                      text: 'Save',
                      press: saveDataForPeriodCycle
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
  saveDataForPeriodCycle() async {

    String key = FirebaseFirestore.instance.collection("users").doc().id;

    String periodRecord = await ss.getItem("periodRecord");
    dynamic record = jsonDecode(periodRecord);

    Map<String, dynamic> userPeriodDetails = {
      "birthYear": record["birthYear"],
      "lastPeriod": record["lastPeriod"],
      "length": record["length"],
      "cycle": arrayCount[selectedIndex],
      "id": key,
      "timestamp": FieldValue.serverTimestamp(),
    };

    Map<String, dynamic> userPeriodDetailsLocal = {
      "birthYear": record["birthYear"],
      "lastPeriod": record["lastPeriod"],
      "length": record["length"],
      "cycle": arrayCount[selectedIndex],
    };
    //encode the answers from the questions and store in local storage
    String newPeriodRecord = jsonEncode(userPeriodDetailsLocal);
    await ss.setPrefItem("periodRecord", newPeriodRecord);

    FirebaseFirestore.instance.collection("users").doc(user.uid).collection("periods").doc(key).set(userPeriodDetails);
    Navigator.of(context).pop(true);
  }
}

Future<bool> _showTestDialog2(context, String val) async {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      //context: _scaffoldKey.currentContext,
      builder: (context) {
        return AlertDialogPage2(currentValue: val,);
      });
}

class AlertDialogPage2 extends StatefulWidget {
  const AlertDialogPage2({
    Key key,
    this.currentValue
  }) : super(key: key);

  final String currentValue;

  @override
  _AlertDialogPageState2 createState() => _AlertDialogPageState2();
}

class _AlertDialogPageState2 extends State<AlertDialogPage2> {

  DateTime now = DateTime.now();
  List<String> months = ["Jan", "Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
  final arrayCount = List.generate(35, (index) => "${index + 1}");
  int selectedIndex = 0;

  List<Widget> buildItems() {
    return arrayCount.map((e) => Container(height: 60.0, child: Text(
        e,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline2.copyWith(
            color: Color(MyColors.primaryColor),
            fontSize: getProportionateScreenWidth(35),
            height: 2.0
        )),)
    ).toList();
  }

  StorageSystem ss = new StorageSystem();

  getInitIndex() {
    dynamic res =  arrayCount.indexWhere((element) => element == widget.currentValue);
    setState(() {
      selectedIndex = res;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInitIndex();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //contentPadding: EdgeInsets.only(left: 20, right: 20),
      title: Text(
          'Period Length',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle1.copyWith(
              color: Color(MyColors.titleTextColor),
              fontSize: getProportionateScreenWidth(18)
          )
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Container(
        height: 350,
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
                        arrayCount[selectedIndex],
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
                      "Tap number to select new period length",
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Colors.grey,
                        fontSize: getProportionateScreenWidth(12),
                      ),
                    ),
                  ),
                  Divider(),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Date',
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: Color(MyColors.titleTextColor),
                            fontSize: getProportionateScreenWidth(18)
                        ),
                      ),
                      Spacer(),
                      Text(
                        "${now.day} ${months[now.month - 1]} ${now.year}, ${(now.hour < 10) ? '0${now.hour}' : '${now.hour}'}:${(now.minute < 10) ? '0${now.minute}' : '${now.minute}'}",
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: Color(MyColors.primaryColor),
                            fontSize: getProportionateScreenWidth(16)
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Divider(),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  DefaultButton(
                      text: 'Save',
                      press: saveDataForPeriodLength
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

  saveDataForPeriodLength() async {

    String key = FirebaseFirestore.instance.collection("users").doc().id;

    String periodRecord = await ss.getItem("periodRecord");
    dynamic record = jsonDecode(periodRecord);

    Map<String, dynamic> userPeriodDetails = {
      "birthYear": record["birthYear"],
      "lastPeriod": record["lastPeriod"],
      "length": arrayCount[selectedIndex],
      "cycle": record["cycle"],
      "id": key,
      "timestamp": FieldValue.serverTimestamp(),
    };

    Map<String, dynamic> userPeriodDetailsLocal = {
      "birthYear": record["birthYear"],
      "lastPeriod": record["lastPeriod"],
      "length": arrayCount[selectedIndex],
      "cycle": record["cycle"],
    };
    //encode the answers from the questions and store in local storage
    String newPeriodRecord = jsonEncode(userPeriodDetailsLocal);
    await ss.setPrefItem("periodRecord", newPeriodRecord);

    FirebaseFirestore.instance.collection("users").doc(user.uid).collection("periods").doc(key).set(userPeriodDetails);
    Navigator.of(context).pop(true);
  }
}


