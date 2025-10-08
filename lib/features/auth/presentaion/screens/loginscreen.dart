import 'package:ecommerce_admin/features/auth/presentaion/screens/mobile_screenview.dart';
import 'package:ecommerce_admin/features/auth/presentaion/screens/web_screenview.dart';
import 'package:flutter/material.dart';


class Loginscreen extends StatelessWidget {
  const Loginscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      body: LayoutBuilder(
        builder: (context,constrits){
 
   bool ismobile = 800 <constrits.maxWidth;


  return  ismobile ? WebScreenview() : MobileScreenview();

        }

      
      
    
      )
    );
  }
}