import 'package:flutter/material.dart';
import '../../shared/custom_bottom_nav.dart';
import 'widgets/activity_list.dart';
import 'widgets/messages_list.dart';
import 'widgets/social_hub_tabs.dart';

class SocialHubPage extends StatefulWidget {
  const SocialHubPage({super.key});

  @override
  State<SocialHubPage> createState() => _SocialHubPageState();
}

class _SocialHubPageState extends State<SocialHubPage> {
  int selectedTabIndex = 0;

  void changeTab(int index) {
    setState(() {
      selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050608),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
      body: SafeArea(
        child: Column(
          children: [
            buildHeader(),
            SocialHubTabs(
              selectedTabIndex: selectedTabIndex,
              onTabChanged: changeTab,
            ),
            Expanded(
              child: selectedTabIndex == 0
                  ? const ActivityList()
                  : const MessagesList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      child: Row(
        children: [
          const Icon(
            Icons.menu,
            color: Color(0xFF00E5FF),
            size: 24,
          ),
          const SizedBox(width: 16),
          const Spacer(),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF102326),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF00E5FF).withOpacity(0.4),
              ),
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}