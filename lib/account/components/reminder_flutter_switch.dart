
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class RemindersListItem extends StatefulWidget {

  const RemindersListItem({
    Key key,
    @required this.text,
    @required this.subText,
    @required this.icon,
    @required this.type,
    @required this.trailingText,
    @required this.switchValue,
    this.press,
  }) : super(key: key);

  final String text;
  final String subText;
  final String type;
  final String trailingText;
  final Icon icon;
  final Function(bool toggle) press;
  final bool switchValue;

  @override
  State<StatefulWidget> createState() => _RemindersListItem();
}

class _RemindersListItem extends State<RemindersListItem> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 120.0,
                child: Text(widget.text, softWrap: true,overflow: TextOverflow.clip,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Color(MyColors.titleTextColor),
                        fontSize: 18
                    )),
              ),
              (widget.type == "arrow") ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(widget.trailingText,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Color(MyColors.primaryColor),
                          fontSize: 18
                      )),
                  SizedBox(width: 20.0,),
                  Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 24.0,)
                ],
              ) : FlutterSwitch(
                width: 70.0,
                height: 40.0,
                valueFontSize: 20.0,
                toggleSize: 25.0,
                value: widget.switchValue,
                borderRadius: 30.0,
                padding: 8.0,
                showOnOff: false,
                activeColor: Color(MyColors.primaryColor),
                onToggle: (val) async {
                  widget.press(val);
                },
              )
            ],
          ),
          SizedBox(height: 20.0,),
          (widget.subText.isEmpty) ? SizedBox() : Row(
            children: [
          Container(
          width: MediaQuery.of(context).size.width - 80.0,
          child: Text(widget.subText,
                  textAlign: TextAlign.start, softWrap: true,overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: Colors.grey,
                      fontSize: 13
                  ))),
            ],
          ),
          Divider(thickness: 1.5,),
        ],
    );
  }
}