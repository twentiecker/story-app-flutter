import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class AddStoryImageProvider extends ChangeNotifier {
  late Completer<XFile?> _completer;

  String? imagePath;
  XFile? imageFile;
  String description = '';

  Future<XFile?> waitForResult() async {
    _completer = Completer<XFile?>();
    return _completer.future;
  }

  void returnData(XFile? value) {
    _completer.complete(value);
  }

  void setImagePath(String? value) {
    imagePath = value;
    notifyListeners();
  }

  void setImageFile(XFile? value) {
    imageFile = value;
    notifyListeners();
  }

  void setDescription(String value) {
    description = value;
    notifyListeners();
  }
}
