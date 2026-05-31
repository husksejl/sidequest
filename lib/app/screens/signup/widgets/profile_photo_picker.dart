import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePhotoPicker extends StatefulWidget {
  const ProfilePhotoPicker({
    super.key,
    this.onImageSelected,
  });

  final ValueChanged<String>? onImageSelected;

  @override
  State<ProfilePhotoPicker> createState() => _ProfilePhotoPickerState();
}

class _ProfilePhotoPickerState extends State<ProfilePhotoPicker> {
  String? selectedImagePath;

  Future<void> pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 75,
    );

    if (image == null) return;

    setState(() {
      selectedImagePath = image.path;
    });

    widget.onImageSelected?.call(image.path);
  }

  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (image == null) return;

    setState(() {
      selectedImagePath = image.path;
    });

    widget.onImageSelected?.call(image.path);
  }

  void showImageOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF101216),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 28),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _PickerOptionButton(
                icon: Icons.camera_alt_rounded,
                label: 'CAMERA',
                onTap: () {
                  Navigator.pop(context);
                  pickImageFromCamera();
                },
              ),
              _PickerOptionButton(
                icon: Icons.photo_library_rounded,
                label: 'GALLERY',
                onTap: () {
                  Navigator.pop(context);
                  pickImageFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: showImageOptions,
          child: Container(
            width: 108,
            height: 108,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF18D7FF),
                  Color(0xFFFF9B8F),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF18D7FF).withValues(alpha: 0.18),
                  blurRadius: 28,
                  spreadRadius: 2,
                  offset: const Offset(-8, 0),
                ),
                BoxShadow(
                  color: const Color(0xFFFF8D84).withValues(alpha: 0.16),
                  blurRadius: 28,
                  spreadRadius: 2,
                  offset: const Offset(8, 0),
                ),
              ],
            ),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF111317),
              ),
              child: selectedImagePath == null
                  ? Icon(
                Icons.add_rounded,
                color: Theme.of(context).colorScheme.onSurface,
                size: 40,
              )
                  : ClipOval(
                child: Image.file(
                  File(selectedImagePath!),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          selectedImagePath == null
              ? 'ADD PROFILE PHOTO'
              : 'CHANGE PROFILE PHOTO',
          style: TextStyle(
            color: Color(0xFF18D7FF),
            fontSize: 13,
            letterSpacing: 1.6,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _PickerOptionButton extends StatelessWidget {
  const _PickerOptionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(
                color: const Color(0xFF18D7FF).withValues(alpha: 0.45),
              ),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF18D7FF),
              size: 30,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.70),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}