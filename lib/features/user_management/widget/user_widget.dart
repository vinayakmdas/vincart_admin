import 'package:ecommerce_admin/core/themes/app_color.dart';
import 'package:flutter/material.dart';

class UserContainer {

  static Widget userCountContainer(
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
              color: AppColor.whiteColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  static Widget userHeading() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      color: AppColor.containercolor,
      child: const Row(
        children: [
          Expanded(
              child: Text("Username",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColor.whiteColor))),
          Expanded(
              child: Text("Phone",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColor.whiteColor))),
          Expanded(
              child: Text("Email",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColor.whiteColor))),
          Expanded(
              child: Text("UID",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColor.whiteColor))),
        ],
      ),
    );
  }

  static Widget userRow(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          Expanded(child: Text(data["username"] ?? "")),
          Expanded(child: Text(data["phonenumber"] ?? "")),
          Expanded(child: Text(data["email"] ?? "")),
          Expanded(child: Text(data["uid"] ?? "")),
        ],
      ),
    );
  }
}