import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String username;
  final String email;
  final String bio;
  final String profileimageURL;
  final int streak;
  final DateTime createdAt;

  const AppUser({
    required this.id,
    required this.username,
    required this.email,
    required this.bio,
    required this.profileimageURL,
    required this.streak,
    required this.createdAt,
  });

  factory AppUser.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    return AppUser(
      id: doc.id,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      bio: data['bio'] ?? '',
      profileimageURL: data['profileimageURL'] ?? '',
      streak: data['streak'] ?? 0,
      createdAt: _timestampToDateTime(data['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'bio': bio,
      'profileimageURL': profileimageURL,
      'streak': streak,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  static DateTime _timestampToDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    return DateTime.now();
  }
}