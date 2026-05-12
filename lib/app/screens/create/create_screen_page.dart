import 'package:flutter/material.dart';

import '../../shared/widgets/custom_bottom_nav.dart';
import 'models/create_quest.dart';
import 'widgets/quest_section_label.dart';
import 'widgets/solo_quest_card.dart';
import 'widgets/group_quest_card.dart';
import 'widgets/create_action_button.dart';
import '../../shared/widgets/top_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'photo_preview_page.dart';

class CreateScreenPage extends StatelessWidget {
  const CreateScreenPage({super.key});

  static const Color bgColor = Color(0xFF050608);

  Future<void> openCamera(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (photo == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoPreviewPage(
          imagePath: photo.path,
        ),
      ),
    );
  }

  static const CreateQuest soloQuest = CreateQuest(
    title: 'Take a photo of\nsomething that made\nyou smile today',
    expiresIn: '23  :  58  :  12',
  );

  static const CreateQuest groupQuest = CreateQuest(
    title: 'Take a selfie with\nsomething yellow',
    expiresIn: '23  :  58  :  12',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      bottomNavigationBar: const CustomBottomNav(
        currentIndex: 2,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
          child: Column(
            children: [
              const AppTopBar(),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(38),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF100C0C),
                      Color(0xFF050608),
                      Color(0xFF160B0A),
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const QuestSectionLabel(label: 'SOLO'),
                        const Spacer(),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 1.4,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              '?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const SoloQuestCard(quest: soloQuest),

                    const SizedBox(height: 20),
                    const QuestSectionLabel(label: 'GROUPS'),

                    const SizedBox(height: 16),
                    const GroupQuestCard(quest: groupQuest),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const CreateActionButton(icon: Icons.graphic_eq_rounded),

                        GestureDetector(
                          onTap: () => openCamera(context),
                          child: const CreateActionButton(
                            icon: Icons.camera_alt_rounded,
                          ),
                        ),

                        const CreateActionButton(icon: Icons.title_rounded),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}