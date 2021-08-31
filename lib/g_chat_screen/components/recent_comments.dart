import 'package:coral_reef/ListItem/model_gchat_comment.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/constants.dart';
import 'package:coral_reef/g_chat_screen/services/gchat_services.dart';
import 'package:coral_reef/shared_screens/gchat_user_avatar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'dart:io';

import '../../size_config.dart';

class RecentPostComment extends StatefulWidget {

  final dynamic recentComments;
  RecentPostComment(this.recentComments);

  @override
  State<StatefulWidget> createState() => _RecentPostComment();
}

class _RecentPostComment extends State<RecentPostComment> {

  StorageSystem ss = new StorageSystem();

  GChatServices gChatServices;

  bool sending = false;

  List<dynamic> comments = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gChatServices = new GChatServices(context);
    comments = widget.recentComments;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (comments.isNotEmpty) ? Column(
      children: loadComments(),
    ) : SizedBox();
  }

  List<Widget> loadComments() {
    List<Widget> mComments = [];

    comments.forEach((com) {
      mComments.add(
          ListTile(
            // leading: GChatUserAvatar(
            //   40.0,
            //   avatarData: com["avatar"],
            // ),
            title: Container(
              padding: EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(com["username"],
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(
                          color: Color(MyColors.titleTextColor),
                          fontSize: getProportionateScreenWidth(13))),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        new GeneralUtils().returnFormattedDate(com["created_date"], com["time_zone"]),
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Color(MyColors.titleTextColor),
                          fontSize: getProportionateScreenWidth(10),
                        ),
                      ),
                      SizedBox(width: 5.0,),
                      InkWell(
                        child: userLikeRecords.contains(com["id"]) ? Icon(Icons.favorite, size: 14.0, color: Colors.redAccent,) : Icon(Icons.favorite_border, size: 14.0,),
                        onTap: () async {
                          String commentID = com["id"];
                          if(userLikeRecords.contains(commentID)) {
                            setState(() {
                              userLikeRecords.remove(commentID);
                            });
                            await operationAfterLikeButton("remove", commentID);
                          }else {
                            setState(() {
                              userLikeRecords.add(commentID);
                            });
                            await operationAfterLikeButton("add", commentID);
                          }


                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
            subtitle: ReadMoreText(
              com["message"],
              trimLines: 2,
              colorClickableText: Color(MyColors.primaryColor),
              trimMode: TrimMode.Line,
              trimCollapsedText: 'more',
              trimExpandedText: 'less',
              style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 14.0, color: Color(MyColors.titleTextColor)),
              moreStyle: Theme.of(context).textTheme.headline2.copyWith(fontSize: 14.0, color: Color(MyColors.primaryColor)),
              lessStyle: Theme.of(context).textTheme.headline2.copyWith(fontSize: 14.0, color: Color(MyColors.primaryColor)),
            ),
            isThreeLine: Platform.isAndroid,
            onLongPress: (com["user_uid"] != user.uid) ? null : () async {
              //check if user created the comment
              if(com["user_uid"] != user.uid) return;
              final confirm = await new GeneralUtils().displayReturnedValueAlertDialog(context, "Attention", "Are you sure you want to delete this comment?", confirmText: "YES");
              if(confirm) {
                await gChatServices.removeRecentCommentFromGChat(com, com["gchat_id"]);
                setState(() {
                  comments.remove(com);
                });
              }
            },
          )
      );
    });
    return mComments;
  }

  Future<void> operationAfterLikeButton(String action, String commentID) async {
    //find likeMap data with commentID if action is remove
    if(action == "remove") {
      dynamic findLike = likesData.firstWhere((like) => like["comment_id"] == commentID);
      String likeDataID = findLike["like_id"];
      await gChatServices.removeLikeData(likeDataID);
      await gChatServices.updateCommentNumberOfLikesByID(commentID, -1);
      return;
    }
    String key = FirebaseDatabase.instance.reference().push().key;
    Map<String, dynamic> likeMap = new Map();
    likeMap["like_id"] = key;
    likeMap["gchat_id"] = null;
    likeMap["type"] = "comment";
    likeMap["comment_id"] = commentID;
    setState(() {
      likesData.add(likeMap);
    });
    await gChatServices.saveLikeData(key, null, "comment", commentID);
    await gChatServices.updateCommentNumberOfLikesByID(commentID, 1);
  }
}
