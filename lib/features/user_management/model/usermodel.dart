import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String username;
  final String email;
  final String phone;
  final String uid;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.uid,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserModel(
      id: doc.id,
      username: data["username"] ?? "",
      email: data["email"] ?? "",
      phone: data["phonenumber"] ?? "",
      uid: data["uid"] ?? "",
    );
  }
}