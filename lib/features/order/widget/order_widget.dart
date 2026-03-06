import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin/core/themes/app_color.dart';
import 'package:flutter/material.dart';

class OrderWidget {


  static Widget orderHeadercontainer(
      BuildContext context,
      String title,
      int data,
      IconData icon,
      String percentage,
      Color iconColor) {

    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth / 3.5;

    return Container(
      height: 164,
      width: containerWidth,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.containercolor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Top Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              /// Icon Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 22,
                ),
              ),

              /// Percentage
              Text(
                percentage,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// Title
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 6),

          /// Number
          Expanded(
            child: Text(
              data.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

 static Widget searchDetails() {
    return Container(
      height: 44, // 👈 same as ToggleButtons height
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColor.productBaground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            color: AppColor.whiteColor.withOpacity(0.7),
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            "Search Order Id...",
            style: TextStyle(
              color: AppColor.whiteColor.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

static Widget headerrow() {
    return Container(
      height: 40,
      color: AppColor.headerbaground,
      child: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Row(
          children: [
            Expanded(
              child: Text("ORDER ID", style: TextStyle(color: AppColor.greyColor)),
            ),
            Expanded(
              child: Text(
                "PRODUCT IMAGE",
                style: TextStyle(color: AppColor.greyColor),
              ),
            ),
            SizedBox(width: 33),

            Expanded(
              child: Text(
                "PRODUCT NAME",
                style: TextStyle(color: AppColor.greyColor),
              ),
            ),
            Expanded(
              child: Text(
                "SELLER ID",
                style: TextStyle(color: AppColor.greyColor),
              ),
            ),
            Expanded(
              child: Text(
                "PRICE",
                style: TextStyle(color: AppColor.greyColor),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 32  ),
                child: Text(
                  "STATUS",
                  style: TextStyle(color: AppColor.greyColor),
                ),
              ),
            ),
            Expanded(
              child: Text(
                "DATA ADDED",
                style: TextStyle(color: AppColor.greyColor),
              ),
            ),
          ],
        ),
      ),
    );
  }



static Widget detailsRow(
  Map<String, dynamic> data,
  int index,
  BuildContext context,
) {

 Color buttonBackgroundColor;
  Color borderSide;
  Color colorText;

   if (data["status"] == "pending") {
    buttonBackgroundColor = Colors.orange.withOpacity(0.15);
    borderSide = Colors.orange;
    colorText = Colors.orange;
  } else if (data["status"] == "delivered") {
    buttonBackgroundColor = Colors.green.withOpacity(0.15);
    borderSide = Colors.green;
    colorText = Colors.green;
  } else {
    buttonBackgroundColor = Colors.red.withOpacity(0.15);
    borderSide = Colors.red;
    colorText = Colors.red;
  }

  return Row(
    children: [

      SizedBox(width: 12),

      Expanded(
        child: Text(
          data["orderId"] ?? "",
          style: TextStyle(color: AppColor.greyColor),
        ),
      ),

      CircleAvatar(
        radius: 18,
        backgroundImage: NetworkImage(data["image"] ?? ""),
      ),

      SizedBox(width: 40),

      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 128),
          child: Text(
            data["productName"] ?? "",
            style: TextStyle(color: AppColor.greyColor),
          ),
        ),
      ),

      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 82),
          child: Text(
            data["sellerId"] ?? "",
            style: TextStyle(color: AppColor.greyColor),
          ),
        ),
      ),

      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 72 ),
          child: Text(
            "₹${data["price"]}",
            style: TextStyle(color: AppColor.greyColor),
          ),
        ),
      ),

      Expanded(
  child: Align(
    alignment: Alignment.centerLeft,
    child: SizedBox(
      width: 110,
      height: 28,
      child: Padding(
        padding: const EdgeInsets.only(),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 12),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: buttonBackgroundColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: borderSide),
              borderRadius: BorderRadius.circular(23),
            ),
          ),
         onPressed: () {
        
          if (data["orderDocId"] == null) {
            print("❌ orderDocId missing");
            return;
          }
        
          showOrderStatusDialog(
            context,
            data["orderDocId"],
            data["status"] ?? "pending",
          );
        },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.circle, color: colorText, size: 8),
              SizedBox(width: 5),
              Text(
                data["status"],
                style: TextStyle(color: colorText),
              ),
            ],
          ),
        ),
      ),
    ),
  ),
),

      Expanded(
        child: Text(
          data["createdAt"].toString(),
          style: TextStyle(color: AppColor.greyColor),
        ),
      ),
    ],
  );
}
static Future<void> updateOrderStatus(
    String orderId, String newStatus) async {

  final items = await FirebaseFirestore.instance
      .collection("orders")
      .doc(orderId)
      .collection("items")
      .get();

  for (var doc in items.docs) {
    await doc.reference.update({
      "status": newStatus
    });
  }
}

static void showOrderStatusDialog(
    BuildContext context, String orderId, String status) {

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColor.containerBaground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          "Update Order Status",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        content: Text(
          "Change the order status?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            onPressed: () {
              updateOrderStatus( orderId, "pending");
              Navigator.pop(context);
            },
            child: Text("Pending",style: TextStyle(color: AppColor.whiteColor)),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            onPressed: () {
              updateOrderStatus( orderId, "delivered",);
              Navigator.pop(context);
            },
            child: Text("Delivered",style: TextStyle(color: AppColor.whiteColor),),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              updateOrderStatus( orderId, "cancelled");
              Navigator.pop(context);
            },
            child: Text("Cancelled",style: TextStyle(color: AppColor.whiteColor)),
          ),
        ],
      );
    },
  );
}
}