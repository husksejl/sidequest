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
          icon: Icon(
            Icons.notifications_none_rounded,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.70),
            size: 30,
          ),
        ),
      ],
    );
  }
}