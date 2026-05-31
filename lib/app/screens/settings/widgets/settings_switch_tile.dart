import 'package:flutter/material.dart';
import '../../../shared/theme/app_theme.dart';

class SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color accentColor;

  const SettingsSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.accentColor = const Color(0xFF18D7FF),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.10),
              shape: BoxShape.circle,
              border: Border.all(color: accentColor.withOpacity(0.16)),
            ),
            child: Icon(
              icon,
              color: accentColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: context.appTextColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.appMutedTextColor,
                    fontSize: 12.5,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: context.isLightMode ? Colors.white : Colors.black,
            activeTrackColor: accentColor,
            inactiveThumbColor: context.isLightMode ? const Color(0xFF9AA3AF) : const Color(0xFF6D727B),
            inactiveTrackColor: context.isLightMode ? const Color(0xFFE1E6EE) : const Color(0xFF1A222B),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}
