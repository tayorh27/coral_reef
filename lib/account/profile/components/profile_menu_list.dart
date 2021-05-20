
import 'package:coral_reef/Utils/colors.dart';
import 'package:flutter/material.dart';

class AccountProfileMenu extends StatefulWidget {

  const AccountProfileMenu({
    Key key,
    @required this.text,
    @required this.icon,
    this.showTrailing = true,
    this.showLeading = true,
    this.press,
  }) : super(key: key);

  final String text;
  final Icon icon;
  final VoidCallback press;
  final bool showTrailing;
  final bool showLeading;

  @override
  State<StatefulWidget> createState() => _AccountProfileMenu();
}

class _AccountProfileMenu extends State<AccountProfileMenu> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: (widget.showLeading) ? widget.icon : null,
          title: Text(widget.text,
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Color(MyColors.titleTextColor),
                fontSize: 15
              )),
          trailing: (widget.showTrailing) ? Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18.0,) : SizedBox(),
          onTap: widget.press,
        ),
        Divider(),
      ],
    );
  }
}