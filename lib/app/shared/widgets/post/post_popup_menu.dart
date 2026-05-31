import 'package:flutter/material.dart';

class PostPopupMenu extends StatelessWidget {
  final bool isOwnPost;
  final bool canSaveImage;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final VoidCallback onDelete;
  final VoidCallback onReport;

  const PostPopupMenu({
    super.key,
    required this.isOwnPost,
    required this.canSaveImage,
    required this.onSave,
    required this.onShare,
    required this.onDelete,
    required this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Theme.of(context).colorScheme.surface,
      icon: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.70),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.more_horiz_rounded,
          color: Colors.white,
          size: 22,
        ),
      ),
      onSelected: (value) {
        if (value == 'save') onSave();
        if (value == 'share') onShare();
        if (value == 'delete') onDelete();
        if (value == 'report') onReport();
      },
      itemBuilder: (context) {
        if (isOwnPost) {
          return [
            if (canSaveImage)
              const PopupMenuItem(
                value: 'save',
                child: Text('Save image'),
              ),
            const PopupMenuItem(
              value: 'share',
              child: Text('Share post'),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'delete',
              child: Text(
                'Delete post',
                style: TextStyle(color: Color(0xFFEB5D4F)),
              ),
            ),
          ];
        }

        return [
          if (canSaveImage)
            const PopupMenuItem(
              value: 'save',
              child: Text('Save image'),
            ),
          const PopupMenuItem(
            value: 'share',
            child: Text('Share post'),
          ),
          const PopupMenuDivider(),
          const PopupMenuItem(
            value: 'report',
            child: Text(
              'Report post',
              style: TextStyle(color: Color(0xFFEB5D4F)),
            ),
          ),
        ];
      },
    );
  }
}