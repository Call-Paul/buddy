import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

/**
 * Mit dieser Klasse wird die Verbindung zum Storage in Firebase gesteuert.
 * Alle Up- und Downloads werden von den Methoden dieser Klasse vorgenommen.
 *
 * @author Paul Franken winf104387
 */
class StorageMethods {

  //Referenz zum Cloudspeicher
  final storage = FirebaseStorage.instanceFor(
          bucket: "gs://crossinnovationclass2022.appspot.com")
      .ref();


  /**
   * Diese Methode lädt die übergebene Datei in den Webspeicher hoch.
   *
   * @params userId Die UserId zu der die Datei gehört.
   * @params file Die Date die hochgeladen werden soll.
   * @return Als Ergebnis liefert diese Methode die DownloadUrl.
   *         Dabei handelt es sich um einen direkten Link zum hochgeladenem File.
   */
  Future<String> uploadFile(String userId, File file) async {
    var storageRef = storage.child("user/profile/$userId");
    await storageRef.putFile(file);
    var downloadURL = await storageRef.getDownloadURL();

    return downloadURL;
  }

  /**
   * Diese Methode sorgt dafür, dass für das Profilbild,
   * welches zur übergebenen Userid passt, die DownloadUrl zruückgeben wird.
   * Falls kein Bild gefunden wird, wird ein leerer String als Ergebnis geliefert.
   *
   * @params userid Die NutzerId zum Profilfoto.
   * @return Die DownloadUrl für das Profilfoto.
   */
  Future<String> getProfileImg(String userId) async {
    var storageRef = storage.child("user/profile/$userId");
    try {
      var downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (err) {
      return "";
    }
  }

}
