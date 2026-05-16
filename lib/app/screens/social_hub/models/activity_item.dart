import 'package:flutter/material.dart';

class ActivityItem {
  final IconData icon;
  final String title;
  final String text;
  final String time;
  final String? actionText;
  final DateTime? createdAt;

  const ActivityItem({
    required this.icon,
    required this.title,
    required this.text,
    required this.time,
    this.actionText,
    this.createdAt,
  });
}