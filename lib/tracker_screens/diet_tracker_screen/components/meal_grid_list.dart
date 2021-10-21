
import 'package:coral_reef/tracker_screens/diet_tracker_screen/sections/meal/meal_info.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MealGridList extends StatelessWidget {

  final double aspectRatio;
  final List<dynamic> meals;

  MealGridList(this.aspectRatio, this.meals);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: aspectRatio,//2.0(for blog post),//1.7(for gchat),//2.3 (for opportunity),
      primary: false,
      children: meals.map(
            (m) => MealsGrid(m),
      ).toList(),
    );
  }
}

class MealsGrid extends StatelessWidget {
  final dynamic meal;
  MealsGrid(this.meal);
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
              InkWell(
                onTap: () async {
                  final checking = await Navigator.pushNamed(context, MealInfo.routeName, arguments: meal);
                  if(checking != null) {
                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Container(
                    height: 100.0,
                    width: mediaQueryData.size.width / 2.45,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(meal["image"]),fit: BoxFit.contain),
                    ),
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