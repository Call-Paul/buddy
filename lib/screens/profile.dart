import 'dart:io';

import 'package:buddy/screens/signIn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/auth.dart';
import '../services/storage.dart';

class EditProfile extends StatefulWidget {
  String myDisplayName,
      userName,
      myUserId,
      company,
      skill1,
      skill2,
      skill3,
      skill4;

  EditProfile(
      {required this.myDisplayName,
      required this.userName,
      required this.myUserId,
      required this.company,
      required this.skill1,
      required this.skill2,
      required this.skill3,
      required this.skill4});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String? backgroundImg;
  String? profileImg;

  @override
  initState() {
    getProfilePicture();
    super.initState();
  }

  void getProfilePicture() async {
    var downloadURL =
        await StorageMethods().getProfileBackgroundImg(widget.myUserId);

    if (downloadURL != "") {
      setState(() {
        backgroundImg = downloadURL;
      });
    }
  }

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
                  : Container(
                      alignment: Alignment.center,
                      height: 300,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                            Color.fromRGBO(252, 87, 94, 1),
                            Color.fromRGBO(248, 86, 155, 1)
                          ])
                          // LinearGradient
                          ),
                      // BoxDecoration
                    ),
              UserImage(
                onFileChanged: (profileImg) {
                  setState(() {});
                  this.profileImg = profileImg;
                },
                name: widget.myDisplayName,
                userid: widget.myUserId,
              ),
              Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 370),
                      Container(
                        child: Text(
                          widget.userName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontSize: 22,
                              letterSpacing: 10),
                          // textAlign: TextAlign.left
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Text(
                          widget.company,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontSize: 12,
                              letterSpacing: 18),
                          // textAlign: TextAlign.left
                        ),
                      ),
                      widget.skill1 != ""
                          ? Container(
                              margin: const EdgeInsets.only(top: 40),
                              child: Text(
                                "• ${widget.skill1}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontSize: 16,
                                    letterSpacing: 2),
                                // textAlign: TextAlign.left
                              ),
                            )
                          : Container(),
                      widget.skill2 != ""
                          ? Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Text(
                                "• ${widget.skill2}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontSize: 16,
                                    letterSpacing: 2),
                                // textAlign: TextAlign.left
                              ),
                            )
                          : Container(),
                      widget.skill3 != ""
                          ? Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Text(
                                "• ${widget.skill3}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontSize: 16,
                                    letterSpacing: 2),
                                // textAlign: TextAlign.left
                              ),
                            )
                          : Container(),
                      widget.skill4 != ""
                          ? Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Text(
                                "• ${widget.skill4}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontSize: 16,
                                    letterSpacing: 2),
                                // textAlign: TextAlign.left
                              ),
                            )
                          : Container(),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: Wrap(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: OutlinedButton(
                                onPressed: () {},
                                child: Text('Treffen'),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: OutlinedButton(
                                onPressed: () {},
                                child: Text('Meet-Ups'),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: OutlinedButton(
                                onPressed: () {},
                                child: Text('Unternehmensführung'),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      InkWell(
                        onTap: () {
                          AuthMethods().signOut().then((value) =>
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignIn())));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60.0),
                            color: Color.fromRGBO(252, 87, 94, 1),
                            // LinearGradient
                          ),
                          // BoxDecoration
                          padding: const EdgeInsets.all(0),
                          child: const Text(
                            "Abmelden",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold), // TextStyle
                          ), // Text
                        ),
                      ), // Con
                    ]),
              ),
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

class UserImage extends StatefulWidget {
  final Function(String profileImg) onFileChanged;

  String name, userid;

  UserImage(
      {required this.onFileChanged, required this.name, required this.userid});

  @override
  _UserImageState createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  @override
  initState() {
    getProfilePicture();
    super.initState();
  }

  final ImagePicker imagePicker = ImagePicker();

  String? profileImg;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      margin:
          EdgeInsets.symmetric(horizontal: size.width * 0.09, vertical: 220),
      child: Column(children: [
        if (profileImg == null)
          SizedBox(
              height: 130,
              width: 130,
              child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.black87,
                      child: Text(widget.name == ""
                          ? widget.name.substring(1)
                          : widget.name.substring(0, 1) +
                              widget.name.substring(
                                  widget.name.lastIndexOf(' ') + 1,
                                  widget.name.lastIndexOf(' ') + 2)),
                    ),
                  ])),
        if (profileImg != null)
          SizedBox(
              height: 130,
              width: 130,
              child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    CircleAvatar(
                        backgroundColor: Colors.black87,
                        backgroundImage: Image.network(profileImg!).image),
                  ])), // AppRoundImage.url
      ]),
    );
  }

  void getProfilePicture() async {
    var downloadURL = await StorageMethods().getProfileImg(widget.userid);

    if (downloadURL != "") {
      setState(() {
        profileImg = downloadURL;
      });
      widget.onFileChanged(profileImg!);
    }
  }
}
