

import 'dart:developer';
import 'package:ecommerce_admin/features/homescreen/screens/provider/sideMen_provider.dart';
import 'package:ecommerce_admin/features/seller_management/provider/seller_provider.dart';
// import 'package:ecommerce_admin/features/seller_management/provider/seller_provider.dart';
import 'package:ecommerce_admin/features/splash/splashscreen.dart';
import 'package:ecommerce_admin/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
try {
   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
} catch (e) {
  log(e.toString());
}
 

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DrawerProvider()),
        ChangeNotifierProvider(create: (_)=>SellerProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
