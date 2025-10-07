import 'package:flutter/material.dart';

class ListItem {
  final String title;
  final String subtitle;
  final IconData? icon;
  final Widget? trailingIcon;

  ListItem(
      {required this.title,
      required this.subtitle,
      this.icon,
      this.trailingIcon});
}
