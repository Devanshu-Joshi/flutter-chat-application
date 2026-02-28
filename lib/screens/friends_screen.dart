import 'package:flutter/material.dart';
import 'package:chat_app/services/friend_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/screens/friend_requests_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/user_profile_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendsScreen extends StatelessWidget {
  FriendsScreen({super.key});

  final FriendService _friendService = FriendService();
  final ChatService _chatService = ChatService();
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_currentUser == null) {
      return const Center(child: Text("No user"));
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _pendingRequestsButton(context),
            const SizedBox(height: 6),
            Expanded(child: _friendsList(context)),
          ],
        ),
      ),
    );
  }

  // ───────────────── Pending Requests Button ─────────────────
  Widget _pendingRequestsButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: StreamBuilder<int>(
        stream:
        _friendService.incomingRequestCountStream(_currentUser!.uid),
        builder: (context, snapshot) {
          final count = snapshot.data ?? 0;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => FriendRequestsScreen(
                      currentUserId: _currentUser!.uid,
                    ),
                  ),
                );
              },
              child: Container(
                padding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: colorScheme.onSurface.withValues(alpha: 0.05),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person_add_rounded,
                        color: colorScheme.primary),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        "Friend Requests",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (count > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.error,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          count > 9 ? "9+" : "$count",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(width: 6),
                    Icon(Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color:
                        colorScheme.onSurface.withValues(alpha: 0.5)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ───────────────── Friends List ─────────────────
  Widget _friendsList(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return StreamBuilder<List<RelationshipInfo>>(
      stream: _friendService.friendsStream(_currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: colorScheme.primary,
            ),
          );
        }

        final friends = snapshot.data ?? [];

        if (friends.isEmpty) {
          return Center(
            child: Text(
              "No friends yet",
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 6, 20, 120),
          physics: const BouncingScrollPhysics(),
          itemCount: friends.length,
          itemBuilder: (context, index) {
            return _friendTile(context, friends[index]);
          },
        );
      },
    );
  }

  // ───────────────── Friend Tile ─────────────────
  Widget _friendTile(BuildContext context, RelationshipInfo friend) {
    final colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(friend.otherUid)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const SizedBox.shrink();
        }

        final userData =
        snapshot.data!.data() as Map<String, dynamic>;
        final username = userData['username'] ?? 'User';

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => UserProfileView(
                    userData: {
                      'uid': friend.otherUid,
                      'username': username,
                      'email': userData['email'],
                    },
                    currentUserId: _currentUser!.uid,
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: colorScheme.onSurface.withValues(alpha: 0.04),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor:
                    colorScheme.primary.withValues(alpha: 0.15),
                    child: Text(
                      username.isNotEmpty
                          ? username[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      username,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.chat_bubble_rounded,
                        color: colorScheme.primary),
                    onPressed: () {
                      final chatId = _chatService.getChatId(
                          _currentUser!.uid, friend.otherUid);

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            chatId: chatId,
                            friendUid: friend.otherUid,
                            friendUsername: username,
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}