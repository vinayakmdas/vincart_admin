import 'package:ecommerce_admin/features/brand/widget/brand_custome.dart';
import 'package:flutter/material.dart';

class BrandScreen extends StatelessWidget {
  const BrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          BrandCustome.brandadding(context)
        ],
      )
    );
  }
}