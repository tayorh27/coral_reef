import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/wellness/onboarding/component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vertical_weight_slider/vertical_weight_slider.dart';

import '../../constants.dart';
import '../../size_config.dart';

class HeightScreen extends StatelessWidget {
  static String routeName = "/Height";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('skip',style: TextStyle(color: Colors.purple),),
          ],
        ),
        leading: Icon(Icons.arrow_back,color: Colors.black,),
        backgroundColor: Colors.white,elevation: 0.1,),
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  double weight = 0.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20), 
          vertical: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
          child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.01),
                HeadingText3(),
                SizedBox(height: SizeConfig.screenHeight * 0.05),
                Buttons(),
                Container(
                child: Column(
                  children: [
                      Container(
                        height: 100.0,
                        alignment: Alignment.center,
                        child: GestureDetector(
                        onTap: (){_showTestDialog(context);},
                        child: Text("$weight kg",
                        style: TextStyle(color:Colors.purple,fontSize: 40.0, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      VerticalWeightSlider(
                        maximumWeight: 200,
                        initialWeight: 50,
                        gradationColor: [
                          Colors.purple[500],
                          Colors.purple[300],
                          Colors.purple[100],
                        ],
                        onChanged: (value) {
                          setState(() {
                            weight = value;
                          });
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.05),
                DefaultButton(
                 text: 'Continue',
                 press: (){
                   //Navigator.pushNamed(context, YearScreen.routeName);
                 }
               )  
              ],
            ),
          ),
        ),
      ),
    );
  }
}


void _showTestDialog(context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        //context: _scaffoldKey.currentContext,
        builder: (context) {
          return AlertDialogPage();
        }
     );
}

class AlertDialogPage extends StatefulWidget {
  const AlertDialogPage({
    Key key,
  }) : super(key: key);

  @override
  _AlertDialogPageState createState() => _AlertDialogPageState();
}

class _AlertDialogPageState extends State<AlertDialogPage> {

  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //contentPadding: EdgeInsets.only(left: 20, right: 20),
      title: Text('Add Height',
        textAlign: TextAlign.center,
        style: TextStyle(
        color: Colors.black,
        fontSize: getProportionateScreenWidth(20),
        fontWeight: FontWeight.bold,
        ),
      ),
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Container(
      height: 200,
      width: 300,
      child: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Column(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('70.0',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: getProportionateScreenWidth(30),
                    fontWeight: FontWeight.bold,
                  ),
                 ),
                 Button2(
                   text: 'kg',
                 )
              ],
            ),
             Divider(),
             SizedBox(height: SizeConfig.screenHeight * 0.02),
             Row(
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                Text('DATE: ',
                style: TextStyle(
                color: Colors.black,
                fontSize: getProportionateScreenWidth(13),
                fontWeight: FontWeight.bold,
                ),),
                Spacer(),
                Text(now.toString(),
                style: TextStyle(
                color: kPrimaryColor,
                fontSize: getProportionateScreenWidth(13),
                fontWeight: FontWeight.bold,
                ),
                ),
               ],
             ),
             SizedBox(height: SizeConfig.screenHeight * 0.02),
             Divider(),
             SizedBox(height: SizeConfig.screenHeight * 0.02),
             DefaultButton(
                 text: 'Save',
                 press: (){
                   Navigator.pop(context);
                 }
               ) 
            ],
          ),
        ),
      ),
     ),
   ),
  );
 }
}