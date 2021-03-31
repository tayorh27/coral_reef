import 'package:coral_reef/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../size_config.dart';

class AvatarSelection extends StatefulWidget {
  final String image;
  final String avatarName;
  final bool isSelected;
  final Function(String item) returnSelected;
  AvatarSelection({this.image, this.avatarName, this.isSelected, this.returnSelected});

  @override
  State<StatefulWidget> createState() => _AvatarSelection();
}

class _AvatarSelection extends State<AvatarSelection> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
              onTap: (){
                widget.returnSelected(widget.avatarName);
              },
              child: Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      color: Color(MyColors.other3),
                      borderRadius: BorderRadius.circular(50.0),
                      border: (widget.isSelected)
                          ? Border.all(color: Color(MyColors.primaryColor), width: 2.0)
                          : Border()),
                  child: Image.asset(
                    widget.image,
                    height: 50.0,
                    width: 50.0,
                  )))
        ],
      ),
    );
  }
}
