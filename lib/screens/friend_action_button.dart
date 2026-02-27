// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// FILE: lib/widgets/friend_action_button.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:async';
import 'package:flutter/material.dart';
import '../services/friend_service.dart';

/// A self-contained button that displays and manages the relationship state
/// between the current user and a target user.
///
/// Uses a real-time Firestore listener so the button auto-updates
/// if the relationship changes from any source (other device, other user, etc.)
class FriendActionButton extends StatefulWidget {
  final String targetUid;
  final String currentUserId;
  final bool expanded;

  const FriendActionButton({
    super.key,
    required this.targetUid,
    required this.currentUserId,
    this.expanded = false,
  });

  @override
  State<FriendActionButton> createState() => _FriendActionButtonState();
}

class _FriendActionButtonState extends State<FriendActionButton> {
  final _friendService = FriendService();
  late StreamSubscription<FriendStatus> _statusSubscription;
  FriendStatus _status = FriendStatus.loading;
  bool _actionInProgress = false;

  @override
  void initState() {
    super.initState();
    _statusSubscription = _friendService
        .statusStream(widget.currentUserId, widget.targetUid)
        .listen((status) {
      if (mounted) {
        setState(() => _status = status);
      }
    }, onError: (_) {
      if (mounted) {
        setState(() => _status = FriendStatus.none);
      }
    });
  }

  @override
  void didUpdateWidget(covariant FriendActionButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetUid != widget.targetUid ||
        oldWidget.currentUserId != widget.currentUserId) {
      _statusSubscription.cancel();
      setState(() => _status = FriendStatus.loading);
      _statusSubscription = _friendService
          .statusStream(widget.currentUserId, widget.targetUid)
          .listen((status) {
        if (mounted) {
          setState(() => _status = status);
        }
      }, onError: (_) {
        if (mounted) {
          setState(() => _status = FriendStatus.none);
        }
      });
    }
  }

  @override
  void dispose() {
    _statusSubscription.cancel();
    super.dispose();
  }

  // ─── ACTIONS ──────────────────────────────────────────────────────────
  Future<void> _sendFriendRequest() async {
    if (_actionInProgress) return;
    setState(() => _actionInProgress = true);

    try {
      final result = await _friendService.sendRequest(
        widget.currentUserId,
        widget.targetUid,
      );

      if (mounted) {
        if (result == 'auto_accepted') {
          _showSnackBar('You are now friends! 🎉');
        } else if (result == 'already_friends') {
          _showSnackBar('You are already friends.');
        } else if (result == 'already_sent') {
          _showSnackBar('Request already sent.');
        }
        // Status will auto-update via the stream listener
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Failed to send request. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _actionInProgress = false);
    }
  }

  Future<void> _revokeRequest() async {
    if (_actionInProgress) return;
    setState(() => _actionInProgress = true);

    try {
      await _friendService.revokeRequest(
        widget.currentUserId,
        widget.targetUid,
      );
    } catch (e) {
      if (mounted) {
        _showSnackBar('Failed to revoke request.');
      }
    } finally {
      if (mounted) setState(() => _actionInProgress = false);
    }
  }

  Future<void> _acceptRequest() async {
    if (_actionInProgress) return;
    setState(() => _actionInProgress = true);

    try {
      final result = await _friendService.acceptRequest(
        widget.currentUserId,
        widget.targetUid,
      );

      if (mounted) {
        if (result == 'accepted') {
          _showSnackBar('Friend request accepted! 🎉');
        } else if (result == 'already_friends') {
          _showSnackBar('You are already friends.');
        } else if (result == 'no_request_found') {
          _showSnackBar('Request no longer exists.');
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Failed to accept request.');
      }
    } finally {
      if (mounted) setState(() => _actionInProgress = false);
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showRevokeDialog(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.undo_rounded,
                  color: colorScheme.error, size: 48),
              const SizedBox(height: 16),
              Text(
                'Revoke Friend Request?',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'Do you want to withdraw your friend request?',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color:
                  colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.error,
                        foregroundColor: colorScheme.onError,
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        _revokeRequest();
                      },
                      child: const Text('Revoke',
                          style:
                          TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openChat(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening chat...')),
    );
    // Navigate to your ChatScreen
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (_status) {
      case FriendStatus.loading:
        return SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: colorScheme.primary,
          ),
        );

      case FriendStatus.none:
        return _buildButton(
          context: context,
          label: 'Add Friend',
          icon: Icons.person_add_rounded,
          color: colorScheme.primary,
          textColor: colorScheme.onPrimary,
          onTap: _sendFriendRequest,
          isLoading: _actionInProgress,
        );

      case FriendStatus.requestSent:
        return _buildButton(
          context: context,
          label: 'Requested',
          icon: Icons.schedule_rounded,
          color: colorScheme.onSurface.withValues(alpha: 0.1),
          textColor: colorScheme.onSurface.withValues(alpha: 0.6),
          onTap: () => _showRevokeDialog(context),
          isLoading: _actionInProgress,
        );

      case FriendStatus.requestReceived:
        return _buildButton(
          context: context,
          label: 'Accept',
          icon: Icons.check_circle_outline_rounded,
          color: colorScheme.tertiary,
          textColor: colorScheme.onTertiary,
          onTap: _acceptRequest,
          isLoading: _actionInProgress,
        );

      case FriendStatus.friends:
        return _buildButton(
          context: context,
          label: 'Chat',
          icon: Icons.chat_bubble_rounded,
          color: colorScheme.primary,
          textColor: colorScheme.onPrimary,
          onTap: () => _openChat(context),
          isLoading: false,
        );
    }
  }

  Widget _buildButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
    required bool isLoading,
  }) {
    final expanded = widget.expanded;
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: expanded ? 20 : 12,
          vertical: expanded ? 12 : 8,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: isLoading
            ? SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: textColor,
          ),
        )
            : Row(
          mainAxisSize:
          expanded ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: textColor),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}