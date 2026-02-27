// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// FILE: lib/screens/user_profile_view.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:async';
import 'package:flutter/material.dart';
import '../services/friend_service.dart';

class UserProfileView extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String currentUserId;

  const UserProfileView({
    super.key,
    required this.userData,
    required this.currentUserId,
  });

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  late Map<String, dynamic> _userData;
  final _friendService = FriendService();
  late StreamSubscription<FriendStatus> _statusSubscription;
  FriendStatus _friendStatus = FriendStatus.loading;
  bool _actionInProgress = false;

  @override
  void initState() {
    super.initState();
    _userData = widget.userData;

    _statusSubscription = _friendService
        .statusStream(widget.currentUserId, _userData['uid'])
        .listen((status) {
      if (mounted) setState(() => _friendStatus = status);
    }, onError: (_) {
      if (mounted) setState(() => _friendStatus = FriendStatus.none);
    });
  }

  @override
  void dispose() {
    _statusSubscription.cancel();
    super.dispose();
  }

  // ─── ACTIONS ──────────────────────────────────────────────────────────
  Future<void> _sendRequest() async {
    if (_actionInProgress) return;
    setState(() => _actionInProgress = true);

    try {
      final result = await _friendService.sendRequest(
        widget.currentUserId,
        _userData['uid'],
      );
      if (mounted) {
        if (result == 'auto_accepted') {
          _showSnackBar('You are now friends! 🎉');
        }
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
        widget.currentUserId,
        _userData['uid'],
      );
    } catch (e) {
      if (mounted) _showSnackBar('Failed to revoke request.');
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
        _userData['uid'],
      );
      if (mounted && result == 'accepted') {
        _showSnackBar('Friend request accepted! 🎉');
      }
    } catch (e) {
      if (mounted) _showSnackBar('Failed to accept request.');
    } finally {
      if (mounted) setState(() => _actionInProgress = false);
    }
  }

  Future<void> _removeFriend() async {
    if (_actionInProgress) return;
    setState(() => _actionInProgress = true);

    try {
      await _friendService.removeFriend(
        widget.currentUserId,
        _userData['uid'],
      );
    } catch (e) {
      if (mounted) _showSnackBar('Failed to remove friend.');
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
      ),
    );
  }

  void _openChat() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening chat...')),
    );
  }

  // ─── DIALOGS ──────────────────────────────────────────────────────────
  void _showRevokeDialog() {
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

  void _showRemoveFriendDialog() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final username = _userData['username'] ?? 'this user';

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
              Icon(Icons.person_remove_rounded,
                  color: colorScheme.error, size: 48),
              const SizedBox(height: 16),
              Text(
                'Remove Friend',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to remove $username from your friends?',
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
                        _removeFriend();
                      },
                      child: const Text('Remove',
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

  // ─── BUILD ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final username = _userData['username'] ?? 'Unknown';
    final email = _userData['email'] ?? '';

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          username,
          style: theme.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          if (_friendStatus == FriendStatus.friends)
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert_rounded,
                  color: colorScheme.onSurface),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              onSelected: (value) {
                if (value == 'remove') _showRemoveFriendDialog();
              },
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: 'remove',
                  child: Row(
                    children: [
                      Icon(Icons.person_remove_rounded,
                          color: colorScheme.error, size: 20),
                      const SizedBox(width: 12),
                      Text('Remove Friend',
                          style: TextStyle(color: colorScheme.error)),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor:
              colorScheme.primary.withValues(alpha: 0.15),
              child: Text(
                username.isNotEmpty ? username[0].toUpperCase() : '?',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              username,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '@$username',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 28),
            _buildProfileActionButton(theme, colorScheme),
            const SizedBox(height: 32),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _infoTile(
                        Icons.person, 'Username', username, theme),
                    if (email.isNotEmpty) ...[
                      const Divider(),
                      _infoTile(
                          Icons.email, 'Email', email, theme),
                    ],
                    const Divider(),
                    _infoTile(Icons.info_outline_rounded, 'Status',
                        _friendStatusLabel(), theme),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _friendStatusLabel() {
    switch (_friendStatus) {
      case FriendStatus.friends:
        return 'Friends';
      case FriendStatus.requestSent:
        return 'Request Sent';
      case FriendStatus.requestReceived:
        return 'Request Received';
      case FriendStatus.none:
        return 'Not Connected';
      case FriendStatus.loading:
        return 'Checking...';
    }
  }

  Widget _buildProfileActionButton(
      ThemeData theme, ColorScheme colorScheme) {
    if (_friendStatus == FriendStatus.loading) {
      return SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: colorScheme.primary,
        ),
      );
    }

    IconData icon;
    String label;
    Color bgColor;
    Color fgColor;
    VoidCallback onTap;

    switch (_friendStatus) {
      case FriendStatus.none:
        icon = Icons.person_add_rounded;
        label = 'Add Friend';
        bgColor = colorScheme.primary;
        fgColor = colorScheme.onPrimary;
        onTap = _sendRequest;
        break;
      case FriendStatus.requestSent:
        icon = Icons.schedule_rounded;
        label = 'Requested';
        bgColor = colorScheme.onSurface.withValues(alpha: 0.1);
        fgColor = colorScheme.onSurface.withValues(alpha: 0.6);
        onTap = _showRevokeDialog;
        break;
      case FriendStatus.requestReceived:
        icon = Icons.check_circle_outline_rounded;
        label = 'Accept Request';
        bgColor = colorScheme.tertiary;
        fgColor = colorScheme.onTertiary;
        onTap = _acceptRequest;
        break;
      case FriendStatus.friends:
        icon = Icons.chat_bubble_rounded;
        label = 'Chat';
        bgColor = colorScheme.primary;
        fgColor = colorScheme.onPrimary;
        onTap = _openChat;
        break;
      default:
        return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: _actionInProgress ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 280),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (_friendStatus != FriendStatus.requestSent)
              BoxShadow(
                color: bgColor.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
          ],
        ),
        child: _actionInProgress
            ? Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: fgColor,
            ),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: fgColor, size: 20),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: fgColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
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

  Widget _infoTile(
      IconData icon, String title, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodySmall),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}