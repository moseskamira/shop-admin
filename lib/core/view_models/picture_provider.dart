import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import 'update_image_provider.dart';

class PicturesProvider with ChangeNotifier {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Method to upload multiple pictures
  Future<List<String>> uploadPictures({
    required List<String> picturesList,
    required String productsName,
    required int lengthOfImages,
  }) async {
    List<String> pictureUrls = [];

    try {
      for (var picture in picturesList) {
        String filename = "${const Uuid().v4()}_$lengthOfImages";
        final Reference storageRef =
            _storage.ref().child('productimages/$filename');
        final TaskSnapshot uploadTask =
            await storageRef.putFile(File(picture));
        final String downloadUrl = await uploadTask.ref.getDownloadURL(); //
        pictureUrls.add(downloadUrl);
        lengthOfImages--;
      }

      return pictureUrls;
    } catch (error) {
      rethrow;
    }
  }
  
  
  
  Future<List<ImageToUpload>> updatePictures({
    required List<ImageToUpload> picturesList,
    required String productsName,
    required int lengthOfImages,
  }) async {
    List<ImageToUpload> pictureUrls = [];

    try {
      for (var picture in picturesList) {
        String filename = "${const Uuid().v4()}_$lengthOfImages";
        final Reference storageRef =
            _storage.ref().child('productimages/$filename');
        final TaskSnapshot uploadTask =
            await storageRef.putFile(File(picture.urlOfTheImage));
        final String downloadUrl = await uploadTask.ref.getDownloadURL(); //
        pictureUrls.add(ImageToUpload(
            index: picture.index, urlOfTheImage: downloadUrl));
        lengthOfImages--;
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

  Future<void> deleteSinglePicture({required String url}) async {
    final reference = _storage.refFromURL(url);
    await reference.delete();
  }

  Future<String> uploadSinglePicture({
    required String fileLocationinDevice,
  
  }) async {
    try {
           String filename = const Uuid().v4();
      final ref = _storage.ref().child('userimages').child(filename);

      final uploadTask = await ref.putFile(File(fileLocationinDevice));
      if (uploadTask.state == TaskState.success) {
        final imageUrl = await ref.getDownloadURL();
        return imageUrl;
      } else {
        throw 'Upload failed. Task state: ${uploadTask.state}';
      }
    } catch (e) {
      throw 'Error uploading image: $e';
    }
  }
}
