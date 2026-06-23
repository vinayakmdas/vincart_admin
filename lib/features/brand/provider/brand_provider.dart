// features/brand_management/provider/brand_provider.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class BrandProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream of a single count: "total" or "active"
  Stream<int> getCountStream(String type) {
    final ref = _firestore.collection('brand');

    if (type == 'total') {
      return ref.snapshots().map((s) => s.docs.length);
    } else if (type == 'active') {
      return ref
          .where('status', isEqualTo: 'active')
          .snapshots()
          .map((s) => s.docs.length);
    } else if (type == 'inactive') {
      return ref
          .where('status', isEqualTo: 'inactive')
          .snapshots()
          .map((s) => s.docs.length);
    }
    return Stream.value(0);
  }

  /// Combined stream: {total, active, inactive} — used by PieChart
  Stream<Map<String, int>> getBrandStatsStream() {
    return _firestore.collection('brand').snapshots().map((snapshot) {
      final total = snapshot.docs.length;
      final active =
          snapshot.docs.where((d) => d['status'] == 'active').length;
      final inactive = total - active;
      return {'total': total, 'active': active, 'inactive': inactive};
    });
  }
}