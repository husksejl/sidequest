import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OtherProfileMeta extends StatelessWidget {
  final String username;
  final String bio;
  final String? location;
  final String? locationLat;
  final String? locationLon;
  final String? website;

  const OtherProfileMeta({
    super.key,
    required this.username,
    required this.bio,
    required this.location,
    required this.locationLat,
    required this.locationLon,
    required this.website,
  });

  @override
  Widget build(BuildContext context) {
    final trimmedBio = bio.trim();

    return Column(
      children: [
        Text(
          username,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),

        if (trimmedBio.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            trimmedBio,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFC8CDD5),
              fontSize: 13,
              height: 1.45,
            ),
          ),
        ],

        if (location != null && location!.isNotEmpty) ...[
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              final uri = locationLat != null && locationLon != null
                  ? Uri.parse(
                'https://www.google.com/maps/search/?api=1&query=$locationLat,$locationLon',
              )
                  : Uri.parse(
                'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(location!)}',
              );

              await launchUrl(
                uri,
                mode: LaunchMode.externalApplication,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on_rounded,
                  color: Color(0xFF00B2AA),
                  size: 15,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    location!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        if (website != null && website!.isNotEmpty) ...[
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              String url = website!.trim();

              if (!url.startsWith('http://') &&
                  !url.startsWith('https://')) {
                url = 'https://$url';
              }

              final uri = Uri.parse(url);

              await launchUrl(
                uri,
                mode: LaunchMode.externalApplication,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.link_rounded,
                  color: Color(0xFFEB5D4F),
                  size: 15,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    website!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}