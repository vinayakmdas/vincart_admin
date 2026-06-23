import 'package:ecommerce_admin/core/themes/app_color.dart';
import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String count;

  final IconData icon;
  final bool isGradient;
  final Color iconcolour;
  const DashboardCard({
    super.key,
    required this.title,
    required this.count,
  
    required this.icon,
    this.isGradient = false,
    required this.iconcolour
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16,left: 5 , ), 
      child: Container(
        height: 150,
        width: 200,
        margin: const EdgeInsets.only(right: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
                 color: AppColor.cardbagroundcolor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow( 
              color: AppColor.cardbagroundcolor,
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconcolour.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 20, color: iconcolour),
    ),

    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColor.whiteColor.withValues(alpha: .75),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          count,
          style: TextStyle(
            color: AppColor.whiteColor,
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  ],
),
      ),
    );
  }
}