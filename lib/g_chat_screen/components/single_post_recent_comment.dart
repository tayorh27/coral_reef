import 'package:coral_reef/ListItem/model_gchat_comment.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/g_chat_screen/services/gchat_services.dart';
import 'package:coral_reef/shared_screens/gchat_user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

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
                    new GeneralUtils().returnFormattedDate(com.created_date),
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: Color(MyColors.titleTextColor),
                      fontSize: getProportionateScreenWidth(10),
                    ),
                  ),
                ],
              )) ,
            subtitle: ReadMoreText(
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
            isThreeLine: true,
          )
      );
      // index = index + 1;
    });
    return mComments;
  }
}
