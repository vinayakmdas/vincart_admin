import 'package:flutter/material.dart';

class SideMenuItems {
  final String title;
  final IconData icon;
  final String pageTitle;

  SideMenuItems({
    required this.title,
    required this.icon,
    required this.pageTitle,
  });

  void operator [](String other) {}
}

