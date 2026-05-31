import 'package:flutter/material.dart';

class ChallengeCategoryChip extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const ChallengeCategoryChip({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12) : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? const Color(0xFF00D7E8) : Theme.of(context).colorScheme.onSurface.withOpacity(0.54),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}