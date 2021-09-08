import 'package:coral_reef/Utils/colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final visualDensity = VisualDensity.adaptivePlatformDensity;
  // static final dark = ThemeData(
  //   primaryColor: Colors.black,
  //   scaffoldBackgroundColor: Colors.black,
  //   colorScheme: ColorScheme.dark(),
  //   visualDensity: visualDensity,
  //   cardColor: Colors.grey[900],
  // );

  static ThemeData dark = ThemeData(
    backgroundColor: Color(MyColors.background),
    accentColor: Color(MyColors.accentColor),
    cardColor: Color(MyColors.primaryColor),
    buttonColor: Color(MyColors.primaryColor),
    primaryColor: Color(MyColors.primaryColor),
    brightness: Brightness.dark,
    dividerColor: Color(MyColors.dividerColor),
    disabledColor: Color(MyColors.inActiveState),
    errorColor: Colors.red,

    textTheme: TextTheme(
      headline1: TextStyle(fontFamily: "AvenirNextBold", color: Colors.white),
      headline2: TextStyle(fontFamily: "AvenirNextDemiBold"),
      headline3: TextStyle(fontFamily: "AvenirNextDemiBold"),
      headline4: TextStyle(fontFamily: "AvenirNextDemiBold"),
      headline5: TextStyle(fontFamily: "AvenirNextDemiBold"),
      headline6: TextStyle(fontFamily: "AvenirNextDemiBold"),
      bodyText1: TextStyle(fontFamily: "AvenirNextMedium"),
      bodyText2: TextStyle(fontFamily: "AvenirNextMedium"),
      subtitle1: TextStyle(fontFamily: "AvenirNextRegular"),
      subtitle2: TextStyle(fontFamily: "AvenirNextRegular"),
      caption: TextStyle(fontFamily: "AvenirNextDemiBold"),
      overline: TextStyle(fontFamily: "AvenirNextRegular"),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      brightness: Brightness.dark,
      textTheme: TextTheme(
        headline6: TextStyle(
            fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white),
      ),
    ),
    dialogTheme: DialogTheme(
      // backgroundColor: HexColor("3E4659"),
      contentTextStyle: TextStyle(inherit: true),
    ),
    dialogBackgroundColor: Colors.black,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static ThemeData light = ThemeData(
    backgroundColor: Color(MyColors.background),
    accentColor: Color(MyColors.accentColor),
    cardColor: Color(MyColors.primaryColor),
    buttonColor: Color(MyColors.primaryColor),
    primaryColor: Color(MyColors.primaryColor),
    brightness: Brightness.light,
    dividerColor: Color(MyColors.dividerColor),
    disabledColor: Color(MyColors.inActiveState),
    errorColor: Colors.red,

    textTheme: TextTheme(
      headline1: TextStyle(fontFamily: "AvenirNextBold", color: Color(MyColors.titleTextColor)),
      headline2: TextStyle(fontFamily: "AvenirNextDemiBold"),
      headline3: TextStyle(fontFamily: "AvenirNextDemiBold"),
      headline4: TextStyle(fontFamily: "AvenirNextDemiBold"),
      headline5: TextStyle(fontFamily: "AvenirNextDemiBold"),
      headline6: TextStyle(fontFamily: "AvenirNextDemiBold"),
      bodyText1: TextStyle(fontFamily: "AvenirNextMedium"),
      bodyText2: TextStyle(fontFamily: "AvenirNextMedium"),
      subtitle1: TextStyle(fontFamily: "AvenirNextRegular"),
      subtitle2: TextStyle(fontFamily: "AvenirNextRegular"),
      caption: TextStyle(fontFamily: "AvenirNextDemiBold"),
      overline: TextStyle(fontFamily: "AvenirNextRegular"),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      brightness: Brightness.light,
      textTheme: TextTheme(
        headline6: TextStyle(
            fontWeight: FontWeight.w600, fontSize: 20, color: Colors.black),
      ),
    ),
    dialogTheme: DialogTheme(
      // backgroundColor: HexColor("3E4659"),
      contentTextStyle: TextStyle(inherit: true),
    ),
    dialogBackgroundColor: Colors.white,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}