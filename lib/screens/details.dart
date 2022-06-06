import 'package:buddy/helperfunctions/sharedpref_helper.dart';
import 'package:buddy/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/storage.dart';
import 'chat.dart';

class DetailsPage extends StatefulWidget {
  String text, link, imgURL, companyId, name;

  DetailsPage(
      {required this.text,
      required this.link,
      required this.imgURL,
      required this.companyId,
      required this.name});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Stream? buddyStream;
  String myUserId = "";

  @override
  void initState() {
    doBeforeLaunch();
    super.initState();
  }

  doBeforeLaunch() async {
    myUserId = (await SharedPreferencesHelper().getUserId())!;
    buddyStream = await DataBaseMethods().getBuddysForCompany(widget.companyId, myUserId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return PageView(
      controller: controller,
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        Scaffold(
          body: Container(
            color: Colors.white,
            child: SafeArea(
              child: Stack(children: [
                Column(children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: Image.network(
                        widget.imgURL,
                        fit: BoxFit.fill,
                        height: 200.0,
                        width: double.infinity,
                      ),
                      // BoxDecoration
                    ),
                    margin: EdgeInsets.only(
                        left: 10, top: 50, right: 10, bottom: 20),
                  ),
                  Container(
                    child: Text(
                      widget.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(52, 95, 104, 1),
                          fontSize: 22,
                          letterSpacing: 10),
                      // textAlign: TextAlign.left
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      widget.text,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(52, 95, 104, 1),
                        fontSize: 15,
                      ),
                      // textAlign: TextAlign.left
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      var urllaunchable = await canLaunch(
                          widget.link); //canLaunch is from url_launcher package
                      if (urllaunchable) {
                        await launch(widget
                            .link); //launch is from url_launcher package to launch URL
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 20),
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
                        "Jobs",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontWeight: FontWeight.bold), // TextStyle
                      ), // Text
                    ),
                  ),
                ]),
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: AppBar(
                    centerTitle: true,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Color.fromRGBO(195, 118, 75, 1)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    title: const Text(
                      "Informationen",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(52, 95, 104, 1),
                          fontSize: 22,
                          letterSpacing: 2),
                      // textAlign: TextAlign.left
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
        Container(
          child: Scaffold(
            body: SafeArea(
                child: Stack(children: [
              Column(children: [
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
                    child: searchUsersList())
              ]),
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: AppBar(
                  centerTitle: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Color.fromRGBO(195, 118, 75, 1)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: const Text(
                    "Buddys",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(52, 95, 104, 1),
                        fontSize: 22,
                        letterSpacing: 2),
                    // textAlign: TextAlign.left
                  ),

                  backgroundColor: Colors.transparent,
                  elevation: 0.0, //No shadow
                ),
              ),
            ])),
          ),
        ),
      ],
    );
  }

  Widget searchUsersList() {
    return StreamBuilder(
      stream: buddyStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Container();
                  DocumentSnapshot ds =
                      (snapshot.data! as QuerySnapshot).docs[index];
                  //print(ds["companyId"] == widget.companyId);
                  return SearchListItem(
                    partnerUsername: ds.get("username"),
                  );
                },
              )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class SearchListItem extends StatefulWidget {
  String partnerUsername;

  SearchListItem({required this.partnerUsername});

  @override
  _SearchListItemState createState() => _SearchListItemState();
}

class _SearchListItemState extends State<SearchListItem> {
  String? profileImg;
  String partnerUserId = "";
  String partnerCompany = "";
  String myUserId = "";
  String partnerSkill1 = "";
  String partnerSkill2 = "";
  String partnerSkill3 = "";
  String partnerSkill4 = "";
  String myUserName = "";


  getPartnersCompany() async {
    partnerCompany =
        await DataBaseMethods().getPartnersCompany(widget.partnerUsername);
    setState(() {});
  }

  doBeforeInit() async {
    partnerUserId =
        await DataBaseMethods().getUserIdByUserName(widget.partnerUsername);
    var skills = await DataBaseMethods().getFieldFromUser("skills", partnerUserId);
    var array = skills.split("|");
    partnerSkill1 = array[0];
    partnerSkill2 = array[1];
    partnerSkill3 = array[2];
    partnerSkill4 = array[3];
    myUserName = (await SharedPreferencesHelper().getUserName())!;
    myUserId = (await SharedPreferencesHelper().getUserId())!;
    await getPartnersCompany();
  }

  @override
  void initState() {
    doBeforeInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        showBottomDialog();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              UserImage(
                  onFileChanged: (profileImg) {
                    setState(() {});
                    this.profileImg = profileImg;
                  },
                  partnerUsername: widget.partnerUsername),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.partnerUsername,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(52, 95, 104, 1),
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    partnerCompany,
                    style: TextStyle(
                        color: Color.fromRGBO(95, 152, 161, 1), fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  showBottomDialog() async {
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
                              partnerUsername: widget.partnerUsername,
                            ),
                            Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                  SizedBox(height: 100),
                                  Container(
                                    child: Text(
                                      widget.partnerUsername,
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

                                  partnerSkill1 != ""
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(top: 30),
                                          child: Text(
                                            "• ${partnerSkill1}",
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
                                  partnerSkill2 != ""
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            "• ${partnerSkill2}",
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
                                  partnerSkill3 != ""
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            "• ${partnerSkill3}",
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
                                  partnerSkill4 != ""
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            "• ${partnerSkill4}",
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

                                  InkWell(
                                    onTap: () async {

                                      Map<String, dynamic> chatRoomInfoMap = {
                                        "users": [myUserName, widget.partnerUsername]
                                      };
                                      if (await DataBaseMethods().getChatRoomIdByUsernames(
                                      widget.partnerUsername, myUserName, myUserId) ==
                                      "") {
                                      DataBaseMethods()
                                          .createChatRoom(chatRoomInfoMap, myUserId, partnerUserId);
                                      }
                                      Navigator.pop(context);
                                      Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                      builder: (context) => Chat(widget.partnerUsername)));
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
                                      SizedBox(height: 20,)
                                ]))
                          ],
                        ),
                      ]),
                    )
                  ])),
              onClosing: () {},
            ));
  }
}

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
                      child: Text(widget.partnerUsername[0]),
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
