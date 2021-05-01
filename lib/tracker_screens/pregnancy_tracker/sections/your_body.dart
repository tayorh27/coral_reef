import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/constants.dart';
import 'package:coral_reef/size_config.dart';
import 'package:coral_reef/tracker_screens/pregnancy_tracker/components/list_card.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class YourBody extends StatefulWidget {
  static final routeName = "yourbody";
  @override
  _YourBodyState createState() => _YourBodyState();
}

class _YourBodyState extends State<YourBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 100,
        centerTitle: true,
        title: Text("Your Body", style: Theme.of(context).textTheme.headline2.copyWith(
          color: Color(MyColors.titleTextColor),
          fontSize: getProportionateScreenWidth(18),
        ),)
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your Baby at the 17th Week",
                style: Theme.of(context).textTheme.headline2.copyWith(
                color: Color(MyColors.titleTextColor),
                fontSize: getProportionateScreenWidth(16),
              )),
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    "assets/images/baby.png",
                    width: double.infinity,
                  ),
                  Center(
                    child: Image.asset(
                      "assets/icons/play.png",
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: getProportionateScreenHeight(30),
              ),
              ReadMoreText(
                demodata,
                trimLines: 6,
                colorClickableText: Color(MyColors.primaryColor),
                trimMode: TrimMode.Line,
                trimCollapsedText: 'more',
                trimExpandedText: 'less',
                style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 14.0, color: Color(MyColors.titleTextColor)),
                moreStyle: Theme.of(context).textTheme.headline2.copyWith(fontSize: 14.0, color: Color(MyColors.primaryColor)),
                lessStyle: Theme.of(context).textTheme.headline2.copyWith(fontSize: 14.0, color: Color(MyColors.primaryColor)),
              ),
              SizedBox(
                height: 39,
              ),
              Divider(
                thickness: 2,
              ),
              PregListCard(
                title: "Lorem Ipsum",
                title2: "Some text about something goes here",
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: 10,
              ),
              PregListCard(
                title: "Lorem Ipsum",
                title2: "Some text about something goes here",
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: 10,
              ),
              PregListCard(
                title: "Lorem Ipsum",
                title2: "Some text about something goes here",
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListCard extends StatelessWidget {
  const ListCard({
    Key key,
    @required this.title,
    @required this.title2,
  }) : super(key: key);

  final String title, title2;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Row(
              children: [
                Text(
                  title2,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios)
              ],
            ),
          ],
        ),
      ),
    );
  }
}