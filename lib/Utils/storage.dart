
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageSystem {

  FlutterSecureStorage storage;

  StorageSystem() {
    storage = new FlutterSecureStorage();
  }

  Future<void> setPrefItem(String key, String item, {bool isStoreOnline = true}) async {
    try {
      await storage.write(key: key, value: item);
      if (isStoreOnline) {
        String user = await getItem("user");
        if (user != null) {
          dynamic json = jsonDecode(user);
          Map<String, dynamic> setupData = new Map();
          setupData[key] = item;
          if (json["uid"] == null) {
            return;
          }
          FirebaseFirestore.instance.collection("users").doc(json["uid"])
              .collection("setups").doc("user-data")
              .update(setupData);
        }
      }
    }catch(e) {
      print(e);
    }
  }

  Future<String> getItem(String key) async {
    return await storage.read(key: key);
  }

  // int getIntItem(String key) {
  //   return Prefs.getInt(key, 0);
  // }
  //
  // void setIntItem(String key, int value){
  //   Prefs.setInt(key, value);
  // }

  Future<void> clearPref() async{
    //storage.clear();
    await storage.deleteAll();
  }

  Future<void> deletePref(String key) async {
    //storage.deleteItem(key);
    await storage.delete(key: key);
  }
}