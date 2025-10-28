import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin/core/themes/app_color.dart';
import 'package:flutter/material.dart';


class SellerContainer {
  // Seller count container
  static Widget sellercountContainers(
      int data, BuildContext context, Text detail, IconData icons, Color colors) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth / 3.5;
    return Container(
      height: 120,
      width: containerWidth,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColor.containercolor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              detail,
              const SizedBox(width: 5),
              Icon(icons, color: colors),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "$data",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Header row for pending sellers
  static Widget sellerheading() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      color: AppColor.containercolor,
      child: const Row(
        children: [
          Expanded(
              child: Text("Name",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white))),
          Expanded(
              child: Text("Phone No",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white))),
          Expanded(
              child: Text("Email",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white))),
          Expanded(
              child: Text("Status",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white))),
        ],
      ),
    );
  }
// // Row for each seller
static Widget sellerRow(
  Map<String, dynamic> data,
  BuildContext context,
  String docId,
) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.grey.shade300),
      ),
    ),
    child: Row(
      children: [
        Expanded(child: Text(data["sellerName"] ?? "")),
        Expanded(child: Text(data["phone"] ?? "")),
        Expanded(child: Text(data["email"] ?? "")),


        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.containercolor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: AppColor.containercolor,
                    title: const Text(
                      "Change Seller Status",
                      style: TextStyle(color: Colors.white),
                    ),
                    content: Text(
                      "Do you want to approve or block ${data["sellerName"]}?",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          await updateSellerStatus(
                              context, docId, "approved");
                          if (context.mounted) {
                            Navigator.pop(context); // close dialog
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Seller approved successfully!"),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "Approve",
                          style: TextStyle(color: Colors.greenAccent),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await updateSellerStatus(
                              context, docId, "blocked");
                          if (context.mounted) {
                            Navigator.pop(context); // close dialog
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Seller blocked successfully!"),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "Block",
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text(
              (data["status"] ?? "").toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    ),
  );
}


// 🔹 Firestore update method
static Future<void> updateSellerStatus(
    BuildContext context, String docUid, String newStatus) async {
  try {
    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(docUid)
        .update({"status": newStatus});
    print("✅ Seller status updated to $newStatus");
  } catch (e) {
    print("❌ Error updating seller status: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Error updating seller status")),
    );
  }
}

}
