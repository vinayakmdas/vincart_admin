import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin/features/homescreen/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginUser {
// Main login function
Future<void> login(
BuildContext context,
TextEditingController adminController,
TextEditingController passwordController,
) async {
// Show loading dialog
showDialog(
context: context,
barrierDismissible: false, // Prevent closing while loading
builder: (context) => const Center(
child: CircularProgressIndicator(),
),
);


try {
  // Fetch admin credentials from Firestore
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection("admin")
      .doc("adminLogin")
      .get(const GetOptions(source: Source.server));

  if (!snapshot.exists) {
    if (context.mounted) Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Admin credentials not found.")),
    );
    return;
  }

  final data = snapshot.data() as Map<String, dynamic>?;

  if (data == null ||
      !data.containsKey('AdminId') ||
      !data.containsKey('Password')) {
    if (context.mounted) Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Invalid Firestore admin data.")),
    );
    return;
  }

  String adminIdFromDb = data['AdminId'];
  String passwordFromDb = data['Password'];

  String enteredId = adminController.text.trim();
  String enteredPassword = passwordController.text.trim();

  if (enteredId == adminIdFromDb && enteredPassword == passwordFromDb) {
    await savelogin(enteredId, true);

    if (context.mounted) Navigator.pop(context); // Close loading

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  } else {
    if (context.mounted) Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Invalid Admin ID or Password")),
    );
  }
} catch (e) {
  if (context.mounted) Navigator.pop(context);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Error logging in: $e")),
  );
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
