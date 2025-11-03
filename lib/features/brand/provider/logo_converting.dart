

import 'dart:typed_data';
import 'package:flutter/foundation.dart';

class LogoProvider extends ChangeNotifier {
  Uint8List? _imageBytes;
  String? _imagefile;

  Uint8List? get imagebytes => _imageBytes;
  String? get imagefile => _imagefile;

  void setingBrandingImage(Uint8List bytes, String name) {
    _imageBytes = bytes;
    _imagefile = name;
    notifyListeners();
  }

  void clearImage() {
    _imageBytes = null;
    _imagefile = null;
    notifyListeners();
  }
}
