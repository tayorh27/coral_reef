import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../size_config.dart';

class SymptomsGridOptions extends StatefulWidget {
  final Color backgroundColor;
  final String title;
  final String image;
  final Function(List<String> selected) returnSelected;
  SymptomsGridOptions(
      {this.backgroundColor, this.image, this.title, this.returnSelected});

  @override
  State<StatefulWidget> createState() => _SymptomsGridOptions();
}

class _SymptomsGridOptions extends State<SymptomsGridOptions> {
  List<String> selectedOptions = ["hello"];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
              onTap: widget.returnSelected(selectedOptions),
              child: Container(
                  width: 50.0,
                  height: 50.0,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: widget.backgroundColor,
                      borderRadius: BorderRadius.circular(25.0)),
                  child: SvgPicture.asset(
                    widget.image,
                  ) //Icon(Icons.face, color: Colors.white,),
                  )),
          SizedBox(
            height: 5.0,
          ),
          Text(widget.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: Colors.grey,
                  fontSize: getProportionateScreenWidth(11)))
        ],
      ),
    );
  }
}
