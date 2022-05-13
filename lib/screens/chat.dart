import 'dart:developer';

import 'package:buddy/helperfunctions/sharedpref_helper.dart';
import 'package:buddy/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final String username, name;

  Chat(this.username, this.name);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late String chatRoomId;
  Stream messageStream = const Stream.empty();
  late String myName, myUserName, myEmail;
  TextEditingController messageTextEditingController = TextEditingController();

  getMyInfoFormSharedPreferences() async {
    myName = (await SharedPreferencesHelper().getUserDisplayName())!;
    myUserName = (await SharedPreferencesHelper().getUserName())!;
    myEmail = (await SharedPreferencesHelper().getUserEmail())!;
    chatRoomId = getChatRoomIdByUsernames(widget.username, myUserName);
  }

  getChatRoomIdByUsernames(String userA, String userB) {
    if (userA.substring(0, 1).codeUnitAt(0) >
        userB.substring(0, 1).codeUnitAt(0)) {
      return "$userB\_$userA";
    } else {
      return "$userA\_$userB";
    }
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds =
                      (snapshot.data! as QuerySnapshot).docs[index];
                  return Text(ds["message"]);
                })
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  getAndSetMessages() async {
    messageStream = await DataBaseMethods().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  addMessage() {
    if (messageTextEditingController.text != "") {
      String message = messageTextEditingController.text;

      var timeStamp = DateTime.now();

      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": myUserName,
        "timeStamp": timeStamp
      };

      DataBaseMethods().addMessage(chatRoomId, messageInfoMap).then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTs": timeStamp,
          "lastMessageSendBy": myUserName
        };

        DataBaseMethods().updateLastMessageSend(chatRoomId, lastMessageInfoMap);
      });
    }
  }

  doThisOnLaunch() async {
    await getMyInfoFormSharedPreferences();
    await getAndSetMessages();
  }

  @override
  void initState() {
    doThisOnLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: Container(
          child: Stack(
        children: [
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                color: Colors.amberAccent,
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: messageTextEditingController,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: "type a text"),
                    )),
                    GestureDetector(
                        onTap: () {
                          addMessage();
                          log("HI");
                        },
                        child: const Icon(Icons.send))
                  ],
                )),
          )
        ],
      )),
    );
  }
}
