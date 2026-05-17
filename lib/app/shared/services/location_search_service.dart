import 'dart:convert';

import 'package:http/http.dart' as http;

class LocationSuggestion {
  final String displayName;
  final String lat;
  final String lon;

  const LocationSuggestion({
    required this.displayName,
    required this.lat,
    required this.lon,
  });
}

class LocationSearchService {
  Future<List<LocationSuggestion>> searchLocations(String query) async {
    if (query.trim().length < 2) return [];

    final uri = Uri.https(
      'nominatim.openstreetmap.org',
      '/search',
      {
        'q': query.trim(),
        'format': 'json',
        'limit': '5',
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'User-Agent': 'SideQuestApp/1.0',
      },
    );

    if (response.statusCode != 200) return [];

    final List data = jsonDecode(response.body);

    return data.map((item) {
      return LocationSuggestion(
        displayName: item['display_name'] ?? '',
        lat: item['lat'] ?? '',
        lon: item['lon'] ?? '',
      );
    }).toList();
  }
}