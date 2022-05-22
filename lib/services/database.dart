import 'dart:developer';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods {
  Future<bool> checkIfAccountExists(String accountId) async {
    bool result = false;
    final userRef = FirebaseFirestore.instance.collection('users');
    await userRef.get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        if(doc.get("userid").toString() == accountId){
          result = true;
        }
      });
    });
    return result;
  }

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

  createChatRoom(Map<String, dynamic> chatRoomInfoMap, String myUserId,
      String partnerUserId) async {
    log("DB: createChatRoom");
    var uuidGenerator = const Uuid();
    var uuid = uuidGenerator.v4();
    final snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(uuid)
        .get();
    if (snapshot.exists) {
      return true;
    } else {
      //Add Chat to both users
      FirebaseFirestore.instance
          .collection("users")
          .doc(myUserId)
          .collection("chats")
          .doc(uuid)
          .set(chatRoomInfoMap);
      FirebaseFirestore.instance
          .collection("users")
          .doc(partnerUserId)
          .collection("chats")
          .doc(uuid);
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(uuid)
          .set(chatRoomInfoMap);
    }
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(
      String chatRoomId, String myUserId) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(myUserId)
        .collection("chats")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timeStamp", descending: true)
        .snapshots();
  }
}
