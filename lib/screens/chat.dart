import 'package:buddy/helperfunctions/sharedpref_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final String username, name;

  Chat(this.username, this.name);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late String chatRoomId, messageId = "";
  late String myName, myUserName, myEmail;

  getMyInfoFormSharedPreferneces() async {
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
      "$userA\_$userB";
    }
  }

  getAndSetMessages() async {}


  addMessage(){

  }

  doThisOnLaunch() async {
    await getMyInfoFromSharedPreferences();
    getAndSetMessages();
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
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                color: Colors.amberAccent,
                child: Row(
              children: const [
                Expanded(
                    child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "type a text"),
                )),
                Icon(Icons.send)
              ],
            )),
          )
        ],
      )),
    );
  }

  getMyInfoFromSharedPreferences() {}
}
