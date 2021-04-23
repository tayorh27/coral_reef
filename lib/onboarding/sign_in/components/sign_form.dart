import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/progress.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/socal_card.dart';
import 'package:coral_reef/onboarding/forgotpassword/forgotpassword.dart';
import 'package:coral_reef/services/auth_service.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:coral_reef/homescreen/Home.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {

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
        firebaseLoginContinues(user, req, ext);
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
          print('devAnd = $androidInfo');
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

  String email = "", password = "";
  bool emailError = false, passwordError = false;

  final formKey = new GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          EmailText(),
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
          SizedBox(height: getProportionateScreenHeight(35)),
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
          SizedBox(height: getProportionateScreenHeight(30)),
          DefaultButton(
            text: "Sign in",
            loading: _loading,
            press: () {
              if(!validateAndSave()) {
                return;
              }
              // pd.displayDialog("Logging user in");
              setState(() {
                _loading = true;
              });
              authService.firebaseLoginRequest(context, email, password);
              // Navigator.pushNamed(context, HomeScreen.routeName);
            },
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.04),
          Line(),
          SizedBox(
            height: 5,
          ),
          Center(child: Text('Sign in with',style: Theme.of(context)
              .textTheme
              .subtitle1.copyWith(color: Color(MyColors.titleTextColor)))),
          SizedBox(
            height: 20,
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
            await authService.googleRequest(context);
          },
        ),
        SocialCard(
          icon: "assets/icons/facebook.png",
          press: () async {
            await authService.facebookRequest(context);
          },
        ),
        (Platform.isIOS)
            ? SocialCard(
          icon: "assets/icons/apple.png",
          press: () async {
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

  firebaseLoginContinues(User firebaseUser, String authType, dynamic extraData) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get()
        .then((result) {
      //check if user exists in database
      if (!result.exists) {
        FirebaseAuth.instance.signOut();
        // pd.dismissDialog();
        setState(() {
          _loading = false;
        });
        new GeneralUtils().displayAlertDialog(
            context, 'Error', 'User does not exist. Please create an account.');
        return;
      }
      //check if user has been blocked
      Map<String, dynamic> user = result.data();
      bool blocked = user['blocked'];
      if (blocked) {
        FirebaseAuth.instance.signOut();
        // pd.dismissDialog();
        setState(() {
          _loading = false;
        });
        new GeneralUtils().displayAlertDialog(context, 'Error',
            'Sorry, user has been blocked. Please contact support.');
      }
      Map<String, dynamic> updateUserData = new Map();
      if (msgId.isNotEmpty) {
        updateUserData['msgId'] = FieldValue.arrayUnion([msgId]);
      }
      FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .update(updateUserData)
          .then((v) async {
        // pd.dismissDialog();

        Map<String, dynamic> userData = new Map();
        userData['uid'] = firebaseUser.uid;
        userData['email'] = email;
        userData['firstname'] = user['firstname'];
        userData['lastname'] = user['lastname'];
        userData['picture'] = user['picture'];
        userData['msgId'] = user['msgId'];
        ss.setPrefItem('loggedin', 'true');
        ss.setPrefItem('user', jsonEncode(userData));


        DocumentSnapshot query = await FirebaseFirestore.instance.collection("users").doc(firebaseUser.uid).collection("setups").doc("user-data").get();
        if(query.exists) {
          Map<String, dynamic> userSetup = query.data();
          userSetup.forEach((key, value) async {
            await ss.setPrefItem(key, value, isStoreOnline: false);
          });
          gotoHome();
        }else {
          gotoHome();
        }


      });
    }).catchError((err) {
      FirebaseAuth.instance.signOut();
      // pd.dismissDialog();
      setState(() {
        _loading = false;
      });
      new GeneralUtils().displayAlertDialog(
          context, 'Error', 'An error occurred. Please try again.');
      return;
    });
  }

  gotoHome() {
    setState(() {
      _loading = false;
    });
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => new HomeScreen()));
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
        Text('or',style: Theme.of(context)
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
