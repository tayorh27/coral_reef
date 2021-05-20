import 'package:flutter/widgets.dart';


//Created by Daniel Makinde
//This makes the change notifier universal through out the app
class BaseModel extends ChangeNotifier {



  bool _busy = false;
  bool get busy => _busy;


//This tells the app, the app is busy and dialog starts immediately and ends if it is equal to false
  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
    if (value == true) {
     // _dialogService.showDialog();
    } else {
     // _dialogService.dialogComplete(hh);
    }
  }

}
