import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/ListItem/model_gchat_like.dart';
import 'package:coral_reef/ListItem/model_gchat.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/g_chat_screen/components/image_display_widget.dart';
import 'package:coral_reef/g_chat_screen/components/post_comment.dart';
import 'package:coral_reef/g_chat_screen/components/recent_comments.dart';
import 'package:coral_reef/g_chat_screen/components/report_dialog.dart';
import 'package:coral_reef/g_chat_screen/components/shimmer_effects.dart';
import 'package:coral_reef/g_chat_screen/components/video_display_widget.dart';
import 'package:coral_reef/g_chat_screen/services/gchat_services.dart';
import 'package:coral_reef/shared_screens/gchat_user_avatar.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:truncate/truncate.dart';
import 'package:video_player/video_player.dart';

import '../../size_config.dart';
import 'gchat_single_post_view.dart';

class GChatTimelineScreen extends StatefulWidget {

  final Function(bool hide) hideFloatingButton;
  GChatTimelineScreen(this.hideFloatingButton);

  @override
  State<StatefulWidget> createState() => _GChatTimelineScreen();
}

class _GChatTimelineScreen extends State<GChatTimelineScreen> {

  GChatServices gServices;

  bool hasLoadedContent = false;
  var imageNetwork = NetworkImage(
      "https://firebasestorage.googleapis.com/v0/b/taconlinegiftshop.appspot.com/o/logo-3.png?alt=media&token=92f27f22-efdb-4455-9628-8e9ac7ae99c6");

  bool isBottom = false;

  List<GChat> chats = [
    // GChat(
    //     "id",
    //     "user_uid",
    //     "RaeRae0",
    //     {"selectedAvatar": "avatar2", "selectedColor": MyColors.avatarColor2},
    //     "Relationships",
    //     "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nec, feugiat non pellentesque duis fames vel diam. Ullamcorper rhoncus id nunc mauris turpis lacus lorem sit augue. ",
    //     ["https://miro.medium.com/max/600/1*mKaVn6O_214Fj3tDPRRIUA.jpeg"],
    //     47,
    //     2,0,
    //     0,
    //     [],
    //     "2 days ago",
    //     "timestamp",[], false, "",""),
    // GChat(
    //     "id",
    //     "user_uid",
    //     "coralxyz12",
    //     {"selectedAvatar": "avatar4", "selectedColor": MyColors.avatarColor4},
    //     "Periods",
    //     "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nec, feugiat non pellentesque duis fames vel diam. Ullamcorper rhoncus id nunc mauris turpis lacus lorem sit augue. ",
    //     ["https://dz9yg0snnohlc.cloudfront.net/cro-is-it-healthy-to-chat-with-random-people-online-2.jpg"],
    //     33,
    //     22,0,
    //     0,
    //     [],
    //     "1 wk ago",
    //     "timestamp",[], false, "",""),
    // GChat(
    //     "id",
    //     "user_uid",
    //     "AshAshto20",
    //     {"selectedAvatar": "avatar6", "selectedColor": MyColors.avatarColor6},
    //     "My Pregnancy Test",
    //     "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nec, feugiat non pellentesque duis fames vel diam. Ullamcorper rhoncus id nunc mauris turpis lacus lorem sit augue. ",
    //     ["https://www.ft.com/__origami/service/image/v2/images/raw/http%3A%2F%2Fcom.ft.imagepublish.upp-prod-us.s3.amazonaws.com%2F082f40aa-39d7-11e9-9988-28303f70fcff?fit=scale-down&source=next&width=700"],
    //     333,
    //     242,0,
    //     0,
    //     [],
    //     "1 hr ago",
    //     "timestamp",[], false, "",""),
  ];

  StorageSystem ss = new StorageSystem();

  StreamSubscription<QuerySnapshot> gchatsList;
  ScrollController _scrollController = new ScrollController();

  List<Map<String, dynamic>> likesData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gServices = GChatServices(context);

    // ss.getItem("gchats_local_storage").then((value) {
    //   if(value == null) return;
    //
    // });

    _scrollController.addListener(() {
      if(_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
        setState(() {
          isBottom = true;
          // widget.hideFloatingButton(true);
        });
      }else {
        setState(() {
          isBottom = false;
          // widget.hideFloatingButton(false);
        });
      }
    });

    getAllLikesData();
    // imageNetwork.resolve(new ImageConfiguration()).addListener(
    //     new ImageStreamListener((ImageInfo image, bool synchronousCall) {
    //   if (!mounted) return;
    //   print(synchronousCall);
    //   setState(() {
    //     hasLoadedContent = true;
    //   });
    // }));
  }
  
  getGChats() async {
    gchatsList = FirebaseFirestore.instance.collection("gchats").where("visibility", isEqualTo: "published").orderBy("timestamp", descending: true).limit(100).snapshots().listen((event) async {
      if(!mounted) return;
      
      setState(() {
        hasLoadedContent = true;
      });

      chats = [];

      event.docs.forEach((gc) {
        GChat _gc = GChat.fromSnapshot(gc.data());
        setState(() {
          chats.add(_gc);
        });
      });

      //store data locally
      // await ss.setPrefItem("gchats_local_storage", jsonEncode(chats));
      // print(jsonEncode(chats));

    });
  }

  getAllLikesData() async {
    //get user data
    String user = await ss.getItem('user');
    Map<String, dynamic> json = jsonDecode(user);

    QuerySnapshot query = await FirebaseFirestore.instance.collection("likes").where("user_uid", isEqualTo: json["uid"]).get();

    if(query.size > 0) {
      query.docs.forEach((likeQ) {
        GChatLike gLike = GChatLike.fromSnapshot(likeQ.data());

        //store the likes per post
        Map<String, dynamic> likeMap = new Map();
        likeMap["like_id"] = gLike.id;
        likeMap["gchat_id"] = gLike.gchat_id;

        setState(() {
          likesData.add(likeMap);
        });
      });
    }

    getGChats();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    gchatsList.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (!hasLoadedContent)
        ? ShimmerEffects(LoadingGChat(), 1.7)
        : Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              controller: _scrollController,
              itemBuilder: (context, index) {

                bool liked = hasLikedPost(index);

                Map<String, dynamic> mediaInfo = chats[index].images[0]; //get the first index of uploaded media
                String fileType = mediaInfo["fileType"]; //get the media type
                String postMediaUrl = mediaInfo["url"];
                String thumbImage = (fileType == "image") ? mediaInfo["url"] : (fileType == "video") ? mediaInfo["thumbnailUrl"] : "";//

                return Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (index > 0) ? SizedBox(
                      height: 30.0,
                    ): Text(""),
                    ListTile(
                      leading: GChatUserAvatar(
                        40.0,
                        avatarData: chats[index].user_avatar,
                      ),
                      title: Container(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text(chats[index].username,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    color: Color(MyColors.titleTextColor),
                                    fontSize: getProportionateScreenWidth(13))),
                      ),
                      subtitle: Text(
                        new GeneralUtils().returnFormattedDate(chats[index].created_date),
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Color(MyColors.titleTextColor),
                              fontSize: getProportionateScreenWidth(10),
                            ),
                      ),
                      trailing: TextButton(
                        onPressed: () {
                          onReportClick(index);
                        },
                        child: Text("Report",
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: Color(MyColors.accentColor),
                            fontSize: getProportionateScreenWidth(12),
                          ),
                        ),
                      ),
                      isThreeLine: true,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 15.0, top: 10.0),
                      child:Text(chats[index].title,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: Color(MyColors.titleTextColor),
                              fontWeight: FontWeight.bold,
                              fontSize: getProportionateScreenWidth(15))),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
                      width: MediaQuery.of(context).size.width,
                      child:Text(truncate(chats[index].body, 150, omission: "...", position: TruncatePosition.end),
                          overflow: TextOverflow.clip,
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Color(MyColors.titleTextColor),
                              fontSize: getProportionateScreenWidth(13)))
                    ),
                    (chats[index].body.length > 150) ? ListTile(
                      leading: Text("Continue reading",
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Color(MyColors.primaryColor),
                              fontSize: getProportionateScreenWidth(13))),
                      onTap: (){
                        String getLikeID = "";
                        if(hasLikedPost(index)) {
                          getLikeID = getLikeIDForPost(index);
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GChatSinglePostView(chats[index], liked, getLikeID)),
                        );
                      },
                    ) : SizedBox(),
                    // Container(
                    //   width: MediaQuery.of(context).size.width,
                    //   height: 300.0,
                    //   decoration: BoxDecoration(
                    //     image: DecorationImage(image: NetworkImage(postImage),fit: BoxFit.cover),
                    //   ),
                    // ),
                    (fileType == "image" || fileType == "gif") ? ImageDisplayWidget(postMediaUrl) : (fileType == "video") ? VideoDisplayWidget(postMediaUrl, thumbImage) : Container(),//for docs,
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            child: (!liked) ? Icon(Icons.favorite_border_rounded, size: 24.0, color: Color(MyColors.titleTextColor),) :
                            Icon(Icons.favorite, size: 24.0, color: Colors.redAccent,),
                            onTap: (){
                              onLikeButtonClick(index);
                            },
                          ),

                          Text(gServices.shortenLargeNumber(num: double.parse("${chats[index].number_of_likes}"), digits: 1),//"${}",
                              style: Theme.of(context).textTheme.subtitle1.copyWith(
                                  color: Color(MyColors.titleTextColor),
                                  fontSize: getProportionateScreenWidth(15))),
                          SizedBox(
                            width: 10.0,
                          ),
                          Icon(Icons.mode_comment_outlined, size: 24.0,),

                          Text(gServices.shortenLargeNumber(num: double.parse("${chats[index].number_of_comments}"), digits: 1),
                              style: Theme.of(context).textTheme.subtitle1.copyWith(
                                  color: Color(MyColors.titleTextColor),
                                  fontSize: getProportionateScreenWidth(15))),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    (chats[index].recent_comments == []) ? SizedBox() : RecentPostComment(chats[index].recent_comments),
                    (chats[index].recent_comments == []) ? SizedBox() : SizedBox(
                      height: 0.0,
                    ),
                    (chats[index].number_of_comments > 3) ? Center(
                      child: TextButton(
                        onPressed: (){
                          String getLikeID = "";
                          if(hasLikedPost(index)) {
                            getLikeID = getLikeIDForPost(index);
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => GChatSinglePostView(chats[index], liked, getLikeID)),
                          );
                        },
                        child: Text("View ${chats[index].number_of_comments - 3} more comments.",
                            style: Theme.of(context).textTheme.subtitle1.copyWith(
                                color: Color(MyColors.primaryColor),
                                fontSize: getProportionateScreenWidth(13))),
                      ),
                    ) : SizedBox(),
                    PostComment(GChatUserAvatar(
                      40.0,
                      avatarData: chats[index].user_avatar,
                    ), chats[index].id, onCreateComment: (comment) {
                      print(comment.message);
                      setState(() {
                        chats[index].recent_comments.insert(0, comment.toJSON());
                      });
                    },),
                    Divider(
                      height: 1.0,
                      color: Colors.grey[200],
                    ),
                  ],
                );
              },
              itemCount: chats.length,
              scrollDirection: Axis.vertical,
            ),
          );
  }

  /**
   *
      (chats[index].body.length <= 150)
      ? chats[index].body
      : "${chats[index].body.substring(0, 150)}..."
   * */

  bool hasLikedPost(int index) {
    if(likesData.isEmpty) { //|| likesData.isNotEmpty
      return false;
    }
    GChat currentGChat = chats[index];
    Iterable<Map<String, dynamic>> findLike = likesData.where((like) => like["gchat_id"] == currentGChat.id);
    return findLike.isNotEmpty;
  }

  getLikeIDForPost(int index) {
    if(likesData.isEmpty) {
      return "";
    }
    GChat currentGChat = chats[index];
    dynamic findLike = likesData.firstWhere((like) => like["gchat_id"] == currentGChat.id);
    return findLike["like_id"];
  }

  onLikeButtonClick(int index) async {
    GChat currentGChat = chats[index];

    if(hasLikedPost(index)) { //user has liked the post and wants to unlike
      dynamic findLike = likesData.firstWhere((like) => like["gchat_id"] == currentGChat.id);
      setState(() {
        likesData.remove(findLike);
      });
      await gServices.removeLikeData(findLike["like_id"]);
    } else {
      String key = FirebaseDatabase.instance.reference().push().key;
      //save the likes per post
      Map<String, dynamic> likeMap = new Map();
      likeMap["like_id"] = key;
      likeMap["gchat_id"] = currentGChat.id;

      setState(() {
        likesData.add(likeMap);
      });

      await gServices.saveLikeData(key, currentGChat);
    }
  }

  onReportClick(int index) async {
    ReportDialog reportDialog = new ReportDialog(context, chats[index].id, "gchat");
    reportDialog.displayReportDialog(context, "Attention", "Please enter details about this report");
  }
}
