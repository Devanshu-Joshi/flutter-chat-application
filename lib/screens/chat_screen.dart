import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String friendUid;
  final String friendUsername;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.friendUid,
    required this.friendUsername,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final _currentUser = FirebaseAuth.instance.currentUser;
  bool _isSending = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Stream<DocumentSnapshot?> _friendshipStream() {
    return FirebaseFirestore.instance
        .collection('relationships')
        .where('users', arrayContains: _currentUser!.uid)
        .snapshots()
        .map((snapshot) {
          try {
            return snapshot.docs.firstWhere((doc) {
              final users = List<String>.from(doc['users']);
              return users.contains(widget.friendUid);
            });
          } catch (e) {
            return null;
          }
        });
  }

  // ─── SEND MESSAGE ─────────────────────────────────────────────────────
  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isSending || _currentUser == null) return;

    // ✅ Double-check friendship BEFORE modifying UI
    final relationshipQuery = await FirebaseFirestore.instance
        .collection('relationships')
        .where('users', arrayContains: _currentUser!.uid)
        .get();

    bool areFriends = false;

    for (var doc in relationshipQuery.docs) {
      final users = List<String>.from(doc['users']);
      if (users.contains(widget.friendUid) && doc['type'] == 'friends') {
        areFriends = true;
        break;
      }
    }

    if (!areFriends) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You are no longer friends")),
      );
      return;
    }

    // ✅ NOW start sending state
    setState(() => _isSending = true);
    _messageController.clear();

    try {
      final now = FieldValue.serverTimestamp();
      final chatRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId);

      final chatDoc = await chatRef.get();
      if (!chatDoc.exists) {
        await chatRef.set({
          'participants': [_currentUser!.uid, widget.friendUid],
          'lastMessage': text,
          'lastMessageTime': now,
          'lastMessageSender': _currentUser!.uid,
          'createdAt': now,
        });
      } else {
        await chatRef.update({
          'lastMessage': text,
          'lastMessageTime': now,
          'lastMessageSender': _currentUser!.uid,
        });
      }

      await chatRef.collection('messages').add({
        'text': text,
        'senderId': _currentUser!.uid,
        'timestamp': now,
      });

      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send message.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ─── BUILD ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: cs.primary.withValues(alpha: 0.15),
              child: Text(
                widget.friendUsername.isNotEmpty
                    ? widget.friendUsername[0].toUpperCase()
                    : '?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: cs.primary,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.friendUsername,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<DocumentSnapshot?>(
        stream: _friendshipStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final relationshipDoc = snapshot.data;
          bool areFriends = false;

          if (relationshipDoc != null && relationshipDoc.exists) {
            final data = relationshipDoc.data() as Map<String, dynamic>?;
            final type = data?['type'];
            areFriends = type == 'friends';
          }

          return Column(
            children: [
              Expanded(child: _buildMessagesList(cs)),
              _buildInputBar(theme, cs, areFriends),
            ],
          );
        },
      ),
    );
  }

  // ─── MESSAGES LIST ────────────────────────────────────────────────────
  Widget _buildMessagesList(ColorScheme cs) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final messages = snapshot.data?.docs ?? [];

        if (messages.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 64,
                  color: cs.onSurface.withValues(alpha: 0.15),
                ),
                const SizedBox(height: 16),
                Text(
                  'No messages yet',
                  style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.5),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Say hello! 👋',
                  style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.3),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          reverse: true,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          physics: const BouncingScrollPhysics(),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final data = messages[index].data() as Map<String, dynamic>;
            final isMe = data['senderId'] == _currentUser?.uid;
            final text = data['text'] ?? '';
            final timestamp = data['timestamp'] as Timestamp?;

            // Check if we should show date separator
            bool showDate = false;
            if (index == messages.length - 1) {
              showDate = true;
            } else {
              final nextData =
                  messages[index + 1].data() as Map<String, dynamic>;
              final nextTimestamp = nextData['timestamp'] as Timestamp?;
              if (timestamp != null && nextTimestamp != null) {
                final current = timestamp.toDate();
                final next = nextTimestamp.toDate();
                if (current.day != next.day ||
                    current.month != next.month ||
                    current.year != next.year) {
                  showDate = true;
                }
              }
            }

            return Column(
              children: [
                if (showDate && timestamp != null)
                  _buildDateSeparator(timestamp, Theme.of(context).colorScheme),
                _MessageBubble(text: text, isMe: isMe, timestamp: timestamp),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDateSeparator(Timestamp timestamp, ColorScheme cs) {
    final date = timestamp.toDate();
    final now = DateTime.now();
    String label;

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      label = 'Today';
    } else if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day - 1) {
      label = 'Yesterday';
    } else {
      label = '${date.day}/${date.month}/${date.year}';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: cs.onSurface.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: cs.onSurface.withValues(alpha: 0.45),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ─── INPUT BAR ────────────────────────────────────────────────────────
  Widget _buildInputBar(ThemeData theme, ColorScheme cs, bool areFriends) {
    if (!areFriends) {
      return Container(
        padding: EdgeInsets.fromLTRB(
          16,
          14,
          16,
          MediaQuery.of(context).padding.bottom + 14,
        ),
        decoration: BoxDecoration(
          color: cs.surface,
          border: Border(
            top: BorderSide(color: cs.onSurface.withValues(alpha: 0.08)),
          ),
        ),
        child: Center(
          child: Text(
            "You are no longer friends",
            style: TextStyle(color: cs.error, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    // ✅ Normal input bar if friends
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        10,
        16,
        MediaQuery.of(context).padding.bottom + 10,
      ),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(
          top: BorderSide(color: cs.onSurface.withValues(alpha: 0.08)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: cs.onSurface.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                enabled: areFriends,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: areFriends ? _sendMessage : null,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: cs.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.send_rounded, color: cs.onPrimary, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MESSAGE BUBBLE
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final Timestamp? timestamp;

  const _MessageBubble({
    required this.text,
    required this.isMe,
    this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? cs.primary : cs.onSurface.withValues(alpha: 0.08),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMe ? 18 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 18),
          ),
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isMe ? cs.onPrimary : cs.onSurface,
                fontSize: 15,
                height: 1.4,
              ),
            ),
            if (timestamp != null) ...[
              const SizedBox(height: 4),
              Text(
                _formatTime(timestamp!),
                style: TextStyle(
                  color: isMe
                      ? cs.onPrimary.withValues(alpha: 0.6)
                      : cs.onSurface.withValues(alpha: 0.35),
                  fontSize: 11,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTime(Timestamp timestamp) {
    final date = timestamp.toDate();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
