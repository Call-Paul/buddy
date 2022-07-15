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

/**
 * Mit dieser Klasse wird die Verbindung zum Authentification Service in Firebase gesteuert.
 * Alle Anfragen werden von den Methoden dieser Klasse gesteuert.
 *
 * @author Paul Franken winf104387
 */
class AuthMethods {

  //Instanz für die Verbindung zum Service.
  final FirebaseAuth auth = FirebaseAuth.instance;

  /**
   * Bei dieser Methode wird der Nutzer zurückgegeben,
   * der aktuell beim Service in Firebase angemeldet ist.
   *
   * @return Future<User?> der zur Zeit angemeldete Nutzer.
   */
  Future<User?> getCurrentUseres() async {
    return await auth.currentUser;
  }

  /**
   * Diese Methode kümmert sich um den gesamten Anmeldeprozess über die GoogleAPI.
   * Sollte noch kein Nutzer angemeldet sein, wird dem Nuter hier die Mögichkeit gegeben.
   * SOllte der dann angemeldete Nutzer sich bereits zuvor regrestriert haben,
   * wird er auf den HomeScreen weitergeleitet.
   * Andernfalls wird er zum CreatProfile Scereen geleitet.
   *
   * @param context Der Kontext der App um die Weiterleitung auf andere Screens zu ermöglichen
   * @param companys Die Liste der Unternehmen. Diese wurde bereits beim Welcome-Screen geladen
   *        und werden weitergegebn für den Fall, das ein Profil noch erstellt werden muss.
   * @param industrys Die Liste der Branchen. Diese wurde bereits beim Welcome-Screen geladen
   *        und werden weitergegebn für den Fall, das ein Profil noch erstellt werden muss.
   *
   */
  signInWithGoogle(BuildContext context, List<String> companys, List<String> industrys) async {
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

      DataBaseMethods().checkIfAccountExists(userDetails.uid).then((value) async => {
            if (value != "")
              {
          await DataBaseMethods().saveUserInformationFromOnlineLocal(value),
          Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home()))
              }
            else
              {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateProfile(userInfoMap, companys, industrys)))
              }
          });
    }
  }


  /**
   * Bei dieser Methode wird der aktuelle Benutzer von Google abgemeldet,
   * sodass bei der nächsten Anmeldung erneut der Google Nutzer ausgewählt werden muss.
   */
  signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    _googleSignIn.signOut();
    await auth.signOut();
  }
}
