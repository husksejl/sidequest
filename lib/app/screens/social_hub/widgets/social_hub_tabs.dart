import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      child: Row(
        children: [
          buildTabButton('Activity', 0),
          const SizedBox(width: 28),
          buildTabButton('Messages', 1),
        ],
      ),
    );
  }

  Widget buildTabButton(String text, int index) {
    final bool isSelected = selectedTabIndex == index;

    return GestureDetector(
      onTap: () {
        onTabChanged(index);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              color: isSelected ? const Color(0xFF00E5FF) : Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 7),
          Container(
            width: isSelected ? 34 : 0,
            height: 3,
            decoration: BoxDecoration(
              color: const Color(0xFF00E5FF),
              borderRadius: BorderRadius.circular(20),
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: const Color(0xFF00E5FF).withOpacity(0.8),
                  blurRadius: 8,
                ),
              ]
                  : [],
            ),
          ),
        ],
      ),
    );
  }
}