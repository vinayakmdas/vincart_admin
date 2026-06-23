// features/category_management/provider/category_provider.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CategoryProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Single count stream: "total" | "active" | "inactive"
  Stream<int> getCountStream(String type) {
    final ref = _firestore.collection('category');

    switch (type) {
      case 'active':
        return ref
            .where('status', isEqualTo: 'active')
            .snapshots()
            .map((s) => s.docs.length);
      case 'inactive':
        return ref
            .where('status', isEqualTo: 'inactive')
            .snapshots()
            .map((s) => s.docs.length);
      default: // "total"
        return ref.snapshots().map((s) => s.docs.length);
    }
  }

  /// Combined stats stream — used by PieChart
  Stream<Map<String, int>> getCategoryStatsStream() {
    return _firestore.collection('category').snapshots().map((snapshot) {
      final total = snapshot.docs.length;
      final active =
          snapshot.docs.where((d) => d['status'] == 'active').length;
      final inactive = total - active;
      return {'total': total, 'active': active, 'inactive': inactive};
    });
  }
}