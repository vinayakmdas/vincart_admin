import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  String selectedFilter = "active";

  void setFilter(String filter) {
    selectedFilter = filter;
    notifyListeners();
  }

  Stream<QuerySnapshot> getProductSream() {
    final product = FirebaseFirestore.instance.collection("products");

    switch (selectedFilter) {
      case "active":
        return product.where("status", isEqualTo: "active").snapshots();
      case "inactive":
        return product.where("status", isEqualTo: "inactive").snapshots();
      default:
        return product.snapshots();
    }
  }

  // Count stream for dashboard cards / pie chart
  Stream<int> getCountStream(String filter) {
    final products = FirebaseFirestore.instance.collection("products");
    switch (filter) {
      case "total":
        return products.snapshots().map((snap) => snap.docs.length);
      case "active":
        return products
            .where("status", isEqualTo: "active")
            .snapshots()
            .map((snap) => snap.docs.length);
      case "inactive":
        return products
            .where("status", isEqualTo: "inactive")
            .snapshots()
            .map((snap) => snap.docs.length);
      default:
        return const Stream<int>.empty();
    }
  }

  // Safely parses createdAt whether it's a Timestamp or a String
  DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  // Counts new products per weekday (Mon..Sun) for the current week
  Stream<List<int>> getWeeklyProductStream() {
    final products = FirebaseFirestore.instance.collection("products");

    return products.snapshots().map((snapshot) {
      final now = DateTime.now();
      final startOfWeek = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: now.weekday - 1)); // Monday 00:00
      final endOfWeek = startOfWeek.add(const Duration(days: 7));

      final counts = List<int>.filled(7, 0);
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final date = _toDate(data["createdAt"]);
        if (date != null &&
            !date.isBefore(startOfWeek) &&
            date.isBefore(endOfWeek)) {
          counts[date.weekday - 1]++;
        }
      }
      return counts;
    });
  }
}