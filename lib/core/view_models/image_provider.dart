import 'package:flutter/material.dart';

class ImageList with ChangeNotifier {
  bool _thumbNaiCalled = false;
  final List<ImageToUpload> _images = [
    ImageToUpload(isThumbNail: false, urlOfTheImage: ''),
  ];

  List<ImageToUpload> get images => _images;
  bool get thumbNaiCalled => _thumbNaiCalled;

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
    }
    if (!_thumbNaiCalled && images.isNotEmpty) {
      setfirstImageThumnNail(images[0]);
    }
    notifyListeners();
  }

  void setfirstImageThumnNail(String urlOfTheImage) {
    if (!_thumbNaiCalled) {
      if (_images.length > 1) {
        _images[1] =
            ImageToUpload(isThumbNail: true, urlOfTheImage: urlOfTheImage);
        _thumbNaiCalled = true;
        notifyListeners();
      }
    }
  }

  void setThumbnail(int index) {
    if (index >= 0 && index < _images.length) {
      // Reset all images to non-thumbnail
      for (var img in _images) {
        img.isThumbNail = false;
      }

      // Mark the selected image as the thumbnail
      final selectedImage = _images[index];
      selectedImage.isThumbNail = true;

      // Remove the selected image from its current position
      _images.removeAt(index);

      // Insert the thumbnail at index 1
      if (_images.isNotEmpty) {
        _images.insert(1, selectedImage);
      } else {
        _images.add(selectedImage); // If no other images exist, just add it
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
}

class ImageToUpload {
  final String urlOfTheImage;
  bool isThumbNail;

  ImageToUpload({required this.urlOfTheImage, required this.isThumbNail});
}
