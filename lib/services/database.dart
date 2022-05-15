import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods {
  Future addUserInfoToDB(
      String userId, Map<String, dynamic> userInfoMap) async {
    log("DB: AddUser");
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getUserByUsername(String username) async {
    log("DB: GestUser");
    return FirebaseFirestore.instance
        .collection("users")
        .where("username", isGreaterThan: username)
        .snapshots();
  }

  Future addMessage(String chatRoomId, Map<String, dynamic> messageInfo,
      String myUserId) async {
    log("DB: AddMessage");
    return FirebaseFirestore.instance
        .collection("users")
        .doc(myUserId)
        .collection("chats")
        .doc(chatRoomId)
        .collection("messages")
        .doc()
        .set(messageInfo);
  }

  updateLastMessageSend(String chatRoomId, Map<String, dynamic> lastMessageInfo,
      String myUserId) {
    log("DB: UpdateLast");
    return FirebaseFirestore.instance
        .collection("users")
        .doc(myUserId)
        .collection("chats")
        .doc(chatRoomId)
        .update(lastMessageInfo);
  }

  createChatRoom(String chatRoomId, Map<String, dynamic> chatRoomInfoMap,
      String myUserId) async {
    log("DB: createChatRoom");
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(myUserId)
        .collection("chats")
        .doc(chatRoomId)
        .get();
    if (snapshot.exists) {
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection("users")
          .doc(myUserId)
          .collection("chats")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(
      String chatRoomId, String myUserId) async {
    log("getChatRoomMessages");
    return FirebaseFirestore.instance
        .collection("users")
        .doc(myUserId)
        .collection("chats")
        .doc(chatRoomId).collection("messages")
        .orderBy("timeStamp", descending: true)
        .snapshots();
  }
}
