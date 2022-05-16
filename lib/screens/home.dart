import 'dart:developer';

import 'package:buddy/screens/sign_in.dart';
import 'package:buddy/services/auth.dart';
import 'package:buddy/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../helperfunctions/sharedpref_helper.dart';
import 'chat.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String myName, myUserName, myEmail, myUserId;
  bool isSearching = false;
  Stream? usersStream;
  TextEditingController searchEditingController = TextEditingController();

  onSearchBtnClick() async {
    usersStream =
        await DataBaseMethods().getUserByUsername(searchEditingController.text);
    isSearching = true;
    setState(() {});
  }



  Widget chatList() {
    return Container();
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

  Widget searchListUser(String name, String email, String username) {
    return GestureDetector(
      onTap: () {
        var chatRoomId = getChatRoomIdByUsernames(myUserName, username);
        Map<String, dynamic> chatRoomInfoMap = {
          "users" : [myUserName, username]
        };
        DataBaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap, myUserId);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Chat(username, name)));
      },
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: const Icon(Icons.email),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(name), Text(email)],
          )
        ],
      ),
    );
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
                  return searchListUser(ds["name"], ds["email"], ds["username"]);
                },
              )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  void initState() {
    log("DATA");
    getMyInfoFormSharedPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buddy App'),
        actions: [
          GestureDetector(
            onTap: () {
              AuthMethods().signOut().then((value) => Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => SignIn())));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
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
                            }else {
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
          )),
    );
  }
}
