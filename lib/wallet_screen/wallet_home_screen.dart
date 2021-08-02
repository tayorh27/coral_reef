
import 'dart:async';

import 'package:coral_reef/ListItem/model_transactions.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/shared_screens/EmptyScreen.dart';
import 'package:coral_reef/wallet_screen/sections/receive_token.dart';
import 'package:coral_reef/wallet_screen/sections/transfer_token.dart';
import 'package:coral_reef/wallet_screen/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher.dart';

import '../size_config.dart';
import 'components/wallet_buttons.dart';
import 'package:swipe_refresh/swipe_refresh.dart';

class WalletHomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WalletHomeScreen();
}

class _WalletHomeScreen extends State<WalletHomeScreen> {

  TabController _tabController;
  WalletServices walletServices;
  String balance = "0", crlxBalance = "0", zilBalance = "0";
  Map<String, dynamic> addresses = new Map();

  bool _inAsyncCall = false;

  List<Transactions> transactions = [];

  final _controller = StreamController<SwipeRefreshState>.broadcast();

  Stream<SwipeRefreshState> get _stream => _controller.stream;

  @override
  void initState() {
    super.initState();
    walletServices = new WalletServices();
    _controller.sink.add(SwipeRefreshState.loading);
    setupInitWallet();
    // _tabController = TabController(initialIndex: 1, length: 3, vsync: this);
  }

  setupInitWallet() async {
    List<Transactions> mTrans = await walletServices.getTransactions();
    print(mTrans.length);
    if(!mounted) return;
    setState(() {
      transactions = mTrans;
    });
    addresses = await walletServices.getUserAddresses();
    Map<String, dynamic> resp = await walletServices.getTokenBalance(addresses["public"]);
    String zilBal = await walletServices.getZilBalance(addresses["zil"]);
    addresses["crl"] = resp["crl"];
    addresses["crlx"] = resp["crlx"];
    addresses["zilBal"] = zilBal;
    if(!mounted) return;
    setState(() {
      balance = resp["crl"];
      crlxBalance = resp["crlx"];
      zilBalance = zilBal;
    });
    _controller.sink.add(SwipeRefreshState.hidden);
  }

  @override
  void reassemble() {
    // TODO: implement reassemble
    super.reassemble();
    setupInitWallet();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(MyColors.lightBackground),
      body: ModalProgressHUD(
      inAsyncCall: _inAsyncCall,
      opacity: 0.6,
      progressIndicator: CircularProgressIndicator(),
      color: Color(MyColors.titleTextColor),
      child: SwipeRefresh.material(
      stateStream: _stream,
      onRefresh: setupInitWallet,
      children: [
        Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 255.0,
              decoration: BoxDecoration(
                color: Color(MyColors.primaryColor),
                image: DecorationImage(image: AssetImage("assets/images/wallet_bg.png")),
              ),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 50.0,),
                    Text("$balance CRL", style: Theme.of(context).textTheme.headline2.copyWith(
                      fontSize: getProportionateScreenWidth(28),
                      color: Colors.white,
                    ),),
                    // Text("$zilBalance ZIL", style: Theme.of(context).textTheme.headline2.copyWith(
                    //   fontSize: getProportionateScreenWidth(10),
                    //   color: Colors.white,
                    // ),),
                    SizedBox(height: 10.0,),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WalletButton(text: "Receive", icon: "assets/icons/wallet_arrow_up.svg", press: (){
                          Navigator.pushNamed(context, ReceiveWallet.routeName, arguments: addresses);
                        },),
                        WalletButton(text: "Send", icon: "assets/icons/wallet_arrow_down.svg", press: () async {
                          if(!addresses.containsKey("crl")) {
                            new GeneralUtils().showToast(context, "Fetching token balance...please wait");
                            return;
                          }
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TransferToken(argument: addresses)),
                          );
                          // if(res != null) {
                          //   _controller.sink.add(SwipeRefreshState.loading);
                          //   setupInitWallet();
                          // }
                          // Navigator.pushNamed(context, TransferToken.routeName, arguments: addresses);
                        },),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 255.0,
              margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 220.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  )
              ),
              child: DefaultTabController(
                initialIndex: 0,
                length: 2,
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0.0),
                            child: Container(
                              color: Colors.white.withOpacity(1),
                              child: TabBar(
                                // controller: _tabController,
                                labelColor: Color(MyColors.primaryColor),
                                labelStyle: Theme.of(context).textTheme.headline2.copyWith(
                                  color: Color(MyColors.primaryColor),
                                  fontSize: getProportionateScreenWidth(15),
                                ),
                                automaticIndicatorColorAdjustment: true,
                                unselectedLabelColor: Color(MyColors.titleTextColor),
                                unselectedLabelStyle: Theme.of(context).textTheme.headline2.copyWith(
                                  color: Color(MyColors.titleTextColor),
                                  fontSize: getProportionateScreenWidth(15),
                                ),
                                indicatorColor: Color(MyColors.primaryColor),
                                tabs: <Widget>[
                                  Tab(text: "Tokens",
                                  ),
                                  // Tab(text: "Explorer",
                                  // ),
                                  Tab(text: "Transactions",
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Container(
                              color: Colors.white.withOpacity(1),
                              height: 500,
                              child: TabBarView(
                                // controller: _tabController,
                                children: <Widget>[
                                  Column(
                                    children: [
                                      SizedBox(height: 30,),
                                      Visibility(
                                        visible: false,
                                        child: InkWell(
                                          onTap: () async {
                                            if(crlxBalance == "0") {
                                              return;
                                            }
                                            setState(() {
                                              _inAsyncCall = true;
                                            });
                                            dynamic result = await walletServices.convertCRLXToCRL(addresses["public"], "100");
                                            setState(() {
                                              _inAsyncCall = false;
                                            });
                                            bool success = result["status"];
                                            if(!success) {
                                              new GeneralUtils().displayAlertDialog(context, "Attention", result["message"]);
                                              return;
                                            }
                                            await new GeneralUtils().displayAlertDialog(context, "Transaction Sent", result["message"]);
                                          },
                                          child: Container(
                                              height: 40.0,
                                              width: double.infinity,
                                              padding: EdgeInsets.all(10.0),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10.0),
                                                color: Color(MyColors.lightBackground),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("Convert XCRL Token to CRL", style: Theme.of(context).textTheme.bodyText1.copyWith(
                                                      color: Color(MyColors.titleTextColor),
                                                      fontSize: getProportionateScreenWidth(11)
                                                  ),),
                                                  Icon(Icons.arrow_forward_ios_rounded,),
                                                ],)
                                          ),
                                        ),
                                      ),
                                      // SizedBox(height: 10,),
                                      buildToken("CRL", "Coral", "assets/images/logo2.png", balance),//assets/images/seashell-crl.svg
                                      Divider(thickness: 2.0,),
                                      buildToken("ZIL", "Zilliqa", "assets/images/zilliqa-zil-logo.png", zilBalance),
                                      Divider(thickness: 2.0,),
                                      // buildToken("XCRL", "Coral", "assets/images/logo2.png", crlxBalance),
                                      // Divider(thickness: 2.0,),
                                    ],
                                  ),
                                  (transactions.isEmpty) ? Container(
                                    margin: EdgeInsets.only(top: 0.0),
                                    child: EmptyScreen("No available data!", bgColor: Colors.white,),
                                  ) : ListView(
                                    scrollDirection: Axis.vertical,
                                    children: buildTransactions(),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
      ))
    );
  }

  Widget buildToken(String tokenSymbol, String tokenName, String logo, String value) {
    return ListTile(
      leading: (!logo.contains(".svg")) ? Image.asset(logo, height: 40.0,) : SvgPicture.asset(logo, height: 40.0,),
      title: Text(tokenSymbol, style: Theme.of(context).textTheme.headline2.copyWith(
        color: Color(MyColors.titleTextColor),
          fontSize: getProportionateScreenWidth(15)
      ),),
      subtitle: Text(tokenName, style: Theme.of(context).textTheme.bodyText1.copyWith(
          color: Colors.grey,
        fontSize: getProportionateScreenWidth(12)
      ),),
      trailing: Text(value, style: Theme.of(context).textTheme.headline2.copyWith(
          color: Color(MyColors.titleTextColor),
          fontSize: getProportionateScreenWidth(15)
      ),),
    );
  }

  List<Widget> buildTransactions() {
    List<Widget> transWidget = [];

    transactions.forEach((trans) {

      transWidget.add(
        Column(
          children: [
            ListTile(
              title: Row(
                mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${trans.amount} ${(trans.reason.toLowerCase().contains("zil")) ? 'ZIL' : (trans.type == "Conversion" || trans.type == "Challenge") ? 'CRLX' : 'CRL'}",
                  style: Theme.of(context).textTheme.headline1.copyWith(
                      color: Color(MyColors.titleTextColor),
                      fontSize: getProportionateScreenWidth(15))),
                    TextButton.icon(onPressed: (){
                      _launchInWebViewWithDomStorage("https://viewblock.io/zilliqa/tx/${trans.transaction_hash}?network=testnet");
                    }, icon: Icon(Icons.open_in_new_rounded, color: Color(MyColors.primaryColor), size: 16.0,), label: Text("Viewblock",
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Color(MyColors.titleTextColor),
                        fontSize: getProportionateScreenWidth(13),
                      ),
                    )),
              ]),
              subtitle: Column(
                children: [
                  Text(trans.reason,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Color(MyColors.titleTextColor),
                      fontSize: getProportionateScreenWidth(13),
                    ),
                  ),
                  Text(trans.created_date,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Colors.grey,
                      fontSize: getProportionateScreenWidth(10),
                    ),
                  )
                ],
              ),
              isThreeLine: true,
            ),
            Divider(height: 1.0, color: Colors.grey,)
          ],
        )
      );

    });

    return transWidget;
  }

  Future<void> _launchInWebViewWithDomStorage(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableDomStorage: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    _controller.close();
    // TODO: implement dispose
    super.dispose();
  }
}

/**
 *
 * */