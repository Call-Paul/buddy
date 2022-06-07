import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods {
  final storage = FirebaseStorage.instanceFor(
          bucket: "gs://crossinnovationclass2022.appspot.com")
      .ref();

  Future<String> uploadFile(String userId, File file) async {
    var storageRef = storage.child("user/profile/$userId");
    await storageRef.putFile(file);
    var downloadURL = await storageRef.getDownloadURL();

    return downloadURL;
  }

  Future<String> getProfileImg(String userId) async {
    var storageRef = storage.child("user/profile/$userId");
    try {
      var downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (err) {
      return "";
    }
  }

  Future<String> getCompanyImage(String companyId) async {
    var storageRef = storage.child("industrys/${companyId}.jpg");
    try {
      var downloadUrl = await storageRef.getDownloadURL();
      print(downloadUrl);
      return downloadUrl;
    } catch (err) {
      return "";
    }
  }
}
