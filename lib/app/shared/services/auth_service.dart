import 'package:firebase_auth/firebase_auth.dart';

import 'user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();

  User? get currentUser {
    return _auth.currentUser;
  }

  Stream<User?> get authStateChanges {
    return _auth.authStateChanges();
  }

  Future<UserCredential> register({
    required String email,
    required String password,
    required String username,
    String? fullName,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final user = userCredential.user;

    if (user != null) {
      if (fullName != null && fullName.trim().isNotEmpty) {
        await user.updateDisplayName(fullName.trim());
      }

      await _userService.createUser(
        userID: user.uid,
        username: username.trim(),
        email: email.trim(),
      );
    }

    return userCredential;
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> resetPassword({
    required String email,
  }) async {
    await _auth.sendPasswordResetEmail(
      email: email.trim(),
    );
  }
}