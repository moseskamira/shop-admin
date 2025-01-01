import 'package:flutter/material.dart';

class ImageListProductUpload with ChangeNotifier {
  final List<String> _images = [];

// TODO filtering selected image so that user is don't get to select the same image again
  List<String> get images => _images;

  void add(String image) {
    _images.add(image);

    notifyListeners();
  }

  void addAll(List<String> images) {
    for (final image in images) {
      _images.add(image);
      notifyListeners();
    }

    notifyListeners();
  }

  void setThumbnail(int index) {
    if (index >= 0 && index < _images.length) {
      final selectedImage = _images[index];
      _images.removeAt(index);
      if (_images.isNotEmpty) {
        _images.insert(0, selectedImage);
      } else {
        _images.add(selectedImage);
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

   }

  void reorderImages(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--; // Adjust for moving down
    final movedImage = _images.removeAt(oldIndex);
    _images.insert(newIndex, movedImage);
    notifyListeners(); // Notify the listeners to update the UI
  }

  void replaceImage(int index, String image) {
    if (index >= 0 && index < _images.length) {
      _images[index] = image;
      if (index == 1) {
        setThumbnail(1);
      }
    } else {
      _images.add(image);
    }
    notifyListeners();
  }
}
