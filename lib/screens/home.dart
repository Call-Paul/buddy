import 'package:buddy/screens/sign_in.dart';
import 'package:buddy/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buddy App'),
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
