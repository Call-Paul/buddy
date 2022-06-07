import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper{


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


  Future<bool> saveUserName(String userName) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userNameKey, userName);
  }

  Future<bool> saveUserDisplayName(String userDisplayName) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userDisplayNameKey, userDisplayName);
  }

  Future<bool> saveUserEmail(String userEmail) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userEmailKey, userEmail);
  }
  

  Future<bool> saveUserId(String userId) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userIdKey, userId);
  }

  Future<bool> saveUserStartDate(DateTime startDate) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userStartDateKey, startDate.toString());
  }

  Future<bool> saveUserCompany(String userCompany) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userCompanyKey, userCompany);
  }

  Future<bool> saveUserGuide(String userGuide) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userGuideKey, userGuide);
  }

  Future<bool> saveUserMeet(String userCoffee) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userMeetKey, userCoffee);
  }

  Future<bool> saveUserMeetUp(String userMeetUp) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userMeetUpKey, userMeetUp);
  }

  Future<bool> saveUserSkills(String userSkills) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userSkillsKey, userSkills);
  }

  Future<bool> saveAccountId(String accountId) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userAccountIdKey, accountId);
  }

  Future<bool> saveUserMode(bool mode) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setBool(userModeKey, mode);
  }

  //getData
  Future<String?> getUserId() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userIdKey);
  }

  Future<String?> getUserName() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userNameKey);
  }

  Future<String?> getUserDisplayName() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userDisplayNameKey);
  }
  

  Future<String?> getUserEmail() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userEmailKey);
  }

  Future<DateTime?> getUserStartDate() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return DateTime.parse(preferences.getString(userStartDateKey)!);
  }

  Future<String?> getUserCompany() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userCompanyKey);
  }

  Future<String?> getUserGuide() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userGuideKey);
  }

  Future<String?> getUserCoffee() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userMeetKey);
  }

  Future<String?> getUserMeetUp() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userMeetUpKey);
  }

  Future<String?> getUserSkills() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userSkillsKey);
  }

  Future<String?> getUserAccountId() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userAccountIdKey);
  }

  Future<bool?> getUserMode() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(userModeKey);
  }


  
}
