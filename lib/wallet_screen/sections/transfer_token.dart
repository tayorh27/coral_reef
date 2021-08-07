import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/coral_back_button.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/constants.dart';
import 'package:coral_reef/wallet_screen/components/verify_pin.dart';
import 'package:coral_reef/wallet_screen/sections/scan_qrcode.dart';
import 'package:coral_reef/wallet_screen/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:akvelon_flutter_share_plugin/akvelon_flutter_share_plugin.dart';
// import 'package:flutter_plugin_qr_scanner/flutter_plugin_qr_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../size_config.dart';

class TransferToken extends StatefulWidget {
  static final routeName = "transfer-token";
  final Map<String, dynamic> argument;
  TransferToken({this.argument});
  @override
  State<StatefulWidget> createState() => _TransferToken();
}

class _TransferToken extends State<TransferToken> {
  StorageSystem ss = new StorageSystem();

  Map<String, dynamic> addresses;

  TextEditingController _textEditingController =
      new TextEditingController(text: "");
  TextEditingController _textEditingControllerAmt =
      new TextEditingController(text: "");

  String userPin = "";

  bool _inAsyncCall = false;

  WalletServices walletServices;
  
  bool displayError = false;

  bool isZil = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    walletServices = new WalletServices();
    ss.getItem("userPin").then((value) => userPin = value);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // addresses = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    addresses = widget.argument;

    return Scaffold(
      body: ModalProgressHUD(
          inAsyncCall: _inAsyncCall,
          opacity: 0.6,
          progressIndicator: CircularProgressIndicator(),
          color: Color(MyColors.titleTextColor),
          child: SafeArea(
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
                        Container(
                          margin: EdgeInsets.only(top: (Platform.isAndroid) ? 0.0 : 6.0),
                          child: Text(
                            "Send Token",
                            style: Theme.of(context).textTheme.headline2.copyWith(
                              color: Color(MyColors.titleTextColor),
                              fontSize: getProportionateScreenWidth(20),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.05),
                    tokenSwitch(),
                    Container(
                        margin: EdgeInsets.only(top: 40.0),
                        width: double.infinity,
                        height: getProportionateScreenHeight(460),
                        child: Column(
                          children: [

                            YourNameText(title: "Enter recipient address"),
                            SizedBox(height: getProportionateScreenHeight(5)),
                            recipientAddressField(),
                            SizedBox(height: SizeConfig.screenHeight * 0.05),
                            YourNameText(title: "Enter amount",),
                            SizedBox(height: getProportionateScreenHeight(5)),
                            amountField(),
                            (displayError) ? Row(
                              children: [
                                Text("You don't have enough funds", style: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    .copyWith(color: Colors.red, fontSize: getProportionateScreenWidth(11)))
                              ],
                            ) : SizedBox(),
                            YourNameText(title: (isZil) ? "Available balance: ${addresses["zilBal"]}" : "Available balance: ${addresses["crl"]}",),
                          ],
                        )),
                    DefaultButton(
                      text: 'Send',
                      press: () async {
                        if(validateFields()) {
                          new GeneralUtils().displayAlertDialog(context, "Attention", "Please fill all fields.");
                          return;
                        }
                        double accountBal = (isZil) ? double.parse(addresses["zilBal"]) : double.parse(addresses["crl"]);
                        double amountToSend = double.parse(_textEditingControllerAmt.text);

                        if(amountToSend == 0) {
                          new GeneralUtils().displayAlertDialog(context, "Attention", "Amount to send must be greater than 0.");
                          return;
                        }
                        if(amountToSend > accountBal) {
                          new GeneralUtils().displayAlertDialog(context, "Attention", "You don't have enough funds to perform this transfer.");
                          return;
                        }
                        VerifyPinDialog _verify = new VerifyPinDialog(context, userPin);
                        bool verified = await _verify.displayVerifyPinDialog(context, "Enter your PIN", "To continue with this transaction, please enter your pin.");
                        if(verified) {
                          setState(() {
                            _inAsyncCall = true;
                          });
                          initiateTransfer();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget tokenSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: SwitchButtons(
              text: 'CRL',
              mWidth: 60,
              mHeight: 30,
              textSize: 10,
              selected: !isZil,
              press: () async {
                setState(() {
                  isZil = false;
                });
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: SwitchButtons(
              text: 'ZIL',
              mWidth: 60,
              mHeight: 30,
              textSize: 10,
              selected: isZil,
              press: () async {
                setState(() {
                  isZil = true;
                });
              }),
        ),
      ],
    );
  }

  initiateTransfer() async {
    Map<String, dynamic> result = new Map();
    if(isZil) {
      result = await walletServices.transferZil(addresses["public"], _textEditingController.text, _textEditingControllerAmt.text);
    }else {
      result = await walletServices.transferToken(addresses["public"], _textEditingController.text, _textEditingControllerAmt.text);
    }
    setState(() {
      _inAsyncCall = false;
    });

    bool success = result["status"];
    if(!success) {
      new GeneralUtils().displayAlertDialog(context, "Attention", result["message"]);
      return;
    }

    await new GeneralUtils().displayAlertDialog(context, "Transaction Sent", result["message"]);

    // new GeneralUtils().showToast(context, "Transfer successful.");
    Navigator.of(context).pop(true);
  }

  bool validateFields() {
    return _textEditingController.text.isEmpty || _textEditingControllerAmt.text.isEmpty;
  }

  Widget recipientAddressField() {
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
        keyboardType: TextInputType.name,
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
          // suffixIcon: TextButton.icon(
          //   icon: Icon(Icons.camera_alt_rounded,
          //       color: Color(MyColors.primaryColor)),
          //   label: Text(""),
          //   onPressed: () async {
          //     var status = await Permission.camera.status;
          //     if(status.isGranted) {
          //       openQRCode();
          //       return;
          //     }
          //     final allowPermission = await new GeneralUtils().requestPermission(context, "Camera", "Allow Coral Reef to access your camera");
          //     if(allowPermission) {
          //       if (await Permission.camera.request().isGranted) {
          //         openQRCode();
          //       }
          //     }
          //   },
          // ),
        ),
      ),
    );
  }

  openQRCode() async {
    // final results = await QrScanner.scan(
    //   title: "scanner",
    //   laserColor: Colors.white, //default #ffff55ff
    //   playBeep: false, //default false
    //   promptMessage: "Point the QR code to the frame to complete the scan.",
    //   errorMsg: "Oops, something went wrong. You may need to check your permission of camera or restart the device.",
    //   permissionDeniedText: "Your privacy settings seem to prevent us from accessing your camera for barcode scanning. You can fix it by doing this, touch the OK button below to open the Settings and then turn the Camera on.",
    //   messageConfirmText: "OK",
    //   messageCancelText: "Cancel",
    // );
    // if (results != null) {
    //   _textEditingController.text = results;
    // }
  }

  Widget amountField() {
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
        keyboardType: TextInputType.number,
        obscureText: false,
        controller: _textEditingControllerAmt,
        onChanged: (value) {
          if(value.isEmpty) {
            return;
          }
          double currentBal = (isZil) ? double.parse(addresses["zilBal"]) : double.parse(addresses["crl"]);
          double amountToSend = double.parse(value);
          
          setState(() {
            displayError = amountToSend > currentBal;
          });
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 15,
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          suffixIcon: TextButton(
            child: Text("MAX", style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Color(MyColors.primaryColor),
            ),),
            onPressed: () async {
              _textEditingControllerAmt.text = (isZil) ? addresses["zilBal"] : addresses["crl"];
            },
          ),
          //hintText: '',
        ),
      ),
    );
  }
}

class YourNameText extends StatelessWidget {
  const YourNameText({Key key, this.title, this.amount = ""}) : super(key: key);

  final String title, amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
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
