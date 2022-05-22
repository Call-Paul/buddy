import 'dart:developer';

import 'package:buddy/screens/chatOverview.dart';
import 'package:buddy/screens/helperScreens/navdrawer.dart';
import 'package:buddy/screens/map.dart';
import 'package:buddy/screens/signIn.dart';
import 'package:buddy/services/auth.dart';
import 'package:buddy/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../helperfunctions/sharedpref_helper.dart';
import 'chat.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              AuthMethods().signOut();
              AuthMethods().signOut().then((value) => Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => SignIn())));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Icon(
                Icons.person,
                color: Color.fromRGBO(18, 110, 194, 1),
                size: 30,
              ),
            ),
          )
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              color: const Color.fromRGBO(18, 110, 194, 1),
              icon: const Icon(
                Icons.menu,
                size: 30,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      bottomNavigationBar: buildMyNavBar(context),
      body: SafeArea(
        child: pageIndex == 0
            ? buildHome(context)
            : pageIndex == 1
                ? HeatMap()
                : ChatOverview(),
      ),
    );
  }

  Widget buildHome(BuildContext context) {
    return Container(
      child: Center(
          child: ListView(
        children: [
          buildBucket(context),
          buildBucket(context),
          buildBucket(context),
          buildBucket(context),
          buildBucket(context),
          buildBucket(context),
        ],
      )),
    );
  }

  Widget buildBucket(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        height: 400,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.amber,
            ),
            borderRadius: const BorderRadius.all(const Radius.circular(20))),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topRight: const Radius.circular(20),
                  topLeft: const Radius.circular(20)),
              child: Image.asset(
                "assets/otto.png",
                height: 200.0,
                width: double.infinity,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: const Text(
                  "Die Otto (GmbH & Co KG) (früher Otto Versand (GmbH & Co), auch Otto Group) ist ein deutsches Handels- und Dienstleistungsunternehmen mit Sitz in Hamburg, das weltweit mit rund 52.000 Mitarbeitern agiert und in den Unternehmensbereichen Einzelhandel, Finanzierung und Logistik sowie Versandhandel aktiv ist.",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: 'SansSerif',
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ))
          ],
        ));
  }

  SafeArea buildMyNavBar(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 60,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 0;
                });
              },
              icon: pageIndex == 0
                  ? const Icon(
                      Icons.home_filled,
                      color: Color(0xFF198BAA),
                      size: 35,
                    )
                  : const Icon(
                      Icons.home_outlined,
                      color: Color(0xFF198BAA),
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 1;
                });
              },
              icon: pageIndex == 1
                  ? const Icon(
                      Icons.work_rounded,
                      color: Color(0xFF198BAA),
                      size: 35,
                    )
                  : const Icon(
                      Icons.work_outline_outlined,
                      color: Color(0xFF198BAA),
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 2;
                });
              },
              icon: pageIndex == 2
                  ? const Icon(
                      Icons.widgets_rounded,
                      color: Color(0xFF198BAA),
                      size: 35,
                    )
                  : const Icon(
                      Icons.widgets_outlined,
                      color: Color(0xFF198BAA),
                      size: 35,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
