import 'package:buddy/helperfunctions/sharedpref_helper.dart';
import 'package:buddy/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/storage.dart';

/**
 * Diese Klasse stellt das Chatfenster mit einem Partner dar.
 * Es wird sich sowohl um die grafische Darstellung,
 * als auch um die logischen Aufrufe der entsprechenden Methoden gekümmert.
 *
 * @author Paul Franken winf104387
 */
class Chat extends StatefulWidget {
  final String partnerUsername;

  Chat(this.partnerUsername);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  //Die ID des aktuellen Chatrooms
  String chatRoomId = "";
  //Die DownloadURL zum Profilfotos des Chatpartners
  String? profileImg;

  //Alle Nachrichten als Stream
  Stream messageStream = const Stream.empty();
  //Informtionen zum eigenen Benutzer
  late String myName, myUserName, myEmail, myUserId;
  TextEditingController messageTextEditingController = TextEditingController();

  //Das Unternehmen des Partners
  String partnerCompany = "";

  /**
   * Bei dieser Methode werden einige Informationen von den Sharedpreferences geladen.
   */
  getMyInfoFormSharedPreferences() async {
    myName = (await SharedPreferencesHelper().getUserDisplayName())!;
    myUserName = (await SharedPreferencesHelper().getUserName())!;
    myEmail = (await SharedPreferencesHelper().getUserEmail())!;
    myUserId = (await SharedPreferencesHelper().getUserId())!;
    chatRoomId = await DataBaseMethods()
        .getChatRoomIdByUsernames(widget.partnerUsername, myUserName, myUserId);
  }

  /**
   * Bei diesem Widget handelt es sich um die grafische Darstellung einer einzelnen Nachricht.
   *
   * @params message Die Nachricht
   * @params sendByMe Dieser boolean gibt an, von welchem Benutzer die
   *         Nachricht geschickt wurde. Daruf basierend wird das Design der Nachricht angepasst.
   */
  Widget chatMessage(String message, bool sendByMe) {
    return Row(
        mainAxisAlignment:
            sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    bottomRight:
                        sendByMe ? Radius.circular(0) : Radius.circular(24),
                    topRight: Radius.circular(24),
                    bottomLeft:
                        sendByMe ? Radius.circular(24) : Radius.circular(0)),
                color: sendByMe
                    ? const Color.fromRGBO(225, 0, 5, 1)
                    : const Color.fromRGBO(0, 92, 169, 1)),
            padding: EdgeInsets.all(16),
            child: Text(
              message,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ]);
  }

  /**
   * Diese Widget ist die grafische Darstellung aller gesendeten Nachrichten.
   */
  Widget chatMessages() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 70, top: 16),
                itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                reverse: true,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds =
                      (snapshot.data! as QuerySnapshot).docs[index];
                  return chatMessage(ds["message"], myUserName == ds["sendBy"]);
                })
            :  Center(
                child: Container(),
              );
      },
    );
  }

  /**
   * Diese Methode wird beim Start des Fesnters aufgeruden und lädt aus der Datenbank die ChatroomId anhand der Nutzernamen.
   * Sollte die ChatroomId existieren, werden alle Nachrichten heruntergeladen.
   */
  getAndSetMessages() async {
    chatRoomId = await DataBaseMethods()
        .getChatRoomIdByUsernames(widget.partnerUsername, myUserName, myUserId);
    if (chatRoomId == "") {
      messageStream = Stream.empty();
    } else {
      messageStream =
          await DataBaseMethods().getChatRoomMessages(chatRoomId);
    }

    setState(() {});
  }

  /**
   * Diese Methode lädt das Unternehmen des Partners aus der Datenbank.
   */
  getPartnersCompany() async {
    partnerCompany =
        await DataBaseMethods().getPartnersCompany(widget.partnerUsername);
    setState(() {});
  }

  /**
   * Wenn der Nutzer auf senden drückt, sorgt diese Methode dafür,
   * dass die Nachricht an den Datenbankservice weitergegeben wird und somit hochgeladen wird.
   */
  addMessage() async{
    String message = messageTextEditingController.text;

    chatRoomId = await DataBaseMethods()
        .getChatRoomIdByUsernames(widget.partnerUsername, myUserName, myUserId);
    if (message != "") {

      var timeStamp = DateTime.now();

      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": myUserName,
        "timeStamp": timeStamp
      };

      DataBaseMethods().addMessage(chatRoomId, messageInfoMap).then((value) {});
    }
  }

  /**
   * Diese Methode wird beim Start des Fensters aufgerufen und sorgt dafür,
   * dass alle wichtigen Methoden zum Start ausgeführt werden.
   */
  doThisOnLaunch() async {
    await getMyInfoFormSharedPreferences();
    await getAndSetMessages();
    await getPartnersCompany();
  }

  /**
   * Die Methode die vom Frameowrk zum Start des Fensters aufgerufen wird.
   */
  @override
  void initState() {
    doThisOnLaunch();
    super.initState();
  }

  /**
   * Die build Methode leifert ein Widget für den gesamten Screen.
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.black,
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                //Das Profilbild es Partners
                UserImage(
                    onFileChanged: (profileImg) {
                      setState(() {});
                      this.profileImg = profileImg;
                    },
                    partnerUsername: widget.partnerUsername),
                SizedBox(
                  width: 12,
                ),
                //Der Name und das Unternehmen des Partners
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.partnerUsername,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        partnerCompany,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
          color: Color.fromRGBO(250, 250, 250, 1),
          child: Stack(
            children: [
              chatMessages(),
              Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                      height: 60,
                      width: double.infinity,
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: TextField(
                              controller: messageTextEditingController,
                              decoration: InputDecoration(
                                  hintText: "Nachricht",
                                  hintStyle: TextStyle(color: Colors.black54),
                                  border: InputBorder.none),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          //Dieser Button führt de Aktion des Sendens einer Nachricht aus.
                          FloatingActionButton(
                            onPressed: () {
                              addMessage();
                              messageTextEditingController.text = "";
                              setState(() {});
                            },
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 18,
                            ),
                            backgroundColor: Colors.black,
                            elevation: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
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

  /**
   * Die Methode die vom Frameowrk zum Start des Fensters aufgerufen wird.
   */
  @override
  void initState() {
    getPartnerUserIdAndDownloadImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(children: [
        if (profileImg == null)
          SizedBox(
              height: 35,
              width: 35,
              child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.black87,
                      child: Text(widget.partnerUsername.substring(
                          0,
                          widget.partnerUsername.contains(" ")
                              ? widget.partnerUsername.indexOf(" ")
                              : widget.partnerUsername.length)),
                    ),
                  ])),
        if (profileImg != null)
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: SizedBox(
                height: 35,
                width: 35,
                child: Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    children: [
                      CircleAvatar(
                          backgroundColor: Colors.black87,
                          backgroundImage: Image.network(profileImg!).image),
                    ])), // AppRoundImage.url
          ),
      ]),
    );
  }

  /**
   * Diese Methode sorgt dafür, dass das Profilbild des Partners angezeigt werden kann
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
