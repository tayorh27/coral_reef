
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerEffects extends StatelessWidget {

  final Widget child;
  final double aspectRatio;

  ShimmerEffects(this.child, this.aspectRatio);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GridView.count(
      crossAxisCount: 1,
      shrinkWrap: true,
      childAspectRatio: aspectRatio,//2.0(for blog post),//1.7(for gchat),//2.3 (for opportunity),
      primary: false,
      children: List.generate(
        10,
            (index) => child,
      ),
    );
  }
}

class LoadingJobOpportunities extends StatelessWidget {

  final color = Colors.black38;
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Shimmer.fromColors(
                  baseColor: color,
                  highlightColor: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 40.0,
                        width: mediaQueryData.size.width - 60.0,
                        color: Colors.black12,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 0.0, top: 10.0),
                        child: Container(
                          height: 15.0,
                          width: mediaQueryData.size.width / 2.6,
                          color: Colors.black12,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 0.0, top: 8.0),
                        child: Container(
                          height: 10.0,
                          width: mediaQueryData.size.width / 4.1,
                          color: Colors.black12,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 0.0, top: 10.0),
                        child: Container(
                          height: 8.0,
                          width: mediaQueryData.size.width / 6.0,
                          color: Colors.black12,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0, top: 10.0, bottom: 10.0),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              size: 13.0,
                              color: Colors.black38,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Container(
                                height: 6.0,
                                width: mediaQueryData.size.width / 5.5,
                                color: Colors.black12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class LoadingGChat extends StatelessWidget {

  final color = Colors.black38;
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      margin: EdgeInsets.all(13.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Shimmer.fromColors(
                  baseColor: color,
                  highlightColor: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: BoxDecoration(
                                color: Colors.black12,
                              borderRadius: BorderRadius.circular(20.0)
                            ),
                          ),
                          SizedBox(width: 10.0,),
                          Container(
                            height: 40.0,
                            width: mediaQueryData.size.width - 160.0,
                            color: Colors.black12,
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 0.0, top: 10.0),
                        child: Container(
                          height: 60.0,
                          width: mediaQueryData.size.width - 60.0,
                          color: Colors.black12,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 0.0, top: 8.0),
                        child: Container(
                          height: 10.0,
                          width: mediaQueryData.size.width / 4.1,
                          color: Colors.black12,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 0.0, top: 10.0),
                        child: Container(
                          height: 8.0,
                          width: mediaQueryData.size.width / 6.0,
                          color: Colors.black12,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0, top: 10.0, bottom: 10.0),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.favorite_border_rounded,
                              size: 13.0,
                              color: Colors.black38,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Container(
                                height: 6.0,
                                width: 20.0,
                                color: Colors.black12,
                              ),
                            ),
                            SizedBox(width: 10.0,),
                            Icon(
                              Icons.mode_comment_outlined,
                              size: 13.0,
                              color: Colors.black38,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Container(
                                height: 6.0,
                                width: 20.0,
                                color: Colors.black12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class LoadingBlogPost extends StatelessWidget {

  final color = Colors.black38;
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Shimmer.fromColors(
                  baseColor: color,
                  highlightColor: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 100.0,
                        width: mediaQueryData.size.width - 60.0,
                        color: Colors.black12,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 0.0, top: 10.0),
                        child: Container(
                          height: 15.0,
                          width: mediaQueryData.size.width / 2.6,
                          color: Colors.black12,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 0.0, top: 8.0),
                        child: Container(
                          height: 10.0,
                          width: mediaQueryData.size.width / 4.1,
                          color: Colors.black12,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 0.0, top: 10.0),
                        child: Container(
                          height: 8.0,
                          width: mediaQueryData.size.width / 6.0,
                          color: Colors.black12,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}