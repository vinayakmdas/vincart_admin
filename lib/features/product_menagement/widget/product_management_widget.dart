import 'package:ecommerce_admin/core/themes/app_color.dart';
import 'package:flutter/material.dart';

class ProductManagementWidget {


  static headercontainer(String status, String count,Color color ){

    return  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColor.containerBaground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border(
                        left: BorderSide(color: color, width: 4)
                      )
                    ),
                    
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20,),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [       
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(status,style: TextStyle(color: AppColor.greyColor),)
                            ],
                          ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(count,style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold),)
                            ],
                          )
                      
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

}