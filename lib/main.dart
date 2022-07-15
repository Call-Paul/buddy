import 'package:buddy/screens/home.dart';
import 'package:buddy/screens/signIn.dart';
import 'package:buddy/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Buddy - Dein Anker in Hamburg',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'OoohBaby',
      ),
      home: FutureBuilder(
        future: AuthMethods().getCurrentUseres(),
        builder: (context, AsyncSnapshot<dynamic> snapshot){
        if(snapshot.hasData){
          return Home();
        }else {
          return SignIn();
        }
      },
      ),
    );
  }
}
