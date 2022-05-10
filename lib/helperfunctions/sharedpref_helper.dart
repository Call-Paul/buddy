import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper{


  static String userIdKey = "USERKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userDisplayName = "USERDISPLAYKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userProfileKey = "USERPROFILEKEY";

  Future<bool> saveUserName(String userName) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userNameKey, userName);
  }

  Future<bool> saveUserDisplayName(String userDisplayName) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userDisplayName, userDisplayName);
  }

  Future<bool> saveUserEmailKey(String userEmailKey) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userEmailKey, userEmailKey);
  }

  Future<bool> saveUserProfileKey(String userProfileKey) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userProfileKey, userProfileKey);
  }

  Future<bool> saveUserIdKey(String userIdKey) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userIdKey, userIdKey);
  }

  //getData
  Future<String?> getUserIdKey() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userIdKey);
  }

  Future<String?> getUserName() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userNameKey);
  }

  Future<String?> getUserDisplayName() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userDisplayName);
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
