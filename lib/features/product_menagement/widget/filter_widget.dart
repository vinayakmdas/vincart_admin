import 'package:ecommerce_admin/core/themes/app_color.dart';
import 'package:flutter/material.dart';

class ProductFilterTabs extends StatefulWidget {
  const ProductFilterTabs({super.key});

  @override
  State<ProductFilterTabs> createState() => _ProductFilterTabsState();
}

class _ProductFilterTabsState extends State<ProductFilterTabs> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColor.productBaground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ToggleButtons(
        isSelected: [
          selectedIndex == 0,
          selectedIndex == 1,
          selectedIndex == 2,
        ],
        onPressed: (index) {
          setState(() => selectedIndex = index);

          // TODO: filter products here
          
        },
        borderRadius: BorderRadius.circular(8),
        selectedColor: Colors.white,
        fillColor: AppColor.skyblue,
        color: Colors.white70,
        borderColor: Colors.transparent,
        selectedBorderColor: Colors.transparent,
        constraints: const BoxConstraints(
          minHeight: 40,
          minWidth: 120,
        ),
        children: const [
          Text("All Products"),
          Text("Active"),
          Text("Inactive"),
        ],
      ),
    );
  }
}
