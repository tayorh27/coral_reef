import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/onboarding/sign_in/components/sign_form.dart';
import 'package:flutter/material.dart';
import 'package:coral_reef/homescreen/Home.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          YourNameText(),
          SizedBox(height: getProportionateScreenHeight(5)),
          YourNameField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          EmailAddText(),
          SizedBox(height: getProportionateScreenHeight(5)),
          EmailField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          PasswordText(),
          SizedBox(height: getProportionateScreenHeight(5)),
          PasswordField(),
          SizedBox(height: getProportionateScreenHeight(2)),
          CheckBox(),
          CheckBox2(),
          SizedBox(height: getProportionateScreenHeight(10)),
          DefaultButton(
            text: "Sign up",
            press: () {
              Navigator.pushNamed(context, HomeScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}

class YourNameText extends StatelessWidget {
  const YourNameText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Your Name",
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

class EmailAddText extends StatelessWidget {
  const EmailAddText({
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

class CheckBox extends StatefulWidget {
  @override
  _CheckBoxState createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {

  bool remember = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: remember,
          activeColor: kPrimaryColor,
          onChanged: (value) {
            setState(() {
              remember = value;
            });
          },
        ),
        Text(
          "I'm over the ",
          style: Theme.of(context)
              .textTheme
              .subtitle1
              .copyWith(color: Color(MyColors.titleTextColor)),
        ),
        Text(
          "age of 13",
          style: Theme.of(context).textTheme.subtitle1.copyWith(
              color: Color(MyColors.primaryColor), fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}

class CheckBox2 extends StatefulWidget {
  @override
  _CheckBox2State createState() => _CheckBox2State();
}

class _CheckBox2State extends State<CheckBox2> {
  bool remember = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: remember,
          activeColor: kPrimaryColor,
          onChanged: (value) {
            setState(() {
              remember = value;
            });
          },
        ),
        Text(
          "I agree with the ",
          style: Theme.of(context)
              .textTheme
              .subtitle1
              .copyWith(color: Color(MyColors.titleTextColor)),
        ),
        InkWell(
          child: Text(
            "Terms and Conditions",
            style: Theme.of(context).textTheme.subtitle1.copyWith(
                color: Color(MyColors.primaryColor), fontWeight: FontWeight.bold),
          ),
          onTap: null,
        )
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
        Text("Password",
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(color: Color(MyColors.titleTextColor))),
        Spacer(),
      ],
    );
  }
}

class EmailField extends StatelessWidget {
  EmailField({
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
        keyboardType: TextInputType.emailAddress,
        obscureText: false,
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

class YourNameField extends StatelessWidget {
  YourNameField({
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
        keyboardType: TextInputType.name,
        obscureText: false,
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
