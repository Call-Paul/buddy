import 'dart:io';
import 'dart:ui';

import 'package:buddy/helperfunctions/sharedpref_helper.dart';
import 'package:buddy/screens/home.dart';
import 'package:buddy/screens/sign_in.dart';
import 'package:buddy/screens/helperScreens/sign_in_background.dart';
import 'package:buddy/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class CreateProfile extends StatefulWidget {
  final Map<String, dynamic> userInfoMap;

  CreateProfile(this.userInfoMap);

  @override
  _CreateProfile createState() => _CreateProfile();
}

class _CreateProfile extends State<CreateProfile> {
  String profileImg = "";
  TextEditingController usernameController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  List selectedMeetings = [];


  @override
  Widget build(BuildContext context) {
    companyController.addListener(() {setState(() {});});
    usernameController.addListener(() {setState(() {});});
    experienceController.addListener(() {setState(() {});});

    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SigInBackground(
        child:
        ListView(physics: const NeverScrollableScrollPhysics(), children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
                  margin: EdgeInsets.only(top: size.height * 0.03),
                  child: Text(
                    "BUDDY",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: const Color.fromRGBO(229, 36, 39, 1),
                        fontSize: size.width * 0.085,
                        letterSpacing: size.width * 0.02),
                    // textAlign: TextAlign.left
                  )),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.09),
                  margin: EdgeInsets.only(bottom: size.height * 0.05),
                  child: Text(
                    "Profil erstellen",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: size.width * 0.04,
                        letterSpacing: size.width * 0.01),
                    // textAlign: TextAlign.left
                  )),

              UserImage(
                onFileChanged: (profileImg) {
                  setState(() {});
                  this.profileImg = profileImg;
                },
                name: widget.userInfoMap["name"],
                userid: widget.userInfoMap["userid"],
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(
                    horizontal: size.width * 0.1, vertical: size.height * 0.01),
                child: TextFormField(
                  maxLength: 18,
                  controller: usernameController,
                  decoration: InputDecoration(
                    counterText: usernameController.text.length < 10
                        ? ''
                        : '${usernameController.text.length}/18',
                    labelText: "Nutzername",
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                  style: TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(
                    horizontal: size.width * 0.1, vertical: size.height * 0.01),
                child: TextFormField(
                    maxLength: 30,
                    controller: companyController,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    decoration: InputDecoration(
                      counterText: companyController.text.length < 20
                          ? ''
                          : '${companyController.text.length}/30',
                      labelText: "Unternehmen",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    style: TextStyle(
                      fontFamily: "Poppins",
                    )),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(
                    horizontal: size.width * 0.1, vertical: size.height * 0.01),
                child: TextFormField(
                    controller: experienceController,
                    maxLength: 150,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    maxLines: 4,
                    decoration: InputDecoration(
                      counterText: experienceController.text.length < 120
                          ? ''
                          : '${experienceController.text.length}/150',
                      labelText: "Erfahrungen",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    style: TextStyle(
                      fontFamily: "Poppins",
                    )),
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                alignment: Alignment.centerLeft,
                color: Colors.transparent,
                child: Wrap(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: OutlinedButton(
                        onPressed: () {
                          if (selectedMeetings.contains(0)) {
                            selectedMeetings.remove(0);
                          } else {
                            selectedMeetings.add(0);
                          }
                          setState(() {});
                        },
                        child: Text('Unternehmensführung'),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: selectedMeetings.contains(0)
                              ? Color.fromRGBO(211, 211, 211, 0.5)
                              : Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: OutlinedButton(
                        onPressed: () {
                          if (selectedMeetings.contains(1)) {
                            selectedMeetings.remove(1);
                          } else {
                            selectedMeetings.add(1);
                          }
                          setState(() {});
                        },
                        child: Text('Treffen'),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: selectedMeetings.contains(1)
                              ? Color.fromRGBO(211, 211, 211, 0.5)
                              : Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: OutlinedButton(
                        onPressed: () {
                          if (selectedMeetings.contains(2)) {
                            selectedMeetings.remove(2);
                          } else {
                            selectedMeetings.add(2);
                          }
                          setState(() {});
                        },
                        child: Text('Meet-Ups'),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: selectedMeetings.contains(2)
                              ? Color.fromRGBO(211, 211, 211, 0.5)
                              : Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: size.height * 0.04, bottom: 300),
                child: RaisedButton(
                  onPressed: () {
                    SharedPreferencesHelper()
                        .saveUserName(usernameController.text);
                    Map<String, dynamic> addInformation = {
                      "username": usernameController.text,
                      "company": companyController.text,
                      "experience": experienceController.text,
                      "guide": selectedMeetings.contains(0) ? "true": "false",
                      "meet": selectedMeetings.contains(1) ? "true": "false",
                      "official_meet": selectedMeetings.contains(2) ? "true": "false"
                    };
                    widget.userInfoMap.addAll(addInformation);
                    DataBaseMethods().addUserInfoToDB(
                        widget.userInfoMap["userid"], widget.userInfoMap);

                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Home()));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60.0)),
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    alignment: Alignment.center,
                    height: size.height * 0.07,
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60.0),
                        gradient: const LinearGradient(colors: [
                          Color.fromARGB(255, 255, 136, 34),
                          Color.fromARGB(255, 255, 177, 41)
                        ])
                      // LinearGradient
                    ),
                    // BoxDecoration
                    padding: const EdgeInsets.all(0),
                    child: const Text(
                      "Registrieren",
                      textAlign: TextAlign.center,
                      style:
                      TextStyle(fontWeight: FontWeight.bold), // TextStyle
                    ), // Text
                  ), // Container
                ), // RaisedButton
              ) // Container
            ],
          ),
        ]),
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
  final ImagePicker imagePicker = ImagePicker();

  String? profileImg;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.09, vertical: size.width * 0.05),
      child: Column(children: [
        if (profileImg == null)
          SizedBox(
              height: size.width * 0.2,
              width: size.width * 0.2,
              child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.black87,
                      child: Text(widget.name.substring(0, 1) +
                          widget.name.substring(
                              widget.name.lastIndexOf(' ') + 1,
                              widget.name.lastIndexOf(' ') + 2)),
                    ),
                    Positioned(
                        bottom: 0,
                        right: -35,
                        child: RawMaterialButton(
                          onPressed: () async {
                            _selectPhoto();
                          },
                          elevation: 2.0,
                          fillColor: const Color(0xFFF5F6F9),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.blue,
                          ),
                          padding: EdgeInsets.all(size.width * 0.02),
                          shape: const CircleBorder(),
                        )),
                  ])),
        if (profileImg != null)
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => _selectPhoto(),
            child: SizedBox(
                height: size.width * 0.2,
                width: size.width * 0.2,
                child: Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    children: [
                      CircleAvatar(
                          backgroundColor: Colors.black87,
                          backgroundImage: Image
                              .network(profileImg!)
                              .image),
                      Positioned(
                          bottom: 0,
                          right: -35,
                          child: RawMaterialButton(
                            onPressed: () async {
                              _selectPhoto();
                            },
                            elevation: 2.0,
                            fillColor: const Color(0xFFF5F6F9),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.blue,
                            ),
                            padding: EdgeInsets.all(size.width * 0.02),
                            shape: const CircleBorder(),
                          )),
                    ])), // AppRoundImage.url
          ),
      ]),
    );
  }

  Future _selectPhoto() async {
    await showModalBottomSheet(
        context: context,
        builder: (context) =>
            BottomSheet(
              builder: (context) =>
                  Wrap(
                    children: [
                      Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.camera),
                            title: const Text("Kamara"),
                            onTap: () {
                              Navigator.of(context).pop();
                              pickImage(ImageSource.camera);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.browse_gallery),
                            title: const Text("Gallerie"),
                            onTap: () {
                              Navigator.of(context).pop();
                              pickImage(ImageSource.gallery);
                            },
                          )
                        ],
                      )
                    ],
                  ),
              onClosing: () {},
            ));
  }

  Future pickImage(ImageSource source) async {
    final pickedFile =
    await imagePicker.pickImage(source: source, imageQuality: 50);
    if (pickedFile == null) {
      return;
    }

    final File? imageFile = File(pickedFile.path);
    final storage = FirebaseStorage.instanceFor(
        bucket: "gs://crossinnovationclass2022.appspot.com")
        .ref();

    var storageRef = storage.child("user/profile/${widget.userid}");
    await storageRef.putFile(imageFile!);
    var downloadURL = await storageRef.getDownloadURL();

    setState(() {
      profileImg = downloadURL;
    });
    widget.onFileChanged(profileImg!);
  }
}
