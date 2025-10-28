import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin/core/themes/app_color.dart';
import 'package:ecommerce_admin/features/seller_management/widget/seller_custome.dart';
import 'package:flutter/material.dart';

class SellerManagement extends StatelessWidget {
  const SellerManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bagroundColor,
      body: Column(
        children: [
          const SizedBox(height: 20),

          // Top stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SellerContainer.sellercountContainers(
                  2,
                  context,
                  const Text("Total Sellers", style: TextStyle(color: Colors.white)),
                  Icons.people_outline_sharp,
                  Colors.orange,
                ),
              ),
              Expanded(
                child: SellerContainer.sellercountContainers(
                  23,
                  context,
                  const Text("Active Sellers", style: TextStyle(color: Colors.white)),
                  Icons.people_outline_sharp,
                  Colors.green,
                ),
              ),
              Expanded(
                child: SellerContainer.sellercountContainers(
                  5,
                  context,
                  const Text("Blocked Sellers", style: TextStyle(color: Colors.white)),
                  Icons.people_outline_sharp,
                  Colors.red,
                ),
              ),
              Expanded(
                child: SellerContainer.sellercountContainers(
                  95,
                  context,
                  const Text("Pending Sellers", style: TextStyle(color: Colors.white)),
                  Icons.people_outline_sharp,
                  Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  SellerContainer.sellerheading(),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("sellers")
                          .where("status", isEqualTo: "pending")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(child: Text("Error fetching data"));
                        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text("No pending sellers"));
                        } else {
                          final sellers = snapshot.data!.docs;
                          return ListView.builder(
                            itemCount: sellers.length,
                            itemBuilder: (context, index) {
                              var data = sellers[index].data() as Map<String, dynamic>;

                              var docUid= sellers[index].id;
                              return SellerContainer.sellerRow(data,context,docUid);
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
