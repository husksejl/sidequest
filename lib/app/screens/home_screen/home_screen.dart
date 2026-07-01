import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sidequest/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

import '../../shared/models/daily_sidequest.dart';
import '../../shared/services/daily_sidequest_service.dart';
import '../../shared/widgets/custom_bottom_nav.dart';
import '../../shared/widgets/top_bar.dart';
import '../create/models/create_quest.dart';
import '../create/photo_preview_page.dart';
import 'models/sidequest_post.dart';
import 'widgets/sidequest_post_card.dart';
import 'widgets/today_sidequest_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = '/';
  static const Color bgColor = Color(0xFF050608);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  final DailySideQuestService _dailySideQuestService = DailySideQuestService();
  final ScrollController _scrollController = ScrollController();

  late Timer _dateTimer;
  late String _todayDate;

  int selectedFeedTab = 1;
  List<String> forYouOrder = [];


  @override
  void initState() {
    super.initState();

    _todayDate = _formatDate(DateTime.now());

    _ensureTodaySideQuestExists();

    _dateTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      final newDate = _formatDate(DateTime.now());

      if (newDate != _todayDate) {
        setState(() {
          _todayDate = newDate;
        });

        _ensureTodaySideQuestExists();
      }
    });
  }

  @override
  void dispose() {
    _dateTimer.cancel();
    super.dispose();
  }

  Future<void> _ensureTodaySideQuestExists() async {
    await _dailySideQuestService.getOrCreateTodayDailySideQuest();

    if (!mounted) return;

    setState(() {});
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  String _formatTimeUntilMidnight() {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final remaining = nextMidnight.difference(now);

    String twoDigits(int number) {
      return number.toString().padLeft(2, '0');
    }

    final hours = twoDigits(remaining.inHours);
    final minutes = twoDigits(remaining.inMinutes.remainder(60));
    final seconds = twoDigits(remaining.inSeconds.remainder(60));

    return '$hours  :  $minutes  :  $seconds';
  }

  String _formatPostTime(dynamic timestamp) {
    final l10n = AppLocalizations.of(context)!;

    if (timestamp == null) return l10n.now;

    final DateTime createdAt = timestamp.toDate();
    final difference = DateTime.now().difference(createdAt);

    if (difference.inMinutes < 1) return l10n.now;
    if (difference.inMinutes < 60) return l10n.minutesAgo(difference.inMinutes);
    if (difference.inHours < 24) return l10n.hoursAgo(difference.inHours);
    if (difference.inDays == 1) return l10n.yesterday;

    return l10n.daysAgo(difference.inDays);
  }

  String _getVoteStatus(Map<String, dynamic> data) {
    final votingEndsAt = data['votingEndsAt'];

    if (votingEndsAt == null) return 'open';

    final endTime = votingEndsAt.toDate();

    if (DateTime.now().isBefore(endTime)) {
      return 'open';
    }

    final completedVotes = data['completedVotes'] ?? 0;
    final failedVotes = data['failedVotes'] ?? 0;

    if (completedVotes > failedVotes) {
      return 'completed';
    }

    if (failedVotes > completedVotes) {
      return 'failed';
    }

    return 'undecided';
  }

  CreateQuest _toCreateQuest(DailySideQuest sideQuest) {
    return CreateQuest(
      id: sideQuest.id,
      title: sideQuest.title,
      description: sideQuest.description,
      expiresIn: _formatTimeUntilMidnight(),
      difficulty: sideQuest.difficulty,
      xp: sideQuest.xp,
      isGroupQuest: false,
      date: sideQuest.date,
    );
  }

  Future<void> _openCameraForDailySideQuest(DailySideQuest sideQuest) async {
    final ImagePicker picker = ImagePicker();

    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (photo == null || !mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoPreviewPage(
          imagePath: photo.path,
          quest: _toCreateQuest(sideQuest),
        ),
      ),
    );
  }

  Widget _buildTodaySideQuest() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<DailySideQuest?>(
      stream: _dailySideQuestService.watchDailySideQuestByDate(_todayDate),
      builder: (context, sideQuestSnapshot) {
        if (sideQuestSnapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }

        final sideQuest = sideQuestSnapshot.data;

        if (sideQuest == null) {
          return const SizedBox.shrink();
        }

        return StreamBuilder<bool>(
          stream: _dailySideQuestService.watchIsDailySideQuestCompleted(
            userID: user.uid,
            sideQuestID: sideQuest.id,
            date: sideQuest.date,
          ),
          builder: (context, completedSnapshot) {
            final isCompleted = completedSnapshot.data ?? false;

            if (isCompleted) {
              return const SizedBox.shrink();
            }

            return Column(
              children: [
                TodaySideQuestCard(
                  sideQuest: sideQuest,
                  onCameraTap: () {
                    _openCameraForDailySideQuest(sideQuest);
                  },
                ),
                const SizedBox(height: 24),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildFirestoreFeed() {
    final l10n = AppLocalizations.of(context)!;
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) {
      return Text(
        l10n.pleaseLogIn,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54)),
      );
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .snapshots(),
      builder: (context, userSnapshot) {
        final userData = userSnapshot.data?.data();
        final following = List<String>.from(userData?['following'] ?? []);

        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(
                    color: Color(0xFFEB5D4F),
                  ),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Text(
                l10n.noPostsYet,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54)),
              );
            }

            final docs = snapshot.data!.docs;

            final filteredDocs = docs.where((doc) {
              final data = doc.data();
              final postUserId = data['userId'];
              final isGroupQuest = data['isGroupQuest'] == true;

              final participantIds = List<String>.from(
                (data['participantIds'] ?? []).map((e) => e.toString()),
              );

              if (selectedFeedTab == 0) {
                if (isGroupQuest) {
                  return participantIds.contains(currentUserId) ||
                      participantIds.any((id) => following.contains(id));
                }

                return postUserId == currentUserId ||
                    following.contains(postUserId);
              }

              if (isGroupQuest) {
                return !participantIds.contains(currentUserId) &&
                    !participantIds.any((id) => following.contains(id));
              }

              return postUserId != currentUserId &&
                  !following.contains(postUserId);
            }).toList();

            if (selectedFeedTab == 1) {
              if (forYouOrder.isEmpty) {
                filteredDocs.shuffle();
                forYouOrder = filteredDocs.map((doc) => doc.id).toList();
              } else {
                filteredDocs.sort((a, b) {
                  final aIndex = forYouOrder.indexOf(a.id);
                  final bIndex = forYouOrder.indexOf(b.id);

                  return aIndex.compareTo(bIndex);
                });
              }
            }

            if (filteredDocs.isEmpty) {
              return Text(
                selectedFeedTab == 0
                    ? l10n.noFollowingPostsYet
                    : l10n.noForYouPostsYet,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54)),
              );
            }

            return Column(
              children: filteredDocs.map((doc) {
                final data = doc.data();

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SideQuestPostCard(
                    post: SideQuestPost(
                      userName: data['username'] ?? l10n.unknownUser,
                      timeAgo: _formatPostTime(data['createdAt']),
                      location: '',
                      userId: data['userId'],
                      title: data['questTitle'] ?? '',
                      imageEmoji: '',
                      imageLabelTop: '',
                      imageLabelBottom: '',
                      caption: data['caption'] ?? '',
                      likes: data['likes'] ?? 0,
                      comments: data['comments'] ?? 0,
                      completedVotes: data['completedVotes'] ?? 0,
                      notCompletedVotes: data['failedVotes'] ?? 0,
                      imageUrl: data['imageUrl'],
                      profileImageUrl: data['profileImageUrl'],
                      firestoreId: doc.id,
                      voteStatus: _getVoteStatus(data),
                      votingOpen: _getVoteStatus(data) == 'open',
                      isOwnPost: data['userId'] == currentUserId,
                      isFirestorePost: true,
                      audioUrl: data['audioUrl'],
                      mediaType: data['mediaType'] ?? 'image',
                      isGroupQuest: data['isGroupQuest'] ?? false,
                      participantIds: List<String>.from(
                        (data['participantIds'] ?? []).map((e) => e.toString()),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppTopBar(),


              _buildTodaySideQuest(),

              const HomeSearchBar(),
              const SizedBox(height: 20),

              Text(
                l10n.todaysMissions,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 16),

              MissionTabs(
                selectedIndex: selectedFeedTab,
                onChanged: (index) {
                  setState(() {
                    selectedFeedTab = index;

                    if (index == 1) {
                      forYouOrder = [];
                    }
                  });
                },
              ),
              const SizedBox(height: 18),

              _buildFirestoreFeed(),
            ],
          ),
        ),
      ),
    );
  }
}

class MissionTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const MissionTabs({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        _TabButton(
          label: l10n.forYou,
          isActive: selectedIndex == 1,
          onTap: () => onChanged(1),
        ),
        const SizedBox(width: 26),
        _TabButton(
          label: l10n.following,
          isActive: selectedIndex == 0,
          onTap: () => onChanged(0),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.40),
            ),
            color: isActive ? Theme.of(context).colorScheme.surface : Colors.transparent,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}