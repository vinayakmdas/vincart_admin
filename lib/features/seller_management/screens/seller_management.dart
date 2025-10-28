import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin/core/themes/app_color.dart';
import 'package:ecommerce_admin/features/seller_management/widget/seller_custome.dart';
import 'package:flutter/material.dart';

class SellerManagement extends StatefulWidget {
  const SellerManagement({super.key});

  @override
  State<SellerManagement> createState() => _SellerManagementState();
}

class _SellerManagementState extends State<SellerManagement> {
  String selectedFilter = "pending"; // Default filter

  // 🔹 Helper to get Firestore Stream based on selected filter
  Stream<QuerySnapshot> getSellerStream() {
    final sellers = FirebaseFirestore.instance.collection("sellers");

    switch (selectedFilter) {
      case "total":
        return sellers.snapshots();
      case "active":
        return sellers.where("status", isEqualTo: "approved").snapshots();
      case "blocked":
        return sellers.where("status", isEqualTo: "blocked").snapshots();
      case "pending":
      default:
        return sellers.where("status", isEqualTo: "pending").snapshots();
    }
  }

  // 🔹 Helper to count sellers dynamically
  Stream<int> getCountStream(String filter) {
    final sellers = FirebaseFirestore.instance.collection("sellers");
    switch (filter) {
      case "total":
        return sellers.snapshots().map((snapshot) => snapshot.docs.length);
      case "active":
        return sellers
            .where("status", isEqualTo: "approved")
            .snapshots()
            .map((snapshot) => snapshot.docs.length);
      case "blocked":
        return sellers
            .where("status", isEqualTo: "blocked")
            .snapshots()
            .map((snapshot) => snapshot.docs.length);
      case "pending":
        return sellers
            .where("status", isEqualTo: "pending")
            .snapshots()
            .map((snapshot) => snapshot.docs.length);
      default:
        return const Stream<int>.empty();
    }
  }

  // 🔹 Widget for each top container
  Widget buildCountContainer({
    required String title,
    required IconData icon,
    required Color color,
    required String filterKey,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => selectedFilter = filterKey),
        child: StreamBuilder<int>(
          stream: getCountStream(filterKey),
          builder: (context, snapshot) {
            int count = snapshot.data ?? 0;
            return SellerContainer.sellercountContainers(
              count,
              context,
              Text(
                title,
                style: TextStyle(
                  color: selectedFilter == filterKey
                      ? color
                      : Colors.white,
                ),
              ),
              icon,
              color,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bagroundColor,
      body: Column(
        children: [
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildCountContainer(
                title: "Total Sellers",
                icon: Icons.people_outline,
                color: Colors.orange,
                filterKey: "total",
              ),
              buildCountContainer(
                title: "Active Sellers",
                icon: Icons.check_circle_outline,
                color: Colors.green,
                filterKey: "active",
              ),
              buildCountContainer(
                title: "Blocked Sellers",
                icon: Icons.block,
                color: Colors.red,
                filterKey: "blocked",
              ),
              buildCountContainer(
                title: "Pending Sellers",
                icon: Icons.hourglass_empty,
                color: Colors.blue,
                filterKey: "pending",
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// 🔹 Sellers List
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  SellerContainer.sellerheading(),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: getSellerStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return const Center(
                              child: Text("Error fetching sellers"));
                        }

                        if (!snapshot.hasData ||
                            snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Text(
                              "NO ${selectedFilter.toUpperCase()} FOUND",
                              style: const TextStyle(color: Colors.black54),
                            ),
                          );
                        }

                        final sellers = snapshot.data!.docs;
                        return ListView.separated(
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1),
                          itemCount: sellers.length,
                          itemBuilder: (context, index) {
                            var data =
                                sellers[index].data() as Map<String, dynamic>;
                            var docUid = sellers[index].id;
                            return SellerContainer.sellerRow(
                                data, context, docUid);
                          },
                        );
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
