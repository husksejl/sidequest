import 'package:flutter/material.dart';
import '../../../shared/theme/app_theme.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            title,
            style: TextStyle(
              color: Color(0xFF18D7FF),
              fontSize: 12,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: context.appCardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: context.appBorderColor),
          ),
          child: Column(
            children: [
              for (int index = 0; index < children.length; index++) ...[
                children[index],
                if (index != children.length - 1)
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: 64,
                    endIndent: 16,
                    color: context.appBorderColor,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
