import 'dart:convert';

import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/g_chat_screen/components/image_display_widget.dart';
import 'package:coral_reef/shared_screens/pill_icon.dart';
import 'package:coral_reef/tracker_screens/diet_tracker_screen/components/calories_slider.dart';
import 'package:coral_reef/tracker_screens/diet_tracker_screen/components/meal_shimmer_effect.dart';
import 'package:coral_reef/tracker_screens/diet_tracker_screen/services/diet_service.dart';
import 'package:coral_reef/tracker_screens/well_being_tracker/components/diet_header.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../size_config.dart';
import 'meal_nutrition_slider.dart';

class MealInfo extends StatefulWidget {
  static final routeName = "meal-info";

  @override
  State<StatefulWidget> createState() => _MealInfo();
}

class _MealInfo extends State<MealInfo> {

  Map<String, dynamic> meal = new Map();
  bool detailsFound = false;
  bool _inAsyncCall = true;

  String mealName = "", mealBrand = "", calories = "", carbs = "", fats = "", protein = "";
  List<dynamic> nutrients = [];

  double carbsPercent = 0.0;
  double proteinPercent = 0.0;
  double fatPercent = 0.0;

  DietServices dietServices;
  StorageSystem ss = new StorageSystem();

  String caloriesGoal = "", currentTakenCalories = "";

  @override
  void initState() {
    super.initState();
    dietServices = new DietServices();
    getCaloriesLocalData();
  }

  getCaloriesLocalData() async {
    final date = DateTime.now();
    final months = ["JAN", "FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];

    String formatDate = "${date.year}_${months[date.month - 1]}_${date.day}";

    String goal = await ss.getItem("caloriesGoal") ?? "0";
    String current = await ss.getItem("caloriesCurrent_$formatDate") ?? "0";

    setState(() {
      caloriesGoal = goal;
      currentTakenCalories = current;
    });
  }

  Future<void> getMealInfo() async {
    final uri = Uri.parse("https://api.spoonacular.com/food/products/${meal["id"]}?apiKey=fb57e131c4744bd3a60f618f1502c1b2");
    http.Response res = await http.get(uri);
    setState(() {
      detailsFound = true;
      _inAsyncCall = false;
    });
    Map<String, dynamic> resp = jsonDecode(res.body);
    if(resp["title"] == null) {
      await new GeneralUtils().displayAlertDialog(context, "Attention", "We couldn't get the details of this meal");
      Navigator.of(context).pop();
      return;
    }
    Map<String, dynamic> nut = resp["nutrition"];
    Map<String, dynamic> facts = nut["caloricBreakdown"];
    setState(() {
      mealName= resp["title"];
      mealBrand= resp["brand"];
      calories = "${nut["calories"]}";

      fats = nut["fat"] ?? "0g";
      carbs = nut["carbs"] ?? "0g";
      protein = nut["protein"] ?? "0g";

      nutrients = nut["nutrients"];

      carbsPercent = facts["percentCarbs"] ?? 0.0;
      proteinPercent = facts["percentProtein"] ?? 0.0;
      fatPercent = facts["percentFat"] ?? 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    meal = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    if(!detailsFound) {
      getMealInfo();
    }
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: DietHeader(mealBrand).appBar(context),
        body: ModalProgressHUD(
        inAsyncCall: _inAsyncCall,
        opacity: 0.6,
        progressIndicator: CircularProgressIndicator(),
        color: Color(MyColors.titleTextColor),
        child: SafeArea(
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
                                ImageDisplayWidget(meal["image"]),
                                SizedBox(height: SizeConfig.screenHeight * 0.01),
                                Text(mealName,
                                  style: Theme.of(context).textTheme.headline2.copyWith(
                                    color: Color(MyColors.titleTextColor),
                                    fontSize: getProportionateScreenWidth(16),
                                  ),),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('$calories ',
                                      style: Theme.of(context).textTheme.headline2.copyWith(
                                        color: Color(MyColors.primaryColor),
                                        fontSize: getProportionateScreenWidth(24),
                                      ),),
                                    Text('kcal',
                                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                                        color: Color(MyColors.primaryColor),
                                        fontSize: getProportionateScreenWidth(16),
                                      ),),
                                    Container(
                                      margin: EdgeInsets.only(left: 0.0),
                                      child: PillIcon(
                                        icon: 'assets/diet/kcal.svg',
                                        size: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: SizeConfig.screenHeight * 0.02),
                                Divider(),
                                SizedBox(height: SizeConfig.screenHeight * 0.02),
                                Text('Nutrition Facts',
                                  style: Theme.of(context).textTheme.headline2.copyWith(
                                    color: Color(MyColors.titleTextColor),
                                    fontSize: getProportionateScreenWidth(16),
                                  ),),
                                SizedBox(height: SizeConfig.screenHeight * 0.04),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MealNutritionSlider(carbsPercent, trackColor: Color(MyColors.mealTransparentProgressColor1), progressColor: Color(MyColors.primaryColor), percentValue: "${carbsPercent.toInt()}%", title: 'Carbs',),
                                MealNutritionSlider(proteinPercent, trackColor: Color(MyColors.mealTransparentProgressColor2), progressColor: Color(MyColors.stroke2Color), percentValue: "${proteinPercent.toInt()}%", title: 'Protein'),
                                MealNutritionSlider(fatPercent, trackColor: Color(MyColors.mealTransparentProgressColor3), progressColor: Color(MyColors.stroke1Color), percentValue: "${fatPercent.toInt()}%", title: 'Fats'),
                              ]),
                                SizedBox(height: SizeConfig.screenHeight * 0.08),
                                buildMealDetails(Color(MyColors.mealTransparentProgressColor1), "Carbs", carbs),
                                buildMealDetails(Color(MyColors.mealTransparentProgressColor2), "Proteins", protein),
                                buildMealDetails(Color(MyColors.mealTransparentProgressColor3), "Fats", fats),
                                SizedBox(height: SizeConfig.screenHeight * 0.04),
                                DefaultButton(
                                  text: "Add",
                                  loading: false,
                                  press: () async {
                                    double initCount = double.parse(currentTakenCalories);
                                    double current = double.parse(calories);
                                    String total = (initCount + current).ceil().toString();
                                    await dietServices.updateCaloriesTakenCount(total, caloriesGoal);
                                    new GeneralUtils().showToast(context, "Meal added successfully");
                                    Navigator.of(context).pop({"hello": "world"});
                                  },
                                ),
                                SizedBox(height: SizeConfig.screenHeight * 0.02),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      child: Text("Remove meal", style: Theme.of(context).textTheme.headline2.copyWith(
                                        color: Color(MyColors.primaryColor),
                                        fontSize: getProportionateScreenWidth(15),
                                      ),),
                                      onPressed: () async {
                                        bool awaitResponse = await new GeneralUtils().displayReturnedValueAlertDialog(context, "Attention", "Do you want to continue with this action?", confirmText: "YES");
                                        if(!awaitResponse) return;
                                        double initCount = double.parse(currentTakenCalories);
                                        double current = double.parse(calories);
                                        if(current > initCount) {
                                          new GeneralUtils().displayAlertDialog(context, "Attention", "Your current calories intake is not up to ${current}kcal.");
                                          return;
                                        }
                                        String reduce = (initCount - current).ceil().toString();
                                        await dietServices.updateCaloriesTakenCount(reduce, caloriesGoal);
                                        new GeneralUtils().showToast(context, "Meal removed successfully");
                                        Navigator.of(context).pop({"hello": "world"});
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: SizeConfig.screenHeight * 0.04),

                              ],
                            )
                        )
                    )
                )
            )
        )
    ));
  }

  Map<String, dynamic> getNutrientsByName(String name) {
    Map<String, dynamic> check = nutrients.firstWhere((nut) => nut["name"] == name);
    return check;
  }

  Widget buildMealDetails(Color color, String text1, text2) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: SizeConfig.screenHeight * 0.02,
                    height: SizeConfig.screenHeight * 0.02,
                    decoration: BoxDecoration(
                        color: color,
                      borderRadius: BorderRadius.circular(3.0)
                    ),
                  ),
                  SizedBox(width: SizeConfig.screenWidth * 0.02),
                  Text(text1,
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: Color(MyColors.titleTextColor),
                      fontSize: getProportionateScreenWidth(13),
                    ),),
                ],
              ),
              Text(text2,
                style: Theme.of(context).textTheme.headline2.copyWith(
                  color: Color(MyColors.titleTextColor),
                  fontSize: getProportionateScreenWidth(13),
                ),),
            ],
          ),
          Divider()
        ],
      ),
    );
  }
}
