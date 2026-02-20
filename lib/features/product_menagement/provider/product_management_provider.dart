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
          "total";
          return product.snapshots();
      }
    }
  }
