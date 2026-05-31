import 'package:flutter/material.dart';
import '../../../shared/theme/app_theme.dart';
import 'package:sidequest/l10n/app_localizations.dart';

class SettingsProfileCard extends StatelessWidget {
  final String userName;
  final String userHandle;
  final int streak;
  final String level;

  const SettingsProfileCard({
    super.key,
    required this.userName,
    required this.userHandle,
    required this.streak,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: context.isLightMode
              ? const [
            Color(0xFFFFFFFF),
            Color(0xFFF3F8FB),
            Color(0xFFEAFBFF),
          ]
              : const [
            Color(0xFF1A171B),
            Color(0xFF101317),
            Color(0xFF0A1618),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: context.appBorderColor),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF18D7FF).withOpacity(0.08),
            blurRadius: 28,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 66,
            height: 66,
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFFFF9B8F), Color(0xFF18D7FF)],
              ),
            ),
            child: CircleAvatar(
              backgroundColor: context.isLightMode ? Colors.white : const Color(0xFF1B2026),
              child: Icon(
                Icons.person_rounded,
                color: context.appIconColor,
                size: 30,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                    color: context.appTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  userHandle,
                  style: TextStyle(
                    color: context.appMutedTextColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _StatusPill(
                      icon: Icons.local_fire_department_rounded,
                      label: l10n.dayStreak(streak),
                      color: const Color(0xFFFF8D84),
                    ),
                    _StatusPill(
                      icon: Icons.explore_rounded,
                      label: level.toUpperCase(),
                      color: const Color(0xFF18D7FF),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: context.appMutedTextColor,
            size: 28,
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatusPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.7,
            ),
          ),
        ],
      ),
    );
  }
}
