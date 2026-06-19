import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sidequest/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

import '../../shared/models/daily_sidequest.dart';
import '../../shared/services/daily_sidequest_service.dart';
import '../../shared/widgets/custom_bottom_nav.dart';
import '../../shared/widgets/top_bar.dart';
import 'audio_record_page.dart';
import 'models/create_quest.dart';
import 'photo_preview_page.dart';
import 'widgets/create_action_button.dart';
import 'widgets/quest_section_label.dart';
import 'widgets/solo_quest_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateScreenPage extends StatefulWidget {
  const CreateScreenPage({super.key});

  static const Color bgColor = Color(0xFF050608);

  @override
  State<CreateScreenPage> createState() => _CreateScreenPageState();
}

class _CreateScreenPageState extends State<CreateScreenPage> {
  final DailySideQuestService _dailySideQuestService = DailySideQuestService();

  late Future<DailySideQuest?> _dailySideQuestFuture;
  late Timer _timer;

  String _expiresIn = '';
  CreateQuest? _selectedQuest;
  String? _selectedQuestKey;

  @override
  void initState() {
    super.initState();

    _dailySideQuestFuture =
        _dailySideQuestService.getOrCreateTodayDailySideQuest();

    _updateExpiresIn();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateExpiresIn();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateExpiresIn() {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final remaining = nextMidnight.difference(now);

    String twoDigits(int number) {
      return number.toString().padLeft(2, '0');
    }

    final hours = twoDigits(remaining.inHours);
    final minutes = twoDigits(remaining.inMinutes.remainder(60));
    final seconds = twoDigits(remaining.inSeconds.remainder(60));

    if (!mounted) return;

    setState(() {
      _expiresIn = '$hours  :  $minutes  :  $seconds';
    });
  }

  CreateQuest _toCreateQuest(DailySideQuest sideQuest) {
    return CreateQuest(
      id: sideQuest.id,
      title: sideQuest.title,
      description: sideQuest.description,
      expiresIn: _expiresIn,
      difficulty: sideQuest.difficulty,
      xp: sideQuest.xp,
      isGroupQuest: false,
      date: sideQuest.date,
    );
  }

  String _formatGroupExpiresIn(dynamic expiresAtValue) {
    if (expiresAtValue is! Timestamp) {
      return 'Waiting';
    }

    final expiresAt = expiresAtValue.toDate();
    final remaining = expiresAt.difference(DateTime.now());

    if (remaining.isNegative) {
      return '00  :  00  :  00';
    }

    String twoDigits(int number) {
      return number.toString().padLeft(2, '0');
    }

    final hours = twoDigits(remaining.inHours);
    final minutes = twoDigits(remaining.inMinutes.remainder(60));
    final seconds = twoDigits(remaining.inSeconds.remainder(60));

    return '$hours  :  $minutes  :  $seconds';
  }

  Future<void> _openCamera(CreateQuest quest) async {
    final claimed = await _claimGroupQuest(quest);
    if (!claimed) return;

    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo == null) {
      await _releaseGroupQuestLock(quest);
      return;
    }

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoPreviewPage(
          imagePath: photo.path,
          quest: quest,
        ),
      ),
    );
  }

  Future<void> _openGallery(CreateQuest quest) async {
    final claimed = await _claimGroupQuest(quest);
    if (!claimed) return;

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      await _releaseGroupQuestLock(quest);
      return;
    }

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoPreviewPage(
          imagePath: image.path,
          quest: quest,
        ),
      ),
    );
  }

  void _openAudio(CreateQuest quest) async {
    final claimed = await _claimGroupQuest(quest);
    if (!claimed) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AudioRecordPage(quest: quest),
      ),
    );
  }


  Future<bool> _claimGroupQuest(CreateQuest quest) async {
    if (!quest.isGroupQuest) return true;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final runRef = FirebaseFirestore.instance
        .collection('group_challenge_runs')
        .doc(quest.id);

    bool canStart = false;

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(runRef);
      final data = snapshot.data();

      if (data == null) return;

      final status = data['status'];
      final lockedBy = data['lockedBy'];

      if (status == 'completed') return;

      if (lockedBy != null && lockedBy != user.uid) {
        return;
      }

      transaction.update(runRef, {
        'status': 'in_progress',
        'lockedBy': user.uid,
        'lockedAt': FieldValue.serverTimestamp(),
      });

      canStart = true;
    });

    if (!canStart && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Someone is already completing this Group SideQuest.'),
        ),
      );
    }

    return canStart;
  }

  Future<void> _releaseGroupQuestLock(CreateQuest quest) async {
    if (!quest.isGroupQuest) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final runRef = FirebaseFirestore.instance
        .collection('group_challenge_runs')
        .doc(quest.id);

    final snapshot = await runRef.get();
    final data = snapshot.data();

    if (data?['lockedBy'] == user.uid && data?['status'] == 'in_progress') {
      await runRef.update({
        'status': 'active',
        'lockedBy': FieldValue.delete(),
        'lockedAt': FieldValue.delete(),
      });
    }
  }


  Future<List<Map<String, dynamic>>> _loadGroupMembers(List<String> userIds) async {
    final users = <Map<String, dynamic>>[];

    for (final id in userIds) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .get();

      final data = doc.data();

      if (data != null) {
        users.add({
          'id': id,
          'username': data['username'] ?? data['firstName'] ?? 'Unknown user',
          'profileImageUrl':
          data['profileImageUrl'] ?? data['profileimageURL'] ?? '',
        });
      }
    }

    return users;
  }

  Widget _buildGroupMembersPreview(List<String> userIds) {
    if (userIds.isEmpty) return const SizedBox.shrink();

    final visibleCount = userIds.length > 3 ? 3 : userIds.length;
    final remainingCount = userIds.length - visibleCount;

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _loadGroupMembers(userIds),
      builder: (context, snapshot) {
        final members = snapshot.data ?? [];

        return GestureDetector(
          onTap: () => _showGroupMembersSheet(userIds),
          child: SizedBox(
            width: 120,
            height: 38,
            child: Stack(
              children: [
                for (int i = 0; i < visibleCount; i++)
                  Positioned(
                    left: i * 24,
                    child: _buildMiniAvatar(
                      imageUrl: i < members.length
                          ? members[i]['profileImageUrl']
                          : '',
                    ),
                  ),

                if (remainingCount > 0)
                  Positioned(
                    left: visibleCount * 24,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF171A20),
                        border: Border.all(
                          color: const Color(0xFFEB5D4F),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '+$remainingCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMiniAvatar({required String imageUrl}) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF242730),
        border: Border.all(
          color: Colors.white.withOpacity(0.85),
          width: 1.4,
        ),
        image: imageUrl.isNotEmpty
            ? DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        )
            : null,
      ),
      child: imageUrl.isEmpty
          ? const Icon(
        Icons.person_rounded,
        size: 18,
        color: Colors.white70,
      )
          : null,
    );
  }

  void _showGroupMembersSheet(List<String> userIds) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0E1014),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: _loadGroupMembers(userIds),
          builder: (context, snapshot) {
            final members = snapshot.data ?? [];

            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Group Members',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 18),

                  ...members.map((member) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        children: [
                          _buildMiniAvatar(
                            imageUrl: member['profileImageUrl'] ?? '',
                          ),
                          const SizedBox(width: 12),
                          Text(
                            member['username'] ?? 'Unknown user',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }



  Widget _buildCompletedCard() {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF00B2AA),
            size: 54,
          ),
          const SizedBox(height: 14),
          Text(
            l10n.dailySideQuestCompleted,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.comeBackTomorrow,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF9DA3AD),
              fontSize: 13,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyQuestContent() {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Text(
        l10n.loginToSolveToday,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      );
    }

    return FutureBuilder<DailySideQuest?>(
      future: _dailySideQuestFuture,
      builder: (context, sideQuestSnapshot) {
        if (sideQuestSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFEB5D4F),
            ),
          );
        }

        final sideQuest = sideQuestSnapshot.data;

        if (sideQuest == null) {
          return Text(
            l10n.noDailySideQuestFound,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          );
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
              return _buildCompletedCard();
            }

            final quest = _toCreateQuest(sideQuest);

            /*_selectedQuest ??= quest;
            _selectedQuestKey ??= 'daily_${quest.id}';*/

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedQuest = quest;
                  _selectedQuestKey = 'daily_${quest.id}';
                });
              },
              child: SoloQuestCard(
                quest: quest,
                isSelected: _selectedQuestKey == 'daily_${quest.id}',
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildGroupQuestContent() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox.shrink();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('group_challenge_runs')
          .where('acceptedUserIds', arrayContains: user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox.shrink();
        }

        final docs = snapshot.data!.docs;

        final sortedDocs = [...docs];

        sortedDocs.sort((a, b) {
          final aTime = a.data()['createdAt'] as Timestamp?;
          final bTime = b.data()['createdAt'] as Timestamp?;

          if (aTime == null || bTime == null) return 0;

          return bTime.compareTo(aTime);
        });

        final uniqueDocs = <String, QueryDocumentSnapshot<Map<String, dynamic>>>{};

        for (final doc in sortedDocs) {
          final data = doc.data();
          final templateId = data['templateId']?.toString() ?? doc.id;

          uniqueDocs.putIfAbsent(templateId, () => doc);
        }

        final filteredDocs = uniqueDocs.values.toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 34),
            const QuestSectionLabel(label: 'GROUP SIDEQUESTS'),
            const SizedBox(height: 18),

            ...filteredDocs.map((doc) {
              final data = doc.data();

              final lockedBy = data['lockedBy']?.toString();
              final isBeingDoneByOther =
                  lockedBy != null &&
                      lockedBy != user.uid &&
                      data['status'] == 'in_progress';

              final invitedUserIds = List<String>.from(
                (data['invitedUserIds'] ?? []).map((e) => e.toString()),
              );

              final acceptedUserIds = List<String>.from(
                (data['acceptedUserIds'] ?? []).map((e) => e.toString()),
              );

              final allAccepted = invitedUserIds.isNotEmpty &&
                  invitedUserIds.every((id) => acceptedUserIds.contains(id));

              final expiresAt = data['expiresAt'];

              final isExpired = expiresAt is Timestamp &&
                  expiresAt.toDate().isBefore(DateTime.now());

              if (isExpired) {
                return const SizedBox.shrink();
              }

              if (data['status'] == 'completed') {
                return const SizedBox.shrink();
              }


              /*if (allAccepted && data['startedAt'] == null) {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  if (!mounted) return;

                  final now = Timestamp.now();
                  final expiresAt = Timestamp.fromDate(
                    now.toDate().add(const Duration(hours: 24)),
                  );

                  await doc.reference.update({
                    'status': 'active',
                    'startedAt': now,
                    'expiresAt': expiresAt,
                  });
                });
              }*/

              final participantIds = List<String>.from(
                (data['participantIds'] ?? []).map((e) => e.toString()),
              );

              final allParticipantIds = {
                ...participantIds,
                ...acceptedUserIds,
              }.toList();

              final participantNames = List<String>.from(
                (data['participantNames'] ?? []).map((e) => e.toString()),
              );

              final quest = CreateQuest(
                id: doc.id,
                title: data['title'] ?? '',
                description: data['description'] ?? '',
                difficulty: '',
                expiresIn: _formatGroupExpiresIn(data['expiresAt']),
                xp: 200,
                isGroupQuest: true,
                date: DateTime.now().toIso8601String().split('T').first,
                participantIds: allParticipantIds,
                participantNames: participantNames,
              );

              final key = 'group_${doc.id}';

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    Opacity(
                      opacity: allAccepted && !isBeingDoneByOther ? 1 : 0.45,
                      child: GestureDetector(
                        onTap: allAccepted && !isBeingDoneByOther
                            ? () {
                          setState(() {
                            _selectedQuest = quest;
                            _selectedQuestKey = key;
                          });
                        }
                            : null,
                        child: Stack(
                          children: [
                            SoloQuestCard(
                              quest: quest,
                              isSelected: allAccepted && _selectedQuestKey == key,
                            ),

                            Positioned(
                              top: 30,
                              right: 30,
                              child: _buildGroupMembersPreview(allParticipantIds),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (isBeingDoneByOther)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'This Group SideQuest is currently being completed.',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                    if (!allAccepted)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Waiting for all invited members to accept',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.55),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildUploadActions() {
    final l10n = AppLocalizations.of(context)!;
    final quest = _selectedQuest;
    final hasQuest = quest != null;

    return Opacity(
      opacity: hasQuest ? 1 : 0.35,
      child: IgnorePointer(
        ignoring: !hasQuest,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: hasQuest ? () => _openCamera(quest) : null,
                  child: const CreateActionButton(icon: Icons.camera_alt_rounded),
                ),
                GestureDetector(
                  onTap: hasQuest ? () => _openGallery(quest) : null,
                  child: const CreateActionButton(icon: Icons.image_rounded),
                ),
                GestureDetector(
                  onTap: hasQuest ? () => _openAudio(quest) : null,
                  child: const CreateActionButton(icon: Icons.mic_rounded),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              hasQuest && quest.isGroupQuest
                  ? 'Upload a photo or audio to complete this Group SideQuest.'
                  : l10n.uploadPhotoOrAudio,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF777982),
                fontSize: 12,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: const CustomBottomNav(currentIndex: 2),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppTopBar(),
                  const SizedBox(height: 20),
                  _buildUploadActions(),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    QuestSectionLabel(
                      label: AppLocalizations.of(context)!.dailySideQuest,
                    ),
                    const SizedBox(height: 18),
                    _buildDailyQuestContent(),
                    _buildGroupQuestContent(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}