import 'package:buddy/screens/sign_in_background.dart';
import 'package:buddy/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SigInBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 40),
              margin: EdgeInsets.only(bottom: 10),
              child: const Text(
                "BUDDY",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(229, 36, 39, 1),
                  fontSize: 45,
                  letterSpacing: 8
                ),
               // textAlign: TextAlign.left
              )
            )
            ,Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 40),
                margin: EdgeInsets.only(bottom: 40),
                child: const Text(
                  "Willkommen im Hafen",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 15,
                      letterSpacing: 8
                  ),
                  // textAlign: TextAlign.left
                )
            ),
            GestureDetector(
              onTap: () {
                AuthMethods().signInWithGoogle(context);
              },
              child: Container(
                margin: EdgeInsets.only(top: 150, left: 40, right: 40),
                child: Row(children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 30),
                    child: Image.asset('assets/images/g_logo.png'),
                    width: 25,
                    height: 25,
                  ),
                  const Text(
                    'MIT GOOGLE ANMELDEN',
                    style: TextStyle(
                        fontSize: 18,
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
            GestureDetector(
              onTap: () {
                AuthMethods().signInWithGoogle(context);
              },
              child: Container(
                margin: EdgeInsets.only(top: 20, left: 40, right: 40),
                child: Row(children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 30),
                    child: const Icon(Icons.facebook),
                    width: 25,
                    height: 25,
                  ),
                  const Text(
                    'MIT FACEBOOK ANMELDEN',
                    style: TextStyle(
                        fontSize: 18,
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
