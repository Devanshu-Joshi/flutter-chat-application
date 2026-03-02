import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Generates a deterministic chat ID for two users
  /// Same logic as relationship canonical ID
  String getChatId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  /// Opens or creates a chat between two users
  /// Returns the chat ID
  Future<String> openChat({
    required String currentUid,
    required String friendUid,
  }) async {
    final chatId = getChatId(currentUid, friendUid);
    // Chat document will be created when first message is sent
    // No need to create it here
    return chatId;
  }

  /// Migration function to populate usernames in existing chats
  Future<void> migrateChats() async {
    final chats = await _db.collection('chats').get();

    for (var chat in chats.docs) {
      final data = chat.data();

      if (data.containsKey('participantUsernames')) continue;

      final participants = List<String>.from(data['participants'] ?? []);
      List<String> usernames = [];

      for (var uid in participants) {
        final userDoc = await _db.collection('users').doc(uid).get();
        if (userDoc.exists) {
          usernames.add(
            (userDoc['username'] as String? ?? 'Unknown').toLowerCase(),
          );
        } else {
          usernames.add('unknown');
        }
      }

      if (usernames.isNotEmpty) {
        await chat.reference.update({
          'participantUsernames': usernames,
        });
      }
    }
  }

  /// Update all chats containing a user when they change their username
  Future<void> updateUsernameEverywhere(
    String uid,
    String newUsername,
  ) async {
    final chats = await _db
        .collection('chats')
        .where('participants', arrayContains: uid)
        .get();

    for (var chat in chats.docs) {
      final data = chat.data();
      List<String> usernames = List<String>.from(data['participantUsernames'] ?? []);
      List<String> participants = List<String>.from(data['participants'] ?? []);

      final index = participants.indexOf(uid);
      if (index != -1) {
        // Ensure the list is long enough, though it should be if participants matches
        while (usernames.length <= index) {
          usernames.add('unknown');
        }
        usernames[index] = newUsername.toLowerCase();

        await chat.reference.update({
          'participantUsernames': usernames,
        });
      }
    }
  }
}
