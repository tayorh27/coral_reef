import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/progress.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/socal_card.dart';
import 'package:coral_reef/onboarding/sign_in/components/sign_form.dart';
import 'package:coral_reef/services/auth_service.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:coral_reef/homescreen/Home.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {

  String name = "", email = "", password = "";

  bool nameError = false, emailError = false, passwordError = false, ageCheck = false, termsCheck = false;

  final formKey = new GlobalKey<FormState>();

  StorageSystem ss = new StorageSystem();

  String msgId = '', userUid = '', _deviceInfo = '';//add info to firebase

  AuthService authService;

  ProgressDisplay pd;

  bool _loading = false;

  bool appleAvailable = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pd = new ProgressDisplay(context);
    SignInWithApple.isAvailable().then((value) => appleAvailable = value);
    authService = new AuthService(onComplete: (user, res, req, ext) {
      if(res == "success") {
        setState(() {
          _loading = true;
        });
        firebaseRegistrationContinues(user, req, ext);
        // if(req == "firebase") {
        //
        //   return;
        // }
        // if(req == "google") {
        //   firebaseRegistrationContinues(user, "google", ext);
        //   return;
        // }
        // if(req == "facebook") {
        //   firebaseRegistrationContinues(user, "google", ext);
        //   return;
        // }
        // if(req == "google") {
        //   firebaseRegistrationContinues(user, "google", ext);
        //   return;
        // }
      }else {
        setState(() {
          _loading = false;
        });
      }
    });
    FirebaseMessaging.instance.requestPermission(
        sound: true, badge: true, alert: true
    ).then((value) async {
      await getTokenAndDeviceInfo();
    });
  }

  getTokenAndDeviceInfo() async {
    FirebaseMessaging.instance.getToken().then((token) {
      print(token);
      msgId = token;
    });

   try {
     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
     if(Platform.isAndroid) {
       if (deviceInfo.androidInfo != null) {
         AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
         _deviceInfo = androidInfo.androidId;
         print('devAnd = $_deviceInfo');
       }
     }else if(Platform.isIOS) {
       if (deviceInfo.iosInfo != null) {
         IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
         _deviceInfo = iosInfo.identifierForVendor;
         print('deviOS = $_deviceInfo');
       }
     }
   }catch(e){
     print(e.toString());
   }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          YourNameText(),
          SizedBox(height: getProportionateScreenHeight(5)),
          YourNameField(
            onTextChanged: (value, err) {
              setState(() {
                name = value;
                nameError = err;
              });
            },
          ),
          (nameError) ? Row(
            children: [
              Text(
                "Please enter your name",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: Colors.redAccent),
              ),
            ],
          ) : SizedBox(),
          SizedBox(height: getProportionateScreenHeight(30)),
          EmailAddText(),
          SizedBox(height: getProportionateScreenHeight(5)),
          EmailField(
            onTextChanged: (value, err) {
              setState(() {
                email = value;
                emailError = err;
              });
            },
          ),
          (emailError) ? Row(
            children: [
              Text(
                "Please enter your email address",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: Colors.redAccent),
              ),
            ],
          ) : SizedBox(),
          SizedBox(height: getProportionateScreenHeight(30)),
          PasswordText(),
          SizedBox(height: getProportionateScreenHeight(5)),
          PasswordField(
            onTextChanged: (value, err) {
              setState(() {
                password = value;
                passwordError = err;
              });
            },
          ),
          (passwordError) ? Row(
            children: [
              Text(
                "Please enter your password",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: Colors.redAccent),
              ),
            ],
          ) : SizedBox(),
          SizedBox(height: getProportionateScreenHeight(2)),
          CheckBox(
            onChecked: (val) => ageCheck = val,
          ),
          CheckBox2(
            onChecked: (val) => termsCheck = val,
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          DefaultButton(
            text: "Sign up",
            loading: _loading,
            press: () {
              if(!validateAndSave()){
                return;
              }
              if(!ageCheck || !termsCheck){
                new GeneralUtils().displayAlertDialog(context, "Attention", "Please check the two boxes.");
                return;
              }
              setState(() {
                _loading = true;
              });
              // pd.displayDialog("Registering user");
              // Navigator.pushNamed(context, HomeScreen.routeName);
              authService.firebaseRegisterRequest(context, email.toLowerCase(), password);
            },
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.03),
          Center(
              child: Line()),
          SizedBox(
            height: 10,
          ),
          socialButtons(),
        ],
      ),
    );
  }

  Widget socialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialCard(
          icon: "assets/icons/google.png",
          press: () async {
            if(!ageCheck || !termsCheck){
              new GeneralUtils().displayAlertDialog(context, "Attention", "Please check the two boxes.");
              return;
            }
            await authService.googleRequest(context);
          },
        ),
        SocialCard(
          icon: "assets/icons/facebook.png",
          press: () async {
            if(!ageCheck || !termsCheck){
              new GeneralUtils().displayAlertDialog(context, "Attention", "Please check the two boxes.");
              return;
            }
            await authService.facebookRequest(context);
          },
        ),
        (Platform.isIOS)
            ? SocialCard(
          icon: "assets/icons/apple.png",
          press: () async {
            if(!ageCheck || !termsCheck){
              new GeneralUtils().displayAlertDialog(context, "Attention", "Please check the two boxes.");
              return;
            }
            await authService.appleRequest(context, appleAvailable);
          },
        )
            : Text(''),
      ],
    );
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    form.save();
    return form.validate();
  }

  firebaseRegistrationContinues(User firebaseUser, String authType, dynamic extraData) async {
    Map<String, dynamic> newUserData = new Map();

    newUserData['auth_type'] = authType;

    String _email, _firstname, _lastname, _picture;

    if(authType == "facebook" || authType == "google"){
      if(authType == "facebook") {
        newUserData['fb_userId'] = extraData.userId;
      }
      newUserData['email'] = firebaseUser.email.toLowerCase();
      newUserData['firstname'] = firebaseUser.displayName.split(' ')[0];
      newUserData['lastname'] = firebaseUser.displayName.split(' ')[1];
      newUserData['picture'] = (firebaseUser.photoURL == null) ? "" : firebaseUser.photoURL;

      _email = firebaseUser.email.toLowerCase();
      _firstname = firebaseUser.displayName.split(' ')[0];
      _lastname = firebaseUser.displayName.split(' ')[1];
      _picture = (firebaseUser.photoURL == null) ? "" : firebaseUser.photoURL;
    }
    if(authType == "apple") {
      newUserData['email'] = extraData.email;
      newUserData['firstname'] = extraData.firstname;
      newUserData['lastname'] = extraData.lastname;
      newUserData['picture'] = (firebaseUser.photoURL == null) ? "" : firebaseUser.photoURL;

      _email = firebaseUser.email.toLowerCase();
      _firstname = firebaseUser.displayName.split(' ')[0];
      _lastname = firebaseUser.displayName.split(' ')[1];
      _picture = (firebaseUser.photoURL == null) ? "" : firebaseUser.photoURL;
    }
    if(authType == "firebase") {
      newUserData['email'] = email.toLowerCase();
      newUserData['firstname'] = name.split(' ')[0];
      newUserData['lastname'] = (name.split(' ').length > 1) ? name.split(' ')[1] : '';
      newUserData['picture'] = (firebaseUser.photoURL == null) ? "" : firebaseUser.photoURL;

      _email = email.toLowerCase();
      _firstname = name.split(' ')[0];
      _lastname = (name.split(' ').length > 1) ? name.split(' ')[1] : '';
      _picture = (firebaseUser.photoURL == null) ? "" : firebaseUser.photoURL;
    }

    newUserData['id'] = firebaseUser.uid;
    newUserData['blocked'] = false;
    newUserData['created_date'] = new DateTime.now().toString();

    newUserData['msgId'] = [msgId];
    newUserData['devices'] = [_deviceInfo];
    newUserData['timestamp'] = FieldValue.serverTimestamp();
    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .set(newUserData)
        .then((v) async {
      Map<String, dynamic> userData = new Map();
      userData['uid'] = firebaseUser.uid;
      userData['email'] = _email;
      userData['firstname'] = _firstname;
      userData['lastname'] = _lastname;
      userData['msgId'] = [msgId];
      userData['picture'] = _picture;

      Map<String, dynamic> setupData = new Map();
      setupData["init"] = "true";
      setupData["sleepNotificationAllowed"] = "true";
      setupData["vitaminsNotificationAllowed"] = "true";
      setupData["waterNotificationAllowed"] = "true";
      setupData["caloriesNotificationAllowed"] = "true";
      setupData["stepsNotificationAllowed"] = "true";
      setupData["pregnancyNotificationAllowed"] = "false";
      setupData["periodNotificationAllowed"] = "false";
      await FirebaseFirestore.instance.collection("users").doc(firebaseUser.uid).collection("setups").doc("user-data").set(setupData);


      await ss.setPrefItem('loggedin', 'true', isStoreOnline: false);
      await ss.setPrefItem('user', jsonEncode(userData), isStoreOnline: false);

      // pd.dismissDialog();
      setState(() {
        _loading = false;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => new HomeScreen()));
    }).catchError((err) {
      // pd.dismissDialog();
      setState(() {
        _loading = false;
      });
      new GeneralUtils().displayAlertDialog(context, "Error", "$err");
    });
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
  final Function(bool checked) onChecked;

  CheckBox({this.onChecked});

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
            widget.onChecked(value);
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
  final Function(bool checked) onChecked;

  CheckBox2({this.onChecked});
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
            widget.onChecked(value);
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

class YourNameField extends StatefulWidget {
  YourNameField({
    Key key,
    this.onTextChanged
  }) : super(key: key);
  final Function(String value, bool error) onTextChanged;

  @override
  State<StatefulWidget> createState() => _YourNameField();
}

class _YourNameField extends State<YourNameField> {

  bool error = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(MyColors.formFillColor),
        border: Border.all(
          color: (error) ? Colors.redAccent : Color(MyColors.primaryColor),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: TextFormField(
        keyboardType: TextInputType.name,
        obscureText: false,
        onSaved: (value) {
          widget.onTextChanged(value, error);
        },
        validator: (value) {
          setState(() {
            error = value.isEmpty;
          });
          widget.onTextChanged(value, error);
          return value.isEmpty ? '' : null;
        },
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

class EmailField extends StatefulWidget {
  EmailField({
    Key key,
    this.onTextChanged
  }) : super(key: key);

  final Function(String value, bool error) onTextChanged;

  @override
  State<StatefulWidget> createState() => _EmailField();
}

class _EmailField extends State<EmailField> {

  bool error = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(MyColors.formFillColor),
        border: Border.all(
          color: (error) ? Colors.redAccent : Color(MyColors.primaryColor),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: TextFormField(
        obscureText: false,
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) {
          widget.onTextChanged(value, error);
        },
        validator: (value) {
          setState(() {
            error = value.isEmpty;
          });
          widget.onTextChanged(value, error);
          return value.isEmpty ? '' : null;
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 15,
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  PasswordField({
    Key key,
    this.onTextChanged
  }) : super(key: key);
  final Function(String value, bool error) onTextChanged;

  @override
  State<StatefulWidget> createState() => _PasswordField();
}

class _PasswordField extends State<PasswordField> {
  bool isObscureText = true;
  bool error = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(MyColors.formFillColor),
        border: Border.all(
          color: (error) ? Colors.redAccent : Color(MyColors.primaryColor),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: TextFormField(
        obscureText: isObscureText,
        onSaved: (value) {
          widget.onTextChanged(value, error);
        },
        validator: (value) {
          setState(() {
            error = value.isEmpty;
          });
          widget.onTextChanged(value, error);
          return value.isEmpty ? '' : null;
        },
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

class Line extends StatelessWidget {
  const Line({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: Divider(
              thickness: 0.5,
              color: Color(MyColors.primaryColor).withAlpha(40),
            )),
        SizedBox(
          width: 5,
        ),
        Text('or sign up with', style: Theme.of(context)
            .textTheme
            .subtitle1.copyWith(color: Color(MyColors.titleTextColor)),),
        SizedBox(
          width: 5,
        ),
        Expanded(
            child: Divider(
              thickness: 0.5,
              color: Color(MyColors.primaryColor).withAlpha(40),
            )),
      ],
    );
  }
}
