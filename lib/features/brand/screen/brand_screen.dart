import 'package:ecommerce_admin/core/themes/app_color.dart';
import 'package:ecommerce_admin/features/brand/widget/brand_custome.dart';
import 'package:ecommerce_admin/features/brand/widget/brand_list.dart';
import 'package:flutter/material.dart';

class BrandScreen extends StatelessWidget {
  const BrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          // Top button or form
          BrandCustome.brandadding(context),

          // Expanded section for list
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
              child: Container(
                width: double.infinity,
                color: AppColor.bagroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BrandList.brandHeading(searchController, (value) {}),
                    Divider(thickness: 2, color: AppColor.whiteColor),
                    BrandList.brandDetailsHeading(),

                    // 🔥 Wrap the StreamBuilder inside Expanded
                    Expanded(
                      child: StreamBuilder<List<Map<String, dynamic>>>(
                        stream: BrandList.getingBradnDetails(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          }

                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text(
                              'Brand Details is Empty',
                              style: TextStyle(color: Colors.white),
                            ));
                          }

                          final branddetails = snapshot.data!;
                          return ListView.builder(
                            itemCount: branddetails.length,
                            itemBuilder: (context, index) {
                              final brand = branddetails[index];
                              int slno = index + 1;
                              return Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 8.0),
                                child: BrandList.datarow(slno, brand),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
