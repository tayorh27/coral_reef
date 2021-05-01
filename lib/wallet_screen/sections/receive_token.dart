import 'package:clipboard/clipboard.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/components/coral_back_button.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/constants.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:akvelon_flutter_share_plugin/akvelon_flutter_share_plugin.dart';

import '../../size_config.dart';

class ReceiveWallet extends StatefulWidget {
  static final routeName = "receive-wallet";
  @override
  State<StatefulWidget> createState() => _ReceiveWallet();
}

class _ReceiveWallet extends State<ReceiveWallet> {

  Map<String, dynamic> addresses;

  bool isZil = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    addresses = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

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
                    SizedBox(width: 20.0),
                    Text("Receive", style: Theme.of(context).textTheme.headline2.copyWith(
                      color: Color(MyColors.titleTextColor),
                      fontSize: getProportionateScreenWidth(20),
                    ),)
                  ],
                ),
                Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.only(top: 40.0),
                    width: double.infinity,
                    height: getProportionateScreenHeight(460),
                    child: Column(
                      children: [
                        SizedBox(height: SizeConfig.screenHeight * 0.05),
                        Center(
                            child: Container(
                              height: 200,
                              child: SfBarcodeGenerator(
                                value: (isZil) ? "${addresses["zil"]}" : "${addresses["public"]}",
                                symbology: QRCode(),
                                showValue: false,
                              ),
                            )),
                        SizedBox(height: SizeConfig.screenHeight * 0.05),
                        Divider(height: 2.0,color: Colors.grey),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Wallet address\n",
                                      style: Theme.of(context).textTheme.headline2.copyWith(
                                        color: Color(MyColors.titleTextColor),
                                        fontSize: getProportionateScreenWidth(15),
                                      ),
                                    ),
                                    TextSpan(text: (isZil) ? "${addresses["zil"]}" : "${addresses["public"]}", style: Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: Color(MyColors.titleTextColor),
                                      fontSize: getProportionateScreenWidth(12),
                                    ))
                                  ],
                                ),
                              ),
                              (isZil) ? SizedBox(height: 20.0,) : SizedBox(),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: getProportionateScreenWidth(100),
                                height: getProportionateScreenHeight(40),
                                child: FlatButton(
                                  onPressed: () async {
                                    await FlutterClipboard.copy((isZil) ? "${addresses["zil"]}" : "${addresses["public"]}");
                                    new GeneralUtils().showToast(context, "copied!");
                                  },
                                  child: Text(
                                    'Copy',
                                    style: Theme.of(context).textTheme.headline2.copyWith(
                                      color: Color(MyColors.primaryColor),
                                      fontSize: getProportionateScreenWidth(15),
                                    ),
                                  ),
                                ),
                              ),
                              TextButton.icon(onPressed: (){
                                setState(() {
                                  isZil = !isZil;
                                });
                              }, icon: Icon(Icons.swap_horiz_rounded, color: Color(MyColors.primaryColor), size: 32.0,), label: Text(""))
                            ],
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: SizeConfig.screenHeight * 0.1),
                DefaultButton(
                  text: 'Share address',
                  press: () {
                    AkvelonFlutterSharePlugin.shareText((isZil) ? "${addresses["zil"]}" : "${addresses["public"]}",
                        title: "Wallet Address",
                        subject: "Wallet Address",
                        url: "");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
