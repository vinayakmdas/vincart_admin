import 'package:ecommerce_admin/core/themes/app_color.dart';
import 'package:ecommerce_admin/features/dashboard/provider/dashboard_provider.dart';
import 'package:ecommerce_admin/features/dashboard/widget/dashboard_widget.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashbordScreen extends StatelessWidget {
  const DashbordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.dashboarbagroundcolor,
    
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardWidget.welcomename(), 
            SizedBox(height: 20),
            DashboardWidget.dashboardcard(context),
            SizedBox(height: 25), 
           Consumer<DashboardProvider>(
              builder: (context, provider, child) {
                return DashboardWidget
                    .dashboardlist[provider.selectedIndex];
              },
            ),
          ],
        ),
      ),
    );
  }
}
