import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/components/coral_back_button.dart';
import 'package:coral_reef/shared_screens/gchat_user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../size_config.dart';

class CreateNewGChat extends StatefulWidget {
  static final routeName = "create-new-gchat";

  @override
  State<StatefulWidget> createState() => _CreateNewGChat();
}

class _CreateNewGChat extends State<CreateNewGChat> {

  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(24)),
            child: Stack(
              children: [
                SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: SizeConfig.screenHeight * 0.03),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            CoralBackButton(
                              icon: Icon(
                                Icons.clear,
                                size: 32.0,
                                color: Color(MyColors.titleTextColor),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 10.0),
                                  child: TextButton(
                                      onPressed: () {},
                                      child: Text("Save Draft",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(color: Colors.grey))),
                                ),
                                Container(
                                  height: 35.0,
                                  margin: EdgeInsets.only(top: 10.0),
                                  decoration: BoxDecoration(
                                      color: Color(MyColors.other3),
                                      borderRadius: BorderRadius.circular(10.0)),
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text("Post",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                            color: Color(MyColors.primaryColor))),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        Divider(
                          height: 1.0,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: SizeConfig.screenHeight * 0.02),
                        Row(
                          children: [
                            GChatUserAvatar(40.0),
                            SizedBox(width: 20.0,),
                            Container(
                              height: 80.0,
                              width: MediaQuery.of(context).size.width - 130.0,
                              padding: EdgeInsets.only(top: 20.0),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                                textCapitalization: TextCapitalization.sentences,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Title",
                                    hintStyle: Theme.of(context).textTheme.subtitle1.copyWith(
                                        color: Colors.grey
                                    ),
                                    labelStyle: Theme.of(context).textTheme.subtitle1.copyWith(
                                        color: Colors.grey, fontWeight: FontWeight.bold
                                    )
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: SizeConfig.screenHeight * 0.01),
                        Divider(
                          height: 1.0,
                          color: Colors.grey[300],
                        ),
                        Container(
                          height: 500,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(top: 25.0, left: 0.0),
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 10,
                            minLines: 3,
                            maxLength: 200,
                            maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Write post |",
                                hintStyle: Theme.of(context).textTheme.subtitle1.copyWith(
                                    color: Colors.grey
                                ),
                                labelStyle: Theme.of(context).textTheme.subtitle1.copyWith(
                                    color: Colors.grey, fontWeight: FontWeight.bold
                                )
                            ),
                          ),
                        )
                      ],
                    )
                ),
                Positioned(child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey[300]))
                  ),
                  child: Column(

                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextButton(onPressed: (){}, child: SvgPicture.asset("assets/icons/gchat_image.svg"), style: ButtonStyle(alignment: Alignment.centerLeft),),
                          TextButton(onPressed: (){}, child: SvgPicture.asset("assets/icons/gchat_video.svg")),
                          TextButton(onPressed: (){}, child: SvgPicture.asset("assets/icons/gchat_gif.svg")),
                        ],
                      )
                    ],
                  ),
                ),
                  top: MediaQuery.of(context).size.height - 90,
                ),
                Visibility(
                  visible: isVisible,
                    child: Positioned(child: Container(
                  child: Row(
                    children: [
                      Container(
                        width: 70.0,
                        height: 70.0,
                        margin: EdgeInsets.only(right: 20.0),
                        decoration: BoxDecoration(
                            // color: Colors.grey,
                          image: DecorationImage(image: AssetImage("assets/images/default_avatar.png"))
                        ),
                      ),
                      Container(
                        child: Text("Ready to upload file.",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(color: Colors.grey)),
                      ),
                      TextButton(onPressed: (){
                        setState(() {
                          isVisible = false;
                        });
                      }, child: Text("Remove",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(color: Colors.redAccent) ))
                    ],
                  ),
                ), top: MediaQuery.of(context).size.height - 170,))
              ],
            )
          ),
        ),
      ),
    );
  }
}
