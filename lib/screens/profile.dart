import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String? backgroundImg = "https://picsum.photos/250?image=10";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              backgroundImg != null
                  ? Image.network(
                      backgroundImg!,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    )
                  : Container(),
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0.0, //No shadow
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
