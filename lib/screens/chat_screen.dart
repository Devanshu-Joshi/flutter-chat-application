import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final FocusNode _inputFocusNode = FocusNode();
  final _currentUser = FirebaseAuth.instance.currentUser;

  // ═══════════════════════════════════════════════════════════════════════════
  // CACHED STREAMS - Created once, not on every build
  // ═══════════════════════════════════════════════════════════════════════════
  late final Stream<QuerySnapshot> _messagesStream;
  late final Stream<DocumentSnapshot?> _friendshipStream;

  // ═══════════════════════════════════════════════════════════════════════════
  // SELECTION STATE - Using ValueNotifier to avoid full rebuilds
  // ═══════════════════════════════════════════════════════════════════════════
  final ValueNotifier<Set<String>> _selectedMessageIds = ValueNotifier({});
  final ValueNotifier<bool> _wasDirectSelection = ValueNotifier(false);
  final ValueNotifier<String?> _directSelectedMessageId = ValueNotifier(null);

  // Reply state
  final ValueNotifier<Map<String, dynamic>?> _replyingTo = ValueNotifier(null);

  // Edit state
  final ValueNotifier<String?> _editingMessageId = ValueNotifier(null);
  String? _originalEditText;

  // UI state
  bool _isSending = false;

  // Reaction emojis
  final List<String> _reactionEmojis = ['❤️', '😂', '😮', '😢', '👍'];

  // Overlay for emoji picker
  OverlayEntry? _emojiOverlayEntry;
  final Map<String, GlobalKey> _messageKeys = {};

  @override
  void initState() {
    super.initState();
    _initStreams();
  }

  void _initStreams() {
    // Messages stream - created ONCE
    _messagesStream = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();

    // Friendship stream - created ONCE
    _friendshipStream = FirebaseFirestore.instance
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

  @override
  void dispose() {
    _removeEmojiOverlay();
    _messageController.dispose();
    _scrollController.dispose();
    _inputFocusNode.dispose();
    _selectedMessageIds.dispose();
    _wasDirectSelection.dispose();
    _directSelectedMessageId.dispose();
    _replyingTo.dispose();
    _editingMessageId.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // EMOJI OVERLAY METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  void _tryShowEmojiOverlay(
      String messageId,
      Map<String, String> reactions,
      bool isMe, {
        int retries = 5,
      }) {
    if (retries <= 0) return;
    if (!mounted) return;
    if (!_wasDirectSelection.value ||
        _directSelectedMessageId.value != messageId) return;

    final key = _messageKeys[messageId];

    if (key == null || key.currentContext == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _tryShowEmojiOverlay(messageId, reactions, isMe, retries: retries - 1);
      });
      return;
    }

    final renderObject = key.currentContext!.findRenderObject();
    if (renderObject == null || !renderObject.attached) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _tryShowEmojiOverlay(messageId, reactions, isMe, retries: retries - 1);
      });
      return;
    }

    _showEmojiOverlay(messageId, reactions, isMe);
  }

  void _showEmojiOverlay(
      String messageId, Map<String, String> reactions, bool isMe) {
    _removeEmojiOverlay();

    if (!mounted) return;

    final key = _messageKeys[messageId];
    if (key?.currentContext == null) return;

    final renderObject = key!.currentContext!.findRenderObject();
    if (renderObject == null ||
        renderObject is! RenderBox ||
        !renderObject.attached) {
      return;
    }

    final RenderBox renderBox = renderObject;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _emojiOverlayEntry = OverlayEntry(
      builder: (context) {
        final cs = Theme.of(context).colorScheme;
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        const pickerWidth = 240.0;
        double left;
        if (isMe) {
          left = position.dx + size.width - pickerWidth;
          if (left < 16) left = 16;
        } else {
          left = position.dx;
          if (left + pickerWidth > screenWidth - 16) {
            left = screenWidth - pickerWidth - 16;
          }
        }

        const pickerHeight = 56.0;
        double top = position.dy - pickerHeight - 8;

        if (top < MediaQuery.of(context).padding.top + 60) {
          top = position.dy + size.height + 8;
        }

        if (top + pickerHeight > screenHeight - 100) {
          top = screenHeight - pickerHeight - 100;
        }

        return Stack(
          children: [
            // Tap outside: close emoji bar but KEEP selection
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _removeEmojiOverlay();
                  // Reset direct selection flags so emoji bar won't reappear
                  // but DON'T clear selectedMessageIds - keep message selected
                  _wasDirectSelection.value = false;
                  _directSelectedMessageId.value = null;
                },
                child: Container(color: Colors.transparent),
              ),
            ),
            // Emoji picker
            Positioned(
              left: left,
              top: top,
              child: Material(
                color: Colors.transparent,
                elevation: 8,
                child: _EmojiReactionPicker(
                  reactions: reactions,
                  currentUserId: _currentUser!.uid,
                  emojis: _reactionEmojis,
                  onEmojiSelected: (emoji) {
                    _removeEmojiOverlay();
                    _addReaction(messageId, emoji);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );

    try {
      Overlay.of(context).insert(_emojiOverlayEntry!);
    } catch (e) {
      _emojiOverlayEntry = null;
    }
  }

  void _removeEmojiOverlay() {
    _emojiOverlayEntry?.remove();
    _emojiOverlayEntry = null;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SELECTION LOGIC - No setState, uses ValueNotifier
  // ═══════════════════════════════════════════════════════════════════════════

  void _onMessageLongPress(
      String messageId, Map<String, dynamic> data, bool isMe) {
    HapticFeedback.mediumImpact();
    _removeEmojiOverlay();

    final deletedForEveryone = data['deletedForEveryone'] == true;
    if (deletedForEveryone) return;

    // Update selection without setState
    _selectedMessageIds.value = {messageId};
    _wasDirectSelection.value = true;
    _directSelectedMessageId.value = messageId;

    final reactions = Map<String, String>.from(data['reactions'] ?? {});
    _tryShowEmojiOverlay(messageId, reactions, isMe, retries: 5);
  }

  void _onMessageTap(String messageId) {
    if (_selectedMessageIds.value.isEmpty) return;

    _removeEmojiOverlay();

    final newSet = Set<String>.from(_selectedMessageIds.value);
    if (newSet.contains(messageId)) {
      newSet.remove(messageId);
    } else {
      newSet.add(messageId);
    }

    _selectedMessageIds.value = newSet;
    _wasDirectSelection.value = false;
    _directSelectedMessageId.value = null;
  }

  void _clearSelection() {
    _removeEmojiOverlay();
    _selectedMessageIds.value = {};
    _wasDirectSelection.value = false;
    _directSelectedMessageId.value = null;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // FRIENDSHIP CHECK
  // ═══════════════════════════════════════════════════════════════════════════

  Future<bool> _checkFriendship() async {
    final relationshipQuery = await FirebaseFirestore.instance
        .collection('relationships')
        .where('users', arrayContains: _currentUser!.uid)
        .get();

    for (var doc in relationshipQuery.docs) {
      final users = List<String>.from(doc['users']);
      if (users.contains(widget.friendUid) && doc['type'] == 'friends') {
        return true;
      }
    }
    return false;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MESSAGE ACTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isSending || _currentUser == null) return;

    final areFriends = await _checkFriendship();
    if (!areFriends) {
      _showSnackBar("You are no longer friends");
      return;
    }

    setState(() => _isSending = true);

    final messageText = text;
    final replyData = _replyingTo.value;

    _messageController.clear();
    _replyingTo.value = null;

    try {
      final now = FieldValue.serverTimestamp();
      final chatRef =
      FirebaseFirestore.instance.collection('chats').doc(widget.chatId);

      final chatDoc = await chatRef.get();
      if (!chatDoc.exists) {
        final usersRef = FirebaseFirestore.instance.collection('users');
        final currentUserDoc = await usersRef.doc(_currentUser!.uid).get();
        final friendDoc = await usersRef.doc(widget.friendUid).get();
        final currentUsername =
            currentUserDoc['username'] as String? ?? 'Unknown';
        final friendUsername =
            friendDoc['username'] as String? ?? widget.friendUsername;

        await chatRef.set({
          'participants': [_currentUser!.uid, widget.friendUid],
          'participantUsernames': [
            currentUsername.toLowerCase(),
            friendUsername.toLowerCase(),
          ],
          'lastMessage': messageText,
          'lastMessageTime': now,
          'lastMessageSender': _currentUser!.uid,
          'createdAt': now,
        });
      } else {
        await chatRef.update({
          'lastMessage': messageText,
          'lastMessageTime': now,
          'lastMessageSender': _currentUser!.uid,
        });
      }

      final messageData = <String, dynamic>{
        'text': messageText,
        'senderId': _currentUser!.uid,
        'timestamp': now,
        'deletedFor': [],
        'deletedForEveryone': false,
        'reactions': {},
      };

      if (replyData != null) {
        messageData['replyTo'] = {
          'messageId': replyData['messageId'],
          'text': replyData['text'],
          'senderId': replyData['senderId'],
        };
      }

      await chatRef.collection('messages').add(messageData);
      _scrollToBottom();
    } catch (e) {
      if (mounted) _showSnackBar('Failed to send message.');
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Future<void> _editMessage() async {
    final editingId = _editingMessageId.value;
    if (editingId == null) return;

    final text = _messageController.text.trim();
    if (text.isEmpty || text == _originalEditText) {
      _cancelEdit();
      return;
    }

    try {
      final messageRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .doc(editingId);

      final doc = await messageRef.get();
      if (doc.exists) {
        final data = doc.data()!;
        await messageRef.update({
          'text': text,
          'editedAt': FieldValue.serverTimestamp(),
          'senderId': data['senderId'],
        });
      }

      _cancelEdit();
      _showSnackBar('Message edited');
    } catch (e) {
      _showSnackBar('Failed to edit message');
    }
  }

  void _cancelEdit() {
    _editingMessageId.value = null;
    _originalEditText = null;
    _messageController.clear();
  }

  void _startEdit(String messageId, String text) {
    _removeEmojiOverlay();
    _editingMessageId.value = messageId;
    _originalEditText = text;
    _messageController.text = text;
    _replyingTo.value = null;
    _clearSelection();
    _inputFocusNode.requestFocus();
  }

  void _startReply(String messageId, String text, String senderId) {
    _removeEmojiOverlay();
    _replyingTo.value = {
      'messageId': messageId,
      'text': text,
      'senderId': senderId,
    };
    _editingMessageId.value = null;
    _clearSelection();
    _inputFocusNode.requestFocus();
  }

  void _cancelReply() {
    _replyingTo.value = null;
  }

  Future<void> _copyMessages(List<DocumentSnapshot> allMessages) async {
    final selectedIds = _selectedMessageIds.value;
    final selectedDocs =
    allMessages.where((doc) => selectedIds.contains(doc.id)).toList();

    selectedDocs.sort((a, b) {
      final aTime = a['timestamp'] as Timestamp?;
      final bTime = b['timestamp'] as Timestamp?;
      if (aTime == null || bTime == null) return 0;
      return aTime.compareTo(bTime);
    });

    final texts = selectedDocs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      if (data['deletedForEveryone'] == true) return '[Deleted message]';
      return data['text'] as String? ?? '';
    }).join('\n');

    await Clipboard.setData(ClipboardData(text: texts));
    _clearSelection();
    _showSnackBar('Copied to clipboard');
  }

  Future<void> _addReaction(String messageId, String emoji) async {
    try {
      final messageRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .doc(messageId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final doc = await transaction.get(messageRef);

        if (!doc.exists) {
          throw Exception('Message not found');
        }

        final data = doc.data() as Map<String, dynamic>;
        final reactions = Map<String, String>.from(data['reactions'] ?? {});
        final senderId = data['senderId'] as String;

        if (reactions[_currentUser!.uid] == emoji) {
          reactions.remove(_currentUser!.uid);
        } else {
          reactions[_currentUser!.uid] = emoji;
        }

        transaction.update(messageRef, {
          'reactions': reactions,
          'senderId': senderId,
        });
      });

      _clearSelection();
    } catch (e) {
      if (mounted) {
        _showSnackBar('Failed to add reaction');
      }
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (ctx) => _DeleteDialog(
        chatId: widget.chatId,
        selectedIds: _selectedMessageIds.value.toList(),
        currentUserId: _currentUser!.uid,
        onComplete: () {
          _clearSelection();
          Navigator.pop(ctx);
        },
      ),
    );
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

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MENU ACTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  void _handleMenuAction(String action) {
    _removeEmojiOverlay();
    switch (action) {
      case 'reply':
        _handleReplyFromMenu();
        break;
      case 'copy':
        _handleCopyFromMenu();
        break;
      case 'edit':
        _handleEditFromMenu();
        break;
      case 'delete':
        _showDeleteDialog();
        break;
    }
  }

  void _handleReplyFromMenu() async {
    final selectedIds = _selectedMessageIds.value;
    if (selectedIds.length != 1) return;
    final messageId = selectedIds.first;

    final doc = await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .doc(messageId)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      if (data['deletedForEveryone'] == true) {
        _showSnackBar('Cannot reply to deleted message');
        _clearSelection();
        return;
      }
      _startReply(messageId, data['text'] ?? '', data['senderId'] ?? '');
    }
  }

  void _handleCopyFromMenu() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .get();

    _copyMessages(snapshot.docs);
  }

  void _handleEditFromMenu() async {
    final selectedIds = _selectedMessageIds.value;
    if (selectedIds.length != 1) return;
    final messageId = selectedIds.first;

    final doc = await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .doc(messageId)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      if (data['senderId'] != _currentUser!.uid) {
        _showSnackBar('You can only edit your own messages');
        _clearSelection();
        return;
      }
      if (data['deletedForEveryone'] == true) {
        _showSnackBar('Cannot edit deleted message');
        _clearSelection();
        return;
      }
      _startEdit(messageId, data['text'] ?? '');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD - Optimized with ValueListenableBuilders
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ValueListenableBuilder<Set<String>>(
          valueListenable: _selectedMessageIds,
          builder: (context, selectedIds, _) {
            return _buildAppBar(cs, selectedIds);
          },
        ),
      ),
      body: StreamBuilder<DocumentSnapshot?>(
        stream: _friendshipStream, // Uses cached stream
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final relationshipDoc = snapshot.data;
          bool areFriends = false;
          if (relationshipDoc != null && relationshipDoc.exists) {
            final data = relationshipDoc.data() as Map<String, dynamic>?;
            areFriends = data?['type'] == 'friends';
          }

          return Column(
            children: [
              Expanded(child: _buildMessagesList(cs)),
              _buildReplyPreviewListenable(cs),
              _buildEditPreviewListenable(cs),
              _buildInputBar(cs, areFriends),
            ],
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(ColorScheme cs, Set<String> selectedIds) {
    final isSelecting = selectedIds.isNotEmpty;

    return AppBar(
      leading: isSelecting
          ? IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: _clearSelection,
      )
          : null,
      titleSpacing: 0,
      title: isSelecting
          ? Text(
        '${selectedIds.length} selected',
        style: const TextStyle(fontWeight: FontWeight.w600),
      )
          : Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: cs.primary.withOpacity(0.15),
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
              style: const TextStyle(fontWeight: FontWeight.w700),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: isSelecting
          ? [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          position: PopupMenuPosition.under,
          onSelected: _handleMenuAction,
          itemBuilder: (context) => _buildMenuItems(selectedIds.length),
        ),
      ]
          : null,
    );
  }

  List<PopupMenuEntry<String>> _buildMenuItems(int selectedCount) {
    final items = <PopupMenuEntry<String>>[];
    final singleSelected = selectedCount == 1;

    if (singleSelected) {
      items.add(const PopupMenuItem(
        value: 'reply',
        child: Row(
          children: [
            Icon(Icons.reply, size: 20),
            SizedBox(width: 12),
            Text('Reply'),
          ],
        ),
      ));
    }

    items.add(const PopupMenuItem(
      value: 'copy',
      child: Row(
        children: [
          Icon(Icons.copy, size: 20),
          SizedBox(width: 12),
          Text('Copy'),
        ],
      ),
    ));

    if (singleSelected) {
      items.add(const PopupMenuItem(
        value: 'edit',
        child: Row(
          children: [
            Icon(Icons.edit, size: 20),
            SizedBox(width: 12),
            Text('Edit'),
          ],
        ),
      ));
    }

    items.add(PopupMenuItem(
      value: 'delete',
      child: Row(
        children: [
          Icon(Icons.delete, size: 20,
              color: Theme.of(context).colorScheme.error),
          const SizedBox(width: 12),
          Text('Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.error)),
        ],
      ),
    ));

    return items;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MESSAGES LIST - Optimized
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildMessagesList(ColorScheme cs) {
    return StreamBuilder<QuerySnapshot>(
      stream: _messagesStream, // Uses cached stream - no re-subscription!
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final allDocs = snapshot.data?.docs ?? [];

        final messages = allDocs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final deletedFor = List<String>.from(data['deletedFor'] ?? []);
          return !deletedFor.contains(_currentUser!.uid);
        }).toList();

        if (messages.isEmpty) {
          return _buildEmptyState(cs);
        }

        return ListView.builder(
          controller: _scrollController,
          reverse: true,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          physics: const BouncingScrollPhysics(),
          // Preserve item state
          addAutomaticKeepAlives: true,
          // Use unique keys for stable items
          key: const PageStorageKey('messages_list'),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final doc = messages[index];
            final data = doc.data() as Map<String, dynamic>;
            final messageId = doc.id;
            final isMe = data['senderId'] == _currentUser?.uid;
            final timestamp = data['timestamp'] as Timestamp?;

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
              key: ValueKey(messageId), // Stable key
              children: [
                if (showDate && timestamp != null)
                  _buildDateSeparator(timestamp, cs),
                _MessageItemWidget(
                  messageId: messageId,
                  data: data,
                  isMe: isMe,
                  timestamp: timestamp,
                  currentUserId: _currentUser!.uid,
                  friendUsername: widget.friendUsername,
                  selectedMessageIds: _selectedMessageIds,
                  messageKeys: _messageKeys,
                  onLongPress: () => _onMessageLongPress(messageId, data, isMe),
                  onTap: () => _onMessageTap(messageId),
                  onSwipeReply: () {
                    final text = data['text'] ?? '';
                    final senderId = data['senderId'] ?? '';
                    _startReply(messageId, text, senderId);
                  },
                  onReplyTap: data['replyTo'] != null
                      ? () {
                    final replyTo =
                    data['replyTo'] as Map<String, dynamic>;
                    _scrollToMessage(replyTo['messageId'], allDocs);
                  }
                      : null,
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _scrollToMessage(
      String messageId, List<QueryDocumentSnapshot> allMessages) {
    final index = allMessages.indexWhere((doc) => doc.id == messageId);
    if (index != -1 && _scrollController.hasClients) {
      _scrollController.animateTo(
        index * 80.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _buildEmptyState(ColorScheme cs) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 64,
            color: cs.onSurface.withOpacity(0.15),
          ),
          const SizedBox(height: 16),
          Text(
            'No messages yet',
            style: TextStyle(
              color: cs.onSurface.withOpacity(0.5),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Say hello! 👋',
            style: TextStyle(
              color: cs.onSurface.withOpacity(0.3),
              fontSize: 14,
            ),
          ),
        ],
      ),
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
          color: cs.onSurface.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: cs.onSurface.withOpacity(0.45),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // REPLY & EDIT PREVIEW - Using ValueListenableBuilder
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildReplyPreviewListenable(ColorScheme cs) {
    return ValueListenableBuilder<Map<String, dynamic>?>(
      valueListenable: _replyingTo,
      builder: (context, replyData, _) {
        if (replyData == null) return const SizedBox.shrink();

        final isOwnMessage = replyData['senderId'] == _currentUser!.uid;
        final senderName = isOwnMessage ? 'You' : widget.friendUsername;

        return Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 8, 0),
          decoration: BoxDecoration(
            color: cs.surface,
            border: Border(
              top: BorderSide(color: cs.onSurface.withOpacity(0.08)),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Replying to $senderName',
                      style: TextStyle(
                        color: cs.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      replyData['text'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: cs.onSurface.withOpacity(0.6),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: cs.onSurface.withOpacity(0.5)),
                onPressed: _cancelReply,
                iconSize: 20,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEditPreviewListenable(ColorScheme cs) {
    return ValueListenableBuilder<String?>(
      valueListenable: _editingMessageId,
      builder: (context, editingId, _) {
        if (editingId == null) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 8, 0),
          decoration: BoxDecoration(
            color: cs.surface,
            border: Border(
              top: BorderSide(color: cs.onSurface.withOpacity(0.08)),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: cs.tertiary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Editing message',
                      style: TextStyle(
                        color: cs.tertiary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _originalEditText ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: cs.onSurface.withOpacity(0.6),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: cs.onSurface.withOpacity(0.5)),
                onPressed: _cancelEdit,
                iconSize: 20,
              ),
            ],
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // INPUT BAR
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildInputBar(ColorScheme cs, bool areFriends) {
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
            top: BorderSide(color: cs.onSurface.withOpacity(0.08)),
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

    return ValueListenableBuilder<String?>(
      valueListenable: _editingMessageId,
      builder: (context, editingId, _) {
        final isEditing = editingId != null;

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
              top: BorderSide(color: cs.onSurface.withOpacity(0.08)),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: cs.onSurface.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: TextField(
                    controller: _messageController,
                    focusNode: _inputFocusNode,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText:
                      isEditing ? 'Edit message...' : 'Type a message...',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) =>
                    isEditing ? _editMessage() : _sendMessage(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: isEditing ? _editMessage : _sendMessage,
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: isEditing ? cs.tertiary : cs.primary,
                    shape: BoxShape.circle,
                  ),
                  child: _isSending
                      ? Padding(
                    padding: const EdgeInsets.all(13),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: cs.onPrimary,
                    ),
                  )
                      : Icon(
                    isEditing ? Icons.check : Icons.send_rounded,
                    color: cs.onPrimary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// MESSAGE ITEM WIDGET - Separate StatelessWidget for performance
// ═══════════════════════════════════════════════════════════════════════════════

class _MessageItemWidget extends StatelessWidget {
  final String messageId;
  final Map<String, dynamic> data;
  final bool isMe;
  final Timestamp? timestamp;
  final String currentUserId;
  final String friendUsername;
  final ValueNotifier<Set<String>> selectedMessageIds;
  final Map<String, GlobalKey> messageKeys;
  final VoidCallback onLongPress;
  final VoidCallback onTap;
  final VoidCallback onSwipeReply;
  final VoidCallback? onReplyTap;

  const _MessageItemWidget({
    required this.messageId,
    required this.data,
    required this.isMe,
    required this.timestamp,
    required this.currentUserId,
    required this.friendUsername,
    required this.selectedMessageIds,
    required this.messageKeys,
    required this.onLongPress,
    required this.onTap,
    required this.onSwipeReply,
    this.onReplyTap,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure key exists
    messageKeys[messageId] ??= GlobalKey();
    final messageKey = messageKeys[messageId]!;

    final text = data['text'] ?? '';
    final deletedForEveryone = data['deletedForEveryone'] == true;
    final deletedBy = data['deletedBy'] as String?;
    final reactions = Map<String, String>.from(data['reactions'] ?? {});
    final replyTo = data['replyTo'] as Map<String, dynamic>?;
    final editedAt = data['editedAt'] as Timestamp?;

    return ValueListenableBuilder<Set<String>>(
      valueListenable: selectedMessageIds,
      builder: (context, selectedIds, child) {
        final isSelected = selectedIds.contains(messageId);

        return GestureDetector(
          key: messageKey,
          onLongPress: deletedForEveryone ? null : onLongPress,
          onTap: selectedIds.isNotEmpty ? onTap : null,
          child: Dismissible(
            key: Key('dismiss_$messageId'),
            direction: deletedForEveryone
                ? DismissDirection.none
                : DismissDirection.startToEnd,
            confirmDismiss: (_) async {
              if (!deletedForEveryone) {
                onSwipeReply();
              }
              return false;
            },
            background: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              child: Icon(
                Icons.reply,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            child: _MessageBubble(
              messageId: messageId,
              text: text,
              isMe: isMe,
              timestamp: timestamp,
              isSelected: isSelected,
              deletedForEveryone: deletedForEveryone,
              deletedBy: deletedBy,
              currentUserId: currentUserId,
              reactions: reactions,
              replyTo: replyTo,
              editedAt: editedAt,
              friendUsername: friendUsername,
              onReplyTap: onReplyTap,
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// MESSAGE BUBBLE WIDGET
// ═══════════════════════════════════════════════════════════════════════════════

class _MessageBubble extends StatelessWidget {
  final String messageId;
  final String text;
  final bool isMe;
  final Timestamp? timestamp;
  final bool isSelected;
  final bool deletedForEveryone;
  final String? deletedBy;
  final String currentUserId;
  final Map<String, String> reactions;
  final Map<String, dynamic>? replyTo;
  final Timestamp? editedAt;
  final String friendUsername;
  final VoidCallback? onReplyTap;

  const _MessageBubble({
    required this.messageId,
    required this.text,
    required this.isMe,
    this.timestamp,
    required this.isSelected,
    required this.deletedForEveryone,
    this.deletedBy,
    required this.currentUserId,
    required this.reactions,
    this.replyTo,
    this.editedAt,
    required this.friendUsername,
    this.onReplyTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    String displayText;
    bool isDeleted = false;

    if (deletedForEveryone) {
      isDeleted = true;
      if (deletedBy == currentUserId) {
        displayText = '🚫 You deleted this message';
      } else {
        displayText = '🚫 This message was deleted';
      }
    } else {
      displayText = text;
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(vertical: 3),
        child: Column(
          crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Reply preview
            if (replyTo != null && !deletedForEveryone)
              GestureDetector(
                onTap: onReplyTap,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: cs.onSurface.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(10),
                    border: Border(
                      left: BorderSide(
                        color: cs.primary.withOpacity(0.6),
                        width: 3,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        replyTo!['senderId'] == currentUserId
                            ? 'You'
                            : friendUsername,
                        style: TextStyle(
                          color: cs.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        replyTo!['text'] ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: cs.onSurface.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Main bubble
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isMe
                    ? cs.primary.withOpacity(0.8)
                    : cs.onSurface.withOpacity(0.15))
                    : (isMe ? cs.primary : cs.onSurface.withOpacity(0.08)),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isMe ? 18 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 18),
                ),
              ),
              child: Column(
                crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    displayText,
                    style: TextStyle(
                      color: isDeleted
                          ? (isMe
                          ? cs.onPrimary.withOpacity(0.7)
                          : cs.onSurface.withOpacity(0.5))
                          : (isMe ? cs.onPrimary : cs.onSurface),
                      fontSize: 15,
                      height: 1.4,
                      fontStyle:
                      isDeleted ? FontStyle.italic : FontStyle.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (editedAt != null && !deletedForEveryone)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Text(
                            'edited',
                            style: TextStyle(
                              color: isMe
                                  ? cs.onPrimary.withOpacity(0.5)
                                  : cs.onSurface.withOpacity(0.3),
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      if (timestamp != null)
                        Text(
                          _formatTime(timestamp!),
                          style: TextStyle(
                            color: isMe
                                ? cs.onPrimary.withOpacity(0.6)
                                : cs.onSurface.withOpacity(0.35),
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Reactions
            if (reactions.isNotEmpty && !deletedForEveryone)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: cs.onSurface.withOpacity(0.1),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: cs.shadow.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...reactions.values.toSet().map((emoji) {
                        final count =
                            reactions.values.where((e) => e == emoji).length;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(emoji, style: const TextStyle(fontSize: 14)),
                              if (count > 1)
                                Padding(
                                  padding: const EdgeInsets.only(left: 2),
                                  child: Text(
                                    '$count',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: cs.onSurface.withOpacity(0.6),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
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

// ═══════════════════════════════════════════════════════════════════════════════
// EMOJI REACTION PICKER
// ═══════════════════════════════════════════════════════════════════════════════

class _EmojiReactionPicker extends StatelessWidget {
  final Map<String, String> reactions;
  final String currentUserId;
  final List<String> emojis;
  final Function(String) onEmojiSelected;

  const _EmojiReactionPicker({
    required this.reactions,
    required this.currentUserId,
    required this.emojis,
    required this.onEmojiSelected,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final myReaction = reactions[currentUserId];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: cs.onSurface.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: emojis.map((emoji) {
          final isSelected = myReaction == emoji;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onEmojiSelected(emoji),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? cs.primary.withOpacity(0.2)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Text(
                emoji,
                style: TextStyle(
                  fontSize: isSelected ? 26 : 24,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// DELETE DIALOG
// ═══════════════════════════════════════════════════════════════════════════════

class _DeleteDialog extends StatefulWidget {
  final String chatId;
  final List<String> selectedIds;
  final String currentUserId;
  final VoidCallback onComplete;

  const _DeleteDialog({
    required this.chatId,
    required this.selectedIds,
    required this.currentUserId,
    required this.onComplete,
  });

  @override
  State<_DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<_DeleteDialog> {
  bool _isLoading = false;
  bool _hasOwnMessages = false;
  bool _allOwn = false;

  @override
  void initState() {
    super.initState();
    _checkMessageOwnership();
  }

  Future<void> _checkMessageOwnership() async {
    int ownCount = 0;
    for (final id in widget.selectedIds) {
      final doc = await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .doc(id)
          .get();
      if (doc.exists && doc.data()?['senderId'] == widget.currentUserId) {
        ownCount++;
      }
    }
    if (mounted) {
      setState(() {
        _hasOwnMessages = ownCount > 0;
        _allOwn = ownCount == widget.selectedIds.length;
      });
    }
  }

  Future<void> _deleteForMe() async {
    setState(() => _isLoading = true);
    try {
      final batch = FirebaseFirestore.instance.batch();
      for (final id in widget.selectedIds) {
        final ref = FirebaseFirestore.instance
            .collection('chats')
            .doc(widget.chatId)
            .collection('messages')
            .doc(id);

        final doc = await ref.get();
        if (doc.exists) {
          final data = doc.data()!;
          batch.update(ref, {
            'deletedFor': FieldValue.arrayUnion([widget.currentUserId]),
            'senderId': data['senderId'],
          });
        }
      }
      await batch.commit();
      widget.onComplete();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete')),
        );
      }
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _deleteForEveryone() async {
    setState(() => _isLoading = true);
    try {
      final batch = FirebaseFirestore.instance.batch();
      for (final id in widget.selectedIds) {
        final ref = FirebaseFirestore.instance
            .collection('chats')
            .doc(widget.chatId)
            .collection('messages')
            .doc(id);

        final doc = await ref.get();
        if (doc.exists && doc.data()?['senderId'] == widget.currentUserId) {
          batch.update(ref, {
            'deletedForEveryone': true,
            'deletedBy': widget.currentUserId,
            'text': '',
            'reactions': {},
            'replyTo': null,
            'senderId': doc.data()!['senderId'],
          });
        }
      }
      await batch.commit();
      widget.onComplete();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete')),
        );
      }
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_outline, color: cs.error, size: 48),
            const SizedBox(height: 16),
            Text(
              'Delete ${widget.selectedIds.length} message${widget.selectedIds.length > 1 ? 's' : ''}?',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              )
            else
              Column(
                children: [
                  if (_hasOwnMessages)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cs.error,
                          foregroundColor: cs.onError,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _deleteForEveryone,
                        child: Text(
                          _allOwn
                              ? 'Delete for everyone'
                              : 'Delete my messages for everyone',
                        ),
                      ),
                    ),
                  if (_hasOwnMessages) const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: cs.error,
                        side: BorderSide(color: cs.error),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _deleteForMe,
                      child: const Text('Delete for me'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}