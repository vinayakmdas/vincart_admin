import 'package:ecommerce_admin/core/themes/app_color.dart';
import 'package:ecommerce_admin/features/brand/provider/logo_converting.dart';
import 'package:ecommerce_admin/features/brand/service/cloudinary_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrandCustome {
  // ^brand logo and  brand name adding page

  static Widget brandadding(BuildContext context) {
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
                                      height: 100,
                                      width: 100,
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
                                                fit: BoxFit.cover,
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
                                    "Tap to upload Png image",
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
                      SizedBox(width: 20),
                      TextButton(
                        // ^storing date in cloudinary`
                        onPressed: () async {
                          final logoProvider = Provider.of<LogoProvider>(
                            context,
                            listen: false,
                          );

                          if (logoProvider.imagebytes == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("plase selecyt  a brand logo "),
                              ),
                            );
                            return;
                          }

                          final cloudinaryService = CloudinaryService();
                          final imageUrl = await cloudinaryService.uploadImage(
                            logoProvider.imagebytes!,
                          );
                          if (imageUrl != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("✅ Image uploaded successfully!"),
                              ),
                            );

                            // TODO: Store imageUrl + brand name to Firebase
                            print('🌐 Cloudinary Image URL: $imageUrl');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "❌ Upload failed, please try again",
                                ),
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
                Icon(Icons.breakfast_dining_outlined, color: Colors.white),
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
}
