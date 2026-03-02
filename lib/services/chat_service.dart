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
}
