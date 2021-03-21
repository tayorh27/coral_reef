
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageSystem {

  FlutterSecureStorage storage;

  StorageSystem() {
    storage = new FlutterSecureStorage();
  }

  Future<void> setPrefItem(String key, String item) async {
    await storage.write(key: key, value: item);
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