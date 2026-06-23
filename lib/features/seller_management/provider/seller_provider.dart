import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin/core/themes/app_color.dart';
import 'package:flutter/material.dart';

class SellerProvider extends ChangeNotifier {
  String selectedFilter = "pending"; 
   Color selectcolor = AppColor.whiteColor  ;

    Color get selectedColor => selectcolor;


    changingecolor(Color color){
      selectcolor=color;
      notifyListeners();
    }

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

  // Counts new sellers per weekday (Mon..Sun) for the current week
  Stream<List<int>> getWeeklySignupStream() {
    final sellers = FirebaseFirestore.instance.collection("sellers");
    final now = DateTime.now();
    final startOfWeek = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1)); // Monday 00:00
    final endOfWeek = startOfWeek.add(const Duration(days: 7));

    return sellers
        .where("createdAt",
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfWeek))
        .where("createdAt", isLessThan: Timestamp.fromDate(endOfWeek))
        .snapshots()
        .map((snapshot) {
      final counts = List<int>.filled(7, 0);
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final ts = data["createdAt"] as Timestamp?;
        if (ts != null) {
          final weekday = ts.toDate().weekday; // 1 = Mon ... 7 = Sun
          counts[weekday - 1]++;
        }
      }
      return counts;
    });
  }
}
