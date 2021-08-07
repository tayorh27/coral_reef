import 'package:coral_reef/ListItem/model_gchat_comment.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/constants.dart';
import 'package:coral_reef/g_chat_screen/services/gchat_services.dart';
import 'package:flutter/material.dart';

class PostComment extends StatefulWidget {
  final Widget leadingWidget;
  final String gchatID;
  final Function(GChatComment comment) onCreateComment;

  PostComment(this.leadingWidget, this.gchatID, {this.onCreateComment});

  @override
  State<StatefulWidget> createState() => _PostComment();
}

class _PostComment extends State<PostComment> {

  TextEditingController _controllerMessage = new TextEditingController(text: "");
  FocusNode focusNode = new FocusNode();
  StorageSystem ss = new StorageSystem();

  GChatServices gChatServices;

  bool sending = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gChatServices = new GChatServices(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    alertPost.close();
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
    // String main_comment_id = (replyToUser.isEmpty) ? "" : commentID ?? "";
    GChatComment com = await gChatServices.submitPostComment(_controllerMessage.text, widget.gchatID, "", "");
    widget.onCreateComment(com);
    _controllerMessage.clear();

    setState(() {
      sending = false;
    });
  }
}
