import 'package:coral_reef/size_config.dart';
import 'package:flutter/material.dart';


class ChallengeParticipant extends StatefulWidget {
  static final routeName = "challengeParticipant";
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<ChallengeParticipant> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                padding: EdgeInsets.all(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    ])
            )
        )
    );
  }

}