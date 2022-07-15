import 'dart:developer';
import 'package:buddy/helperfunctions/sharedpref_helper.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/**
 * Mit dieser Klasse wird die Verbindung zur Datenbank in Firebase gesteuert.
 * Alle Anfragen werden von den Methoden dieser Klasse vorgenommen.
 *
 * @author Paul Franken winf104387
 */
class DataBaseMethods {

  /**
   * Diese Methode überprüft, ob es bereits ein Nutzer mit der übergebenen GoogleId gibt.
   *
   * @param die GoogleId die überprüft werden soll.
   * @return ein String, der nicht leer ist, wenn ein Nutzer existiert.
   */
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

  /**
   * Diese Methode legt in der Datenbank in der Tabelle "Users" einen neuen Nutzer an.
   *
   * @param userInfoMap eine Map, die alle Informationen für einen neuen Nutzer enthält.
   */
  addUserInfoToDB(
      String userId, Map<String, dynamic> userInfoMap) async {
    log("DB: AddUser");
    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userInfoMap);
  }

  /**
   * Diese Methode liefert den Nutzer, der sich zu dem übergebenem Nutzernamen passt.
   *
   * @params username Der Nutzername, zu dem der Nutzer gefunden werden soll.
   * @return der Nutzer als QuerySnapshot
   */
  Future<Stream<QuerySnapshot>> getUserByUsername(String username) async {
    log("DB: GetUser");
    return FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .snapshots();
  }

  /**
   * Diese Methode fügt einem Chatroom eine neue Nachricht hinzu.
   *
   * @param chatRoomId Der Chatroom, der die Nachricht hinzgefügt werden soll.
   * @param messageInfo Die Nachricht mit weiteren Informationen in Form einer Map.
   */
  addMessage(String chatRoomId, Map<String, dynamic> messageInfo) async {
    log("DB: AddMessage");
    FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("messages")
        .doc()
        .set(messageInfo);
  }

  /**
   * Diese Methode legt einen neuen Chatraum an und fügt beiden Nutzern
   * die Information in ihren Profilen hinzu.
   *
   * @params chatRoomInfoMap Informationen für den neuen Chatroom.
   * @params myUserId Die Nutzerid des angemeldeten Nutzers.
   * @params  partneruserid Die Nutzerid des Chatpartners.
   */
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

  /**
   * Diese Methode liefert alle Nachrichten eines Chatrooms.
   * 
   * @param chatRoomId der Chatroom von dem die Nachrichten geladen werden sollen.
   * @return alle Nachrichten als Stream
   */
  Future<Stream<QuerySnapshot>> getChatRoomMessages(
      String chatRoomId) async {
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .collection("messages")
          .orderBy("timeStamp", descending: true)
          .snapshots();

  }

  /**
   * Diese Methode liefert lediglich die letzte Nachricht eines Chatrooms.
   * 
   *  @param chatRoomId der Chatroom von dem die letzte Nachricht geladen werden sollen. 
   *  @return die letzte Nachricht
   */
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

  /**
   * Diese Methode liefert die ChatroomId anhand der beiden Nutzernamen der Teilnehmer.
   * 
   * @param partnerUsername der Nutzername des Partners
   * @param myUserName der eigene Nutzername
   * @param myUserId die eigene Nutzerid
   * @return die ChatroomId, falls nicht vorhanden ist dies ein leerer String
   */
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

  /**
   * Diese Methode liefert die UserId für den übergebenen Nutzernamen.
   * 
   * @parm userName der Nutzername zu dem die Id gefunden werden soll.
   * @return die UserId die zum Nutzernamen passt.
   */
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

  /**
   * Mit dieser Methode werden alle Information die Online zu dem Profilgespeichert sin
   * offline in den SharedPreferences gespeichert.
   * 
   * @param die eigene UserId
   */
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

  /**
   * Mit dieser Methode werden alle Chats für einen Nutzer geladen
   * 
   * @param myUserId die eigene UserId
   * @return die Informationen aller Chaträume als Stream
   */
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllChats(String myUserId) {
    log("DB: GetAllChats");
    return FirebaseFirestore.instance
        .collection("users")
        .doc(myUserId)
        .collection("chats")
        .snapshots();
  }

  /**
   * Diese Methode liefert das Unternehmen das in einem Profil gespeichert ist.
   * 
   * @param username der Nutzername zu dem das Unternehmen gefunden werden soll
   * @return der Name des Unternehmens
   */
  Future<String> getPartnersCompany(String username) async {
    String userId = await getUserIdByUserName(username);
    DocumentSnapshot<Map<String, dynamic>> result =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();
    String company = "";
    if (result.exists) {
      company = result.get("company");
    }
    return company;
  }

  /**
   * Diese Methode liefert den Nutzernamen für die übergebene UserId.
   *
   * @parm userId die UserId zu dem der Nutzername gefunden werden soll.
   * @return der Nutzername der zur UserId passt passt.
   */
  Future<String> getUsernameById(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> result =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();
    String username = "";
    if (result.exists) {
      username = result.get("username");
    }
    return username;
  }


  /**
   * Diese Methode fügt der Tabelle "Mettings" ein neues Treffen hinzu.
   *
   * @params meetingDetails die Meetinginformationen
   */
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

  /**
   * Diese Methode liefert alle gespeicherten Meetings als Stream.
   * 
   * @return alle Meetings als Stream.
   */
  getMeetingMarker() {
    final Stream<QuerySnapshot> stream =
        FirebaseFirestore.instance.collection('meetings').snapshots();
    return stream;
  }

  /**
   * Diese Methode liefert alle gespeicherten Unternehmen als Stream.
   *
   * @return alle Unternehmen als Stream.
   */
  Stream getCompanyList() {
    final Stream<QuerySnapshot> stream =
        FirebaseFirestore.instance.collection('companys').snapshots();
    return stream;
  }

  /**
   * Diese Methode liefert alle gespeicherten Projekte als Stream.
   *
   * @return alle Projekte als Stream.
   */
  getProjectList() {
    final Stream<QuerySnapshot> stream =
    FirebaseFirestore.instance.collection('project').snapshots();
    return stream;
  }

  /**
   * Diese Methode liefert alle gespeicherten Branchen als Stream.
   *
   * @return alle Branchen als Stream.
   */
  getIndustryList() {
    final Stream<QuerySnapshot> stream =
    FirebaseFirestore.instance.collection('industry').snapshots();
    return stream;
  }

  /**
   * Diese Methode liefert alle Nutzer, die sich als Buddy für das Unternehmen gekennzeichnet haben.
   * 
   * @param companyId Das Unternehmen zu dem die Buddys geladen werden sollen.
   * @param ownId Die eigene Id sodass man nicht selber in der Liste auftaucht.
   */
  Future<Stream<QuerySnapshot>> getBuddysForCompany(
      String companyId, String ownId) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("companyId", isEqualTo: companyId)
        .where("userid", isNotEqualTo: ownId)
        .where("userMode", isEqualTo: true)
        .snapshots();
  }

  /**
   * Diese Methode liefert alle Nutzer, die sich als Buddy für das Projekt gekennzeichnet haben.
   *
   * @param projectId Das Projekt zu dem die Buddys geladen werden sollen.
   * @param ownId Die eigene Id sodass man nicht selber in der Liste auftaucht.
   */
  Future<Stream<QuerySnapshot>> getBuddysForProjects(
      String projectId, String ownId) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("projectId", isEqualTo: projectId)
        .where("userid", isNotEqualTo: ownId)
        .where("userMode", isEqualTo: true)
        .snapshots();
  }

  /**
   * Diese Methode liefert alle Nutzer, die sich als Buddy für diese Branche gekennzeichnet haben.
   *
   * @param industryId Die Branche zu dem die Buddys geladen werden sollen.
   * @param ownId Die eigene Id sodass man nicht selber in der Liste auftaucht.
   */
  Future<Stream<QuerySnapshot>> getBuddysForIndustry(
      String industryId, String ownId) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("industryId", isEqualTo: industryId)
        .where("userid", isNotEqualTo: ownId)
        .where("userMode", isEqualTo: true)
        .snapshots();
  }

  /**
   * Diese Methode dient dazu ein einzelnes Feld aus dem Profil eines Nutzers zu laden.
   *
   * @param field Das Feld was benötigt wird.
   * @param userId DIe ID aus welchem die Information geladen werden soll.
   */
  Future<String> getFieldFromUser(String field, String userId) async {
    DocumentSnapshot<Map<String, dynamic>> resultQ =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();
    String result = "";
    if (resultQ.exists) {
      result = resultQ.get(field);
    }
    return result;
  }

  /**
   * Diese Methode liefert eine Liste mit Strings mit den Namen aller Unternehmen
   *
   * @return Liste mit allen Namen der Unternehmen.
   */
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

  /**
   * Diese Methode liefert die Id zu dem übergenenen Unternehmensnamen.
   *
   * @return die Id des Unternehmens
   */
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

  /**
   * Diese Methode liefert eine Liste mit Strings mit den Namen aller Branchen
   *
   * @return Liste mit allen Namen der Branchen.
   */
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

  /**
   * Diese Methode liefert die Id zu dem übergenenen Branchennamen.
   *
   * @return die Id der Branche
   */
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

  /**
   * Diese Methode ändert im Profil eines Benutzers ob er Buddy oder Seeker ist.
   *
   * @param index 0 wenn es sich um einen Buddy handelt
   * @param userid die Id zum Benutzer bei dem die Information angepasst werden soll.
   */
  setMode(int index, String userId) {
    Map<String, bool> userInfoMap = Map();
    userInfoMap["userMode"] = index == 0 ? true: false;
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .update(userInfoMap);
  }
}
