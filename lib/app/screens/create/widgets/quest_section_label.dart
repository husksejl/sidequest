import 'package:flutter/material.dart';

class QuestSectionLabel extends StatelessWidget {
  final String label;

  const QuestSectionLabel({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Color(0xFF00B2AA),
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 4,
        ),
      ),
    );
  }
}