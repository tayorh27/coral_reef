import 'package:coral_reef/Utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:coral_reef/size_config.dart';


class HomeLogo extends StatelessWidget {
  const HomeLogo({
    Key key,
    this.icon,
  }) : super(key: key);

  final String icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          //margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(5)),
          //padding: EdgeInsets.all(getProportionateScreenWidth(0)),
          height: getProportionateScreenHeight(50),
          width: getProportionateScreenWidth(90),
          decoration: BoxDecoration(
            // color: Color(0xFFF5F6F9),
            //shape: BoxShape.circle,
          ),
          child: Image.asset('assets/images/coral_reef_splash_logo.png'),
        ),
      ],
    );
  }
}


class Heading extends StatelessWidget {
  const Heading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Hi Dupe,",
              style: Theme.of(context).textTheme.headline1.copyWith(
                color: Color(MyColors.titleTextColor), fontSize: getProportionateScreenWidth(25)
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Hope you're feeling good today",
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: Color(MyColors.titleTextColor), fontSize: getProportionateScreenWidth(13)
              ),
            ),
          ],
        ),
      ],
    );
  }
}


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

class IconBtn extends StatelessWidget {
  const IconBtn({
    Key key,
    @required this.press,
  }) : super(key: key);
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
      horizontal: getProportionateScreenWidth(10.0),
      vertical: getProportionateScreenWidth(23),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: this.press, //(){_showTestDialog(context);},
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Container(
              height: getProportionateScreenWidth(50),
              width: getProportionateScreenWidth(50),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Center(child: Image.asset("assets/images/forward_icon.png",)),
            ),
          ],
        ),
      ),
    );
  }
}