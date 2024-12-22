import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class PicturesProvider with ChangeNotifier {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Method to upload multiple pictures
  Future<List<String>> uploadPictures(
      {required List<String> picturesList,
      required String productsName}) async {
    List<String> pictureUrls = [];
    try {
      int i = 1;
      for (var picture in picturesList) {
        // Generate a unique filename for each picture
        String filename = "${const Uuid().v4()}_$i";
        print(filename);
        i++;
        // Upload picture to Firebase Storage
        final Reference storageRef =
            _storage.ref().child('productimages/$filename');
        final TaskSnapshot uploadTask = await storageRef.putFile(File(picture));
        // Get the download URL of the uploaded picture
        final String downloadUrl = await uploadTask.ref.getDownloadURL();
        pictureUrls.add(downloadUrl);
      }

      return pictureUrls;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deletePictures({required List<String> picturePaths}) async {
    for (final url in picturePaths) {
      final reference = _storage.refFromURL(url);
      await reference.delete();
    }
    notifyListeners();
  }
}
