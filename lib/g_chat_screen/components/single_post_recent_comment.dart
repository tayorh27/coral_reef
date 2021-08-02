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
  SinglePostPostComment(this.recentComments);

  @override
  State<StatefulWidget> createState() => _SinglePostPostComment();
}

class _SinglePostPostComment extends State<SinglePostPostComment> {

  StorageSystem ss = new StorageSystem();

  GChatServices gChatServices;

  bool sending = false;

  List<GChatComment> comments = [];

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
                    (com.number_of_likes == null || com.number_of_likes <= 0) ? SizedBox() : Text("${com.number_of_likes} ${(com.number_of_likes == 1) ? "like" : "likes"}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(
                            color: Colors.grey,
                            fontSize: getProportionateScreenWidth(12))),
                    Visibility(
                      visible: false,
                      child: Container(
                        margin: EdgeInsets.only(left: (com.number_of_likes == null || com.number_of_likes <= 0) ? 0.0 : 20.0),
                        child: InkWell(onTap: (){
                          List<String> post = [com.username, com.main_comment_id];
                          // print("reply @${com.username}");
                          // alertPost.
                          alertPost.add(post);
                        }, child: Text("Reply",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                color: Colors.grey,
                                fontSize: getProportionateScreenWidth(12))),),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: (com.number_of_likes == null || com.number_of_likes <= 0) ? 0.0 : 20.0, top: 3.0),
                      child: InkWell(
                        child: userLikeRecords.contains(com.id) ? Icon(Icons.favorite, size: 14.0, color: Colors.redAccent,) : Icon(Icons.favorite_border, size: 14.0,),
                        onTap: () async {
                          String commentID = com.id;
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
                      ),
                    )
                  ],
                )
              ],
            ),
            isThreeLine: true,
          )
      );
      // index = index + 1;
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

