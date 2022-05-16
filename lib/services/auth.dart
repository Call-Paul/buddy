import 'dart:developer';

import 'package:buddy/helperfunctions/sharedpref_helper.dart';
import 'package:buddy/screens/createProfile.dart';
import 'package:buddy/screens/home.dart';
import 'package:buddy/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUseres()async {
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

    if (userDetails != null ) {
      print(userDetails.displayName);
      await SharedPreferencesHelper().saveUserDisplayName(userDetails.displayName!);
      SharedPreferencesHelper().saveUserEmailKey(userDetails.email!);
      SharedPreferencesHelper().saveUserIdKey(userDetails.uid);
      SharedPreferencesHelper().saveUserName(userDetails.email!.replaceAll("@gmail.com", ""));

      Map<String, dynamic> userInfoMap = {
        "email": userDetails.email,
        "username": userDetails.email!.replaceAll("@gmail.com", ""),
        "name": userDetails.displayName,
        "userid": userDetails.uid
      };

      String name = "";
      SharedPreferencesHelper().getUserDisplayName().then((value) => name = value!);
      String userId = "";
      SharedPreferencesHelper().getUserId().then((value) => userId = value!);
      DataBaseMethods().addUserInfoToDB(userDetails.uid, userInfoMap).then(
          (value) => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => CreateProfile(name, userId))));
    }
  }

  Future signOut() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await auth.signOut();
  }
}
