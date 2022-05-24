import 'dart:io';

import 'package:buddy/screens/createProfile.dart';
import 'package:buddy/services/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../helperfunctions/sharedpref_helper.dart';
import '../services/database.dart';
import 'chat.dart';

class ChatOverview extends StatefulWidget {
  @override
  _ChatOverview createState() => _ChatOverview();
}

class _ChatOverview extends State<ChatOverview> {
  bool isSearching = false;
  TextEditingController searchEditingController = TextEditingController();
  Stream? usersStream;
  Stream? chatStream;
  late String myName, myUserName, myEmail, myUserId;

  @override
  void initState() {
    getMyInfoFormSharedPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(children: [
                  isSearching
                      ? Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: GestureDetector(
                              onTap: () {
                                isSearching = false;
                                searchEditingController.clear();
                                setState(() {});
                              },
                              child: const Icon(Icons.arrow_back)))
                      : Container(),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(24)),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextField(
                            onChanged: (text) {
                              if (text == "") {
                                isSearching = false;
                                searchEditingController.clear();
                                setState(() {});
                              } else {
                                onSearchBtnClick();
                              }
                            },
                            controller: searchEditingController,
                            decoration: const InputDecoration(
                                border: InputBorder.none, hintText: "Username"),
                          )),
                          GestureDetector(child: const Icon(Icons.search))
                        ],
                      ),
                    ),
                  ),
                ]),
                isSearching ? searchUsersList() : chatList()
              ],
            )));
  }

  Widget searchUsersList() {
    return StreamBuilder(
      stream: usersStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds =
                      (snapshot.data! as QuerySnapshot).docs[index];
                  return searchListUser(
                      ds["name"], ds["email"], ds["username"], ds["userid"]);
                },
              )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget searchListUser(
      String name, String email, String partnerUsername, String partnerUserId) {
    return GestureDetector(
      onTap: () async {
        Map<String, dynamic> chatRoomInfoMap = {
          "users": [myUserName, partnerUsername]
        };
        if (await DataBaseMethods().getChatRoomIdByUsernames(
                partnerUsername, myUserName, myUserId) ==
            "") {
          DataBaseMethods()
              .createChatRoom(chatRoomInfoMap, myUserId, partnerUserId);
        }
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Chat(partnerUsername)));
      },
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: const Icon(Icons.email),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(name), Text(email)],
          )
        ],
      ),
    );
  }

  Widget chatList() {
    return StreamBuilder(
      stream: chatStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds =
                      (snapshot.data! as QuerySnapshot).docs[index];
                  return ChatWidget(
                      partnerUsername: ds["users"][1] == myUserName
                          ? ds["users"][0]
                          : ds["users"][1],
                      myUserId: myUserId,
                      chatRoomId: ds.id);
                },
              )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  getMyInfoFormSharedPreferences() async {
    myName = (await SharedPreferencesHelper().getUserDisplayName())!;
    myUserName = (await SharedPreferencesHelper().getUserName())!;
    myEmail = (await SharedPreferencesHelper().getUserEmail())!;
    myUserId = (await SharedPreferencesHelper().getUserId())!;
    chatStream = await DataBaseMethods().getAllChats(myUserId);
    setState(() {});
  }

  onSearchBtnClick() async {
    usersStream =
        await DataBaseMethods().getUserByUsername(searchEditingController.text);
    isSearching = true;
    setState(() {});
  }
}

class ChatWidget extends StatefulWidget {
  String partnerUsername, myUserId, chatRoomId;

  ChatWidget(
      {required this.partnerUsername,
      required this.myUserId,
      required this.chatRoomId});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<ChatWidget> {
  String? profileImg;
  String lastMessage = "";
  String lastTimeStamp = "";

  @override
  void initState() {
    getLastMessage();
    super.initState();
  }

  getLastMessage() async {
    Map<String, dynamic> lastInfo = await DataBaseMethods()
        .getLastMessageOfChatRoom(widget.chatRoomId);
    lastMessage = lastInfo["message"];
    Timestamp t = lastInfo["time"];

    DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
    if (t.toDate().day == yesterday.day) {
      lastTimeStamp = "Gestern";
    } else {
      var format = DateFormat('hh:mm a');
      lastTimeStamp = format.format(t.toDate());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Chat(widget.partnerUsername)))
            .then((value) => {getLastMessage(), setState(() {})});
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
                  name: widget.partnerUsername,
                  userid: widget.myUserId),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.partnerUsername,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    lastMessage.length > 25
                        ? lastMessage.substring(0, 25) + '...'
                        : lastMessage,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ],
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(
              lastTimeStamp,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            /*const Icon(
              Icons.new_releases_rounded,
              color: Color(0xFF198BAA),
              size: 35,
            )
             */
          ]),
        ],
      ),
    );
  }
}

class UserImage extends StatefulWidget {
  final Function(String profileImg) onFileChanged;

  String userid, name;

  UserImage(
      {required this.onFileChanged, required this.name, required this.userid});

  @override
  _UserImageState createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  String? profileImg;

  @override
  void initState() {
    downloadImage();
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
              height: 60,
              width: 60,
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
                  ])),
        if (profileImg != null)
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: SizedBox(
                height: 60,
                width: 60,
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

  Future downloadImage() async {
    print(widget.userid);
    var downloadURL = await StorageMethods().getProfileImg(widget.userid);
    if (downloadURL != "") {
      setState(() {
        profileImg = downloadURL;
      });
      widget.onFileChanged(profileImg!);
    }
  }
}
