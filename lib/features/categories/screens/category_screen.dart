import 'package:ecommerce_admin/core/themes/app_color.dart';
import 'package:ecommerce_admin/features/categories/widget/category_custom.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchcontroller = TextEditingController();
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          const SizedBox(height: 20),
          CategoryCustom.categoryAdding(context),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
                child: Container(
                  width: double.infinity,
                  color: AppColor.bagroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CategoryCustom.categoryHeading(
                        searchcontroller,
                        (value) {},
                      ),
                      const SizedBox(height: 10),
                      Divider(thickness: 2, color: AppColor.whiteColor),
                      CategoryCustom.categoryTableHeader(),

                      Expanded(
                        child: StreamBuilder<List<Map<String, dynamic>>>(
                          stream: CategoryCustom.categoryDataGet(),
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
                              return const Center(child: Text('No Data Found'));
                            }

                            final categories = snapshot.data!;
                          

                            return ListView.builder(
                              itemCount: categories.length,
                              itemBuilder: (context, index) {
                                final category = categories[index];
                            int    slno = index + 1;
                    
                                return  Padding(
  padding: const EdgeInsets.only(bottom: 8.0), 
  child: CategoryCustom.categoryDataRow(category, slno),
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
          ),
        ],
      ),
    );
  }
}
