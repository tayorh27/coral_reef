import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreateChallengePage extends StatefulWidget {
  static final routeName = "createChallengePage";
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<CreateChallengePage> {

  shareDialog() {
    return showDialog(

        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(15)),
            content: Container(
                height: MediaQuery.of(context).size.height / 2,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(''),
                          Text(
                            'Invite friends',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    fontSize: getProportionateScreenWidth(15),
                                    fontWeight: FontWeight.w500),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.clear,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/exercise/group_people.png",
                            height: 70,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Send a link to your friends and family',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    fontSize: getProportionateScreenWidth(15),
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'to join your friendly challenge',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    fontSize: getProportionateScreenWidth(15),
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) {
                              //widget.onTextChanged(value, error);
                            },
                            validator: (value) {
                              setState(() {
                                //  error = value.isEmpty;
                              });
                              //idget.onTextChanged(value, error);
                              return value.isEmpty ? '' : null;
                            },
                            decoration: InputDecoration(
                              fillColor: Colors.grey,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 15,
                              ),
                              border: InputBorder.none,
                              hintText: 'https://coralreef.com/Sv89Cm',
                              hintStyle: TextStyle(fontSize: 12),
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                            ),
                          ),
                          Text(
                            'Copy link',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    fontSize: getProportionateScreenWidth(15),
                                    color: Color(MyColors.primaryColor),
                                    fontWeight: FontWeight.w300),
                          ),
                          Container(
                              padding: EdgeInsets.all(20),
                              child: DefaultButton(
                                loading: false,
                                text: 'Share Link',
                              ))
                        ],
                      )
                    ])),
          );
        });
  }

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
                'Create virtual challenge',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: getProportionateScreenWidth(15),
                    fontWeight: FontWeight.bold),
              ),
              Text('')
            ],
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
              SizedBox(height: 40),
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
                            child: Text('TITLE',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      fontSize: getProportionateScreenWidth(13),
                                    )))
                      ])),
              TextFormField(
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) {
                  //widget.onTextChanged(value, error);
                },
                validator: (value) {
                  setState(() {
                    //  error = value.isEmpty;
                  });
                  //idget.onTextChanged(value, error);
                  return value.isEmpty ? '' : null;
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    border: InputBorder.none,
                    hintText: 'Select your challenge title',
                    hintStyle: TextStyle(fontSize: 12),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    suffixIcon: Icon(
                      Icons.cancel,
                      color: Colors.grey[400],
                      size: 20,
                    )),
              ),
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
                            child: Text('RULES',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      fontSize: getProportionateScreenWidth(13),
                                    )))
                      ])),
              Container(
                  width: MediaQuery.of(context).size.width,
                  //  color: Colors.grey[100],
                  height: 40,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                padding: EdgeInsets.only(left: 20),
                                child: Text('Select your challenge type',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                          fontSize:
                                              getProportionateScreenWidth(13),
                                        ))),
                            Container(
                                padding: EdgeInsets.only(right: 20),
                                child: Row(
                                  children: [
                                    Text('Run',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        13),
                                                color: Color(
                                                    MyColors.primaryColor))),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(MyColors.primaryColor),
                                    )
                                  ],
                                ))
                          ],
                        )
                      ])),
              Divider(
                thickness: 2,
                indent: 20,
                endIndent: 20,
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  //  color: Colors.grey[100],
                  height: 40,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                padding: EdgeInsets.only(left: 20),
                                child: Text('GPS distance',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                          fontSize:
                                              getProportionateScreenWidth(13),
                                        ))),
                            Container(
                                padding: EdgeInsets.only(right: 20),
                                child: Row(
                                  children: [
                                    Text('5km',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        13),
                                                color: Color(
                                                    MyColors.primaryColor))),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(MyColors.primaryColor),
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ])),
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
                            child: Text('START AND END DATE',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      color: Colors.grey,
                                      fontSize: getProportionateScreenWidth(13),
                                    )))
                      ])),
              Container(
                  width: MediaQuery.of(context).size.width,
                  //  color: Colors.grey[100],
                  height: 40,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                padding: EdgeInsets.only(left: 20),
                                child: Text('Start date',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                          fontSize:
                                              getProportionateScreenWidth(13),
                                        ))),
                            Container(
                                padding: EdgeInsets.only(right: 20),
                                child: Row(
                                  children: [
                                    Text('Choose date',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        13),
                                                color: Colors.grey)),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(MyColors.primaryColor),
                                    )
                                  ],
                                ))
                          ],
                        )
                      ])),
              Divider(
                thickness: 2,
                indent: 20,
                endIndent: 20,
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  //  color: Colors.grey[100],
                  height: 40,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                padding: EdgeInsets.only(left: 20),
                                child: Text('End date',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                          fontSize:
                                              getProportionateScreenWidth(13),
                                        ))),
                            Container(
                                padding: EdgeInsets.only(right: 20),
                                child: Row(
                                  children: [
                                    Text('Set end date',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        13),
                                                color: Colors.grey)),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(MyColors.primaryColor),
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ])),
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
                            child: Text('DETAILS',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      color: Colors.grey,
                                      fontSize: getProportionateScreenWidth(13),
                                    ))),
                      ])),
              Container(
                  padding: EdgeInsets.only(left: 10),
                  child: TextFormField(
                    obscureText: false,
                    keyboardType: TextInputType.multiline,
                    onSaved: (value) {
                      //widget.onTextChanged(value, error);
                    },
                    validator: (value) {
                      setState(() {
                        //  error = value.isEmpty;
                      });
                      //idget.onTextChanged(value, error);
                      return value.isEmpty ? '' : null;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                      border: InputBorder.none,
                      hintText: 'Short description',
                      hintStyle: TextStyle(fontSize: 12),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  )),
              Divider(
                thickness: 2,
                indent: 20,
                endIndent: 20,
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  //  color: Colors.grey[100],
                  height: 40,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                padding: EdgeInsets.only(left: 20),
                                child: Text('Reward',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                          fontSize:
                                              getProportionateScreenWidth(13),
                                        ))),
                            Container(
                                padding: EdgeInsets.only(right: 20),
                                child: Row(
                                  children: [
                                    Text('',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        13),
                                                color: Colors.grey)),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(MyColors.primaryColor),
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ])),
              Container(
                  padding: EdgeInsets.all(20),
                  child: DefaultButton(
                    loading: false,
                    press: () {
                      shareDialog();
                    },
                    text: 'Publish',
                  ))
            ])));
  }
}
