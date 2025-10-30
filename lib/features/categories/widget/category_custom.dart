import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin/core/themes/app_color.dart';
import 'package:flutter/material.dart';

class CategoryCustom {
  // Add Category Button
  static Widget categoryAdding(BuildContext context) {
    // ✅ Keep controllers OUTSIDE of the dialog button
    TextEditingController categoryController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.only(right: 40, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    title: const Text("Add New Category"),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 🔹 Category Name Field
                          TextFormField(
                            controller: categoryController,
                            decoration: InputDecoration(
                              labelText: "Category Name",
                              hintText: "Enter category name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please enter a category name";
                              } else if (value.trim().length < 3) {
                                return "Category name must be at least 3 characters";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // 🔹 Description Field
                          TextFormField(
                            controller: descriptionController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              labelText: "Description",
                              hintText: "Enter category description",
                              alignLabelWithHint: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please enter a description";
                              } else if (value.trim().length < 10) {
                                return "Description must be at least 10 characters long";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      // ✅ Add Button
                      TextButton(
                        onPressed: () async {
                          String categoryName = categoryController.text.trim();
                          String description = descriptionController.text
                              .trim();

                          if (categoryName.isEmpty || description.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please fill all fields"),
                              ),
                            );
                            return;
                          }

                          try {
                            FirebaseFirestore firestore =
                                FirebaseFirestore.instance;

                            await firestore.collection('category').add({
                              'category': categoryName,
                              'description': description, // ✅ Correct key
                              'status': 'active',
                              'createdAt': DateTime.now().toIso8601String(),
                            });

                            log("✅ Category added successfully!");
                            Navigator.of(context).pop();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("✅ Category added successfully!"),
                                backgroundColor: Colors.green,
                              ),
                            );

                            categoryController.clear();
                            descriptionController.clear();
                          } catch (e) {
                            log("Error adding category: $e");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("❌ Failed to add category: $e"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Text("Add"),
                      ),

                      // Cancel Button
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancel"),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Row(
              children: [
                Icon(Icons.shopping_cart_checkout, color: Colors.white),
                SizedBox(width: 8),
                Text("Add Category", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Category heading + search
  static Widget categoryHeading(
    TextEditingController controller,
    ValueChanged<String> onSearch,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Text(
            "Category List",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 300,
            height: 42,
            child: TextFormField(
              controller: controller,
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: "Search Category...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColor.primaryColor,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColor.primaryColor,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget categoryTableHeader() {
    return Container(
      color: AppColor.primaryColor,
      child: Row(
        children: [
          SizedBox(width: 20),
          SizedBox(height: 50,),
          Expanded(
            child: Text(
              "Category Name",
              style: TextStyle(color: AppColor.whiteColor),
            ),
          ),
          Expanded(
            child: Text(
              "Description",
              style: TextStyle(color: AppColor.whiteColor),
            ),
          ),
          Expanded(
            child: Text("Status", style: TextStyle(color: AppColor.whiteColor)),
          ),
          Expanded(
            child: Text(
              "Created At",
              style: TextStyle(color: AppColor.whiteColor),
            ),
          ),
          Expanded(
            child: Text("Action", style: TextStyle(color: AppColor.whiteColor)),
          ),
        ],
      ),
    );
  }
 
  // static  Future   getingCategoryData() async  {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   QuerySnapshot snapshot = await firestore.collection('category').get();
  //   return snapshot.docs;
  // }
}
