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
        backgroundColor: AppColor.bagroundColor,
        actions: [
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(Icons.menu_rounded, color: Color.fromARGB(255, 255, 255, 255)),
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
