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
  late String myName, myUserName, myEmail, myUserId;
  TextEditingController messageTextEditingController = TextEditingController();

  getMyInfoFormSharedPreferences() async {
    myName = (await SharedPreferencesHelper().getUserDisplayName())!;
    myUserName = (await SharedPreferencesHelper().getUserName())!;
    myEmail = (await SharedPreferencesHelper().getUserEmail())!;
    myUserId = (await SharedPreferencesHelper().getUserId())!;
    //chatRoomId = getChatRoomIdByUsernames(widget.username, myUserName);
  }

  getChatRoomIdByUsernames(String userA, String userB) {
    if (userA.substring(0, 1).codeUnitAt(0) >
        userB.substring(0, 1).codeUnitAt(0)) {
      return "$userB\_$userA";
    } else {
      return "$userA\_$userB";
    }
  }

  Widget chatMessage(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment: sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
      Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
            bottomRight: sendByMe? Radius.circular(0): Radius.circular(24),
            topRight: Radius.circular(24),
            bottomLeft:  sendByMe ? Radius.circular(24): Radius.circular(0)),
            color: Colors.amberAccent),
        padding: EdgeInsets.all(16),
        child: Text(
          message,
          style: const TextStyle(color: Colors.black),
        ),

      ),
    ]);
  }

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
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  getAndSetMessages() async {
    //messageStream = await DataBaseMethods().getChatRoomMessages(chatRoomId, myUserId);
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

      DataBaseMethods().addMessage(chatRoomId, messageInfoMap, myUserId).then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTs": timeStamp,
          "lastMessageSendBy": myUserName
        };

        DataBaseMethods().updateLastMessageSend(chatRoomId, lastMessageInfoMap, myUserId);
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
