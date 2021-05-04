import 'package:coral_reef/Utils/colors.dart';
import 'package:flutter/material.dart';

class PregListCard extends StatelessWidget {
  const PregListCard({
    Key key,
    @required this.title,
    @required this.title2,
  }) : super(key: key);

  final String title, title2;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontSize: 17.0,
                  color: Color(MyColors.titleTextColor)
              ),
            ),
            Row(
              children: [
                Text(
                    title2,
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                        fontSize: 12.0,
                        color: Colors.grey
                    )
                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios)
              ],
            ),
          ],
        ),
      ),
    );
  }
}