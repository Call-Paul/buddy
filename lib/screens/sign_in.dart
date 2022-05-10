import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget{
  @override
  _SignInState createState() => _SignInState();

}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Buddy App')),
      body: Container(
        child: const Text('HALLO Welt'),
      )
    );
  }

}
