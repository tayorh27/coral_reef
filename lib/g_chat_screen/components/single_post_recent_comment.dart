import 'dart:io';

import 'package:coral_reef/ListItem/model_gchat_comment.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/g_chat_screen/services/gchat_services.dart';
import 'package:coral_reef/shared_screens/gchat_user_avatar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import '../../constants.dart';
import '../../size_config.dart';

class SinglePostPostComment extends StatefulWidget {

  final List<GChatComment> recentComments;
  final List<GChatComment> allPostComments;
  SinglePostPostComment(this.recentComments, this.allPostComments);

  @override
  State<StatefulWidget> createState() => _SinglePostPostComment();
}

class _SinglePostPostComment extends State<SinglePostPostComment> {

  StorageSystem ss = new StorageSystem();

  GChatServices gChatServices;

  bool sending = false;

  List<GChatComment> comments = [];
  String deviceLocale = Platform.localeName.split("_")[0].toLowerCase();

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

    // int index = 0;

    comments.forEach((com) {
      //get the replies under this comment
      List<GChatComment> repliesComment = getRepliesFromComments(com.id);
      String gLocale = com.locale ?? "";
      Map<String, dynamic> translated = com.translated;

      mComments.add(
          ListTile(
            leading: GChatUserAvatar(
              40.0,
              avatarData: com.avatar,
            ),
            title: Container(
              padding: EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(com.username,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(
                      color: Color(MyColors.titleTextColor),
                      fontSize: getProportionateScreenWidth(13))),
                  Text(
                    new GeneralUtils().returnFormattedDate(com.created_date, com.time_zone),
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: Color(MyColors.titleTextColor),
                      fontSize: getProportionateScreenWidth(10),
                    ),
                  ),
                ],
              )) ,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReadMoreText(
                  com.message,
                  trimLines: 3,
                  colorClickableText: Color(MyColors.primaryColor),
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'more',
                  trimExpandedText: 'less',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 14.0, color: Color(MyColors.titleTextColor)),
                  moreStyle: Theme.of(context).textTheme.headline2.copyWith(fontSize: 14.0, color: Color(MyColors.primaryColor)),
                  lessStyle: Theme.of(context).textTheme.headline2.copyWith(fontSize: 14.0, color: Color(MyColors.primaryColor)),
                ),
                SizedBox(height: 10.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (gLocale == "" || deviceLocale == gLocale) ? SizedBox() : InkWell(onTap: (){
                      if(translated[deviceLocale] == null) return;
                      setState(() {
                        com.message = translated[deviceLocale];
                      });
                    }, child: Text("See translation",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Color(MyColors.titleTextColor),
                            fontSize: getProportionateScreenWidth(12))),),
                    SizedBox(width: (gLocale == "" || deviceLocale == gLocale) ? 0.0 : 15.0,),
                    (com.number_of_likes == null || com.number_of_likes <= 0) ? SizedBox() : Text("${com.number_of_likes} ${(com.number_of_likes == 1) ? "like" : "likes"}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(
                            color: Colors.grey,
                            fontSize: getProportionateScreenWidth(12))),
                    Visibility(
                      visible: true,
                      child: Container(
                        margin: EdgeInsets.only(left: (com.number_of_likes == null || com.number_of_likes <= 0) ? 0.0 : 15.0),
                        child: InkWell(onTap: (){
                          // List<String> post = [com.username, com.main_comment_id];
                          Map<String, dynamic> data = new Map();
                          data["username"] = com.username;
                          data["mainComment"] = com.toJSON();
                          universalController.add(data);
                        }, child: Text("Reply",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                color: Colors.grey,
                                fontSize: getProportionateScreenWidth(12))),),
                      ),
                    ),
            SizedBox(width: 10,),
                    Container(
                      margin: EdgeInsets.only(left: (com.number_of_likes == null || com.number_of_likes <= 0) ? 0.0 : 15.0, top: 3.0),
                      child: InkWell(
                        child: userLikeRecords.contains(com.id) ? Icon(Icons.favorite, size: 14.0, color: Colors.redAccent,) : Icon(Icons.favorite_border, size: 14.0,),
                        onTap: () async {
                          String commentID = com.id;
                          if(userLikeRecords.contains(commentID)) {
                            setState(() {
                              userLikeRecords.remove(commentID);
                            });
                            await operationAfterLikeButton("remove", commentID);
                            // setState(() {});
                          }else {
                            setState(() {
                              userLikeRecords.add(commentID);
                            });
                            await operationAfterLikeButton("add", commentID);
                            // setState(() {});
                          }
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
            isThreeLine: true,
              onLongPress: (com.user_uid != user.uid) ? null : () async {
                //check if user created the comment
                if(com.user_uid != user.uid) return;
                final confirm = await new GeneralUtils().displayReturnedValueAlertDialog(context, "Attention", "Are you sure you want to delete this comment?", confirmText: "YES");
                if(confirm) {
                  await gChatServices.removeCommentFromGChat(com.toJSON(), com.id, com.gchat_id);
                  setState(() {
                    comments.remove(com);
                  });
                }
              }
          )
      );
      if(repliesComment.isNotEmpty) {
        mComments.add(loadRepliesComments(repliesComment, com));
      }

    });
    return mComments;
  }

  //display replies comments
  Widget loadRepliesComments(List<GChatComment> repliesComment, GChatComment mainComment) {
    List<Widget> mComments = [];

    // int index = 0;

    repliesComment.forEach((com) {
      String gLocale = com.locale ?? "";
      Map<String, dynamic> translated = com.translated;
      mComments.add(
          ListTile(
            leading: GChatUserAvatar(
              40.0,
              avatarData: com.avatar,
            ),
            title: Container(
                padding: EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(com.username,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(
                            color: Color(MyColors.titleTextColor),
                            fontSize: getProportionateScreenWidth(13))),
                    Text(
                      new GeneralUtils().returnFormattedDate(com.created_date, com.time_zone),
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Color(MyColors.titleTextColor),
                        fontSize: getProportionateScreenWidth(10),
                      ),
                    ),
                  ],
                )) ,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReadMoreText(
                  com.message,
                  trimLines: 3,
                  colorClickableText: Color(MyColors.primaryColor),
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'more',
                  trimExpandedText: 'less',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 14.0, color: Color(MyColors.titleTextColor)),
                  moreStyle: Theme.of(context).textTheme.headline2.copyWith(fontSize: 14.0, color: Color(MyColors.primaryColor)),
                  lessStyle: Theme.of(context).textTheme.headline2.copyWith(fontSize: 14.0, color: Color(MyColors.primaryColor)),
                ),
                SizedBox(height: 10.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (gLocale == "" || deviceLocale == gLocale) ? SizedBox() : InkWell(onTap: (){
                      if(translated[deviceLocale] == null) return;
                      setState(() {
                        com.message = translated[deviceLocale];
                      });
                    }, child: Text("See translation",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Color(MyColors.titleTextColor),
                            fontSize: getProportionateScreenWidth(12))),),
                    SizedBox(width: (gLocale == "" || deviceLocale == gLocale) ? 0.0 : 15.0,),
                    (com.number_of_likes == null || com.number_of_likes <= 0) ? SizedBox() : Text("${com.number_of_likes} ${(com.number_of_likes == 1) ? "like" : "likes"}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(
                            color: Colors.grey,
                            fontSize: getProportionateScreenWidth(12))),
                    Visibility(
                      visible: true,
                      child: Container(
                        margin: EdgeInsets.only(left: (com.number_of_likes == null || com.number_of_likes <= 0) ? 0.0 : 15.0),
                        child: InkWell(onTap: (){
                          Map<String, dynamic> data = new Map();
                          data["username"] = com.username;
                          data["mainComment"] = mainComment.toJSON();
                          universalController.add(data);
                        }, child: Text("Reply",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                color: Colors.grey,
                                fontSize: getProportionateScreenWidth(12))),),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      margin: EdgeInsets.only(left: (com.number_of_likes == null || com.number_of_likes <= 0) ? 0.0 : 15.0, top: 3.0),
                      child: InkWell(
                        child: userLikeRecords.contains(com.id) ? Icon(Icons.favorite, size: 14.0, color: Colors.redAccent,) : Icon(Icons.favorite_border, size: 14.0,),
                        onTap: () async {
                          String commentID = com.id;
                          if(userLikeRecords.contains(commentID)) {
                            setState(() {
                              userLikeRecords.remove(commentID);
                            });
                            await operationAfterLikeButton("remove", commentID);
                            // setState(() {});
                          }else {
                            setState(() {
                              userLikeRecords.add(commentID);
                            });
                            await operationAfterLikeButton("add", commentID);
                            // setState(() {});
                          }
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
            isThreeLine: true,
              onLongPress: (com.user_uid != user.uid) ? null : () async {
                //check if user created the comment
                if(com.user_uid != user.uid) return;
                final confirm = await new GeneralUtils().displayReturnedValueAlertDialog(context, "Attention", "Are you sure you want to delete this comment?", confirmText: "YES");
                if(confirm) {
                  await gChatServices.removeCommentFromGChat(com.toJSON(), com.id, com.gchat_id);
                  setState(() {
                    repliesComment.remove(com);
                  });
                }
              }
          )
      );
      // index = index + 1;
    });
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        children: mComments,
      ),
    );
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

  List<GChatComment> getRepliesFromComments(String commentID) {
    final query = widget.allPostComments.where((element) => element.main_comment_id == commentID).toList();
    return (query.isEmpty) ? [] : query;
  }
}

