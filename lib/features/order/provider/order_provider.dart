import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class OrderProvider extends ChangeNotifier {
  Stream<List<Map<String, dynamic>>> getOrders() {
    return FirebaseFirestore.instance
        .collection("orders")
        .snapshots()
        .switchMap((orderSnapshot) {
      if (orderSnapshot.docs.isEmpty) {
        return Stream.value(<Map<String, dynamic>>[]);
      }

      final itemStreams = orderSnapshot.docs.map((orderDoc) {
        return orderDoc.reference
            .collection("items")
            .snapshots()
            .map((itemsSnapshot) {
          return itemsSnapshot.docs.map((item) {
            final data = Map<String, dynamic>.from(item.data());
            data["orderDocId"] = orderDoc.id;
            data["createdAt"] = orderDoc["createdAt"];
            return data;
          }).toList();
        });
      }).toList();

      return Rx.combineLatest<List<Map<String, dynamic>>,
          List<Map<String, dynamic>>>(
        itemStreams,
        (listOfLists) => listOfLists.expand((e) => e).toList(),
      );
    });
  }

  // Count stream for dashboard card / pie chart — based on order-level status
  Stream<int> getOrderCountStream(String filter) {
    final orders = FirebaseFirestore.instance.collection("orders");
    switch (filter) {
      case "total":
        return orders.snapshots().map((snap) => snap.docs.length);
      case "delivered":
        return orders
            .where("status", isEqualTo: "delivered")
            .snapshots()
            .map((snap) => snap.docs.length);
      case "pending":
        return orders
            .where("status", isEqualTo: "pending")
            .snapshots()
            .map((snap) => snap.docs.length);
      default:
        return const Stream<int>.empty();
    }
  }

  DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  Stream<List<int>> getWeeklyOrderStream() {
    final orders = FirebaseFirestore.instance.collection("orders");

    return orders.snapshots().map((snapshot) {
      final now = DateTime.now();
      final startOfWeek = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: now.weekday - 1));
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