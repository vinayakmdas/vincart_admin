import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin/core/themes/app_color.dart';
import 'package:flutter/material.dart';

class ChatListSCreen extends StatelessWidget {

  final Function(String) onSellerSelected;

  const ChatListSCreen({super.key, required this.onSellerSelected});

  @override
  Widget build(BuildContext context) {

    List<Color> leadingbaground = [
      Colors.greenAccent,
      Colors.amberAccent,
      Colors.tealAccent,
      Colors.redAccent,
      Colors.purpleAccent,
      Colors.indigoAccent
    ];

    return Scaffold(
backgroundColor: AppColor.productBaground,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('sellers')
            .where('status', isEqualTo: 'approved')
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final sellers = snapshot.data!.docs;

          return ListView.builder(
            itemCount: sellers.length,
            itemBuilder: (context, index) {

              final seller = sellers[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: leadingbaground[index % leadingbaground.length],
                  child: Text(
                    seller['sellerName'][0],
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
           title: Text(seller['sellerName'],style: TextStyle(color: AppColor.whiteColor),), subtitle: Text(seller['email'],style: TextStyle(color: AppColor.listsubheading),),
                onTap: () {

                 
                  onSellerSelected(seller['uid']);
                },
              );
            },
          );
        },
      ),
    );
  }
}