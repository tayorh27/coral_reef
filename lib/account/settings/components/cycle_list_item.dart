
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class CycleListItem extends StatefulWidget {

  const CycleListItem({
    Key key,
    @required this.text,
    @required this.subText,
    @required this.icon,
    @required this.type,
    @required this.trailingText,
    this.press,
  }) : super(key: key);

  final String text;
  final String subText;
  final String type;
  final String trailingText;
  final Icon icon;
  final VoidCallback press;

  @override
  State<StatefulWidget> createState() => _CycleListItem();
}

class _CycleListItem extends State<CycleListItem> {

  StorageSystem ss = new StorageSystem();

  bool isPregnancyPredict = false;

  getPregnancyState() {
    ss.getItem("pregnancy_predict").then((value) {
      print(value);
      if(value == null) return;
      setState(() {
        isPregnancyPredict = value == "true";
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPregnancyState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.press,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,

      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.text,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Color(MyColors.titleTextColor),
                      fontSize: 18
                  )),
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
                width: 80.0,
                height: 50.0,
                valueFontSize: 20.0,
                toggleSize: 40.0,
                value: isPregnancyPredict,
                borderRadius: 30.0,
                padding: 8.0,
                showOnOff: false,
                activeColor: Color(MyColors.primaryColor),
                onToggle: (val) async {
                  await ss.setPrefItem("pregnancy_predict", "$val");
                  setState(() {
                    isPregnancyPredict = val;
                  });
                },
              )
            ],
          ),
          SizedBox(height: 20.0,),
          (widget.subText.isEmpty) ? SizedBox() : Text(widget.subText,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: Colors.grey,
                  fontSize: 13
              )),
          Divider(),
        ],
      ),
    );
  }
}