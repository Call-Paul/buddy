import 'package:buddy/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SigInBackground extends StatelessWidget {
  final Widget child;

  const SigInBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset("assets/top1.png", width: size.width),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset("assets/top2.png", width: size.width),
          ),
          Positioned(
            top: 50,
            right: 15,
            child: Image.asset("assets/f_logo.png", width: size.width * 0.3),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset("assets/bottom2.png", width: size.width),
          ),

          child
        ],
      ),
    );
  }
}
