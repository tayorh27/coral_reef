import 'package:coral_reef/ListItem/model_blog_post.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/g_chat_screen/components/shimmer_effects.dart';
import 'package:flutter/material.dart';
import 'package:truncate/truncate.dart';

import '../../size_config.dart';

class BlogPostScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BlogPostScreen();
}

class _BlogPostScreen extends State<BlogPostScreen> {
  bool hasLoadedContent = false;
  var imageNetwork = NetworkImage(
      "https://firebasestorage.googleapis.com/v0/b/taconlinegiftshop.appspot.com/o/logo-3.png?alt=media&token=92f27f22-efdb-4455-9628-8e9ac7ae99c6");

  List<BlogPost> posts = [
    BlogPost(
        "id",
        "category",
        "Lorem ipsum dolor sit. ipsum dolor sit.",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nec, feugiat non pellentesque duis fames vel diam. Ullamcorper rhoncus id nunc mauris turpis lacus lorem sit augue. ",
        "5 mins read",
        ["https://miro.medium.com/max/600/1*mKaVn6O_214Fj3tDPRRIUA.jpeg"],
        "Jan 15, 2021",
        "timestamp"),
    BlogPost(
        "id",
        "category",
        "Lorem ipsum dolor sit.",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nec, feugiat non pellentesque duis fames vel diam. Ullamcorper rhoncus id nunc mauris turpis lacus lorem sit augue. ",
        "5 mins read",
        [
          "https://dz9yg0snnohlc.cloudfront.net/cro-is-it-healthy-to-chat-with-random-people-online-2.jpg"
        ],
        "Jan 15, 2021",
        "timestamp"),
    BlogPost(
        "id",
        "category",
        "Lorem ipsum dolor sit.",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nec, feugiat non pellentesque duis fames vel diam. Ullamcorper rhoncus id nunc mauris turpis lacus lorem sit augue. ",
        "5 mins read",
        [
          "https://www.ft.com/__origami/service/image/v2/images/raw/http%3A%2F%2Fcom.ft.imagepublish.upp-prod-us.s3.amazonaws.com%2F082f40aa-39d7-11e9-9988-28303f70fcff?fit=scale-down&source=next&width=700"
        ],
        "Jan 15, 2021",
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
        ? ShimmerEffects(LoadingBlogPost(), 2.0)
        : Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(top: 0.0),
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Trending news",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Color(MyColors.titleTextColor),
                            fontWeight: FontWeight.bold,
                            fontSize: getProportionateScreenWidth(13))),
                    Text("Show more",
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: Color(MyColors.primaryColor),
                            fontSize: getProportionateScreenWidth(13))),
                  ],
                ),
                Container(
                  width: 300.0,
                  margin: EdgeInsets.only(top: 15.0),
                  height: 310.0,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(right: 20.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0))),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 0.0,
                            ),
                            Container(
                              width: 320.0,
                              height: 150.0,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          NetworkImage(posts[index].images[0]),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0))),
                            ),
                            Container(
                              width: 300.0,
                              margin: EdgeInsets.only(
                                  left: 15.0, top: 10.0, right: 0.0),
                              child: Text(posts[index].title,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                          color: Color(MyColors.titleTextColor),
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              getProportionateScreenWidth(15))),
                            ),
                            Container(
                                width: 300.0,
                                margin: EdgeInsets.only(left: 15.0, right: 0.0),
                                child: Text(truncate(posts[index].body, 100, omission: "...", position: TruncatePosition.end),
                                    overflow: TextOverflow.clip,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(
                                            color:
                                                Color(MyColors.titleTextColor),
                                            fontSize:
                                                getProportionateScreenWidth(
                                                    13)))
                            ),
                            (posts[index].body.length > 100)
                                ? Container(
                                    width: 300.0,
                                    child: ListTile(
                                      leading: Text("Continue reading",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .copyWith(
                                                  color: Color(
                                                      MyColors.primaryColor),
                                                  fontSize:
                                                      getProportionateScreenWidth(
                                                          13))),
                                      onTap: () {},
                                    ),
                                  )
                                : Text(""),
                          ],
                        ),
                      );
                    },
                    itemCount: posts.length,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                ...horizontalPosts("Related articles"),
                ...horizontalPosts("Understanding your cycle"),
                ...horizontalPosts("Maintaining your weight"),
                ...horizontalPosts("Pregnancy guide"),
                ...horizontalPosts("Do's and Don'ts"),
              ],
            ),
          );
  }

  /*
  *
                                    (posts[index].body.length <= 100)
                                        ? posts[index].body
                                        : "${posts[index].body.substring(0, 100)}..."
  */

  List<Widget> horizontalPosts(String headerTitle) {
    return [
      SizedBox(
        height: 20.0,
      ),
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(headerTitle,
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: Color(MyColors.titleTextColor),
                  fontWeight: FontWeight.bold,
                  fontSize: getProportionateScreenWidth(13))),
          Text("Show more",
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: Color(MyColors.primaryColor),
                  fontSize: getProportionateScreenWidth(13))),
        ],
      ),
      SizedBox(
        height: 15.0,
      ),
      Container(
          width: MediaQuery.of(context).size.width,
          child: Column(children: buildRelatedArticles())),
    ];
  }

  List<Widget> buildRelatedArticles() {
    List<Widget> mArticles = [];
    posts.forEach((blog) {
      mArticles.add(Container(
          width: MediaQuery.of(context).size.width,
          height: 100.0,
          margin: EdgeInsets.only(bottom: 20.0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  width: 80.0,
                  height: 80.0,
                  margin: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(blog.images[0]),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(10.0))),
              Container(
                width: MediaQuery.of(context).size.width - 175.0,
                margin: EdgeInsets.only(top: 10.0),
                child: ListTile(
                  title: Text(blog.title,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Color(MyColors.titleTextColor),
                          height: 1.1,
                          fontSize: getProportionateScreenWidth(15))),
                  subtitle: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(blog.created_date,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(
                                    color: Color(MyColors.titleTextColor),
                                    fontSize: getProportionateScreenWidth(13))),
                        TextButton.icon(
                          onPressed: null,
                          icon: Icon(
                            Icons.access_time_rounded,
                            color: Color(MyColors.titleTextColor),
                            size: 18.0,
                          ),
                          label: Text(blog.min_read,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                      color: Color(MyColors.titleTextColor),
                                      fontSize:
                                          getProportionateScreenWidth(10))),
                        )
                      ],
                    ),
                  ),
                  isThreeLine: true,
                ),
              )
            ],
          )));
    });
    return mArticles;
  }
}
