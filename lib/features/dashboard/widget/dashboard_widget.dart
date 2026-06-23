import 'package:ecommerce_admin/core/themes/app_color.dart';
import 'package:ecommerce_admin/features/brand/provider/brand_provider.dart';
import 'package:ecommerce_admin/features/categories/provider/category_provider.dart';
import 'package:ecommerce_admin/features/dashboard/provider/dashboard_provider.dart';
import 'package:ecommerce_admin/features/dashboard/widget/dashboardcard.dart';
import 'package:ecommerce_admin/features/dashboard/widget/seller_dashbordwidget.dart';
import 'package:ecommerce_admin/features/dashboard/widget/totalCategory_widget.dart';
import 'package:ecommerce_admin/features/dashboard/widget/total_product.dart';
import 'package:ecommerce_admin/features/dashboard/widget/total_revenue_widget.dart';
import 'package:ecommerce_admin/features/dashboard/widget/totalbrand_widget.dart';
import 'package:ecommerce_admin/features/dashboard/widget/totalorders_widget.dart';
import 'package:ecommerce_admin/features/order/provider/order_provider.dart';
import 'package:ecommerce_admin/features/product_menagement/provider/product_management_provider.dart';
import 'package:ecommerce_admin/features/seller_management/provider/seller_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardWidget{


  static Widget welcomename(){
 
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 20,left: 20),
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Welcome Back, Admin👋",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Here's what's happening with your store today.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );

  }

static  List<Widget> dashboardlist= [
  SellerDashbordwidget(),
  TotalProductWidget(),
  TotalordersWidget(),
  TotalbrandWidget(),
  TotalcategoryWidget(),
 

];


 
  static Widget dashboardcard(BuildContext context ) {
  return Row(
    children: [
      SizedBox(width: 5,), 
   Expanded(
  child: InkWell(
    onTap: () {
      context.read<DashboardProvider>().changeScreen(0);
    },
    child: StreamBuilder<int>(
      stream: context.read<SellerProvider>().getCountStream("total"),
      builder: (context, snapshot) {
        final count = snapshot.hasData ? snapshot.data.toString() : "...";
        return DashboardCard(
          iconcolour: Colors.blue,
          icon: Icons.people_alt_sharp,
          title: "Total sellers",
          count: count,
        );
      },
    ),
  ),

      ),
     Expanded(
  child: InkWell(
    onTap: () {
      context.read<DashboardProvider>().changeScreen(1);
    },
    child: StreamBuilder<int>(
      stream: context.read<ProductProvider>().getCountStream("total"),
      builder: (context, snapshot) {
        final count = snapshot.hasData ? snapshot.data.toString() : "...";
        return DashboardCard(
          iconcolour: Colors.deepPurple,
          icon: Icons.inventory_2_outlined,
          title: "Total product",
          count: count,
        );
      },
    ),
  ),
),
     Expanded(
  child: InkWell(
    onTap: () {
      context.read<DashboardProvider>().changeScreen(2);
    },
    child: StreamBuilder<int>(
      stream: context.read<OrderProvider>().getOrderCountStream("total"),
      builder: (context, snapshot) {
        final count = snapshot.hasData ? snapshot.data.toString() : "...";
        return DashboardCard(
          iconcolour: Colors.orange,
          icon: Icons.shopping_cart_outlined,
          title: "Total Orders",
          count: count,
        );
      },
    ),
  ),
),
      Expanded(
  child: InkWell(
    onTap: () => context.read<DashboardProvider>().changeScreen(3),
    child: StreamBuilder<int>(
      stream: context.read<BrandProvider>().getCountStream("total"),
      builder: (context, snapshot) {
        final count = snapshot.hasData ? snapshot.data.toString() : "...";
        return DashboardCard(
          iconcolour: AppColor.greenColor,
          icon: Icons.local_offer_outlined,
          title: "Total Brands",
          count: count,
        );
      },
    ),
  ),
),
        Expanded(
  child: InkWell(
    onTap: () => context.read<DashboardProvider>().changeScreen(4),
    child: StreamBuilder<int>(
      stream: context.read<CategoryProvider>().getCountStream("total"),
      builder: (context, snapshot) {
        final count = snapshot.hasData ? snapshot.data.toString() : "...";
        return DashboardCard(
          iconcolour: Colors.pink,
          icon: Icons.category_outlined,
          title: "Total Categories",
          count: count,
        );
      },
    ),
  ),
),
      
    ],
  );
}
 }
