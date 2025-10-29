import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SellerProvider extends ChangeNotifier {
  String selectedFilter = "pending"; // Default filter

  // Change filter and notify UI
  void setFilter(String filter) {
    selectedFilter = filter;
    notifyListeners();
  }

  // Firestore stream for seller list
  Stream<QuerySnapshot> getSellerStream() {
    final sellers = FirebaseFirestore.instance.collection("sellers");

    switch (selectedFilter) {
      case "total":
        return sellers.snapshots();
      case "active":
        return sellers.where("status", isEqualTo: "approved").snapshots();
      case "blocked":
        return sellers.where("status", isEqualTo: "blocked").snapshots();
      case "pending":
      default:
        return sellers.where("status", isEqualTo: "pending").snapshots();
    }
  }

  // Count stream for each type
  Stream<int> getCountStream(String filter) {
    final sellers = FirebaseFirestore.instance.collection("sellers");
    switch (filter) {
      case "total":
        return sellers.snapshots().map((snap) => snap.docs.length);
      case "active":
        return sellers
            .where("status", isEqualTo: "approved")
            .snapshots()
            .map((snap) => snap.docs.length);
      case "blocked":
        return sellers
            .where("status", isEqualTo: "blocked")
            .snapshots()
            .map((snap) => snap.docs.length);
      case "pending":
        return sellers
            .where("status", isEqualTo: "pending")
            .snapshots()
            .map((snap) => snap.docs.length);
      default:
        return const Stream<int>.empty();
    }
  }
}
