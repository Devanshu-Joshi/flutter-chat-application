// search_screen.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  SEARCH SCREEN
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  bool _hasSearched = false;
  String _lastQuery = '';

  // Animation controllers
  late AnimationController _floatingController;
  late AnimationController _pulseController;

  final _currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // ─── SEARCH FIRESTORE ──────────────────────────────────────────────────────

  Future<void> _performSearch(String query) async {
    final trimmed = query.trim().toLowerCase();

    if (trimmed.isEmpty) {
      setState(() {
        _searchResults = [];
        _hasSearched = false;
        _lastQuery = '';
      });
      return;
    }

    if (trimmed == _lastQuery) return;
    _lastQuery = trimmed;

    setState(() => _isSearching = true);

    try {
      // Search by username prefix
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: trimmed)
          .where('username', isLessThanOrEqualTo: '$trimmed\uf8ff')
          .limit(20)
          .get();

      if (!mounted) return;

      final results = snapshot.docs
          .where((doc) => doc.id != _currentUser?.uid)
          .map((doc) {
        final data = doc.data();
        data['uid'] = doc.id;
        return data;
      }).toList();

      setState(() {
        _searchResults = results;
        _isSearching = false;
        _hasSearched = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSearching = false;
        _hasSearched = true;
        _searchResults = [];
      });
    }
  }

  // ─── RECENTLY VIEWED ──────────────────────────────────────────────────────

  Future<void> _saveRecentlyViewed(String viewedUid) async {
    if (_currentUser == null) return;

    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser!.uid)
        .collection('recentlyViewed')
        .doc(viewedUid);

    await ref.set({
      'uid': viewedUid,
      'viewedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<QuerySnapshot> _recentlyViewedStream() {
    if (_currentUser == null) {
      return const Stream.empty();
    }
    return FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser!.uid)
        .collection('recentlyViewed')
        .orderBy('viewedAt', descending: true)
        .limit(10)
        .snapshots();
  }

  // ─── NAVIGATE TO PROFILE ──────────────────────────────────────────────────

  void _openUserProfile(Map<String, dynamic> userData) {
    _saveRecentlyViewed(userData['uid']);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => UserProfileView(
          userData: userData,
          currentUserId: _currentUser!.uid,
        ),
      ),
    );
  }

  // ─── BUILD ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Search Header ──
            _buildSearchHeader(theme, colorScheme),

            // ── Content ──
            Expanded(
              child: _isSearching
                  ? _buildLoadingState(theme)
                  : _hasSearched
                  ? _buildSearchResults(theme, colorScheme)
                  : _buildDefaultState(theme, colorScheme),
            ),
          ],
        ),
      ),
    );
  }

  // ─── SEARCH HEADER ────────────────────────────────────────────────────────

  Widget _buildSearchHeader(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'Search by username...',
                hintStyle: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchResults = [];
                      _hasSearched = false;
                      _lastQuery = '';
                    });
                  },
                )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              onChanged: (value) {
                setState(() {}); // for suffix icon visibility
                _performSearch(value);
              },
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ─── LOADING STATE ─────────────────────────────────────────────────────────

  Widget _buildLoadingState(ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const BouncingScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 12,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 80,
                      height: 10,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── SEARCH RESULTS ────────────────────────────────────────────────────────

  Widget _buildSearchResults(ThemeData theme, ColorScheme colorScheme) {
    if (_searchResults.isEmpty) {
      return _buildNoResults(theme, colorScheme);
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
      physics: const BouncingScrollPhysics(),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final user = _searchResults[index];
        return _SearchResultTile(
          userData: user,
          currentUserId: _currentUser!.uid,
          onTap: () => _openUserProfile(user),
        );
      },
    );
  }

  Widget _buildNoResults(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 80,
              color: colorScheme.onSurface.withValues(alpha: 0.15),
            ),
            const SizedBox(height: 20),
            Text(
              'No users found',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Try a different username or check the spelling.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── DEFAULT STATE ─────────────────────────────────────────────────────────

  Widget _buildDefaultState(ThemeData theme, ColorScheme colorScheme) {
    return StreamBuilder<QuerySnapshot>(
      stream: _recentlyViewedStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState(theme);
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return _buildEmptySearchState(theme, colorScheme);
        }

        return _buildRecentlyViewed(docs, theme, colorScheme);
      },
    );
  }

  Widget _buildRecentlyViewed(
      List<QueryDocumentSnapshot> recentDocs,
      ThemeData theme,
      ColorScheme colorScheme,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
          child: Row(
            children: [
              Icon(
                Icons.history_rounded,
                size: 20,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 8),
              Text(
                'Recently Viewed',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
            physics: const BouncingScrollPhysics(),
            itemCount: recentDocs.length,
            itemBuilder: (context, index) {
              final data = recentDocs[index].data() as Map<String, dynamic>;
              final uid = data['uid'] as String;

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                    return const SizedBox.shrink();
                  }

                  final userData =
                  userSnapshot.data!.data() as Map<String, dynamic>;
                  userData['uid'] = uid;

                  return _SearchResultTile(
                    userData: userData,
                    currentUserId: _currentUser!.uid,
                    onTap: () => _openUserProfile(userData),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // ─── EMPTY SEARCH STATE (Styled like empty_chat_state.dart) ───────────────

  Widget _buildEmptySearchState(ThemeData theme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 120),
      child: Column(
        children: [
          const SizedBox(height: 30),
          _emptyIllustration(colorScheme),
          const SizedBox(height: 10),
          Text(
            'Discover People',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              'Search for friends by username.\nConnect, chat, and stay close!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.4),
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 36),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: GestureDetector(
              onTap: () {
                _searchFocusNode.requestFocus();
              },
              child: Container(
                height: 56,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_rounded,
                        color: colorScheme.onPrimary),
                    const SizedBox(width: 10),
                    Text(
                      'Start Searching',
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: colorScheme.onSurface.withValues(alpha: 0.05),
            ),
            child: Row(
              children: [
                const Text('💡', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Type a username to find and connect with people!',
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyIllustration(ColorScheme colorScheme) {
    return SizedBox(
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulse background
          AnimatedBuilder(
            animation: _pulseController,
            builder: (_, __) {
              final pulse = 0.2 + _pulseController.value * 0.15;
              return Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colorScheme.primary.withValues(alpha: pulse),
                      colorScheme.secondary.withValues(alpha: pulse * 0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
              );
            },
          ),

          // Floating bubbles
          ..._buildFloatingBubbles(colorScheme),

          // Main circle
          AnimatedBuilder(
            animation: _floatingController,
            builder: (_, child) {
              final offset = 8.0 * _floatingController.value;
              return Transform.translate(
                offset: Offset(0, -offset),
                child: child,
              );
            },
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    colorScheme.surface,
                    colorScheme.surfaceContainerHighest,
                  ],
                ),
                border: Border.all(
                  color: colorScheme.onSurface.withValues(alpha: 0.08),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.person_search_rounded,
                color: colorScheme.onSurface,
                size: 48,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFloatingBubbles(ColorScheme colorScheme) {
    final bubbles = [
      _BubbleInfo(
          const Offset(-80, -70), 38, colorScheme.primary, Icons.search),
      _BubbleInfo(const Offset(75, -50), 33, colorScheme.secondary,
          Icons.person_add),
      _BubbleInfo(
          const Offset(-60, 60), 28, colorScheme.tertiary, Icons.chat_bubble),
    ];

    return bubbles.map((b) {
      return AnimatedBuilder(
        animation: _floatingController,
        builder: (_, __) {
          final float =
              math.sin(_floatingController.value * math.pi) * 6;
          return Transform.translate(
            offset: b.offset + Offset(0, float),
            child: Container(
              width: b.size,
              height: b.size,
              decoration: BoxDecoration(
                color: b.color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(b.icon, color: b.color, size: b.size * 0.5),
            ),
          );
        },
      );
    }).toList();
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  SEARCH RESULT TILE
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _SearchResultTile extends StatelessWidget {
  final Map<String, dynamic> userData;
  final String currentUserId;
  final VoidCallback onTap;

  const _SearchResultTile({
    required this.userData,
    required this.currentUserId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final username = userData['username'] ?? 'Unknown';
    final uid = userData['uid'] ?? '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.onSurface.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 25,
              backgroundColor: colorScheme.primary.withValues(alpha: 0.15),
              child: Text(
                username.isNotEmpty ? username[0].toUpperCase() : '?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Username
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '@$username',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.45),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Action button
            _FriendActionButton(
              targetUid: uid,
              currentUserId: currentUserId,
            ),
          ],
        ),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  FRIEND ACTION BUTTON (Handles all relationship states)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

enum FriendStatus { none, requestSent, requestReceived, friends, loading }

class _FriendActionButton extends StatefulWidget {
  final String targetUid;
  final String currentUserId;
  final bool expanded;

  const _FriendActionButton({
    required this.targetUid,
    required this.currentUserId,
    this.expanded = false,
  });

  @override
  State<_FriendActionButton> createState() => _FriendActionButtonState();
}

class _FriendActionButtonState extends State<_FriendActionButton> {
  FriendStatus _status = FriendStatus.loading;
  bool _actionInProgress = false;

  @override
  void initState() {
    super.initState();
    _checkRelationship();
  }

  Future<void> _checkRelationship() async {
    try {
      // Check if already friends
      final friendDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.currentUserId)
          .collection('friends')
          .doc(widget.targetUid)
          .get();

      if (friendDoc.exists) {
        if (mounted) setState(() => _status = FriendStatus.friends);
        return;
      }

      // Check if request sent by me
      final sentDoc = await FirebaseFirestore.instance
          .collection('friendRequests')
          .doc('${widget.currentUserId}_${widget.targetUid}')
          .get();

      if (sentDoc.exists) {
        if (mounted) setState(() => _status = FriendStatus.requestSent);
        return;
      }

      // Check if request received from them
      final receivedDoc = await FirebaseFirestore.instance
          .collection('friendRequests')
          .doc('${widget.targetUid}_${widget.currentUserId}')
          .get();

      if (receivedDoc.exists) {
        if (mounted) {
          setState(() => _status = FriendStatus.requestReceived);
        }
        return;
      }

      if (mounted) setState(() => _status = FriendStatus.none);
    } catch (e) {
      if (mounted) setState(() => _status = FriendStatus.none);
    }
  }

  Future<void> _sendFriendRequest() async {
    if (_actionInProgress) return;
    setState(() => _actionInProgress = true);

    try {
      await FirebaseFirestore.instance
          .collection('friendRequests')
          .doc('${widget.currentUserId}_${widget.targetUid}')
          .set({
        'from': widget.currentUserId,
        'to': widget.targetUid,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending',
      });

      if (mounted) {
        setState(() {
          _status = FriendStatus.requestSent;
          _actionInProgress = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _actionInProgress = false);
    }
  }

  Future<void> _revokeRequest() async {
    if (_actionInProgress) return;
    setState(() => _actionInProgress = true);

    try {
      await FirebaseFirestore.instance
          .collection('friendRequests')
          .doc('${widget.currentUserId}_${widget.targetUid}')
          .delete();

      if (mounted) {
        setState(() {
          _status = FriendStatus.none;
          _actionInProgress = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _actionInProgress = false);
    }
  }

  void _showRevokeDialog(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
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
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Do you want to withdraw your friend request?',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        _revokeRequest();
                      },
                      child: const Text(
                        'Revoke',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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
    // Navigate to chat — you can replace with your chat screen route
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening chat...')),
    );
    // TODO: Navigator.push to your ChatScreen with appropriate chatId
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
          onTap: () => _acceptRequest(context),
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

  Future<void> _acceptRequest(BuildContext context) async {
    if (_actionInProgress) return;
    setState(() => _actionInProgress = true);

    try {
      final batch = FirebaseFirestore.instance.batch();

      // Add to both friends lists
      final myFriendRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.currentUserId)
          .collection('friends')
          .doc(widget.targetUid);

      final theirFriendRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.targetUid)
          .collection('friends')
          .doc(widget.currentUserId);

      final requestRef = FirebaseFirestore.instance
          .collection('friendRequests')
          .doc('${widget.targetUid}_${widget.currentUserId}');

      batch.set(myFriendRef, {
        'uid': widget.targetUid,
        'since': FieldValue.serverTimestamp(),
      });

      batch.set(theirFriendRef, {
        'uid': widget.currentUserId,
        'since': FieldValue.serverTimestamp(),
      });

      batch.delete(requestRef);

      await batch.commit();

      if (mounted) {
        setState(() {
          _status = FriendStatus.friends;
          _actionInProgress = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _actionInProgress = false);
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

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  USER PROFILE VIEW (Full profile opened from search)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

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
  FriendStatus _friendStatus = FriendStatus.loading;
  bool _actionInProgress = false;

  @override
  void initState() {
    super.initState();
    _userData = widget.userData;
    _checkRelationship();
  }

  Future<void> _checkRelationship() async {
    try {
      final uid = _userData['uid'];

      // Check if friends
      final friendDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.currentUserId)
          .collection('friends')
          .doc(uid)
          .get();

      if (friendDoc.exists) {
        if (mounted) setState(() => _friendStatus = FriendStatus.friends);
        return;
      }

      // Check sent request
      final sentDoc = await FirebaseFirestore.instance
          .collection('friendRequests')
          .doc('${widget.currentUserId}_$uid')
          .get();

      if (sentDoc.exists) {
        if (mounted) {
          setState(() => _friendStatus = FriendStatus.requestSent);
        }
        return;
      }

      // Check received request
      final receivedDoc = await FirebaseFirestore.instance
          .collection('friendRequests')
          .doc('${uid}_${widget.currentUserId}')
          .get();

      if (receivedDoc.exists) {
        if (mounted) {
          setState(() => _friendStatus = FriendStatus.requestReceived);
        }
        return;
      }

      if (mounted) setState(() => _friendStatus = FriendStatus.none);
    } catch (e) {
      if (mounted) setState(() => _friendStatus = FriendStatus.none);
    }
  }

  Future<void> _sendRequest() async {
    if (_actionInProgress) return;
    setState(() => _actionInProgress = true);

    try {
      await FirebaseFirestore.instance
          .collection('friendRequests')
          .doc('${widget.currentUserId}_${_userData['uid']}')
          .set({
        'from': widget.currentUserId,
        'to': _userData['uid'],
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending',
      });

      if (mounted) {
        setState(() {
          _friendStatus = FriendStatus.requestSent;
          _actionInProgress = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _actionInProgress = false);
    }
  }

  Future<void> _revokeRequest() async {
    if (_actionInProgress) return;
    setState(() => _actionInProgress = true);

    try {
      await FirebaseFirestore.instance
          .collection('friendRequests')
          .doc('${widget.currentUserId}_${_userData['uid']}')
          .delete();

      if (mounted) {
        setState(() {
          _friendStatus = FriendStatus.none;
          _actionInProgress = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _actionInProgress = false);
    }
  }

  Future<void> _acceptRequest() async {
    if (_actionInProgress) return;
    setState(() => _actionInProgress = true);

    try {
      final batch = FirebaseFirestore.instance.batch();
      final uid = _userData['uid'];

      batch.set(
        FirebaseFirestore.instance
            .collection('users')
            .doc(widget.currentUserId)
            .collection('friends')
            .doc(uid),
        {'uid': uid, 'since': FieldValue.serverTimestamp()},
      );

      batch.set(
        FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('friends')
            .doc(widget.currentUserId),
        {'uid': widget.currentUserId, 'since': FieldValue.serverTimestamp()},
      );

      batch.delete(
        FirebaseFirestore.instance
            .collection('friendRequests')
            .doc('${uid}_${widget.currentUserId}'),
      );

      await batch.commit();

      if (mounted) {
        setState(() {
          _friendStatus = FriendStatus.friends;
          _actionInProgress = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _actionInProgress = false);
    }
  }

  Future<void> _removeFriend() async {
    if (_actionInProgress) return;
    setState(() => _actionInProgress = true);

    try {
      final batch = FirebaseFirestore.instance.batch();
      final uid = _userData['uid'];

      batch.delete(
        FirebaseFirestore.instance
            .collection('users')
            .doc(widget.currentUserId)
            .collection('friends')
            .doc(uid),
      );

      batch.delete(
        FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('friends')
            .doc(widget.currentUserId),
      );

      await batch.commit();

      if (mounted) {
        setState(() {
          _friendStatus = FriendStatus.none;
          _actionInProgress = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _actionInProgress = false);
    }
  }

  void _showRevokeDialog() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
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
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Do you want to withdraw your friend request?',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        _revokeRequest();
                      },
                      child: const Text(
                        'Revoke',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
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
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to remove $username from your friends?',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        _removeFriend();
                      },
                      child: const Text(
                        'Remove',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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

  void _openChat() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening chat...')),
    );
    // TODO: Navigate to ChatScreen
  }

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
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_friendStatus == FriendStatus.friends)
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert_rounded,
                color: colorScheme.onSurface,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              onSelected: (value) {
                if (value == 'remove') {
                  _showRemoveFriendDialog();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: 'remove',
                  child: Row(
                    children: [
                      Icon(Icons.person_remove_rounded,
                          color: colorScheme.error, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        'Remove Friend',
                        style: TextStyle(color: colorScheme.error),
                      ),
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
            // ── Avatar ──
            CircleAvatar(
              radius: 60,
              backgroundColor: colorScheme.primary.withValues(alpha: 0.15),
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

            // ── Username ──
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

            // ── Action Button ──
            _buildProfileActionButton(theme, colorScheme),

            const SizedBox(height: 32),

            // ── Info Card ──
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _infoTile(
                      Icons.person,
                      'Username',
                      username,
                      theme,
                    ),
                    if (email.isNotEmpty) ...[
                      const Divider(),
                      _infoTile(
                        Icons.email,
                        'Email',
                        email,
                        theme,
                      ),
                    ],
                    const Divider(),
                    _infoTile(
                      Icons.info_outline_rounded,
                      'Status',
                      _friendStatusLabel(),
                      theme,
                    ),
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

  Widget _buildProfileActionButton(ThemeData theme, ColorScheme colorScheme) {
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
      IconData icon,
      String title,
      String value,
      ThemeData theme,
      ) {
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
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  HELPER CLASSES
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _BubbleInfo {
  final Offset offset;
  final double size;
  final Color color;
  final IconData icon;

  _BubbleInfo(this.offset, this.size, this.color, this.icon);
}