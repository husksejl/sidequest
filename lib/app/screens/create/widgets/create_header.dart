import 'package:flutter/material.dart';

class CreateHeader extends StatelessWidget {
  const CreateHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/images/LOGO.png',
          height: 42,
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: Colors.white70,
            size: 30,
          ),
        ),
      ],
    );
  }
}