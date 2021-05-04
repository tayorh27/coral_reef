
import 'package:flutter/material.dart';

import '../size_config.dart';

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key key,
    @required this.title,
    @required this.image,
    @required this.title2,
    @required this.press,
  }) : super(key: key);

  final String title, image,title2;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: Duration(seconds: 7),
        curve: Curves.easeInSine,
        // width: (MediaQuery.of(context).size.width / 2) - 30.0,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: GestureDetector(
            onTap: press,
            child: SizedBox(
              width: getProportionateScreenWidth(145),
              // height: getProportionateScreenWidth(250),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Image.asset(
                      image,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(10.0),
                        vertical: getProportionateScreenWidth(25),
                      ),
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(color: Colors.white),
                          children: [
                            TextSpan(
                              text: "$title\n",
                              style: Theme.of(context).textTheme.headline2.copyWith(
                                  color: Colors.white, fontSize: getProportionateScreenWidth(18)
                              ),
                            ),
                            TextSpan(text: "$title2", style: Theme.of(context).textTheme.subtitle1.copyWith(
                                color: Colors.white, fontSize: getProportionateScreenWidth(11)
                            ))
                          ],
                        ),
                      ),
                    ),
                    // Align(
                    //   alignment: Alignment.topLeft,
                    //   child: Container(
                    //     padding: EdgeInsets.all(20.0),
                    //     child: InkWell(
                    //       child: Image.asset("assets/images/forward_icon.png",),
                    //       onTap: press,
                    //     ),
                    //   ),
                    // )
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.end,
                    //   children: [
                    //     Spacer(),
                    //      Row(
                    //        mainAxisAlignment: MainAxisAlignment.end,
                    //        children: [
                    //          IconBtn(
                    //               press: press
                    //             ),
                    //        ],
                    //      ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}