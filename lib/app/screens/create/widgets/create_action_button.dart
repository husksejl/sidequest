import 'package:flutter/material.dart';

class CreateActionButton extends StatelessWidget {
  final IconData icon;

  const CreateActionButton({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF121212),
        border: Border.all(
          color: const Color(0xFFEB5D4F),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEB5D4F).withOpacity(0.35),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(
        icon,
        color: const Color(0xFFEB5D4F),
        size: 38,
      ),
    );
  }
}