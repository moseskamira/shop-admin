import 'package:flutter/material.dart';

class UpdateImageProvider with ChangeNotifier {
   //TODO removing this initial image

  final List<ImageToUpload> _images = [];
  final List<ImageToUpload> _firstImages = [];
  List<ImageToUpload> get initialImages => _firstImages;
// TODO filtering selected image so that user is don't get to select the same image again from their device
  List<ImageToUpload> get images => _images;

  List<ImageToUpload> get newImagesToUpload =>
      _images.where((image) => !image.urlOfTheImage.contains('http')).toList();

  List<ImageToUpload> get backedUpImages =>
      _images.where((image) => image.urlOfTheImage.contains('http')).toList();

  bool get isDeletedPreviousImage => imagesToDeleteFromStorage.isNotEmpty;

  List<ImageToUpload> get imagesToDeleteFromStorage => _firstImages
      .where((element) =>
          !_images.any((image) => image.urlOfTheImage == element.urlOfTheImage))
      .toList();

  List<String> get urlofThemimagesToDeleteFromStorage =>
      imagesToDeleteFromStorage
          .map((image) => image.urlOfTheImage) // Extract only the URL
          .toList();

  void add(String image) {
    print('Add length: ${_images.length}');
    final inst = ImageToUpload(index: _images.length, urlOfTheImage: image);
    _images.add(inst);
 

    notifyListeners();
  }

  void addAll(List<String> images) {
    for (final image in images) {
      print('Add ALL length: ${_images.length}');
      final inst = ImageToUpload(index: _images.length, urlOfTheImage: image);
      _images.add(inst);
     }
   
    notifyListeners();

   
   }

  void reorderImages(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--; // Adjust for moving down
    final movedImage = _images.removeAt(oldIndex);
    _images.insert(newIndex, movedImage);
    notifyListeners(); // Notify the listeners to update the UI
  }

 

  void setThumbnail(int index) {
    if (index >= 0 && index < _images.length) {
      final selectedImage = _images[index];
      selectedImage.index = 0;
      _images.removeAt(index);
      _images.insert(0, selectedImage);
      for (var i = 0; i < _images.length; i++) {
        _images[i].index = i;
      }
     
      notifyListeners();
    }
  }

  void remove(int index) {
    if (index >= 0 && index < _images.length) {
      _images.removeAt(index);
      notifyListeners();
    }
  }

  void clear() {
    _images.clear();
    notifyListeners();

    notifyListeners();
  }

  // void replaceImage(int index, String image) {
  //   if (index >= 0 && index < _images.length) {
  //     _images[index] = ImageToUpload(isThumbNail: false, urlOfTheImage: image);
  //     if (index == 1) {
  //       setThumbnail(1);
  //     }
  //   } else {
  //     _images.add(ImageToUpload(isThumbNail: false, urlOfTheImage: image));
  //   }
  //   notifyListeners();
  // }

  void reset() {
 
    _images.clear();
    _firstImages.clear();
    notifyListeners();
  }

  List<String> mergeAndRearrangeAsList({
    required List<ImageToUpload> oldData,
    required List<ImageToUpload> recentUploads,
  }) {
    final mergedList = [...oldData, ...recentUploads];
    mergedList.sort((a, b) => a.index.compareTo(b.index));
    return mergedList.map((item) => item.urlOfTheImage).toList();
  }
}

class ImageToUpload {
  final String urlOfTheImage;
  int index;

  ImageToUpload({
    required this.urlOfTheImage,
    required this.index,
  });
}
