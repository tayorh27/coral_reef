import 'dart:convert';

import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/shared_screens/EmptyScreen.dart';
import 'package:coral_reef/tracker_screens/diet_tracker_screen/components/meal_grid_list.dart';
import 'package:coral_reef/tracker_screens/diet_tracker_screen/components/meal_shimmer_effect.dart';
import 'package:coral_reef/tracker_screens/well_being_tracker/components/diet_header.dart';
import 'package:flutter/material.dart';

import '../../../../size_config.dart';
import 'package:http/http.dart' as http;

class MealList extends StatefulWidget {
  static final routeName = "meal-list";

  @override
  State<StatefulWidget> createState() => _MealList();
}

class _MealList extends State<MealList> {

  TextEditingController _textEditingController = new TextEditingController(text: "");
  
  bool isSearching = true;
  
  List<dynamic> meals = [];
  
  @override
  void initState() {
    super.initState();
    getMealsBySearchItem("rice");
  }
  
  Future<void> getMealsBySearchItem(String searchItem) async {
    setState(() {
      isSearching = true;
      meals.clear();
    });
    final uri = Uri.parse("https://api.spoonacular.com/food/products/search?query=$searchItem&number=50&apiKey=fb57e131c4744bd3a60f618f1502c1b2");
    http.Response res = await http.get(uri);
    Map<String, dynamic> resp = jsonDecode(res.body);
    if(resp["products"] == null) {
      setState(() {
        isSearching = false;
      });
      return;
    }
    setState(() {
      meals = resp["products"];
      isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: DietHeader("Add Meal", showAction: true, onPress: (){
          setState(() {
            _textEditingController.clear();
          });
          getMealsBySearchItem("rice");
        }).appBar(context),
        body: SafeArea(
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(30)),
                    child: Container(
                        child: SingleChildScrollView(
                            child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        searchMealBox(),
                        (isSearching) ? MealShimmerEffects(LoadingMeals(), 1.4) : (meals.isEmpty) ? EmptyScreen("No meal found!") : MealGridList(1.4, meals),
                      ],
                    )
                        )
                    )
                )
            )
        )
    );
  }

  Widget searchMealBox() {
    return Container(
      decoration: BoxDecoration(
        color: Color(MyColors.formFillColor),
        border: Border.all(
          color: Color(MyColors.formFillColor),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      height: getProportionateScreenHeight(50),
      child: TextFormField(
        keyboardType: TextInputType.name,
        obscureText: false,
        controller: _textEditingController,
        textInputAction: TextInputAction.search,
        onFieldSubmitted: (searchText) {
          if(searchText.isEmpty) {
            return;
          }
          getMealsBySearchItem(searchText);
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 15,
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Color(MyColors.primaryColor),),
          hintText: "Search meal",
          focusColor: Color(MyColors.primaryColor),
          hoverColor: Color(MyColors.primaryColor),
          suffix: InkWell(
            onTap: (){
              if(_textEditingController.text.isEmpty) {
                return;
              }
              getMealsBySearchItem(_textEditingController.text);
            },
            child: Text(
              "Search",
              style: Theme.of(context).textTheme.headline2.copyWith(
                  color: Color(MyColors.primaryColor),
                  fontSize: getProportionateScreenWidth(14)),
            ),
          )
        ),
      ),
    );
  }
}
