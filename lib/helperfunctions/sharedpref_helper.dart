import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper{


  static String userIdKey = "USERKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userDisplayNameKey = "USERDISPLAYKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userProfileKey = "USERPROFILEKEY";

  Future<bool> saveUserName(String userName) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userNameKey, userName);
  }

  Future<bool> saveUserDisplayName(String userDisplayName) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userDisplayNameKey, userDisplayName);
  }

  Future<bool> saveUserEmailKey(String userEmail) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userEmailKey, userEmail);
  }

  Future<bool> saveUserProfileKey(String userProfile) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userProfileKey, userProfile);
  }

  Future<bool> saveUserIdKey(String userId) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userIdKey, userId);
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

  Future<String?> getUserProfile() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userProfileKey);
  }

  Future<String?> getUserEmail() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userEmailKey);
  }
}
