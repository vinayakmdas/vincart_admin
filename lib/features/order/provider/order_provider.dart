import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart'; // add rxdart to pubspec.yaml

class OrderProvider extends ChangeNotifier {

  Stream<List<Map<String, dynamic>>> getOrders() {

    return FirebaseFirestore.instance
        .collection("orders")
        .snapshots()
        .switchMap((orderSnapshot) {

      // If no orders, return empty stream immediately
      if (orderSnapshot.docs.isEmpty) {
        return Stream.value(<Map<String, dynamic>>[]);
      }

      // For EACH order doc, create a live stream of its items
      final itemStreams = orderSnapshot.docs.map((orderDoc) {
        return orderDoc.reference
            .collection("items")
            .snapshots() // 👈 snapshots() not get() — this is the key fix
            .map((itemsSnapshot) {

          return itemsSnapshot.docs.map((item) {
            final data = Map<String, dynamic>.from(item.data());
            data["orderDocId"] = orderDoc.id;
            data["createdAt"] = orderDoc["createdAt"];
            return data;
          }).toList();
        });
      }).toList();

      // Combine all item streams into one list
      return Rx.combineLatest<List<Map<String, dynamic>>,
          List<Map<String, dynamic>>>(
        itemStreams,
        (listOfLists) => listOfLists.expand((e) => e).toList(),
      );
    });
  }
}