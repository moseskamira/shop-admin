import 'package:flutter/material.dart';

class UpdateImageProvider with ChangeNotifier {
  bool _thumbNaiCalled = false;
  bool _isFirstTime = true;
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


List<String> get urlofThemimagesToDeleteFromStorage => imagesToDeleteFromStorage
    .map((image) => image.urlOfTheImage) // Extract only the URL
    .toList();


  void add(String image) {
    final inst = ImageToUpload(isThumbNail: false, urlOfTheImage: image);
    _images.add(inst);
    setfirstImageThumnNail(image);

    notifyListeners();
  }

  void addAll(List<String> images) {
    for (final image in images) {
      final inst = ImageToUpload(isThumbNail: false, urlOfTheImage: image);
      _images.add(inst);
      notifyListeners();
    }
    if (!_thumbNaiCalled && images.isNotEmpty) {
      setfirstImageThumnNail(images[0]);
    }
    notifyListeners();

    if (_isFirstTime) {
      for (final image in images) {
        final inst = ImageToUpload(isThumbNail: false, urlOfTheImage: image);
        _firstImages.add(inst);
        notifyListeners();
      }
    }
    _isFirstTime = false;
    notifyListeners();
  }

  void setfirstImageThumnNail(String urlOfTheImage) {
    if (!_thumbNaiCalled) {
      if (_images.length > 1) {
        _images[0] =
            ImageToUpload(isThumbNail: true, urlOfTheImage: urlOfTheImage);
        _thumbNaiCalled = true;
        notifyListeners();
      }
    }
  }

  void setThumbnail(int index) {
    if (index >= 0 && index < _images.length) {
      for (var img in _images) {
        img.isThumbNail = false;
      }
      final selectedImage = _images[index];
      selectedImage.isThumbNail = true;
      _images.removeAt(index);
      if (_images.isNotEmpty) {
        _images.insert(0, selectedImage);
      } else {
        _images.add(selectedImage);
      }
      _thumbNaiCalled = true;
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
    _images.add(ImageToUpload(isThumbNail: false, urlOfTheImage: ''));
    notifyListeners();
  }

  void replaceImage(int index, String image) {
    if (index >= 0 && index < _images.length) {
      _images[index] = ImageToUpload(isThumbNail: false, urlOfTheImage: image);
      if (index == 1) {
        setThumbnail(1);
      }
    } else {
      _images.add(ImageToUpload(isThumbNail: false, urlOfTheImage: image));
    }
    notifyListeners();
  }

  void reset() {
    _thumbNaiCalled = false;
    _isFirstTime = true;
    _images.clear();
    _firstImages.clear();
    notifyListeners();
  }





List<String> mergeAndRearrangeAsList(
     {required List<ImageToUpload> oldData,required List<ImageToUpload> recentUploads}) {
  List<ImageToUpload> mergedList = [...oldData, ...recentUploads];

  int thumbnailIndex = mergedList.indexWhere((item) => item.isThumbNail);

  if (thumbnailIndex != -1) {
    ImageToUpload thumbnailItem = mergedList.removeAt(thumbnailIndex);
    mergedList.insert(0, thumbnailItem);
  }

  // Convert the merged list to a list of strings (URLs only)
  return mergedList.map((item) => item.urlOfTheImage).toList();
}






}

class ImageToUpload {
  final String urlOfTheImage;
  bool isThumbNail;

  ImageToUpload({required this.urlOfTheImage, required this.isThumbNail});
}
