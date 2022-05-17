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


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SigInBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                margin: EdgeInsets.only(top: size.height * 0.08),
                child: Text(
                  "BUDDY",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: const Color.fromRGBO(229, 36, 39, 1),
                      fontSize: size.width * 0.13,
                      letterSpacing: size.width * 0.02),
                  // textAlign: TextAlign.left
                )),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                margin: EdgeInsets.only(bottom: size.height * 0.05),
                child: Text(
                  "Profil erstellen",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: size.width * 0.043,
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
              margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
              child: TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: "Nutzername"),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
              child: const TextField(
                decoration: InputDecoration(labelText: "Unternehmen"),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
              child: const TextField(
                decoration: InputDecoration(labelText: "Erfahrungen"),
              ),
            ),

            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: size.height * 0.04, left: 0),
              child: RaisedButton(
                onPressed: () {
                  SharedPreferencesHelper().saveUserName(usernameController.text);
                  Map<String, dynamic> addInformation = {
                    "username" : usernameController.text
                  };
                  widget.userInfoMap.addAll(addInformation);
                  DataBaseMethods().addUserInfoToDB(widget.userInfoMap["userid"], widget.userInfoMap);

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
                    style: TextStyle(fontWeight: FontWeight.bold), // TextStyle
                  ), // Text
                ), // Container
              ), // RaisedButton
            ) // Container
          ],
        ),
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
    Size size = MediaQuery.of(context).size;
    return Column(children: [
      if (profileImg == null)
        SizedBox(
            height: size.width * 0.2,
            width: size.width * 0.2,
            child:
                Stack(clipBehavior: Clip.none, fit: StackFit.expand, children: [
              CircleAvatar(
                backgroundColor: Colors.black87,
                child: Text(widget.name.substring(0, 1) +
                    widget.name.substring(widget.name.lastIndexOf(' ') + 1,
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
                        backgroundImage: Image.network(profileImg!).image),
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
                          padding:  EdgeInsets.all(size.width * 0.02),
                          shape: const CircleBorder(),
                        )),
                  ])), // AppRoundImage.url
        ),
    ]);
  }

  Future _selectPhoto() async {
    await showModalBottomSheet(
        context: context,
        builder: (context) => BottomSheet(
              builder: (context) => Wrap(
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
