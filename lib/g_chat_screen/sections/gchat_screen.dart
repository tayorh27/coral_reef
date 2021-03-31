import 'package:coral_reef/ListItem/model_gchat.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/g_chat_screen/components/shimmer_effects.dart';
import 'package:coral_reef/shared_screens/gchat_user_avatar.dart';
import 'package:flutter/material.dart';

import '../../size_config.dart';

class GChatTimelineScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GChatTimelineScreen();
}

class _GChatTimelineScreen extends State<GChatTimelineScreen> {
  bool hasLoadedContent = false;
  var imageNetwork = NetworkImage(
      "https://firebasestorage.googleapis.com/v0/b/taconlinegiftshop.appspot.com/o/logo-3.png?alt=media&token=92f27f22-efdb-4455-9628-8e9ac7ae99c6");

  List<GChat> chats = [
    GChat(
        "id",
        "user_uid",
        "Dupe Adeleke",
        {"selectedAvatar": "avatar2", "selectedColor": MyColors.avatarColor2},
        "Relationships",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nec, feugiat non pellentesque duis fames vel diam. Ullamcorper rhoncus id nunc mauris turpis lacus lorem sit augue. ",
        ["https://miro.medium.com/max/600/1*mKaVn6O_214Fj3tDPRRIUA.jpeg"],
        47,
        2,
        null,
        "2 days ago",
        "timestamp"),
    GChat(
        "id",
        "user_uid",
        "John Doe",
        {"selectedAvatar": "avatar4", "selectedColor": MyColors.avatarColor4},
        "Periods",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nec, feugiat non pellentesque duis fames vel diam. Ullamcorper rhoncus id nunc mauris turpis lacus lorem sit augue. ",
        ["https://dz9yg0snnohlc.cloudfront.net/cro-is-it-healthy-to-chat-with-random-people-online-2.jpg"],
        33,
        22,
        null,
        "1 wk ago",
        "timestamp"),
    GChat(
        "id",
        "user_uid",
        "Victoria Secret",
        {"selectedAvatar": "avatar6", "selectedColor": MyColors.avatarColor6},
        "My Pregnancy Test",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nec, feugiat non pellentesque duis fames vel diam. Ullamcorper rhoncus id nunc mauris turpis lacus lorem sit augue. ",
        ["https://www.ft.com/__origami/service/image/v2/images/raw/http%3A%2F%2Fcom.ft.imagepublish.upp-prod-us.s3.amazonaws.com%2F082f40aa-39d7-11e9-9988-28303f70fcff?fit=scale-down&source=next&width=700"],
        333,
        242,
        null,
        "1 hr ago",
        "timestamp"),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imageNetwork.resolve(new ImageConfiguration()).addListener(
        new ImageStreamListener((ImageInfo image, bool synchronousCall) {
      if (!mounted) return;
      print(synchronousCall);
      setState(() {
        hasLoadedContent = true;
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (!hasLoadedContent)
        ? ShimmerEffects(LoadingGChat(), 1.7)
        : Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(top: 0.0),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30.0,
                    ),
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
                        chats[index].created_date,
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
                      child:Text(chats[index].title,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: Color(MyColors.titleTextColor),
                              fontWeight: FontWeight.bold,
                              fontSize: getProportionateScreenWidth(15))),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15.0, right: 15.0),
                      width: MediaQuery.of(context).size.width,
                      child:Text(
                          (chats[index].body.length <= 150)
                              ? chats[index].body
                              : "${chats[index].body.substring(0, 150)}...",
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
                      onTap: (){},
                    ) : Text(""),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: NetworkImage(chats[index].images[0]),fit: BoxFit.fill),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      width: 120.0,
                      margin: EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.favorite_border_rounded, size: 24.0, color: Color(MyColors.titleTextColor),),

                          Text("${chats[index].number_of_likes}",
                              style: Theme.of(context).textTheme.subtitle1.copyWith(
                                  color: Color(MyColors.titleTextColor),
                                  fontSize: getProportionateScreenWidth(15))),
                          Icon(Icons.mode_comment_outlined, size: 24.0,),

                          Text("${chats[index].number_of_comment}",
                              style: Theme.of(context).textTheme.subtitle1.copyWith(
                                  color: Color(MyColors.titleTextColor),
                                  fontSize: getProportionateScreenWidth(15))),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
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
}
