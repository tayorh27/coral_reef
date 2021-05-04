import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/ListItem/model_gchat.dart';
import 'package:coral_reef/ListItem/model_gchat_comment.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/coral_back_button.dart';
import 'package:coral_reef/g_chat_screen/components/image_display_widget.dart';
import 'package:coral_reef/g_chat_screen/components/post_comment.dart';
import 'package:coral_reef/g_chat_screen/components/recent_comments.dart';
import 'package:coral_reef/g_chat_screen/components/single_post_recent_comment.dart';
import 'package:coral_reef/g_chat_screen/components/video_display_widget.dart';
import 'package:coral_reef/g_chat_screen/services/gchat_services.dart';
import 'package:coral_reef/shared_screens/gchat_user_avatar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../size_config.dart';

class GChatSinglePostView extends StatefulWidget {

  final GChat gChat;
  final bool gLiked;
  final String likeID;

  GChatSinglePostView(this.gChat, this.gLiked, this.likeID);

  @override
  State<StatefulWidget> createState() => _GChatSinglePostView();
}

class _GChatSinglePostView extends State<GChatSinglePostView> {
  GChatServices gServices;
  StorageSystem ss = new StorageSystem();
  ScrollController _scrollController = new ScrollController();

  List<GChatComment> comments = [];

  Map<String, dynamic> mediaInfo;
  String fileType = "";
  String postMediaUrl = "";
  String thumbImage = "";
  bool liked = false;

  String postLikeID = "";

  StreamSubscription<QuerySnapshot> commentList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      postLikeID = widget.likeID;
      liked = widget.gLiked;
      mediaInfo =
          widget.gChat.images[0]; //get the first index of uploaded media
      fileType = mediaInfo["fileType"]; //get the media type
      postMediaUrl = mediaInfo["url"];
      thumbImage = (fileType == "image" || fileType == "gif")
          ? mediaInfo["url"]
          : (fileType == "video")
              ? mediaInfo["thumbnailUrl"]
              : ""; //
    });

    gServices = GChatServices(context);

    getPostComment();
  }

  getPostComment() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("comments")
        .where("gchat_id", isEqualTo: widget.gChat.id)
        .orderBy("timestamp", descending: true).get();

    if(!mounted) return;

    // print("I dey here");

    // setState(() {
    //   comments = [];
    // });

    if (query.size > 0) {
      query.docs.forEach((commentQ) {
        GChatComment gComment = GChatComment.fromSnapshot(commentQ.data());
        // print(gComment);
        setState(() {
          comments.add(gComment);
        });
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // commentList.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, leading: Container(
        margin: EdgeInsets.only(left: 15.0, top: 20.0, bottom: 0.0),
        child: CoralBackButton(icon: Icon(
          Icons.clear,
          size: 32.0,
          color: Color(MyColors.titleTextColor),
        ),),
      ),),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 100.0,
                child: ListView(
                  controller: _scrollController,
                  children: [
                    // Container(
                    //   margin: EdgeInsets.only(left: 15.0, top: 0.0, bottom: 20.0),
                    //   child: CoralBackButton(icon: Icon(
                    //     Icons.clear,
                    //     size: 32.0,
                    //     color: Color(MyColors.titleTextColor),
                    //   ),),
                    // ),
                    ListTile(
                      leading: GChatUserAvatar(
                        40.0,
                        avatarData: widget.gChat.user_avatar,
                      ),
                      title: Container(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text(widget.gChat.username,
                            style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Color(MyColors.titleTextColor),
                                fontSize: getProportionateScreenWidth(13))),
                      ),
                      subtitle: Text(
                        new GeneralUtils().returnFormattedDate(widget.gChat.created_date),
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Color(MyColors.titleTextColor),
                          fontSize: getProportionateScreenWidth(10),
                        ),
                      ),
                      isThreeLine: true,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 15.0, top: 10.0),
                      child: Text(widget.gChat.title,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: Color(MyColors.titleTextColor),
                              fontWeight: FontWeight.bold,
                              fontSize: getProportionateScreenWidth(15))),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
                        width: MediaQuery.of(context).size.width,
                        child: Text(widget.gChat.body,
                            overflow: TextOverflow.clip,
                            style: Theme.of(context).textTheme.subtitle1.copyWith(
                                color: Color(MyColors.titleTextColor),
                                fontSize: getProportionateScreenWidth(13)))),
                    (fileType == "image" || fileType == "gif")
                        ? ImageDisplayWidget(postMediaUrl)
                        : (fileType == "video")
                        ? VideoDisplayWidget(postMediaUrl, thumbImage)
                        : Container(), //for docs,
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            child: (!liked)
                                ? Icon(
                              Icons.favorite_border_rounded,
                              size: 24.0,
                              color: Color(MyColors.titleTextColor),
                            )
                                : Icon(
                              Icons.favorite,
                              size: 24.0,
                              color: Colors.redAccent,
                            ),
                            onTap: () {
                              onLikeButtonClick();
                            },
                          ),
                          Text(
                              gServices.shortenLargeNumber(
                                  num: double.parse("${widget.gChat.number_of_likes}"),
                                  digits: 1), //"${}",
                              style: Theme.of(context).textTheme.subtitle1.copyWith(
                                  color: Color(MyColors.titleTextColor),
                                  fontSize: getProportionateScreenWidth(15))),
                          SizedBox(
                            width: 10.0,
                          ),
                          Icon(
                            Icons.mode_comment_outlined,
                            size: 24.0,
                          ),
                          Text(
                              gServices.shortenLargeNumber(
                                  num: double.parse("${widget.gChat.number_of_comments}"),
                                  digits: 1),
                              style: Theme.of(context).textTheme.subtitle1.copyWith(
                                  color: Color(MyColors.titleTextColor),
                                  fontSize: getProportionateScreenWidth(15))),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    (comments.isEmpty) ? SizedBox() : Column(
                      children: [
                        SinglePostPostComment(comments),
                        SizedBox(height: 100.0,)
                      ],
                    ),
                  ],
                  scrollDirection: Axis.vertical,
                ),
              ),
              Positioned(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                      border: Border(
                          top: BorderSide(color: Colors.grey[300]))),
                  child:
                  PostComment(
                      GChatUserAvatar(
                        40.0,
                        avatarData: widget.gChat.user_avatar,
                      ),
                      widget.gChat.id, onCreateComment: (comment) {
                        print(comment.message);
                        setState(() {
                          comments.insert(0, comment);
                        });
                  },),
                ),
                top: (MediaQuery.of(context).viewInsets.bottom != 0) ? MediaQuery.of(context).size.height - 510.0 : MediaQuery.of(context).size.height - 185.0,
              ),
            ],
          )

      )
    );
  }

  onLikeButtonClick() async {
    GChat currentGChat = widget.gChat;
    if (liked) {
      //user has liked the post and wants to unlike
      setState(() {
        liked = false;
      });
      await gServices.removeLikeData(postLikeID);
    } else {
      String key = FirebaseDatabase.instance.reference().push().key;
      setState(() {
        liked = true;
        postLikeID = key;
      });
      await gServices.saveLikeData(key, currentGChat);
    }
  }
}
