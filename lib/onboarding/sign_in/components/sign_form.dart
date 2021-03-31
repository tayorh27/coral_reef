import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/onboarding/forgotpassword/forgotpassword.dart';
import 'package:flutter/material.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:coral_reef/homescreen/Home.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          EmailText(),
          SizedBox(height: getProportionateScreenHeight(5)),
          EmailField(),
          SizedBox(height: getProportionateScreenHeight(35)),
          PasswordText(),
          SizedBox(height: getProportionateScreenHeight(5)),
          PasswordField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          DefaultButton(
            text: "Sign in",
            press: () {
              Navigator.pushNamed(context, HomeScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}

class EmailText extends StatelessWidget {
  const EmailText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Email Address",
          style: Theme.of(context)
              .textTheme
              .subtitle1
              .copyWith(color: Color(MyColors.titleTextColor)),
        ),
        Spacer(),
      ],
    );
  }
}

class PasswordText extends StatelessWidget {
  const PasswordText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Password",
          style: Theme.of(context)
              .textTheme
              .subtitle1
              .copyWith(color: Color(MyColors.titleTextColor)),
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, ForgotPasswordScreen.routeName);
          },
          child: Text(
            "Forgot Password?",
            style: Theme.of(context).textTheme.subtitle1.copyWith(
                color: Color(MyColors.primaryColor)
            )
          ),
        ),
      ],
    );
  }
}

class EmailField extends StatelessWidget {
  const EmailField({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        obscureText: false,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 15,
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          //hintText: '',
        ),
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  PasswordField({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  State<StatefulWidget> createState() => _PasswordField();
}

class _PasswordField extends State<PasswordField> {
  bool isObscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        obscureText: isObscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 15,
          ),
          border: InputBorder.none,
          suffixIcon: IconButton(
            color: Color(MyColors.primaryColor),
            onPressed: () {
              setState(() {
                isObscureText = !isObscureText;
              });
            },
            icon: Icon(
              (isObscureText) ? Icons.visibility_off : Icons.visibility,
            ),
          ),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          //hintText: 'Password',
        ),
      ),
    );
  }
}
