import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/components/default_button.dart';
import 'package:coral_reef/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../size_config.dart';

class EmailField extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmailField();
}

class _EmailField extends State<EmailField> {
  bool _loading = false;
  TextEditingController _controller = new TextEditingController(text: "");

  AuthService authService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authService = new AuthService(onComplete: (user, res, req, ext) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(MyColors.formFillColor),
            border: Border.all(
              color: Color(MyColors.primaryColor),
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          width: double.infinity,
          height: getProportionateScreenHeight(56),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            controller: _controller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 15,
              ),
              border: InputBorder.none,
              suffixIcon: Icon(
                Icons.mail,
                color: kPrimaryColor,
              ),
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              hintText: 'Enter your email',
            ),
          ),
        ),
        SizedBox(height: SizeConfig.screenHeight * 0.08),
        DefaultButton(
          text: "Send new password",
          loading: _loading,
          press: () {
            if(_controller.text.isEmpty) {
              return;
            }
            setState(() {
              _loading = true;
            });
            authService.forgotPasswordRequest(context, _controller.text.toLowerCase());
            // Navigator.pushNamed(context, SignInScreen.routeName);
          },
        ),
      ],
    );
  }
}
