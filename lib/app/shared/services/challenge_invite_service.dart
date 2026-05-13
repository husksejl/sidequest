import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/challenge_invite.dart';

class ChallengeInviteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _invitesCollection {
    return _firestore.collection('challengeInvites');
  }

  Stream<ChallengeInvite?> watchActiveInviteForChat(String chatID) {
    return _invitesCollection
        .where('chatID', isEqualTo: chatID)
        .snapshots()
        .map((querySnapshot) {
      final invites = querySnapshot.docs.map((doc) {
        return ChallengeInvite.fromFirestore(doc);
      }).where((invite) {
        return invite.status == 'pending' || invite.status == 'accepted';
      }).toList();

      invites.sort((a, b) {
        return b.createdAt.compareTo(a.createdAt);
      });

      if (invites.isEmpty) {
        return null;
      }

      return invites.first;
    });
  }

  Future<void> createInvite({
    required String chatID,
    required String challengeTitle,
    required String challengeID,
    required String senderID,
    required String receiverID,
  }) async {
    final invite = ChallengeInvite(
      id: '',
      challengeTitle: challengeTitle,
      challengeID: challengeID,
      chatID: chatID,
      senderID: senderID,
      receiverID: receiverID,
      status: 'pending',
      createdAt: DateTime.now(),
    );

    await _invitesCollection.add(invite.toMap());
  }

  Future<void> acceptInvite(String inviteID) async {
    await _invitesCollection.doc(inviteID).update({
      'status': 'accepted',
    });
  }

  Future<void> declineInvite(String inviteID) async {
    await _invitesCollection.doc(inviteID).update({
      'status': 'declined',
    });
  }

  Future<void> completeInvite(String inviteID) async {
    await _invitesCollection.doc(inviteID).update({
      'status': 'completed',
    });
  }
}