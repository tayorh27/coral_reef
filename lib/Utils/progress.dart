import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class ProgressDisplay {
  BuildContext context;
  ProgressDialog pr;

  ProgressDisplay(BuildContext context) {
    this.context = context;
    pr = new ProgressDialog(context: context);
  }

  void displayDialog(String text) {
    pr.show(
      max: 100,
      msg: text,
      progressType: ProgressType.valuable,
      barrierDismissible: false,
    );
  }

  void dismissDialog() {
    if (pr != null) {
      if(pr.isOpen())
        pr.close();
    }
  }

}
