import 'package:flutter/material.dart';

class OnboardingProgress extends StatelessWidget {
  final int currentIndex;
  final int totalSteps;

  const OnboardingProgress({
    super.key,
    required this.currentIndex,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final bool isActive = index == currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: isActive ? 28 : 7,
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFF00D9E8)
                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(99),
            boxShadow: isActive
                ? [
              BoxShadow(
                color: const Color(0xFF00D9E8).withValues(alpha: 0.45),
                blurRadius: 12,
              ),
            ]
                : [],
          ),
        );
      }),
    );
  }
}