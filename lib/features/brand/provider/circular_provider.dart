


import 'package:flutter/foundation.dart';

class CircularProvider extends ChangeNotifier{


  bool _isloading = false ;


  bool get isloading => _isloading;

  startloading(){

    _isloading = true; 
    notifyListeners();
  }


  stoploading(){

    _isloading = false;
    notifyListeners();
  }
} 