import 'dart:math';

import 'package:buddy/screens/chatOverview.dart';
import 'package:buddy/screens/helperScreens/navdrawer.dart';
import 'package:buddy/screens/map.dart';
import 'package:buddy/screens/overviewPage.dart';
import 'package:buddy/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';

import '../helperfunctions/sharedpref_helper.dart';
import '../services/database.dart';
import '../services/storage.dart';
import 'chat.dart';

/**
 * Diese Klasse sorgt für die Darstellung des Menüs und der anderen immer
 * angezeigten Elemente wie de ToggleSwitch oder dem NavDrawer.
 * Sie kümmert sich um die NFC Funktionlität.
 * Es wird sich sowohl um die grafische Darstellung,
 * als auch um die logischen Aufrufe der entsprechenden Methoden gekümmert.
 *
 * @author Paul Franken winf104387
 */
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin{
  int pageIndex = 0;
  String displayName = "";
  String userId = "";
  String userName = "";
  String company = "";
  String skill1 = "";
  String skill2 = "";
  String skill3 = "";
  String skill4 = "";
  String startDate = "";
  int mode = 1;
  int _tabTextIconIndexSelected = 0;
  var toggleListText = ["Buddy", "Seeker"];
  late AnimationController controller;

  TextEditingController topic = TextEditingController();
  String scannedId = "";
  String profileImg = "";
  ValueNotifier<int> _notifier = ValueNotifier(1);

  /**
   * Beim Start dieses Fesnters wird der NFC Listener registriert.
   * Beim erfolgreichen Scannen wird ein Botom Dialog angezeigt.
   *
   */
  @override
  void initState() {
    Stream<NDEFMessage> stream =
        NFC.readNDEF(once: false, readerMode: NFCDispatchReaderMode());

    stream.listen((NDEFMessage message) {
      scannedId = message.data;
      showBottomDialog_Chooser();
    });
    getDataFromPrefs();

    controller = AnimationController(
      duration: const Duration(milliseconds: 800),
        vsync: this,

    );
    super.initState();
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  /**
   * Hier werden zu Beginn des Programmes einige Informationen aus den
   * SharedPreferences geladen um sie im späteren Verlauf zu verwenden.
   */
  getDataFromPrefs() async {
    displayName = (await SharedPreferencesHelper().getUserDisplayName())!;
    userId = (await SharedPreferencesHelper().getUserId())!;
    company = (await SharedPreferencesHelper().getUserCompany())!;
    userName = (await SharedPreferencesHelper().getUserName())!;
    bool mode = (await SharedPreferencesHelper().getUserMode())!;
    _tabTextIconIndexSelected = mode == true ? 0 : 1;
    var format = DateFormat('dd.MM.yy');
    startDate =
        format.format((await SharedPreferencesHelper().getUserStartDate())!);
    String skills = (await SharedPreferencesHelper().getUserSkills())!;
    var array = skills.split("|");
    skill1 = array[0];
    skill2 = array[1];
    skill3 = array[2];
    skill4 = array[3];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(
          value: mode,
          onResult: (result) {
            mode = result;
            _notifier.value = mode;
            setState(() {});
          }),
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.black,
        ),
        actions: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            //Der Toggle um den Modus auszuwählen
            child: FlutterToggleTab(
              width: 30,
              height: 10,
              borderRadius: 15,
              selectedBackgroundColors: [Color.fromRGBO(225, 0, 5, 1)],
              selectedTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600),
              unSelectedTextStyle: const TextStyle(
                  color: Color.fromRGBO(0, 48, 99, 1),
                  fontSize: 10,
                  fontWeight: FontWeight.w400),
              labels: toggleListText,
              selectedIndex: _tabTextIconIndexSelected,
              selectedLabelIndex: (index) {
                setState(() {
                  _tabTextIconIndexSelected = index;
                  DataBaseMethods().setMode(index, userId);
                  SharedPreferencesHelper()
                      .saveUserMode(index == 1 ? false : true);
                });
              },
            ),
          ),
          //Der Button um zur Profilansicht zu gelangen
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
                            startDate: startDate)));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Icon(
                  Icons.person,
                  color: Color.fromRGBO(0, 48, 99, 1),
                  size: 30,
                ),
              )),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              color: const Color.fromRGBO(0, 48, 99, 1),
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
              ? ValueListenableBuilder<int>(
                  valueListenable: _notifier,
                  builder: (context, value, _) {
                    return OverviewPage(mode: value);
                  })
              : pageIndex == 1
                  ? MapScreen()
                  : ChatOverview(),
        ],
      )),
    );
  }


  //Diese bottomDialog wird aufgerufen sobal ein NFC Chip gescannt wurde.
  //Er bietet dem Nutzer die Auswahl das Meeting zu teieln oder das Profil des Partners zu betrachten.
  showBottomDialog_Chooser() async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => BottomSheet(
              builder: (context) => Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: Wrap(children: [
                      AnimatedBuilder(animation: controller, builder: (context, child){
                        double angle = controller.value * -pi;
                        final transform = Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(angle);
                        return Transform(
                          transform: transform,
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/anker.png",
                          ),
                        );
                      }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              showBottomDialog_Sharing();
                            },
                            child: Wrap(children: [
                              Column(children: const [
                                Text(
                                  "Meeting teilen",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SansSerif',
                                    color: Color.fromRGBO(52, 95, 104, 1),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Icon(
                                  Icons.share,
                                  color: Color.fromRGBO(195, 118, 75, 1),
                                  size: 25,
                                ),
                              ]),
                            ]),
                          ),
                          InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              String partnerUsername = await DataBaseMethods()
                                  .getUsernameById(scannedId);
                              String partnerCompany = await DataBaseMethods()
                                  .getPartnersCompany(partnerUsername);
                              var skills = await DataBaseMethods()
                                  .getFieldFromUser("skills", scannedId);
                              var array = skills.split("|");

                              showBottomDialog_connect(
                                  partnerUsername,
                                  partnerCompany,
                                  userId,
                                  userName,
                                  scannedId,
                                  array[0],
                                  array[1],
                                  array[2],
                                  array[3],
                                  startDate);
                            },
                            child: Wrap(children: [
                              Column(children: const [
                                Text(
                                  "Vernetzen",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SansSerif',
                                    color: Color.fromRGBO(52, 95, 104, 1),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Icon(
                                  Icons.person_add,
                                  color: Color.fromRGBO(195, 118, 75, 1),
                                  size: 25,
                                ),
                              ]),
                            ]),
                          ),
                        ],
                      ),
                    ]),
                  )),
              onClosing: () {},
            ));
  }

  //Entscheidet sich der Nutzer dazu, das Metting zu teilen wird dieser BottomDialog aufgerufen.
  //Hier hat der Nutzer die Möglichkeit dem Meeting einen Namen zu geben und es in die Datenbank hochzuladen.
  showBottomDialog_Sharing() async {
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
                            margin: const EdgeInsets.all(20),
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
                                    borderSide: const BorderSide(),
                                  ),
                                  //fillColor: Colors.green
                                ),
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                )),
                          ),

                          InkWell(
                            onTap: () async {
                              if (topic.text != "") {
                                String partnerUsername = "";
                                if (scannedId != "") {
                                  partnerUsername = await DataBaseMethods()
                                      .getUsernameById(scannedId);
                                }
                                Position position =
                                    await _getGeoLocationPosition();
                                addMeeting(
                                    position.latitude,
                                    position.longitude,
                                    userName,
                                    partnerUsername,
                                    topic.text);
                                topic.text = "";
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.all(20),
                              alignment: Alignment.center,
                              height: 50,
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60.0),
                                color: const Color.fromRGBO(202, 170, 147, 1),
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
  //Dieser BottomDialog zeigt das Profil des Partners an und bietet die Möglichkeit einen Chat zu beginnen.
  showBottomDialog_connect(
      String partnerUsername,
      String partnerCompany,
      String myUserId,
      String myUsername,
      String partnerId,
      String skill1,
      String skill2,
      String skill3,
      String skill4,
      String startDate) async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => BottomSheet(
              builder: (context) => Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Wrap(children: [
                    Center(
                      child: Column(children: [
                        Stack(
                          children: [
                            UserImage(
                              onFileChanged: (profileImg) {
                                setState(() {});
                                this.profileImg = profileImg;
                              },
                              partnerUsername: partnerUsername,
                            ),
                            Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                  SizedBox(height: 100),
                                  Container(
                                    child: Text(
                                      partnerUsername,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(52, 95, 104, 1),
                                          fontSize: 22,
                                          letterSpacing: 10),
                                      // textAlign: TextAlign.left
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      partnerCompany,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(52, 95, 104, 1),
                                          fontSize: 12,
                                          letterSpacing: 18),
                                      // textAlign: TextAlign.left
                                    ),
                                  ),
                                  skill1 != ""
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(top: 30),
                                          child: Text(
                                            "• ${skill1}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(
                                                    52, 95, 104, 1),
                                                fontSize: 16,
                                                letterSpacing: 2),
                                            // textAlign: TextAlign.left
                                          ),
                                        )
                                      : Container(),
                                  skill2 != ""
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            "• ${skill2}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(
                                                    52, 95, 104, 1),
                                                fontSize: 16,
                                                letterSpacing: 2),
                                            // textAlign: TextAlign.left
                                          ),
                                        )
                                      : Container(),
                                  skill3 != ""
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            "• ${skill3}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(
                                                    52, 95, 104, 1),
                                                fontSize: 16,
                                                letterSpacing: 2),
                                            // textAlign: TextAlign.left
                                          ),
                                        )
                                      : Container(),
                                  skill4 != ""
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            "• ${skill4}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(
                                                    52, 95, 104, 1),
                                                fontSize: 16,
                                                letterSpacing: 2),
                                            // textAlign: TextAlign.left
                                          ),
                                        )
                                      : Container(),
                                  Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      alignment: Alignment.center,
                                      color: Colors.transparent,
                                      child: Wrap(children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: OutlinedButton(
                                            onPressed: () {},
                                            child: Text(
                                              'Treffen',
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      52, 95, 104, 1)),
                                            ),
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: OutlinedButton(
                                            onPressed: () {},
                                            child: Text(
                                              'Meet-Ups',
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      52, 95, 104, 1)),
                                            ),
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: OutlinedButton(
                                            onPressed: () {},
                                            child: Text(
                                              'Unternehmensführung',
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      52, 95, 104, 1)),
                                            ),
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ])),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: Text(
                                      "Dabei seit dem ${startDate}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(52, 95, 104, 1),
                                          fontSize: 16,
                                          letterSpacing: 2),
                                      // textAlign: TextAlign.left
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      Map<String, dynamic> chatRoomInfoMap = {
                                        "users": [myUsername, partnerUsername]
                                      };
                                      if (await DataBaseMethods()
                                              .getChatRoomIdByUsernames(
                                                  partnerUsername,
                                                  myUsername,
                                                  myUserId) ==
                                          "") {
                                        DataBaseMethods().createChatRoom(
                                            chatRoomInfoMap,
                                            myUserId,
                                            partnerId);
                                      }
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Chat(partnerUsername)));
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 50,
                                      width: 300,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(60.0),
                                        color: Color.fromRGBO(202, 170, 147, 1),
                                        // LinearGradient
                                      ),
                                      // BoxDecoration
                                      padding: const EdgeInsets.all(0),
                                      child: const Text(
                                        "Chat starten",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight:
                                                FontWeight.bold), // TextStyle
                                      ), // Text
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  )
                                ]))
                          ],
                        ),
                      ]),
                    )
                  ])),
              onClosing: () {},
            ));
  }

  /**
   * Diese Methode sorgt mit einem Aufruf einer Methode aus der Datenbankklasse
   * dafür, dass das Meeting der Datenbank hinzugefügt wird
   */
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


  /**
   * Diese Methode fragt beim Benutzer die Berechtigung an, den Standort des Handys zu benutzen.
   * Bei Erlaubnis liefert diese Methode die aktuelle Position.
   */
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

  /**
   * Diese Methode erzeugt die BottomNavigationBar
   */
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
                      color: Color.fromRGBO(225, 0, 5, 1),
                      size: 35,
                    )
                  : const Icon(
                      Icons.home_outlined,
                      color: Color.fromRGBO(225, 0, 5, 1),
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
                      color: Color.fromRGBO(225, 0, 5, 1),
                      size: 35,
                    )
                  : const Icon(
                      Icons.map_outlined,
                      color: Color.fromRGBO(225, 0, 5, 1),
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
                      color: Color.fromRGBO(225, 0, 5, 1),
                      size: 35,
                    )
                  : const Icon(
                      Icons.chat_bubble_outline_outlined,
                      color: Color.fromRGBO(225, 0, 5, 1),
                      size: 35,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/**
 * Diese Klasse sorgt für die gesamte Darstellung eines Profilbildes.
 */
class UserImage extends StatefulWidget {
  final Function(String profileImg) onFileChanged;

  String partnerUsername;

  UserImage({required this.onFileChanged, required this.partnerUsername});

  @override
  _UserImageState createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  String? profileImg;
  String partnerId = "";

  @override
  void initState() {
    getPartnerUserIdAndDownloadImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(children: [
        if (profileImg == null)
          SizedBox(
              height: 70,
              width: 70,
              child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    CircleAvatar(
                      backgroundColor: Color.fromRGBO(52, 95, 104, 1),
                      child: Text(widget.partnerUsername[0].substring(
                          0,
                          widget.partnerUsername[0].contains(" ")
                              ? widget.partnerUsername[0].indexOf(" ")
                              : widget.partnerUsername[0].length)),
                    ),
                  ])),
        if (profileImg != null)
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: SizedBox(
                height: 70,
                width: 70,
                child: Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    children: [
                      CircleAvatar(
                          backgroundColor: Color.fromRGBO(52, 95, 104, 1),
                          backgroundImage: Image.network(profileImg!).image),
                    ])), // AppRoundImage.url
          ),
      ]),
    );
  }

  /**
   * Diese Methode sorgt dafür, dass das Profilbild des Partners angezeigt werden kann.
   */
  void getPartnerUserIdAndDownloadImage() async {
    partnerId =
        await DataBaseMethods().getUserIdByUserName(widget.partnerUsername);
    var downloadURL = await StorageMethods().getProfileImg(partnerId);

    if (downloadURL != "") {
      setState(() {
        profileImg = downloadURL;
      });
      widget.onFileChanged(profileImg!);
    }
  }
}
