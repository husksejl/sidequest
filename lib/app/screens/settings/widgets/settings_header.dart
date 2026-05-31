import 'package:flutter/material.dart';

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF18D7FF).withOpacity(0.10),
                blurRadius: 18,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Icon(
            Icons.tune_rounded,
            color: Color(0xFF18D7FF),
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Customize your SideQuest experience',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color(0xFF8A8F98),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          icon: Icon(
            Icons.close_rounded,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.70),
          ),
        ),
      ],
    );
  }
}
