import 'package:ecommerce_admin/core/themes/app_color.dart';
import 'package:ecommerce_admin/features/product_menagement/widget/filter_widget.dart';
import 'package:ecommerce_admin/features/product_menagement/widget/product_management_widget.dart';
import 'package:flutter/material.dart';

class ProductManagement extends StatelessWidget {
  const ProductManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.productBaground,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ProductManagementWidget.headercontainer("TOTAL PRODUCTS", "32",
                  AppColor.whiteColor)
                ),
                const SizedBox(width: 20),

                Expanded(
                  child: ProductManagementWidget.headercontainer("ACTIVE LISTINGS", "23",AppColor.greenColor)
                ),
                const SizedBox(width: 20),

                Expanded(
                  child: ProductManagementWidget.headercontainer("REJECTED LISTINGS", "23",AppColor.redColor)
                ),
                SizedBox(width: 20,),
                Expanded(
                  child: ProductManagementWidget.headercontainer("TOTAL SELLERS", "10",AppColor.greyColor)
                ),
              ],
            ),
              SizedBox(height: 20,),

            Container(
  width: double.infinity,
  decoration: BoxDecoration(
    color: AppColor.containerBaground,
    borderRadius: BorderRadius.circular(12 )
  ),
  child: Column(
    children: [
      SizedBox(height: 12,), 
      Container(

        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ProductFilterTabs(),

            Spacer(),
            ProductManagementWidget.searchDetails()
          ],
        )
      ),
      SizedBox(height:  5  ),
        Divider(thickness: 0.2 ,) ,

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 40 ,
            color: AppColor.bagroundColor,
            child: 
                 
               
               Padding( 
                 padding: const EdgeInsets.only(left: 12 ),
                 child: Row(
                  children: [
                    Expanded(child: Text("S NO",style: TextStyle(color: AppColor.greyColor),)),
                    Expanded(child: Text("PRODUCT NAME",style: TextStyle(color: AppColor.greyColor),)),
                    Expanded(child: Text("SELLER NAME",style: TextStyle(color: AppColor.greyColor),)),
                    Expanded(child: Text("Status",style: TextStyle(color: AppColor.greyColor),)),
                    Expanded(child: Text("DATA ADDED",style: TextStyle(color: AppColor.greyColor),)),
                  ],
                               ),
               ),
            
             
          ),
        )

    ],
  ),
)

          ],
        ),
      ),
    );
  }
}
