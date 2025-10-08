

import 'package:flutter/material.dart';

class DrawerProvider extends ChangeNotifier{


  int  selectedIndex =0;

  
  int get currentindex => selectedIndex;


  void onMenuButton(int index  ,){
 
     
     selectedIndex =index;
     notifyListeners(); 
 
  }
}