import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin/core/themes/app_color.dart';
import 'package:flutter/material.dart';

class ProductManagementWidget {
  static headercontainer(String status, String count, Color color) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColor.containerBaground,
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),

      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(status, style: TextStyle(color: AppColor.greyColor)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  count,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
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
            "Search product or seller...",
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
              child: Text("S NO", style: TextStyle(color: AppColor.greyColor)),
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
                "SELLER NAME",
                style: TextStyle(color: AppColor.greyColor),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 40),
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
    String imageUrl,
    Color buttonbagroundColor,
    Color borderside,
    Color colorText,
    BuildContext context,
  ) {
    return Row(
      children: [
        SizedBox(width: 12),
        Expanded(
          child: Text(
            (index + 1).toString(),
            style: TextStyle(color: AppColor.greyColor),
          ),
        ),
        SizedBox(width: 55),
        CircleAvatar(
          radius: 18,
          backgroundColor: AppColor.whiteColor,
          child: ClipOval(
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: 36, // radius * 2
                    height: 36,
                    fit: BoxFit.cover, // change this if needed
                  )
                : Icon(Icons.image, size: 18),
          ),
        ),
        Spacer(),
        Expanded(
          child: Text(
            data["category"] ?? "",
            style: TextStyle(color: AppColor.greyColor),
          ),
        ),
        Expanded(
          child: Text(
            data["sellerName"] ?? "",
            style: TextStyle(color: AppColor.greyColor),
          ),
        ),

        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 110,
              height: 28,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: buttonbagroundColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: borderside),
                    borderRadius: BorderRadius.circular(23),
                  ),
                ),
                onPressed: () {
                  showstatusUpdateDialog(context, data["productId"], data["status"]);
                  

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.circle, color: colorText, size: 8),
                    SizedBox(width: 5),
                    Text(
                      data["status"] ?? "",
                      style: TextStyle(color: colorText),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        Expanded(
          child: Text(
            data["createdAt"] ?? "",
            style: TextStyle(color: AppColor.greyColor),
          ),
        ),
      ],
    );
  }







static Future<void> updateProductStatus(
    BuildContext context, String docUid, String newStatus) async {
  try {
    await FirebaseFirestore.instance
        .collection("products")
        .doc(docUid)
        .update({"status": newStatus});
    print("✅ Product  status updated to $newStatus");
  } catch (e) {
    print("❌ Error updating product status: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Error updating product status")),
    );
  }
}




static  void showstatusUpdateDialog(BuildContext context , String docId,String status){
print("this is  the product id $docId and status is $status");
showDialog(
  context: context,
  builder: (context) {
    return AlertDialog(
      backgroundColor: AppColor.containerBaground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        "Change Status",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      content: Text(
        "Are you sure you want to change this product status?",
        style: TextStyle(color: Colors.white70),
      ),
      actions: [
        // INACTIVE BUTTON (Red Style)
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.redcolor,
            side: BorderSide(color: AppColor.bordercolorRed),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            updateProductStatus(context, docId, "inactive");
            Navigator.pop(context);
          },
          child: Text(
            "Inactive",
            style: TextStyle(color: AppColor.rednText),
          ),
        ),

        // ACTIVE BUTTON (Green Style)
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.greencolor,
            side: BorderSide(color: AppColor.bordercolorGreen),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            updateProductStatus(context, docId, "active");
            Navigator.pop(context);
          },
          child: Text(
            "Active",
            style: TextStyle(color: AppColor.greenText),
          ),
        ),
      ],
    );
  },
);
}


}
