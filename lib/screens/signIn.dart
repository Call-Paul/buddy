import 'package:buddy/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/database.dart';


/**
 * Diese Klasse stellt den Welcomescreen dar.
 * Es wird sich sowohl um die grafische Darstellung,
 * als auch um die logischen Aufrufe der entsprechenden Methoden gekümmert.
 *
 * @author Paul Franken winf104387
 */
class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}


class _SignInState extends State<SignIn> {


  List<String> companys = List.empty(growable: true);
  List<String> industrys = List.empty(growable: true);


  @override
  void initState() {
    companys.add("Unternehmen");
    companys.add("Branchen");
    doBeforeLaunch();
    super.initState();
  }

  /**
   * Vor dem Start des Fensters werden bereits die Namen der Unternehmen
   * und Branchen heruntergeladen. Diese werden beim Profile erstellen auf dem nächsten Screen benötigt.
   */
  doBeforeLaunch() async {
    companys = await DataBaseMethods().getAllCompanys();
    industrys = await DataBaseMethods().getAllIndustrys();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Stack(

          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset("assets/top1.png", width: size.width),
            ),
            Positioned(
              top: 15,
              right: 15,
              child: Image.asset("assets/f_logo.png", width: size.width * 0.3),
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 25),
              Text(
                "BUDDY",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(255,0,5,1),
                    fontSize: 40,
                    letterSpacing: size.width * 0.02),
                // textAlign: TextAlign.left
              ),
              Text(
                "Willkommen im Hafen",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(0, 92, 169, 1),
                    fontSize: 20,
                    letterSpacing: size.width * 0.01),
                // textAlign: TextAlign.left
              ),
              const SizedBox(height: 30),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap:() {
                        AuthMethods().signInWithGoogle(context, companys, industrys);

                        },
                      child: Container(
                        color: const Color.fromRGBO(220, 220, 220, 0.8),
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                        child: Image.asset(
                          'assets/images/g_logo.png',
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                    Container(
                        color: const Color.fromRGBO(220, 220, 220, 0.8),
                        padding:
                            const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                        child: const IconTheme(
                          data: IconThemeData(
                              color: Color.fromRGBO(66, 103, 178, 1)),
                          child: Icon(
                            Icons.facebook_sharp,
                            size: 30,
                          ),
                        )),
                    Container(
                        color: const Color.fromRGBO(220, 220, 220, 0.8),
                        padding:
                            const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                        child: const IconTheme(
                          data: IconThemeData(color: Colors.black),
                          child: Icon(
                            Icons.apple,
                            size: 30,
                          ),
                        ))
                  ],
                ),
              ),
            ],
          ),
            Positioned(
              bottom: 10,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  "@CrossInnovationClass2022",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 15,
                      letterSpacing: size.width * 0.01),
                  // textAlign: TextAlign.left
                ),
              ),
            ),
        ],
        ),
      ),
    ));
  }
}
