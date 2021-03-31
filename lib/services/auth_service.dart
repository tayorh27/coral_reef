import 'package:coral_reef/Utils/general.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  final Function(dynamic user, String response, String request) onComplete;

  AuthService({this.onComplete});

  Future<User> googleRequest(BuildContext context) async {
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
      return user;
    } catch (err) {
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
          new GeneralUtils().displayAlertDialog(context, 'Error',
              "Your facebook account doesn't have an email address. Please try with another account");
          return;
        }
        onComplete(user, "success", "facebook");
        break;
      case FacebookLoginStatus.cancel:
        onComplete("error", "error", "facebook");
        new GeneralUtils().displayAlertDialog(
            context, 'Error', 'An error occurred.\n${res.error.developerMessage}');
        break;
      case FacebookLoginStatus.error:
        onComplete("error", "error", "facebook");
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
    final result = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    // switch (result) {
    //   case AuthorizationStatus.authorized:
    //   //FlutterSecureStorage()
    //     final appleIdCredential = result.credential;
    //     final oAuthProvider = OAuthProvider(providerId: 'apple.com');
    //     final credential = oAuthProvider.getCredential(
    //       idToken: String.fromCharCodes(appleIdCredential.identityToken),
    //       accessToken:
    //       String.fromCharCodes(appleIdCredential.authorizationCode),
    //     );
    //     final FirebaseAuth _auth = FirebaseAuth.instance;
    //     final authResult = await _auth.signInWithCredential(credential);
    //     final user = authResult.user;
    //     if (result.credential.email == null) {
    //       await FirebaseAuth.instance.signOut();
    //       //logout apple
    //       new GeneralUtils().displayAlertDialog(context, 'Error',
    //           "Your apple account doesn't have an email address. Please try with another account");
    //       return;
    //     }
    //     pd.displayDialog("Please wait...");
    //     checkFirestoreAndRedirectForApple(
    //         result.credential.email, result.credential.fullName);
    //     break;
    //   case AuthorizationStatus.error:
    //     new GeneralUtils().displayAlertDialog(context, 'Error',
    //         "Sign in failed: ${result.error.localizedDescription}");
    //     break;
    //   case AuthorizationStatus.cancelled:
    //     new GeneralUtils().displayAlertDialog(context, 'Error', 'User cancelled');
    //     break;
    // }

  }

  Future<User> firebaseLoginRequest(BuildContext context, String email, String password) async {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.toLowerCase(), password: password);
    return credential.user;
  }

  Future<User> firebaseRegisterRequest(BuildContext context, String email, String password) async {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.toLowerCase(), password: password);
    return credential.user;
  }
}
