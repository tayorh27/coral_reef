import 'package:flutter/material.dart';
import '../homescreen/components/body.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(backgroundColor: Colors.white,elevation: 0.1,),
      body: Body(),
    );
  }
}