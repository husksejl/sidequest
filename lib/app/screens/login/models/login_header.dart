import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  final VoidCallback onCloseTap;

  const LoginHeader({
    super.key,
    required this.onCloseTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.04),
            border: Border.all(color: Colors.white.withOpacity(0.09)),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: onCloseTap,
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.white70,
              size: 25,
            ),
          ),
        ),
      ],
    );
  }
}