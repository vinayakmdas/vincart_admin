import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin/core/themes/app_color.dart';
import 'package:ecommerce_admin/features/seller_management/provider/seller_provider.dart';
import 'package:ecommerce_admin/features/seller_management/widget/seller_custome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SellerManagement extends StatelessWidget {
  const SellerManagement({super.key});

  final String selectedFilter = "pending"; 
 // Default filter
  Widget buildCountContainer({
    required String title,
    required IconData icon,
    required Color color,
    required String filterKey,
     required BuildContext context,
  }) {

    final provider = Provider.of<SellerProvider>(context);
    return Expanded(
       
      child: InkWell(
        onTap: () => provider.setFilter(filterKey),
        child: StreamBuilder<int>(
             stream: provider.getCountStream(filterKey),
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
                context: context,
                title: "Total Sellers",
                icon: Icons.people_outline,
                color: Colors.orange,
                filterKey: "total",
              ),
              buildCountContainer(
                context: context,
                title: "Active Sellers",
                icon: Icons.check_circle_outline,
                color: Colors.green,
                filterKey: "active",
              ),
              buildCountContainer(
                context: context,
                title: "Blocked Sellers",
                icon: Icons.block,
                color: Colors.red,
                filterKey: "blocked",
              ),
              buildCountContainer(
                context: context,
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
                        stream: Provider.of<SellerProvider>(context).getSellerStream(),
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
