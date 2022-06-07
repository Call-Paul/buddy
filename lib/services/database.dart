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

  Future<Map<String, dynamic>> getLastMessageOfChatRoom(
      String chatRoomId) async {
    QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore
        .instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timeStamp", descending: true)
        .limit(1)
        .get();

    Map<String, dynamic> lastMessage = {};
    if (result.docs.isNotEmpty) {
      Map collection = result.docs.first.data();
      lastMessage["message"] = collection["message"];
      lastMessage["time"] = collection["timeStamp"];
    }
    return lastMessage;
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

  Future<String> getUserIdByUserName(String userName) async {
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('users').get();
    final List<DocumentSnapshot> documents = result.docs;

    String documentId = "";

    documents.forEach((snapshot) {
      if ((snapshot.get("username").toString() == userName)) {
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
      await SharedPreferencesHelper().saveAccountId(data["accountid"]);
      await SharedPreferencesHelper().saveUserCompany(data["company"]);
      await SharedPreferencesHelper().saveUserEmail(data["email"]);
      await SharedPreferencesHelper().saveUserGuide(data["guide"]);
      await SharedPreferencesHelper().saveUserMeet(data["meet"]);
      await SharedPreferencesHelper().saveUserDisplayName(data["name"]);
      await SharedPreferencesHelper().saveUserMeetUp(data["official_meet"]);
      await SharedPreferencesHelper().saveUserSkills(data["skills"]);
      await SharedPreferencesHelper().saveUserStartDate(
          DateTime.parse(data["startDate"].toDate().toString()));
      await SharedPreferencesHelper().saveUserId(data["userid"]);
      await SharedPreferencesHelper().saveUserName(data["username"]);
      await SharedPreferencesHelper().saveUserMode(data["userMode"]);

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

  Future<String> getPartnersCompany(String partnerUsername) async {
    String userId = await getUserIdByUserName(partnerUsername);
    DocumentSnapshot<Map<String, dynamic>> result =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();
    String company = "";
    if (result.exists) {
      company = result.get("company");
    }
    return company;
  }

  Future<String> getUsernameById(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> result =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();
    String username = "";
    if (result.exists) {
      username = result.get("username");
    }
    return username;
  }

  addMeeting(Map<String, dynamic> meetingDetails) async {
    log("DB: addMeeting");
    var uuidGenerator = const Uuid();
    var uuid = uuidGenerator.v4();
    final snapshot =
        await FirebaseFirestore.instance.collection("meetings").doc(uuid).get();
    if (snapshot.exists) {
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection("meetings")
          .doc(uuid)
          .set(meetingDetails);
    }
  }

  getMeetingMarker() {
    final Stream<QuerySnapshot> stream =
        FirebaseFirestore.instance.collection('meetings').snapshots();
    return stream;
  }

  getCompanyList() {
    final Stream<QuerySnapshot> stream =
        FirebaseFirestore.instance.collection('companys').snapshots();
    return stream;
  }

  Future<Stream<QuerySnapshot>> getBuddysForCompany(
      String companyId, String ownId) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("companyId", isEqualTo: companyId)
        .where("userid", isNotEqualTo: ownId)
        .where("userMode", isEqualTo: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getBuddysForIndustry(
      String companyId, String ownId) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("industryId", isEqualTo: companyId)
        .where("userid", isNotEqualTo: ownId)
        .where("userMode", isEqualTo: true)
        .snapshots();
  }

  Future<String> getFieldFromUser(String field, String userId) async {
    DocumentSnapshot<Map<String, dynamic>> resultQ =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();
    String result = "";
    if (resultQ.exists) {
      result = resultQ.get(field);
    }
    return result;
  }

  getAllCompanys() {
    getData() async {
      return await FirebaseFirestore.instance.collection("companys").get();
    }

    List<String> companys = List.empty(growable: true);
    getData().then((val) {
      for (var element in val.docs) {
        companys.add(element.data()["name"]);
      }
    });
    return companys;
  }

  getCompanyId(String companyName) async {
    QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore
        .instance
        .collection("companys")
        .where("name", isEqualTo: companyName)
        .snapshots().first;
    if(result.docs.first.exists) {
      return result.docs.first.id;
    }
  }

  getIndustryList() {
    final Stream<QuerySnapshot> stream =
    FirebaseFirestore.instance.collection('industry').snapshots();
    return stream;
  }

  getAllIndustrys() {
    getData() async {
      return await FirebaseFirestore.instance.collection("industry").get();
    }

    List<String> industrys = List.empty(growable: true);
    getData().then((val) {
      for (var element in val.docs) {
        industrys.add(element.data()["name"]);
      }
    });
    return industrys;
  }

  getIndustryId(String industryName)async {
    QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore
        .instance
        .collection("industry")
        .where("name", isEqualTo: industryName)
        .snapshots().first;
    if(result.docs.first.exists) {
      return result.docs.first.id;
    }
  }

  setMode(int index, String userId) {
    Map<String, bool> userInfoMap = Map();
    userInfoMap["userMode"] = index == 0 ? true: false;
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .update(userInfoMap);
  }
}
