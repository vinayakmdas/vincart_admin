import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {

  Stream<QuerySnapshot> getUserStream() {
    return FirebaseFirestore.instance
        .collection("user")
        .snapshots();
  }

  Stream<int> getUserCount() {
    return FirebaseFirestore.instance
        .collection("user")
        .snapshots()
        .map((snap) => snap.docs.length);
  }
}