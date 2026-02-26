import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatTile extends StatelessWidget {
  final String chatId;
  final Map<String, dynamic> data;
  final String currentUserId;
  final int index;
  final VoidCallback? onTap;

  const ChatTile({
    super.key,
    required this.chatId,
    required this.data,
    required this.currentUserId,
    required this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final participants = List<String>.from(data['participants'] ?? []);
    final otherUserId = participants.firstWhere(
      (id) => id != currentUserId,
      orElse: () => '',
    );

    final lastMessage = data['lastMessage'] ?? '';
    final lastMessageTime = data['lastMessageTime'] as Timestamp?;
    final unreadCount = data['unreadCount_$currentUserId'] ?? 0;

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(otherUserId)
          .get(),
      builder: (context, userSnapshot) {
        String name = 'Unknown';
        String? photoUrl;

        if (userSnapshot.hasData && userSnapshot.data!.exists) {
          final userData = userSnapshot.data!.data() as Map<String, dynamic>;
          name = userData['name'] ?? userData['displayName'] ?? 'Unknown';
          photoUrl = userData['photoUrl'] ?? userData['photoURL'];
        }

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 400 + index * 80),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: unreadCount > 0
                        ? Theme.of(context)
    .colorScheme
    .onSurface
    .withValues(alpha: 0.04)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      _buildAvatar(context, name, photoUrl, otherUserId),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: unreadCount > 0
                                          ? FontWeight.w700
                                          : FontWeight.w600,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                                if (lastMessageTime != null)
                                  Text(
                                    _formatTime(lastMessageTime),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: unreadCount > 0
                                          ? const Color(0xFFE100FF)
                                          : Theme.of(context)
    .colorScheme
    .onSurface
    .withValues(alpha: 0.3),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    lastMessage,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: unreadCount > 0
                                          ? Theme.of(context)
    .colorScheme
    .onSurface
    .withValues(alpha: 0.6)
                                          : Theme.of(context)
    .colorScheme
    .onSurface
    .withValues(alpha: 0.3),
                                    ),
                                  ),
                                ),
                                if (unreadCount > 0)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF7F00FF),
                                          Color(0xFFE100FF),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      unreadCount > 99 ? '99+' : '$unreadCount',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context).colorScheme.onPrimary,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatar(
      BuildContext context,
      String name,
      String? photoUrl,
      String userId,
      ) {
    final colors = [
      const Color(0xFFFF6B6B),
      const Color(0xFF4ECDC4),
      const Color(0xFFA78BFA),
      const Color(0xFFFFE66D),
      const Color(0xFF60A5FA),
      const Color(0xFFF472B6),
    ];

    final color = colors[userId.hashCode % colors.length];

    return Stack(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.8),
                color.withValues(alpha: 0.4),
              ],
            ),
          ),
          child: photoUrl != null
              ? ClipOval(
                  child: Image.network(
                    photoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _initial(name),
                  ),
                )
              : _initial(name),
        ),
        Positioned(
          bottom: 1,
          right: 1,
          child: Container(
            width: 13,
            height: 13,
            decoration: BoxDecoration(
              color: const Color(0xFF34D399),
              shape: BoxShape.circle,
              border: Border.all(
  color: Theme.of(context).colorScheme.surface,
  width: 2.5,
),
            ),
          ),
        ),
      ],
    );
  }

  Widget _initial(String name) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  String _formatTime(Timestamp timestamp) {
    final now = DateTime.now();
    final date = timestamp.toDate();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${date.day}/${date.month}';
  }
}
