
import 'package:coral_reef/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:truncate/truncate.dart';

class ListCard extends StatelessWidget {
  const ListCard({
    Key key,
    @required this.title,
    @required this.title2,
    @required this.image,
    @required this.onPress,
  }) : super(key: key);

  final String title, image, title2;
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(0.0),
        child: InkWell(
          onTap: onPress,
          child: Container(
              child: ListTile(
                  leading: SvgPicture.asset(
                    image,
                    height: 50.0,
                    width: 50.0,
                  ),
                  title: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontSize: 18.0,
                        color: Color(MyColors.titleTextColor)
                    ),
                  ),
                  subtitle: Text(truncate(title2, 70, omission: "...", position: TruncatePosition.end),
                      overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Color(MyColors.titleTextColor),
                          fontSize: 12)
                  ))
          ),
        )
    );
  }
}