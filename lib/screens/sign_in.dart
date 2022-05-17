import 'package:buddy/screens/helperScreens/sign_in_background.dart';
import 'package:buddy/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'createProfile.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SigInBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                child: Text(
                  "BUDDY",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(229, 36, 39, 1),
                      fontSize: size.width * 0.13,
                      letterSpacing: size.width * 0.02),
                  // textAlign: TextAlign.left
                )),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                margin: EdgeInsets.only(bottom: size.height * 0.04),
                child: Text(
                  "Willkommen im Hafen",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: size.width * 0.043,
                      letterSpacing: size.width * 0.01),
                  // textAlign: TextAlign.left
                )),
            GestureDetector(
              onTap: () {
                AuthMethods().signInWithGoogle(context);
              },
              child: Container(
                margin: EdgeInsets.only(
                    top: size.height * 0.2,
                    left: (size.width * 0.1),
                    right: (size.width * 0.1)),
                child: Row(children: [
                  Container(
                    margin: EdgeInsets.only(left:  (size.width * 0.06), right: (size.width * 0.04)),
                    child: Image.asset('assets/images/g_logo.png'),
                    width: size.width * 0.09,
                    height: size.height * 0.04,
                  ),
                  Text(
                    'MIT GOOGLE ANMELDEN',
                    style: TextStyle(
                        fontSize: (size.width * 0.045),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SansSerif',
                        color: Color.fromRGBO(225, 242, 249, 1)),
                  )
                ]),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Color.fromRGBO(227, 0, 15, 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                padding:
                    EdgeInsets.symmetric( vertical: size.height*0.015),
              ),
            ),
            GestureDetector(
              onTap: () {
                AuthMethods().signInWithGoogle(context);
              },
              child: Container(
                margin: EdgeInsets.only(
                    top: size.height * 0.03,
                    left: (size.width * 0.1),
                    right: (size.width * 0.1)),
                child: Row(children: [
                  Container(
                    margin: EdgeInsets.only(left: (size.width * 0.06), right: (size.width * 0.04)),
                    child: const Icon(Icons.facebook),
                    width: size.width * 0.09,
                    height: size.height * 0.04,
                  ),
                  Text(
                    'MIT FACEBOOK ANMELDEN',
                    style: TextStyle(
                        fontSize: (size.width * 0.045),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SansSerif',
                        color: Color.fromRGBO(225, 242, 249, 1)),
                  )
                ]),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Color.fromRGBO(63, 90, 169, 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                padding:
                    EdgeInsets.symmetric( vertical: size.height*0.015),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
