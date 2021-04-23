import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  final Function(dynamic user, String response, String request, dynamic extraData) onComplete;

  AuthService({this.onComplete});

  Future<void> googleRequest(BuildContext context) async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'profile'
        ],
      );
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final result = await _auth.signInWithCredential(credential);
      final User user = result.user;
      onComplete(user, "success", "google", googleAuth);
    } catch (err) {
      onComplete(null, "error", "google", null);
      new GeneralUtils().displayAlertDialog(context, "Error Message", "$err");
    }
    return null;
  }

  Future<void> facebookRequest(BuildContext context) async {
    final facebookLogin = FacebookLogin();
    final res = await facebookLogin.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    switch (res.status) {
      case FacebookLoginStatus.success:
        final FirebaseAuth _auth = FirebaseAuth.instance;
        final AuthCredential credential = FacebookAuthProvider.credential(res.accessToken.token);
        final _result = await _auth.signInWithCredential(credential);
        final User user = _result.user;
        if (user.email == null) {
          await FirebaseAuth.instance.signOut();
          await facebookLogin.logOut();
          onComplete("error", "error", "facebook", null);
          new GeneralUtils().displayAlertDialog(context, 'Error',
              "Your facebook account doesn't have an email address. Please try with another account");
          return;
        }
        onComplete(user, "success", "facebook", res.accessToken);
        break;
      case FacebookLoginStatus.cancel:
        onComplete("error", "error", "facebook", null);
        new GeneralUtils().displayAlertDialog(
            context, 'Error', 'An error occurred.\n${res.error.developerMessage}');
        break;
      case FacebookLoginStatus.error:
        onComplete("error", "error", "facebook", null);
        new GeneralUtils().displayAlertDialog(
            context, 'Error', 'An error occurred.\n${res.error.developerMessage}');
        break;
    }
  }

  Future<void> appleRequest(BuildContext context, bool isAvailable) async {
    if(!isAvailable) {
      new GeneralUtils().displayAlertDialog(context, 'Error',
          'Sign in With Apple not available. Must be running on iOS 13+');
      return;
    }
    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
          String.fromCharCodes(appleIdCredential.authorizationCode),
        );
        final FirebaseAuth _auth = FirebaseAuth.instance;
        final authResult = await _auth.signInWithCredential(credential);
        final user = authResult.user;
        if (result.credential.email == null) {
          await FirebaseAuth.instance.signOut();
          onComplete("error", "error", "apple", null);
          new GeneralUtils().displayAlertDialog(context, 'Error',
              "Your apple account doesn't have an email address. Please try with another account");
          return;
        }

        Map<String,dynamic> extData = new Map();
        extData["email"] = result.credential.email.toLowerCase();
        extData["firstname"] = result.credential.fullName.givenName;
        extData["lastname"] = result.credential.fullName.familyName;

        onComplete(user, "success", "apple", extData);
        break;
      case AuthorizationStatus.error:
        onComplete("error", "error", "apple", null);
        new GeneralUtils().displayAlertDialog(
            context, 'Error', "Sign in failed: ${result.error.localizedDescription}");
        break;
      case AuthorizationStatus.cancelled:
        onComplete("error", "error", "apple", null);
        new GeneralUtils().displayAlertDialog(
            context, 'Error', 'User cancelled');
        break;
    }

  }

  Future<void> firebaseLoginRequest(BuildContext context, String email, String password) async {
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email.toLowerCase(), password: password).then((credential) {
      onComplete(credential.user, "success", "firebase", null);
    }).catchError((err) {
      onComplete(null, "error", "firebase", null);
      new GeneralUtils().displayAlertDialog(context, 'Error', '${err.toString()}');
    });
  }

  Future<void> firebaseRegisterRequest(BuildContext context, String email, String password) async {
    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.toLowerCase(), password: password).then((credential) {
      onComplete(credential.user, "success", "firebase", null);
    }).catchError((err) {
      onComplete(null, "error", "firebase", null);
      new GeneralUtils().displayAlertDialog(context, 'Error', '${err.toString()}');
    });
  }

  Future<void> forgotPasswordRequest(BuildContext context, String email) async {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email.toLowerCase()).then((credential) {
      onComplete(null, "success", "firebase", null);
      new GeneralUtils().displayAlertDialog(context, 'Attention', 'A password reset link has been sent to your email.');
    }).catchError((err) {
      onComplete(null, "error", "firebase", null);
      new GeneralUtils().displayAlertDialog(context, 'Error', '${err.toString()}');
    });
  }
}
