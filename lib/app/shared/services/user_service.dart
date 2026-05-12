import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersCollection {
    return _firestore.collection('users');
  }

  Future<void> createUser({
    required String userID,
    required String username,
    required String email,
  }) async {
    final user = AppUser(
      id: userID,
      username: username,
      email: email,
      bio: '',
      profileimageURL: '',
      streak: 0,
      createdAt: DateTime.now(),
    );

    await _usersCollection.doc(userID).set(user.toMap());
  }

  Future<AppUser?> getUserByID(String userID) async {
    final doc = await _usersCollection.doc(userID).get();

    if (!doc.exists) {
      return null;
    }

    return AppUser.fromFirestore(doc);
  }

  Stream<AppUser?> watchUserByID(String userID) {
    return _usersCollection.doc(userID).snapshots().map((doc) {
      if (!doc.exists) {
        return null;
      }

      return AppUser.fromFirestore(doc);
    });
  }

  Future<void> updateUserProfile({
    required String userID,
    required String username,
    required String bio,
    String? profileimageURL,
  }) async {
    final data = <String, dynamic>{
      'username': username.trim(),
      'bio': bio.trim(),
    };

    if (profileimageURL != null) {
      data['profileimageURL'] = profileimageURL;
    }

    await _usersCollection.doc(userID).update(data);
  }

  Future<void> updateStreak({
    required String userID,
    required int streak,
  }) async {
    await _usersCollection.doc(userID).update({
      'streak': streak,
    });
  }
}