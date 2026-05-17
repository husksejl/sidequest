import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sidequest/l10n/app_localizations.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../../shared/services/location_search_service.dart';

class EditProfileBottomSheet extends StatefulWidget {
  const EditProfileBottomSheet({super.key});

  @override
  State<EditProfileBottomSheet> createState() => _EditProfileBottomSheetState();
}

class _EditProfileBottomSheetState extends State<EditProfileBottomSheet> {
  final usernameController = TextEditingController();
  final fullNameController = TextEditingController();
  final bioController = TextEditingController();
  final locationController = TextEditingController();
  final websiteController = TextEditingController();
  final LocationSearchService locationSearchService = LocationSearchService();

  String? selectedLocationLat;
  String? selectedLocationLon;

  bool isSaving = false;

  @override
  void dispose() {
    usernameController.dispose();
    fullNameController.dispose();
    bioController.dispose();
    locationController.dispose();
    websiteController.dispose();
    super.dispose();
  }

  Future<void> saveProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() {
      isSaving = true;
    });

    final fullName = fullNameController.text.trim();

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'username': usernameController.text.trim(),
      'fullName': fullName,
      'firstName': fullName.isEmpty ? '' : fullName.split(' ').first,
      'bio': bioController.text.trim(),
      'location': locationController.text.trim(),
      'locationLat': selectedLocationLat,
      'locationLon': selectedLocationLon,
      'website': websiteController.text.trim(),
    }, SetOptions(merge: true));

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return DraggableScrollableSheet(
      initialChildSize: 0.82,
      minChildSize: 0.45,
      maxChildSize: 0.94,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
          decoration: const BoxDecoration(
            color: Color(0xFF101216),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: uid == null
              ? Center(
            child: Text(
              l10n.pleaseLogIn,
              style: const TextStyle(color: Colors.white),
            ),
          )
              : FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF00B2AA),
                  ),
                );
              }

              final data = snapshot.data!.data() ?? {};

              usernameController.text =
                  data['username']?.toString() ?? '';
              fullNameController.text =
                  data['fullName']?.toString() ?? '';
              bioController.text = data['bio']?.toString() ?? '';
              locationController.text =
                  data['location']?.toString() ?? '';
              selectedLocationLat = data['locationLat']?.toString();
              selectedLocationLon = data['locationLon']?.toString();

              websiteController.text =
                  data['website']?.toString() ?? '';

              return ListView(
                controller: scrollController,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    l10n.editProfileCaps,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 22),

                  _EditField(
                    controller: usernameController,
                    label: l10n.username,
                    hint: 'yourusername',
                    icon: Icons.alternate_email_rounded,
                  ),

                  const SizedBox(height: 14),

                  _EditField(
                    controller: fullNameController,
                    label: l10n.fullName,
                    hint: 'Emma Explorer',
                    icon: Icons.person_outline_rounded,
                  ),

                  const SizedBox(height: 14),

                  _EditField(
                    controller: bioController,
                    label: l10n.bio,
                    hint: l10n.bioHint,
                    icon: Icons.notes_rounded,
                    maxLines: 3,
                  ),

                  const SizedBox(height: 14),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.location,
                        style: const TextStyle(
                          color: Color(0xFF00B2AA),
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 7),
                      TypeAheadField<LocationSuggestion>(
                        suggestionsCallback: (pattern) {
                          return locationSearchService.searchLocations(pattern);
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            tileColor: const Color(0xFF171A20),
                            title: Text(
                              suggestion.displayName,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        },
                        onSelected: (suggestion) {
                          locationController.text = suggestion.displayName;
                          selectedLocationLat = suggestion.lat;
                          selectedLocationLon = suggestion.lon;
                        },
                        builder: (context, controller, focusNode) {
                          controller.text = locationController.text;

                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: l10n.searchYourLocation,
                              hintStyle: const TextStyle(color: Colors.white38),
                              prefixIcon: const Icon(
                                Icons.location_on_outlined,
                                color: Colors.white54,
                                size: 20,
                              ),
                              filled: true,
                              fillColor: const Color(0xFF171A20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (value) {
                              locationController.text = value;
                              selectedLocationLat = null;
                              selectedLocationLon = null;
                            },
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  _EditField(
                    controller: websiteController,
                    label: l10n.website,
                    hint: 'https://your-site.com',
                    icon: Icons.link_rounded,
                  ),

                  const SizedBox(height: 22),

                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isSaving ? null : saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEB5D4F),
                        disabledBackgroundColor: const Color(0xFF5A2B27),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      child: isSaving
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                          : Text(
                        l10n.saveChanges,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _EditField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final int maxLines;

  const _EditField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF00B2AA),
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white38),
            prefixIcon: Icon(
              icon,
              color: Colors.white54,
              size: 20,
            ),
            filled: true,
            fillColor: const Color(0xFF171A20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}