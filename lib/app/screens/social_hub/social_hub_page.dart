import 'package:flutter/material.dart';
import '../../shared/widgets/custom_bottom_nav.dart';
import 'widgets/activity_list.dart';
import 'widgets/messages_list.dart';
import 'widgets/social_hub_tabs.dart';
import '../../shared/widgets/top_bar.dart';

class SocialHubPage extends StatefulWidget {
  const SocialHubPage({
    super.key,
    this.initialTabIndex = 0,
  });

  final int initialTabIndex;

  @override
  State<SocialHubPage> createState() => _SocialHubPageState();
}

class _SocialHubPageState extends State<SocialHubPage> {
  late int selectedTabIndex;

  @override
  void initState() {
    super.initState();
    selectedTabIndex = widget.initialTabIndex;
  }

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
            const AppTopBar(),
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
}