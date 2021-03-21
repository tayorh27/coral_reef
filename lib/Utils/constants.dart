import 'package:coral_reef/Utils/colors.dart';
import 'package:flutter/material.dart';
// import 'package:hexcolor/hexcolor.dart';

class Constant {
  // static ThemeData darkTheme = ThemeData(
  //   backgroundColor: HexColor("#1F2933"),
  //   accentColor: HexColor("3E4659"),
  //   cardColor: HexColor("3E4659"),
  //   primaryColor: Colors.red,
  //   buttonColor: HexColor("1F2933").withOpacity(0.5),
  //   brightness: Brightness.dark,
  //   appBarTheme: AppBarTheme(
  //     elevation: 0,
  //     iconTheme: IconThemeData(color: Colors.white),
  //     brightness: Brightness.dark,
  //     textTheme: TextTheme(
  //       headline6: TextStyle(
  //           fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white),
  //     ),
  //   ),
  //   dividerColor: HexColor("7B8794"),
  //   textTheme: TextTheme(
  //     headline1: TextStyle(fontFamily: "AvenirNext"),
  //     headline2: TextStyle(fontFamily: "AvenirNext"),
  //     headline3: TextStyle(fontFamily: "AvenirNext"),
  //     headline4: TextStyle(fontFamily: "AvenirNext"),
  //     headline5: TextStyle(fontFamily: "AvenirNext"),
  //     headline6: TextStyle(fontFamily: "AvenirNext"),
  //     bodyText1: TextStyle(fontFamily: "AvenirNext", color: Colors.white),
  //     bodyText2: TextStyle(fontFamily: "AvenirNext"),
  //     subtitle1: TextStyle(fontFamily: "AvenirNext"),
  //     subtitle2: TextStyle(fontFamily: "AvenirNext", color: Colors.white60),
  //     caption: TextStyle(fontFamily: "AvenirNext"),
  //     overline: TextStyle(fontFamily: "AvenirNext"),
  //   ),
  //   dialogTheme: DialogTheme(
  //     backgroundColor: HexColor("3E4659"),
  //     contentTextStyle: TextStyle(inherit: true),
  //   ),
  //   dialogBackgroundColor: HexColor("3E4659"),
  //   visualDensity: VisualDensity.adaptivePlatformDensity,
  // );

  static ThemeData lightTheme = ThemeData(
    // This is the theme of your application.
    //
    // Try running your application with "flutter run". You'll see the
    // application has a blue toolbar. Then, without quitting the app, try
    // changing the primarySwatch below to Colors.green and then invoke
    // "hot reload" (press "r" in the console where you ran "flutter run",
    // or simply save your changes to "hot reload" in a Flutter IDE).
    // Notice that the counter didn't reset back to zero; the application
    // is not restarted.
    // primarySwatch: Colors.red[50],
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
