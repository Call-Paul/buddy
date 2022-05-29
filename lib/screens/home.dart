import 'dart:developer';

import 'package:buddy/screens/chatOverview.dart';
import 'package:buddy/screens/helperScreens/navdrawer.dart';
import 'package:buddy/screens/map.dart';
import 'package:buddy/screens/profile.dart';
import 'package:buddy/screens/signIn.dart';
import 'package:buddy/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:geolocator/geolocator.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';

import '../helperfunctions/sharedpref_helper.dart';
import '../services/database.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int pageIndex = 0;
  String displayName = "";
  String userId = "";
  String userName = "";
  String company = "";
  String skill1 = "";
  String skill2 = "";
  String skill3 = "";
  String skill4 = "";

  TextEditingController topic = TextEditingController();
  String scannedId ="";

  int _tabTextIconIndexSelected = 0;

  @override
  void initState() {
    Stream<NDEFMessage> stream = NFC.readNDEF();

    stream.listen((NDEFMessage message) {
      scannedId = message.data;
      showBottomDialog();
    });
    getDataFromPrefs();
    super.initState();
  }

  getDataFromPrefs() async {
    displayName = (await SharedPreferencesHelper().getUserDisplayName())!;
    userId = (await SharedPreferencesHelper().getUserId())!;
    company = (await SharedPreferencesHelper().getUserCompany())!;
    userName = (await SharedPreferencesHelper().getUserName())!;
    String skills = (await SharedPreferencesHelper().getUserSkills())!;
    var array = skills.split("|");
    skill1 = array[0];
    skill2 = array[1];
    skill3 = array[2];
    skill4 = array[3];
  }

  var _listGenderText = ["Buddy", "Seeker"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.black,
        ),
        actions: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: FlutterToggleTab(
              width: 30,
              height: 10,
              borderRadius: 15,
              selectedBackgroundColors: [Color.fromRGBO(128, 172, 173, 1)],
              selectedTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600),
              unSelectedTextStyle: const TextStyle(
                  color: Color.fromRGBO(195, 118, 75, 1),
                  fontSize: 10,
                  fontWeight: FontWeight.w400),
              labels: _listGenderText,
              selectedIndex: _tabTextIconIndexSelected,
              selectedLabelIndex: (index) {
                setState(() {
                  _tabTextIconIndexSelected = index;
                });
              },
            ),
          ),
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProfile(
                              myDisplayName: displayName,
                              myUserId: userId,
                              userName: userName,
                              company: company,
                              skill1: skill1,
                              skill2: skill2,
                              skill3: skill3,
                              skill4: skill4,
                            )));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Icon(
                  Icons.person,
                  color: Color.fromRGBO(195, 118, 75, 1),
                  size: 30,
                ),
              )),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              color: const Color.fromRGBO(195, 118, 75, 1),
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
          child: Stack(
        children: [
          pageIndex == 0
              ? buildHome(context)
              : pageIndex == 1
                  ? MapScreen()
                  : ChatOverview(),
        ],
      )),
    );
  }

  showBottomDialog() async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => BottomSheet(
              builder: (context) => Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Wrap(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Container(
                            child: const Text(
                              "Meeting teilen",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(195, 118, 75, 1),
                                  fontSize: 30,
                                  letterSpacing: 8),
                              // textAlign: TextAlign.left
                            ),
                            margin: EdgeInsets.all(20),
                          ),
                          Container(
                            width: 200,
                            child: TextFormField(
                                controller: topic,
                                maxLengthEnforcement:
                                    MaxLengthEnforcement.enforced,
                                decoration: InputDecoration(
                                  labelText: "Thema",
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

                          InkWell(
                            onTap: () async {
                              if (topic.text != "") {
                                String partnerUsername = "";
                                if(scannedId != ""){
                                  partnerUsername = await DataBaseMethods()
                                      .getUsernameById(scannedId);
                                }
                                Position position = await _getGeoLocationPosition();
                                addMeeting(position.latitude, position.longitude, userName, partnerUsername, topic.text);
                                topic.text = "";
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.all(20),
                              alignment: Alignment.center,
                              height: 50,
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60.0),
                                color: Color.fromRGBO(202, 170, 147, 1),
                                // LinearGradient
                              ),
                              // BoxDecoration
                              padding: const EdgeInsets.all(0),
                              child: const Text(
                                "Teilen",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold), // TextStyle
                              ), // Text
                            ),
                          ), // Con
                        ],
                      ),
                    )
                  ],
                ),
              ),
              onClosing: () {},
            ));
  }

  addMeeting(
      double lat, double long, String name1, String name2, String topic) async {
    Map<String, dynamic> meetingInfos = {
      "lat": lat,
      "long": long,
      "name1": name1,
      "name2": name2,
      "topic": topic,
    };
    await DataBaseMethods().addMeeting(meetingInfos);
  }

  _getGeoLocationPosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
    } else {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return position;
    }
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
              width: 2,
              color: Color.fromRGBO(202, 170, 147, 1),
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
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: const Text(
                  "Die Otto (GmbH & Co KG) (früher Otto Versand (GmbH & Co), auch Otto Group) ist ein deutsches Handels- und Dienstleistungsunternehmen mit Sitz in Hamburg, das weltweit mit rund 52.000 Mitarbeitern agiert und in den Unternehmensbereichen Einzelhandel, Finanzierung und Logistik sowie Versandhandel aktiv ist.",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SansSerif',
                    color: Color.fromRGBO(52, 95, 104, 1),
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
                      color: Color.fromRGBO(95, 152, 161, 1),
                      size: 35,
                    )
                  : const Icon(
                      Icons.home_outlined,
                      color: Color.fromRGBO(95, 152, 161, 1),
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
                      Icons.map,
                      color: Color.fromRGBO(95, 152, 161, 1),
                      size: 35,
                    )
                  : const Icon(
                      Icons.map_outlined,
                      color: Color.fromRGBO(95, 152, 161, 1),
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
                      Icons.chat_bubble,
                      color: Color.fromRGBO(95, 152, 161, 1),
                      size: 35,
                    )
                  : const Icon(
                      Icons.chat_bubble_outline_outlined,
                      color: Color.fromRGBO(95, 152, 161, 1),
                      size: 35,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
