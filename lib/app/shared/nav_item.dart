import 'package:flutter/material.dart';

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isCenter;
  final VoidCallback? onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    this.isActive = false,
    this.isCenter = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = isCenter
        ? const Color(0xFFEB5D4F)
        : isActive
        ? const Color(0xFF00B2AA)
        : const Color(0xFF6D727B);

    return GestureDetector(
        onTap: onTap,
        child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: activeColor,
          size: isCenter ? 30 : 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: activeColor,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
      ],
        ),
    );
  }
}