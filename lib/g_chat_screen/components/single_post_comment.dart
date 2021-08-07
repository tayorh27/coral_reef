import 'dart:async';

import 'package:coral_reef/ListItem/model_gchat_comment.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/constants.dart';
import 'package:coral_reef/g_chat_screen/services/gchat_services.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SinglePostComment extends StatefulWidget {
  final Widget leadingWidget;
  final String gchatID;
  final Function(GChatComment comment) onCreateComment;
  final Function(bool hide) popupReplyField;
  SinglePostComment(this.leadingWidget, this.gchatID, {this.onCreateComment, this.popupReplyField});

  @override
  State<StatefulWidget> createState() => _SinglePostComment();
}



// void triggerPopupReplyField(bool float) {
//   controller.add(float);
// }

class _SinglePostComment extends State<SinglePostComment> {

  TextEditingController _controllerMessage = new TextEditingController(text: "");
  FocusNode focusNode = new FocusNode();
  StorageSystem ss = new StorageSystem();

  GChatServices gChatServices;

  bool sending = false;

  bool isReplyTo = false;
  GChatComment mainCommentData;

  Stream stream = universalController.stream;
  StreamSubscription<Map<String, dynamic>> streamSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gChatServices = new GChatServices(context);
    streamSubscription = stream.listen((event) {
      if(event == null) return;
      if(!mounted) return;
      print("streaming: $event");
      setState(() {
        isReplyTo = true;
        mainCommentData = GChatComment.fromSnapshot(event["mainComment"]);
        _controllerMessage.text = "@${event["username"]} ";
      });
      focusNode.requestFocus();
    });
    // alertPost.listen((value) {{id: -MZ_ZJAZ8fkwto4AC8e7, main_comment_id: , gchat_id: -MZ_2oImajtvl87psiYk, user_uid: LBLJwbE6WwZSYigYyNs0ftEhBmk2, main_comment_user_uid: null, username: royking, avatar: {selectedAvatar: avatar5, selectedColor: 4294941584}, message: Alright. Sooooo excited...
    //   if(value.isNotEmpty) {
    //     replyToUser = value[0];
    //     commentID = value[1];
    //     setState(() {
    //       _controllerMessage.text = "@$replyToUser";
    //       focusNode.requestFocus();
    //     });
    //   }
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // alertPost.close();
    streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTile(
        leading: Container(
          margin: EdgeInsets.only(top: 15.0),
          child: widget.leadingWidget,
        ),
        title: Container(
          height: 80.0,
          width: MediaQuery.of(context).size.width - 130.0,
          padding: EdgeInsets.only(top: 20.0),
          child: TextFormField(
            keyboardType: TextInputType.text,
            controller: _controllerMessage,
            focusNode: focusNode,
            maxLines: 1,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter comment here",
                hintStyle: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: Colors.grey),
                labelStyle: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: Color(MyColors.titleTextColor),
                )),
          ),
        ),
        trailing: Container(
            margin: EdgeInsets.only(top: 15.0),
            child: TextButton(
              onPressed: (sending) ? null : () {
                submitComment();
              },
              child: Text("Send",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: Color(MyColors.primaryColor))),
            )));
  }

  submitComment() async {
    if(_controllerMessage.text.isEmpty) {
      return;
    }

    setState(() {
      sending = true;
    });

    String main_comment_id = (!isReplyTo) ? "" : mainCommentData.id; //|| !_controllerMessage.text.startsWith("@")
    String replyUserID = (!isReplyTo) ? user.uid : mainCommentData.user_uid;
    GChatComment com = await gChatServices.submitPostComment(_controllerMessage.text, widget.gchatID, main_comment_id, replyUserID);
    widget.onCreateComment(com);
    _controllerMessage.clear();
    setState(() {
      universalController.add(null);
      isReplyTo = false;
      sending = false;
    });
  }
}
