
import 'package:flutter/material.dart';

class VariationProvider extends ChangeNotifier{



  String? _variationType ;


  String? get variationType => _variationType;


 setVariations(value){
 
 _variationType = value;
 notifyListeners();

 }

  
} 