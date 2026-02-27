import 'dart:async';
import 'package:flutter/material.dart';
import '../services/friend_service.dart';
import '../services/chat_service.dart';
import '../screens/chat_screen.dart';

class FriendActionButton extends StatefulWidget {
  final String targetUid;
  final String currentUserId;
  final String targetUsername;
  final bool expanded;

  const FriendActionButton({
    super.key,
    required this.targetUid,
    required this.currentUserId,
    this.targetUsername = '',
    this.expanded = false,
  });

  @override
  State<FriendActionButton> createState() => _FriendActionButtonState();
}

class _FriendActionButtonState extends State<FriendActionButton> {
  final _friendService = FriendService();
  StreamSubscription<FriendStatus>? _statusSub;
  FriendStatus _status = FriendStatus.loading;
  bool _actionInProgress = false;

  @override
  void initState() {
    super.initState();
    _listenStatus();
  }

  @override
  void didUpdateWidget(covariant FriendActionButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetUid != widget.targetUid ||
        oldWidget.currentUserId != widget.currentUserId) {
      _statusSub?.cancel();
      setState(() => _status = FriendStatus.loading);
      _listenStatus();
    }
  }

  void _listenStatus() {
    _statusSub = _friendService
        .statusStream(widget.currentUserId, widget.targetUid)
        .listen(
          (status) {
        if (mounted) setState(() => _status = status);
      },
      onError: (_) {
        if (mounted) setState(() => _status = FriendStatus.none);
      },
    );
  }

  @override
  void dispose() {
    _statusSub?.cancel();
    super.dispose();
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _sendRequest() async {
    if (_actionInProgress) return;
    setState(() => _actionInProgress = true);
    try {
      final result = await _friendService.sendRequest(
          widget.currentUserId, widget.targetUid);
      if (mounted) {
        if (result == 'auto_accepted') _showSnackBar('You are now friends! 🎉');
        if (result == 'already_friends') _showSnackBar('Already friends.');
        if (result == 'already_sent') _showSnackBar('Request already sent.');
      }
    } catch (e) {
      if (mounted) _showSnackBar('Failed to send request.');
    } finally {
      if (mounted) setState(() => _actionInProgress = false);
    }
  }

  Future<void> _revokeRequest() async {
    if (_actionInProgress) return;
    setState(() => _actionInProgress = true);
    try {
      await _friendService.revokeRequest(
          widget.currentUserId, widget.targetUid);
    } catch (e) {
      if (mounted) _showSnackBar('Failed to revoke.');
    } finally {
      if (mounted) setState(() => _actionInProgress = false);
    }
  }

  Future<void> _acceptRequest() async {
    if (_actionInProgress) return;
    setState(() => _actionInProgress = true);
    try {
      final result = await _friendService.acceptRequest(
          widget.currentUserId, widget.targetUid);
      if (mounted && result == 'accepted') {
        _showSnackBar('Friend request accepted! 🎉');
      }
    } catch (e) {
      if (mounted) _showSnackBar('Failed to accept.');
    } finally {
      if (mounted) setState(() => _actionInProgress = false);
    }
  }

  void _showRevokeDialog() {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.undo_rounded, color: cs.error, size: 48),
            const SizedBox(height: 16),
            Text('Revoke Friend Request?',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Withdraw your friend request?',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.6))),
            const SizedBox(height: 24),
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: cs.error,
                      foregroundColor: cs.onError,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _revokeRequest();
                  },
                  child: const Text('Revoke',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }

  void _openChat() {
    final chatService = ChatService();
    final chatId = chatService.getChatId(
        widget.currentUserId, widget.targetUid);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          chatId: chatId,
          friendUid: widget.targetUid,
          friendUsername: widget.targetUsername,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    switch (_status) {
      case FriendStatus.loading:
        return SizedBox(
          width: 24, height: 24,
          child: CircularProgressIndicator(strokeWidth: 2, color: cs.primary),
        );
      case FriendStatus.none:
        return _btn(
            label: 'Add Friend', icon: Icons.person_add_rounded,
            color: cs.primary, textColor: cs.onPrimary, onTap: _sendRequest);
      case FriendStatus.requestSent:
        return _btn(
            label: 'Requested', icon: Icons.schedule_rounded,
            color: cs.onSurface.withValues(alpha: 0.1),
            textColor: cs.onSurface.withValues(alpha: 0.6),
            onTap: _showRevokeDialog);
      case FriendStatus.requestReceived:
        return _btn(
            label: 'Accept', icon: Icons.check_circle_outline_rounded,
            color: cs.tertiary, textColor: cs.onTertiary,
            onTap: _acceptRequest);
      case FriendStatus.friends:
        return _btn(
            label: 'Chat', icon: Icons.chat_bubble_rounded,
            color: cs.primary, textColor: cs.onPrimary, onTap: _openChat);
    }
  }

  Widget _btn({
    required String label, required IconData icon,
    required Color color, required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: _actionInProgress ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: widget.expanded ? 20 : 12,
          vertical: widget.expanded ? 12 : 8,
        ),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(12)),
        child: _actionInProgress
            ? SizedBox(width: 18, height: 18,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: textColor))
            : Row(
          mainAxisSize:
          widget.expanded ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: textColor),
            const SizedBox(width: 6),
            Flexible(
              child: Text(label,
                  style: TextStyle(color: textColor,
                      fontWeight: FontWeight.w600, fontSize: 13),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}