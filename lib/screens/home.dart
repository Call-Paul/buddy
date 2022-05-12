import 'package:buddy/screens/sign_in.dart';
import 'package:buddy/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buddy App'),
        actions: [
          GestureDetector(
            onTap: () {
              AuthMethods().signOut().then((value) => Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => SignIn())));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
    );
  }
}
