import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChallengeParticipant extends StatefulWidget {
  static final routeName = "challengeParticipant";
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<ChallengeParticipant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios)),
              Text(
                'Challenge details',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: getProportionateScreenWidth(15),
                    ),
              ),
              Text('')
            ],
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey[100],
                  height: 40,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            padding: EdgeInsets.only(left: 20),
                            child: Text('Participants',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      fontSize: getProportionateScreenWidth(13),
                                    )))
                      ])),
              Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset("assets/exercise/end.png",
                                height: 40.0),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Elie',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    fontSize: getProportionateScreenWidth(14),
                                  ),
                            ),
                          ],
                        ),
                        Text(
                          '',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                fontSize: getProportionateScreenWidth(12),
                              ),
                        ),
                      ])),
              Divider(
                thickness: 3,
              ),
              Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset("assets/exercise/end.png",
                                height: 40.0),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Elie',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    fontSize: getProportionateScreenWidth(14),
                                  ),
                            ),
                          ],
                        ),
                        Text(
                          '',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                fontSize: getProportionateScreenWidth(12),
                              ),
                        ),
                      ])),
              Divider(
                thickness: 3,
              ),
              Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset("assets/exercise/end.png",
                                height: 40.0),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Elie',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    fontSize: getProportionateScreenWidth(14),
                                  ),
                            ),
                          ],
                        ),
                        Text(
                          '',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                fontSize: getProportionateScreenWidth(12),
                              ),
                        ),
                      ])),
              Divider(
                thickness: 3,
              ),
              Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset("assets/exercise/invite_friends.svg",
                                height: 40.0),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Invite friends',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    fontSize: getProportionateScreenWidth(14),
                                  ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Color(MyColors.primaryColor),
                        )
                      ])),
SizedBox(height: 45,),
                      Text(
                        'Quit this challenge',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(
                          color: Color(MyColors.primaryColor),
                          fontWeight: FontWeight.bold,
                          fontSize: getProportionateScreenWidth(14),
                        ),
                      ),
            ]))));
  }
}
