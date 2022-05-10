import 'package:buddy/helperfunctions/sharedpref_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods{
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUseres(){
    return auth.currentUser;
  }

  signInWithGoogle(BuildContext context) async{
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();


    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    if (googleSignInAccount == null) return null;

    final GoogleSignInAuthentication googleSignInAuthentication = await
    googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken
    );

    UserCredential result =await _firebaseAuth.signInWithCredential(credential);

    User? userDetails = result.user;

    if(userDetails != null){
      SharedPreferencesHelper().saveUserDisplayName(userDetails.displayName!);
      SharedPreferencesHelper().saveUserEmailKey(userDetails.email!);
      SharedPreferencesHelper().saveUserIdKey(userDetails.uid);
    }







  }


}