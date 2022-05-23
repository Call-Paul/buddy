import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  Widget chatList() {
    return Container();
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
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(partnerUsername, name)));
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

  getMyInfoFormSharedPreferences() async {
    myName = (await SharedPreferencesHelper().getUserDisplayName())!;
    myUserName = (await SharedPreferencesHelper().getUserName())!;
    myEmail = (await SharedPreferencesHelper().getUserEmail())!;
    myUserId = (await SharedPreferencesHelper().getUserId())!;
  }

  getChatRoomIdByUsernames(String userA, String userB) {
    if (userA.substring(0, 1).codeUnitAt(0) >
        userB.substring(0, 1).codeUnitAt(0)) {
      return "$userB\_$userA";
    } else {
      return "$userA\_$userB";
    }
  }

  onSearchBtnClick() async {
    usersStream =
        await DataBaseMethods().getUserByUsername(searchEditingController.text);
    isSearching = true;
    setState(() {});
  }
}
