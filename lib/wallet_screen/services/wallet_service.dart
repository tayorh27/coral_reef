
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/ListItem/model_transactions.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:http/http.dart' as http;

class WalletServices {
  StorageSystem ss;

  WalletServices() {
    ss = new StorageSystem();
  }

  /*
  get the token balance of the user
  * */
  Future<Map<String, dynamic>> getTokenBalance(String publicAddress) async {

    Uri _uri = Uri.parse("https://us-central1-coraltrackerapp.cloudfunctions.net/getusertokenbalance?address=$publicAddress");

    http.Response res = await http.get(_uri);

    print(res.body);

    Map<String, dynamic> _body = jsonDecode(res.body);

    Map<String, dynamic> resp = new Map();

    resp["crl"] = "0";
    resp["crlx"] = "0";

    if(_body["token_balance_crl"] != null) {
      resp["crl"] = _body["token_balance_crl"];
      resp["crlx"] = _body["token_balance_crlx"];
    }

    return resp;

    // return (_body["token_balance_crl"] == null) ? "0" : _body["token_balance_crl"];

  }

  /*
  get the token balance of the user
  * */
  Future<String> getZilBalance(String zilAddress) async {
    Uri _uri = Uri.parse("https://us-central1-coraltrackerapp.cloudfunctions.net/getzilbalance?address=$zilAddress");

    http.Response res = await http.get(_uri);

    print(res.body);

    Map<String, dynamic> _body = jsonDecode(res.body);

    return (_body["zil_balance"] == null) ? "0" : _body["zil_balance"];

  }

  /*
  get the user zil and token address
  * */
  Future<Map<String, dynamic>> getUserAddresses() async {
    Map<String, dynamic> address = new Map();

    String user = await ss.getItem("user");
    dynamic json = jsonDecode(user);
    String uid = json["uid"];

    DocumentSnapshot query = await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if(!query.exists) {
      return null;
    }

    Map<String, dynamic> data = query.data();

    address["public"] = data["public_address"];
    address["zil"] = data["zil_address"];

    return address;
  }

  /*
  get the list of transactions
  * */
  Future<List<Transactions>> getTransactions() async {
    String user = await ss.getItem("user");
    dynamic json = jsonDecode(user);
    String uid = json["uid"];

    QuerySnapshot query = await FirebaseFirestore.instance.collection("transactions").where("user_uid", isEqualTo: uid).orderBy("timestamp", descending: true).get();

    if(query.size == 0) {
      return [];
    }

    List<Transactions> mTrans = [];

    query.docs.forEach((q) {
      Transactions tr = Transactions.fromSnapshot(q.data());
      mTrans.add(tr);
    });

    return mTrans;
  }

  Future<Map<String, dynamic>> transferZil(String senderAddress, String recipientAddress, String amount) async {
    String user = await ss.getItem("user");
    dynamic json = jsonDecode(user);
    String uid = json["uid"];

    Uri _uri = Uri.parse("https://us-central1-coraltrackerapp.cloudfunctions.net/transferzil?uid=$uid&recipientAddress=$recipientAddress&sendingAddress=$senderAddress&sendingAmount=$amount");

    http.Response res = await http.get(_uri);

    print(res.body);

    Map<String, dynamic> _body = jsonDecode(res.body);

    return _body;
  }

  Future<Map<String, dynamic>> transferToken(String senderAddress, String recipientAddress, String amount) async {
    String user = await ss.getItem("user");
    dynamic json = jsonDecode(user);
    String uid = json["uid"];

    Uri _uri = Uri.parse("https://us-central1-coraltrackerapp.cloudfunctions.net/transfertoaccount?uid=$uid&recipientAddress=$recipientAddress&sendingAddress=$senderAddress&sendingAmount=$amount");

    http.Response res = await http.get(_uri);

    print(res.body);

    Map<String, dynamic> _body = jsonDecode(res.body);

    return _body;

  }

  Future<Map<String, dynamic>> transferAdmin(String senderAddress, String transMsg, String amount) async {
    String user = await ss.getItem("user");
    dynamic json = jsonDecode(user);
    String uid = json["uid"];

    Uri _uri = Uri.parse("https://us-central1-coraltrackerapp.cloudfunctions.net/transfercrlxtoadmin?uid=$uid&transMsg=$transMsg&sendingAddress=$senderAddress&sendingAmount=$amount");

    http.Response res = await http.get(_uri);

    print(res.body);

    Map<String, dynamic> _body = jsonDecode(res.body);

    return _body;

  }

  Future<Map<String, dynamic>> convertCRLXToCRL(String senderAddress, String amount) async {
    String user = await ss.getItem("user");
    dynamic json = jsonDecode(user);
    String uid = json["uid"];

    Uri _uri = Uri.parse("https://us-central1-coraltrackerapp.cloudfunctions.net/convertcrlxtocrl?uid=$uid&sendingAddress=$senderAddress&sendingAmount=$amount");

    http.Response res = await http.get(_uri);

    print(res.body);

    Map<String, dynamic> _body = jsonDecode(res.body);

    return _body;

  }
}