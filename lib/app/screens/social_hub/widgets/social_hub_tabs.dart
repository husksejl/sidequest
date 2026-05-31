import 'package:flutter/material.dart';
import 'package:sidequest/l10n/app_localizations.dart';

class SocialHubTabs extends StatelessWidget {
  final int selectedTabIndex;
  final Function(int) onTabChanged;

  const SocialHubTabs({
    super.key,
    required this.selectedTabIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
      child: Container(
        height: 54,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: buildTabButton(
                context: context,
                text: l10n.activity,
                index: 0,
                icon: Icons.notifications_none_rounded,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: buildTabButton(
                context: context,
                text: l10n.messages,
                index: 1,
                icon: Icons.chat_bubble_outline_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTabButton({
    required BuildContext context,
    required String text,
    required int index,
    required IconData icon,
  }) {
    final bool isSelected = selectedTabIndex == index;

    return GestureDetector(
      onTap: () {
        onTabChanged(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        height: double.infinity,
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.10) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.60)
                : Colors.transparent,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54),
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
