
import 'package:ecommerce_admin/features/homescreen/screens/homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginUser {
// Main login function


Future<void> login(
  BuildContext context,
  TextEditingController adminController,
  TextEditingController passwordController,
) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );

  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: adminController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (context.mounted) Navigator.pop(context);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  } on FirebaseAuthException catch (e) {
    if (context.mounted) Navigator.pop(context);

    String message = "Login failed";
    if (e.code == 'user-not-found') message = "Admin not found";
    if (e.code == 'wrong-password') message = "Invalid password";

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

// Save login to SharedPreferences
Future<void> savelogin(String adminId, bool logIn) async {
final pref = await SharedPreferences.getInstance();
await pref.setString("Admin_Id", adminId);
await pref.setBool("is_logged_in", logIn);
debugPrint("Saved successfully: $adminId");
}

// Auto-login check
Future<void> checkLogin(BuildContext context) async {
final pref = await SharedPreferences.getInstance();
bool? isLoggedIn = pref.getBool("is_logged_in");


if (isLoggedIn == true) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const HomeScreen()),
  );
}


}

// Logout
Future<void> logout(BuildContext context) async {
final pref = await SharedPreferences.getInstance();
await pref.clear();


Navigator.pushReplacementNamed(context, "/login");


}
}
