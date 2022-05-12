import 'package:buddy/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Buddy App')),
        body: Center(
            child: GestureDetector(
              onTap: (){
                AuthMethods().signInWithGoogle(context);
              },
          child: Container(
            child: const Text(
              'Login with Google',
              style: TextStyle(fontSize: 30),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.amber,
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
        )));
  }
}
