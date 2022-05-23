import 'dart:developer';

import 'package:buddy/helperfunctions/sharedpref_helper.dart';
import 'package:buddy/screens/home.dart';
import 'package:buddy/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../screens/createProfile.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUseres() async {
    return await auth.currentUser;
  }

  signInWithGoogle(BuildContext context) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    if (googleSignInAccount == null) return null;

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    UserCredential result =
        await _firebaseAuth.signInWithCredential(credential);
    User? userDetails = result.user;

    if (userDetails != null) {
      var uuidGenerator = const Uuid();
      var uuid = uuidGenerator.v4();
      await SharedPreferencesHelper()
          .saveUserDisplayName(userDetails.displayName!);
      await SharedPreferencesHelper().saveUserEmail(userDetails.email!);
      await SharedPreferencesHelper().saveUserId(uuid);
      await SharedPreferencesHelper().saveAccountId(userDetails.uid);

      Map<String, dynamic> userInfoMap = {
        "email": userDetails.email,
        "name": userDetails.displayName,
        "userid": uuid,
        "accountid": userDetails.uid
      };

      DataBaseMethods().checkIfAccountExists(userDetails.uid).then((value) => {
            if (value != "")
              {
          DataBaseMethods().saveUserInformationFromOnlineLocal(value),
          Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home()))
              }
            else
              {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateProfile(userInfoMap)))
              }
          });
    }
  }

  Future signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    _googleSignIn.signOut();
    await auth.signOut();
  }
}
