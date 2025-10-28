import 'package:ecommerce_admin/core/themes/app_color.dart';
import 'package:ecommerce_admin/features/categories/screens/category_screen.dart';
import 'package:ecommerce_admin/features/customer_service/screen/customer_screen.dart';
import 'package:ecommerce_admin/features/dashboard/screens/dashbord_screen.dart';
import 'package:ecommerce_admin/features/homescreen/model/drawer_Model.dart';
import 'package:ecommerce_admin/features/homescreen/screens/provider/sideMen_provider.dart';
import 'package:ecommerce_admin/features/order/screens/Oreder_screens.dart';
import 'package:ecommerce_admin/features/seller_management/screens/seller_management.dart';
import 'package:ecommerce_admin/features/user_management/screens/userManagement.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'dart:developer' as developer;



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return DashbordScreen();
      case 1:
        return Usermanagement();
      case 2:
        return SellerManagement();
      case 3:
        return CustomerScreen();
      case 4:
        return OrederScreens();
      case 5:
        return CategoryScreen();
      default:
        return Center(
          child: Text(
            "Unknown Screen",
            style: GoogleFonts.cormorantGaramond(
              color: Colors.grey.shade300,
              fontSize: 18,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sideMenu = context.watch<DrawerProvider>();

    final menuItems = [
      SideMenuItems(title: "Dashboard", icon: Icons.dashboard, pageTitle: "Dashboard Overview"),
      SideMenuItems(title: "User Management", icon: Icons.supervised_user_circle_outlined, pageTitle: "User Management"),
      SideMenuItems(title: "Seller Management", icon: Icons.add_business_sharp, pageTitle: "Seller Management"),
      SideMenuItems(title: "Customer Service", icon: Icons.headset_mic_outlined, pageTitle: "Customer Service"),
      SideMenuItems(title: "Order", icon: Icons.shopping_cart, pageTitle: "Order Details"),
      SideMenuItems(title: "Categories", icon: Icons.category_outlined, pageTitle: "Categories"),
    ];

    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
  title: Text(
    menuItems[sideMenu.selectedIndex].pageTitle,
    style: GoogleFonts.cormorantGaramond(
      color: Colors.grey.shade300,
      fontWeight: FontWeight.w600,
    ),
  ),
  foregroundColor: Colors.white,
  backgroundColor: AppColor.bagroundColor,
  actions: [
    Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        children: [
          // ✅ "Admin" Button
          ElevatedButton(
            onPressed: () {
              // Optional: do something when pressing "Admin"
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Admin",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.white),
            ),
          ),

          const SizedBox(width: 4),

          // ✅ Dropdown (Logout Option)
          PopupMenuButton<String>(
            color: AppColor.primaryColor,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white, size: 28),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onSelected: (value) {
              if (value == 'logout') {
             
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out')),
                );
            
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Text('Logout',style: TextStyle(color: Colors.red),),
              ),
            ],
          ),
        ],
      ),
    ),
  ],
),

      drawer: Drawer(
        shadowColor: Colors.white,
        backgroundColor: AppColor.bagroundColor,
        child: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            final item = menuItems[index];
            return ListTile(
              
              leading: Icon(item.icon, color: Colors.white),
              title: Text(
                item.title,
                style: GoogleFonts.cormorantGaramond(
                  color: Colors.grey.shade300, // light grey
                  fontSize: 18,
                ),
              ),
              selected: index == sideMenu.selectedIndex,
              selectedTileColor: AppColor.primaryColor,
              onTap: () {
                context.read<DrawerProvider>().onMenuButton(index);
                Navigator.pop(context); // close drawer
              },
            );
          },
        ),
      ),
      body: _buildScreen(sideMenu.selectedIndex),
    );
  }
}
