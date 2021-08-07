
import 'package:akvelon_flutter_share_plugin/akvelon_flutter_share_plugin.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../size_config.dart';

class ShareChallenge extends StatefulWidget {
  static final routeName = "shareChallengePage";
  final String title, desc, link, joinCode;
  ShareChallenge(this.title, this.desc, this.link, this.joinCode);

  @override
  State<StatefulWidget> createState() => _ShareChallenge();
}

class _ShareChallenge extends State<ShareChallenge> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios)),
          elevation: 0,
          title: Text(
            '',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontSize: getProportionateScreenWidth(15),
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/exercise/speed_run_2.svg",
                          height: 150.0),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        widget.title,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: getProportionateScreenWidth(20),
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Share with your friends & family. \nThey will need the code to join this challenge.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                  fontSize:
                                  getProportionateScreenWidth(10),
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                            ),
                          ]),
                      Divider(
                        thickness: 2,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                          decoration: BoxDecoration(
                            color: Color(MyColors.primaryColor).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: getProportionateScreenWidth(
                              MediaQuery.of(context).size.width / 1.5),
                          height: getProportionateScreenHeight(130),
                          child:
                          Padding(
                            padding: EdgeInsets.all(20),
                            child:
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "CODE: ${widget.joinCode}",
                                  softWrap: true,
                                  textAlign: TextAlign.start,
                                  style:
                                  Theme.of(context).textTheme.bodyText1.copyWith(color: Color(MyColors.primaryColor), fontSize: 14, fontWeight: FontWeight.bold,),
                                ),
                                Divider(thickness: 2, color: Color(MyColors.primaryColor),),
                                Text(
                                  "${widget.desc}",
                                  textAlign: TextAlign.start,
                                  style:
                                  Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.black, fontSize: 12),
                                ),
                                // Text(
                                //   "Excludes manually recorded activities",
                                //   textAlign: TextAlign.start,
                                //   style:
                                //   TextStyle(color: Colors.black, fontSize: 12),
                                // ),
                              ],
                            ),)
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 7,
                      ),
                      DefaultButton(
                        press: () {
                          String text = "Join me on CoralApp to participate in this challenge titled ${widget.title}.\nUse this code ${widget.joinCode} to access the challenge. \nIf you don't have the app, click on the link below to download and install.\n${widget.link}\n\n${widget.desc}";
                          AkvelonFlutterSharePlugin.shareText(text,
                              title: widget.title,
                              subject: "CoralApp",
                              url: "");
                        },
                        text: 'Share',
                      )
                    ]))));
  }
}