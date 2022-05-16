import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/src/widgets/image.dart';

class StorageMethods {
  final storage = FirebaseStorage.instanceFor(
      bucket: "gs://crossinnovationclass2022.appspot.com").ref();

  Future<String> uploadFile(String userId, File file) async{
    var storageRef = storage.child("user/profile/$userId");
    await storageRef.putFile(file);
    var downloadURL = await storageRef.getDownloadURL();

    return downloadURL;
  }

  Future<String> getProfileImg(String userId) {
    var storageRef = storage.child("user/profile/$userId");
    return storageRef.getDownloadURL();

  }
}
