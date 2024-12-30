import 'package:flutter/material.dart';
import 'package:shop_owner_app/core/view_models/update_image_provider.dart';

class ImageListProductUpload with ChangeNotifier {
  bool _thumbNaiCalled = false;
  //TODO removing this initial image
  final List<ImageToUpload> _images = [];

// TODO filtering selected image so that user is don't get to select the same image again
  List<ImageToUpload> get images => _images;
  bool get thumbNaiCalled => _thumbNaiCalled;

  void add(String image) {
    final inst = ImageToUpload(isThumbNail: false, urlOfTheImage: image);
    _images.add(inst);
    if (!_thumbNaiCalled && images.isNotEmpty) {
      setfirstImageThumnNail(image);
    }
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
  }

  void setfirstImageThumnNail(String urlOfTheImage) {
    _images[0] = ImageToUpload(isThumbNail: true, urlOfTheImage: urlOfTheImage);
    _thumbNaiCalled = true;
    notifyListeners();
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

    notifyListeners();
  }
   void reorderImages(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--; // Adjust for moving down
    final movedImage = images.removeAt(oldIndex);
    images.insert(newIndex, movedImage);
    notifyListeners(); // Notify the listeners to update the UI
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
