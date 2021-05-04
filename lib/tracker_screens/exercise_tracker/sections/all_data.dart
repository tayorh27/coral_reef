import 'package:coral_reef/size_config.dart';
import 'package:flutter/material.dart';

class AllData extends StatefulWidget {
  static final routeName = "allData";
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<AllData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios)),
              Text(
                'All data',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontSize: getProportionateScreenWidth(15),
                  fontWeight: FontWeight.bold
                    ),
              ),
              Text('')
            ],
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
              Container(
                  height: 30,
                  color: Colors.grey[200],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Text('STEPS')),
                      Text('')
                    ],
                  )),
            SizedBox(height: 10,),
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('5,234', style: TextStyle(fontSize: 16),),
                      Text('Feb 24th 2021', style: TextStyle(fontSize: 16),)
                    ],
                  )),
                  Divider(
                    indent:20,
                    endIndent: 20,
                    thickness: 2,

                  ),
                  SizedBox(height: 10,),
                  Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('5,234', style: TextStyle(fontSize: 16),),
                          Text('Feb 24th 2021', style: TextStyle(fontSize: 16),)
                        ],
                      )),
                  Divider(
                    indent:20,
                    endIndent: 20,
                    thickness: 2,

                  ),
                  SizedBox(height: 10,),
                  Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('5,234', style: TextStyle(fontSize: 16),),
                          Text('Feb 24th 2021', style: TextStyle(fontSize: 16),)
                        ],
                      )),
                  Divider(
                    indent:20,
                    endIndent: 20,
                    thickness: 2,

                  ),
                  SizedBox(height: 10,),
                  Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('5,234', style: TextStyle(fontSize: 16),),
                          Text('Feb 24th 2021', style: TextStyle(fontSize: 16),)
                        ],
                      )),
                  Divider(
                    indent:20,
                    endIndent: 20,
                    thickness: 2,

                  ),
                  SizedBox(height: 10,),
                  Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('5,234', style: TextStyle(fontSize: 16),),
                          Text('Feb 24th 2021', style: TextStyle(fontSize: 16),)
                        ],
                      )),
                  Divider(
                    indent:20,
                    endIndent: 20,
                    thickness: 2,

                  ),
                  SizedBox(height: 10,),
                  Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('5,234', style: TextStyle(fontSize: 16),),
                          Text('Feb 24th 2021', style: TextStyle(fontSize: 16),)
                        ],
                      )),
                  Divider(
                    indent:20,
                    endIndent: 20,
                    thickness: 2,

                  ),
                  SizedBox(height: 10,),
                  Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('5,234', style: TextStyle(fontSize: 16),),
                          Text('Feb 24th 2021', style: TextStyle(fontSize: 16),)
                        ],
                      )),
                  Divider(
                    indent:20,
                    endIndent: 20,
                    thickness: 2,

                  ),
                  SizedBox(height: 10,),
                  Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('5,234', style: TextStyle(fontSize: 16),),
                          Text('Feb 24th 2021', style: TextStyle(fontSize: 16),)
                        ],
                      )),
                  Divider(
                    indent:20,
                    endIndent: 20,
                    thickness: 2,

                  ),  SizedBox(height: 10,),
                  Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('5,234', style: TextStyle(fontSize: 16),),
                          Text('Feb 24th 2021', style: TextStyle(fontSize: 16),)
                        ],
                      )),
                  Divider(
                    indent:20,
                    endIndent: 20,
                    thickness: 2,

                  ),  SizedBox(height: 10,),
                  Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('5,234', style: TextStyle(fontSize: 16),),
                          Text('Feb 24th 2021', style: TextStyle(fontSize: 16),)
                        ],
                      )),
                  Divider(
                    indent:20,
                    endIndent: 20,
                    thickness: 2,

                  ),  SizedBox(height: 10,),
                  Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('5,234', style: TextStyle(fontSize: 16),),
                          Text('Feb 24th 2021', style: TextStyle(fontSize: 16),)
                        ],
                      )),
                  Divider(
                    indent:20,
                    endIndent: 20,
                    thickness: 2,

                  ),



            ])));
  }
}
