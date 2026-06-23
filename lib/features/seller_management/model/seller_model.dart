import 'package:cloud_firestore/cloud_firestore.dart';


class SellerModel {
  final String id;
  final String sellerName;
  final String email;
  final String phone;
  final String status;
  final DateTime createdAt;

  SellerModel({
    required this.id,
    required this.sellerName,
    required this.email,
    required this.phone,
    required this.status,
    required this.createdAt,
  });

  factory SellerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SellerModel(
      id: doc.id,
      sellerName: data["sellerName"] ?? "",
      email: data["email"] ?? "",
      phone: data["phone"] ?? "",
      status: data["status"] ?? "",
      createdAt:
          (data["createdAt"] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}