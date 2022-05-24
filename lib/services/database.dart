import 'dart:developer';
import 'package:buddy/helperfunctions/sharedpref_helper.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods {
  Future<String> checkIfAccountExists(String accountId) async {
    String result = "";
    final userRef = FirebaseFirestore.instance.collection('users');
    await userRef.get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        if (doc.get("accountid").toString() == accountId) {
          result = doc.get("userid");
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
        .where("username", isEqualTo: username)
        .snapshots();
  }

  Future addMessage(String chatRoomId, Map<String, dynamic> messageInfo) async {
    log("DB: AddMessage");
    return FirebaseFirestore.instance
        .collection("chatrooms")
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
      await FirebaseFirestore.instance
          .collection("users")
          .doc(myUserId)
          .collection("chats")
          .doc(uuid)
          .set(chatRoomInfoMap);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(partnerUserId)
          .collection("chats")
          .doc(uuid)
          .set(chatRoomInfoMap);
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(uuid)
          .set(chatRoomInfoMap);
    }
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(
      String chatRoomId, String myUserId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timeStamp", descending: true)
        .snapshots();
  }

  Future<String> getChatRoomIdByUsernames(
      String partnerUsername, String myUserName, String myUserId) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .doc(myUserId)
        .collection('chats')
        .get();
    final List<DocumentSnapshot> documents = result.docs;

    String documentId = "";

    documents.forEach((snapshot) {
      if ((snapshot.get("users")[0].toString() == myUserName &&
              snapshot.get("users")[1].toString() == partnerUsername) ||
          (snapshot.get("users")[1].toString() == myUserName &&
              snapshot.get("users")[0].toString() == partnerUsername)) {
        documentId = snapshot.id;
        return;
      }
    });
    return documentId;
  }

  saveUserInformationFromOnlineLocal(String userId) async {
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(userId).get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data()!;

      // You can then retrieve the value from the Map like this:
      SharedPreferencesHelper().saveAccountId(data["accountid"]);
      SharedPreferencesHelper().saveUserCompany(data["company"]);
      SharedPreferencesHelper().saveUserEmail(data["email"]);
      SharedPreferencesHelper().saveUserGuide(data["guide"]);
      SharedPreferencesHelper().saveUserMeet(data["meet"]);
      SharedPreferencesHelper().saveUserDisplayName(data["name"]);
      SharedPreferencesHelper().saveUserMeetUp(data["official_meet"]);
      SharedPreferencesHelper().saveUserSkills(data["skills"]);
      SharedPreferencesHelper().saveUserStartDate(
          DateTime.parse(data["startDate"].toDate().toString()));
      SharedPreferencesHelper().saveUserId(data["userid"]);
      SharedPreferencesHelper().saveUserName(data["username"]);
    }
  }

  getAllChats(String myUserId) {
    log("DB: GetAllChats");
    return FirebaseFirestore.instance
        .collection("users")
        .doc(myUserId)
        .collection("chats")
        .snapshots();
  }
}
