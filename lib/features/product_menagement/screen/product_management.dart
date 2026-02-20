import 'package:ecommerce_admin/core/themes/app_color.dart';
import 'package:ecommerce_admin/features/product_menagement/provider/product_management_provider.dart';
import 'package:ecommerce_admin/features/product_menagement/widget/filter_widget.dart';
import 'package:ecommerce_admin/features/product_menagement/widget/product_management_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductManagement extends StatelessWidget {
  const ProductManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.productBaground,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ProductManagementWidget.headercontainer(
                      "TOTAL PRODUCTS",
                      "32",
                      AppColor.whiteColor,
                    ),
                  ),
                  const SizedBox(width: 20),

                  Expanded(
                    child: ProductManagementWidget.headercontainer(
                      "ACTIVE LISTINGS",
                      "23",
                      AppColor.greenColor,
                    ),
                  ),
                  const SizedBox(width: 20),

                  Expanded(
                    child: ProductManagementWidget.headercontainer(
                      "REJECTED LISTINGS",
                      "23",
                      AppColor.redColor,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: ProductManagementWidget.headercontainer(
                      "TOTAL SELLERS",
                      "10",
                      AppColor.greyColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.containerBaground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ProductFilterTabs(),

                          Spacer(),
                          ProductManagementWidget.searchDetails(),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Divider(thickness: 0.2),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ProductManagementWidget.headerrow(),

                          SizedBox(height: 10),
                          Divider(thickness: 0.2),
                          SizedBox(height: 10),

                          Consumer<ProductProvider>(
                            builder: (context, provider, child) {
                              return StreamBuilder(
                                stream: provider.getProductSream(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  final docs = snapshot.data?.docs ?? [];

                                  return ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: docs.length,
                                    separatorBuilder: (context, index) =>
                                        Divider(thickness: 0.2),
                                    itemBuilder: (context, index) {
                                      final data =
                                          docs[index].data()
                                              as Map<String, dynamic>;

                                      final variants =
                                          data["variants"] as List<dynamic>? ??
                                          [];

                                      final variant = variants.isNotEmpty
                                          ? variants[0] as Map<String, dynamic>
                                          : null;

                                      final images =
                                          variant?["images"] as List<dynamic>?;

                                      final imageUrl =
                                          (images != null && images.isNotEmpty)
                                          ? images[0]
                                          : "";

                                      late Color borderside;
                                      late Color colorText;
                                      late Color buttonbagroundColor;

                                      if (data["status"] == "active") {
                                        buttonbagroundColor =
                                            AppColor.greencolor;
                                        borderside = AppColor.bordercolorGreen;
                                        colorText = AppColor.greenText;
                                      } else if (data["status"] == "inactive") {
                                        borderside = AppColor.bordercolorRed;
                                        colorText = AppColor.rednText;
                                        buttonbagroundColor = AppColor.redcolor;
                                      }

                                      return  ProductManagementWidget.detailsRow(data, index, imageUrl, buttonbagroundColor, borderside, colorText, context);
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
