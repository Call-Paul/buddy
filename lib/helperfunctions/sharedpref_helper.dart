import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

/**
 * Mit dieser Klasse werden alle Information die lokal verwaltet werden müssen,
 * gespeichert und wieder geladen.
 * @author Paul Franken winf104387
 */
class SharedPreferencesHelper{


  /*
   * Definition der Schlüssel die dazu verwendet werden, Inofrmation zu
   * speichern und wieder zu laden.
   */
  static String userIdKey = "USERIDKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userDisplayNameKey = "USERDISPLAYNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userStartDateKey = "USERSTARTDATEKEY";
  static String userCompanyKey = "USERCOMPANYKEY";
  static String userGuideKey = "USERGUIDEKEY";
  static String userMeetKey = "USERMEETKEY";
  static String userMeetUpKey = "USERMEETUPKEY";
  static String userSkillsKey = "USERSKILLSKEY";
  static String userAccountIdKey = "USERACCOUNTIDKEY";
  static String userModeKey = "userModeKey";


  /**
   * Mit dieser Methode wird der übergeben Nutzername gespeichert.
   *
   * @params username der Username der gespeichert werden soll.
   * @return ein boolean ob die Operation erfolgreich war.
   */
  Future<bool> saveUserName(String userName) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userNameKey, userName);
  }

  /**
   * Mit dieser Methode wird der übergeben Klarnamen aus dem Google Konto gespeichert.
   *
   * @params userDisplayName der Klarname der gespeichert werden soll.
   * @return ein boolean ob die Operation erfolgreich war.

   */
  Future<bool> saveUserDisplayName(String userDisplayName) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userDisplayNameKey, userDisplayName);
  }

  /**
   * Mit dieser Methode wird die übergebene Email gespeichert.
   *
   * @params userEmail die Email der gespeichert werden soll.
   * @return ein boolean ob die Operation erfolgreich war.
   */
  Future<bool> saveUserEmail(String userEmail) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userEmailKey, userEmail);
  }

  /**
   * Mit dieser Methode wird die übergebene UserId gespeichert.
   *
   * @params userId die UserId die gespeichert werden soll.
   * @return ein boolean ob die Operation erfolgreich war.
   */
  Future<bool> saveUserId(String userId) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userIdKey, userId);
  }

  /**
   * Mit dieser Methode wird das übergebene Startdatum gespeichert.
   *
   * @params startDate das Startdatum das gespeichert werden soll.
   * @return ein boolean ob die Operation erfolgreich war.
   */
  Future<bool> saveUserStartDate(DateTime startDate) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userStartDateKey, startDate.toString());
  }

  /**
   * Mit dieser Methode wird das übergebene Unternehmen gespeichert.
   *
   * @params userCompany das Unternehmen das gespeichert werden soll.
   * @return ein boolean ob die Operation erfolgreich war.
   */
  Future<bool> saveUserCompany(String userCompany) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userCompanyKey, userCompany);
  }

  /**
   * Mit dieser Methode wird gespeichert, ob der Nutzer offen
   * für Unternehmensführungen ist.
   *
   * @params userGuide die Information ob der Nutzer offen ist.
   * @return ein boolean ob die Operation erfolgreich war.
   */
  Future<bool> saveUserGuide(String userGuide) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userGuideKey, userGuide);
  }

  /**
   * Mit dieser Methode wird gespeichert, ob der Nutzer offen
   * für ein normales Treffen ist.
   *
   * @params userCoffee die Information ob der Nutzer offen ist.
   * @return ein boolean ob die Operation erfolgreich war.
   */
  Future<bool> saveUserMeet(String userCoffee) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userMeetKey, userCoffee);
  }

  /**
   * Mit dieser Methode wird gespeichert, ob der Nutzer offen
   * für offizielle Meetups ist.
   *
   * @params userMeetup die Information ob der Nutzer offen ist.
   * @return ein boolean ob die Operation erfolgreich war.
   */
  Future<bool> saveUserMeetUp(String userMeetUp) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userMeetUpKey, userMeetUp);
  }

  /**
   * Mit dieser Methode werden die Skills des Nutzers abgespeichert.
   *
   * @params userSkills die Skills die gespeichert werden sollen.
   * @return ein boolean ob die Operation erfolgreich war.
   */
  Future<bool> saveUserSkills(String userSkills) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userSkillsKey, userSkills);
  }

  /**
   * Mit dieser Methode wird die accountId vom Google Konto gespeichert gespeichert.
   *
   * @params accountId die AccountId zum Google Konto.
   * @return ein boolean ob die Operation erfolgreich war.
   */
  Future<bool> saveAccountId(String accountId) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userAccountIdKey, accountId);
  }

  /**
   * Mit dieser Methode wird gespeichert, ob der Nutzer den Modus Buddy oder
   * Seeker ausgewählt hat.
   *
   * @params mode der Modus des Nutzers.
   * @return ein boolean ob die Operation erfolgreich war.
   */
  Future<bool> saveUserMode(bool mode) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setBool(userModeKey, mode);
  }

  /**
   * Mit dieser Methode wird die gespeicherte UserId zurückgegeben.
   *
   * @return die UserId gekapselt in einem Future Type.
   */
  Future<String?> getUserId() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userIdKey);
  }

  /**
   * Mit dieser Methode wird der gespeicherte Nutzername zurückgegeben.
   *
   * @return der Nutzername gekapselt in einem Future Type.
   */
  Future<String?> getUserName() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userNameKey);
  }

  /**
   * Mit dieser Methode wird der gespeicherte Klarname zurückgegeben.
   *
   * @return der Klarname gekapselt in einem Future Type.
   */
  Future<String?> getUserDisplayName() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userDisplayNameKey);
  }

  /**
   * Mit dieser Methode wird die gespeicherte Email zurückgegeben.
   *
   * @return die Email gekapselt in einem Future Type.
   */
  Future<String?> getUserEmail() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userEmailKey);
  }

  /**
   * Mit dieser Methode wird die gespeicherte Email zurückgegeben.
   *
   * @return die Email gekapselt in einem Future Type.
   */
  Future<DateTime?> getUserStartDate() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return DateTime.parse(preferences.getString(userStartDateKey)!);
  }

  /**
   * Mit dieser Methode wird das gespeicherte Unternehmen zurückgegeben.
   *
   * @return das Unternehmen gekapselt in einem Future Type.
   */
  Future<String?> getUserCompany() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userCompanyKey);
  }

  /**
   * Mit dieser Methode wird die gespeicherte Information bezüglich
   * der Unternehmensführung zurückgegeben.
   *
   * @return die Information gekapselt in einem Future Type.
   */
  Future<String?> getUserGuide() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userGuideKey);
  }

  /**
   * Mit dieser Methode wird die gespeicherte Information bezüglich
   * der normalen Treffen zurückgegeben.
   *
   * @return die Information gekapselt in einem Future Type.
   */
  Future<String?> getUserCoffee() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userMeetKey);
  }

  /**
   * Mit dieser Methode wird die gespeicherte Information bezüglich
   * der offiziellen Meetups zurückgegeben.
   *
   * @return die Information gekapselt in einem Future Type.
   */
  Future<String?> getUserMeetUp() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userMeetUpKey);
  }

  /**
   * Mit dieser Methode werden die gespeicherten Userskills zurückgegeben.
   *
   * @return die UserSkills gekapselt in einem Future Type.
   */
  Future<String?> getUserSkills() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userSkillsKey);
  }

  /**
   * Mit dieser Methode wird die gespeicherte AccountId zurückgegeben.
   *
   * @return die AccountId gekapselt in einem Future Type.
   */
  Future<String?> getUserAccountId() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userAccountIdKey);
  }

  /**
   * Mit dieser Methode wird der gespeicherte UserMode zurückgegeben.
   *
   * @return der UserMode gekapselt in einem Future Type.
   */
  Future<bool?> getUserMode() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(userModeKey);
  }
}
