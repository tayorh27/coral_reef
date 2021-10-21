
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MealShimmerEffects extends StatelessWidget {

  final Widget child;
  final double aspectRatio;

  MealShimmerEffects(this.child, this.aspectRatio);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GridView.count(
      crossAxisCount: 2,
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

class MealsGrid extends StatelessWidget {
  final String imageURL;
  MealsGrid(this.imageURL);
  final color = Colors.black38;
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      margin: EdgeInsets.only(top:20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Container(
                  height: 100.0,
                  width: mediaQueryData.size.width / 2.45,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(imageURL),fit: BoxFit.contain),
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

class LoadingMeals extends StatelessWidget {

  final color = Colors.black38;
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      margin: EdgeInsets.only(top:20.0),
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
                        width: mediaQueryData.size.width / 2.45,
                        color: Colors.black12,
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