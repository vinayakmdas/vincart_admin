import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin/core/themes/app_color.dart';
import 'package:ecommerce_admin/features/auth/presentaion/widget/navigator.dart';
import 'package:ecommerce_admin/features/brand/provider/logo_converting.dart';
import 'package:ecommerce_admin/features/brand/service/cloudinary_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrandCustome {
  // ^brand logo and brand name adding page
  static Widget brandadding(BuildContext context) {
    final TextEditingController brandcontrolling = TextEditingController();

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
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: AppColor.primaryColor,
                    title: Text(
                      "Add Brand",
                      style: TextStyle(color: AppColor.whiteColor),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColor.whiteColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Consumer<LogoProvider>(
                            builder: (context, value, child) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    borderRadius: BorderRadius.circular(60),
                                    onTap: () async {
                                      await pickiamge(context);
                                    },
                                    child: Container(
                                      height: 120,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColor.primaryColor
                                              .withOpacity(0.5),
                                          width: 2,
                                        ),
                                        color: AppColor.whiteColor,
                                        image: value.imagebytes != null
                                            ? DecorationImage(
                                                image: MemoryImage(
                                                  value.imagebytes!,
                                                ),
                                                fit: BoxFit.contain, // ✅ show full logo
                                              )
                                            : null,
                                      ),
                                      child: value.imagebytes == null
                                          ? Center(
                                              child: Icon(
                                                Icons.add_a_photo_outlined,
                                                color: AppColor.greyColor,
                                                size: 36,
                                              ),
                                            )
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    value.imagefile ?? "Add Brand Logo",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColor.blackColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Tap to upload PNG image",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColor.greyColor[600],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 25),
                        TextFormField(
                          controller: brandcontrolling,
                          decoration: InputDecoration(
                            hintText: 'Enter brand name',
                            prefixIcon: const Icon(Icons.store),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            fillColor: AppColor.whiteColor,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: AppColor.whiteColor),
                        ),
                      ),
                      const SizedBox(width: 20),
                      TextButton(
                        onPressed: () async {
                          final logoProvider = Provider.of<LogoProvider>(
                            context,
                            listen: false,
                          );

                          if (logoProvider.imagebytes == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please select a brand logo."),
                              ),
                            );
                            return;
                          }

                          final cloudinaryService = CloudinaryService();
                          final imageUrl = await cloudinaryService.uploadImage(
                            logoProvider.imagebytes!,
                          );

                          if (imageUrl != null) {
                            String brandname = brandcontrolling.text.trim();
                            await addBrandToFirestore(
                                imageurl: imageUrl, brandName: brandname);
                            logoProvider.clearImage();
                            brandcontrolling.clear();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("✅ Image uploaded successfully!"),
                              ),
                            );
                            navigatePop(context);
                            print('🌐 Cloudinary Image URL: $imageUrl');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("❌ Upload failed, please try again"),
                              ),
                            );
                          }
                        },
                        child: Text(
                          "Submit",
                          style: TextStyle(color: AppColor.whiteColor),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Row(
              children: [
                Icon(Icons.add_circle_outline, color: Colors.white),
                SizedBox(width: 8),
                Text("Add Brand", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ^pick image from file
  static pickiamge(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png'],
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      var byte = result.files.single.bytes!;
      final imagename = result.files.single.name;

      Provider.of<LogoProvider>(
        context,
        listen: false,
      ).setingBrandingImage(byte, imagename);
    }
  }

  // ^ Add brand to Firestore
  static Future<void> addBrandToFirestore({
    required String brandName,
    required String imageurl,
  }) async {
    final firestore = FirebaseFirestore.instance;

    // Step 1: Check if brand already exists
    final existing = await firestore
        .collection('brand')
        .where('brandName', isEqualTo: brandName.trim())
        .get();

    if (existing.docs.isNotEmpty) {
      print("⚠️ Brand '$brandName' already exists!");
      return;
    }

    // Step 2: Add new brand
    await firestore.collection('brand').add({
      'brandName': brandName.trim(),
      'imageUrl': imageurl,
      'status': 'active',
      'createdAt': FieldValue.serverTimestamp(),
    });

    print("✅ Brand '$brandName' added successfully!");
  }

  // ^Fetch and display all brands
  static Widget brandListView() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('brand')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final brands = snapshot.data!.docs;

        if (brands.isEmpty) {
          return const Center(
            child: Text("No brands added yet"),
          );
        }

        return ListView.builder(
          itemCount: brands.length,
          itemBuilder: (context, index) {
            final brand = brands[index];
            final brandName = brand['brandName'];
            final imageUrl = brand['imageUrl'];

            return ListTile(
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey[200],
                child: ClipOval(
                  child: Image.network(
                    imageUrl,
                    width: 56,
                    height: 56,
                    fit: BoxFit.contain, // ✅ show full logo properly
                  ),
                ),
              ),
              title: Text(
                brandName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text("Tap to view details"),
            );
          },
        );
      },
    );
  }
}
