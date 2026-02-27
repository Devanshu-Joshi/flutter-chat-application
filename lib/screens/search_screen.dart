// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// FILE: lib/screens/search_screen.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:async';
import 'dart:math' as math;
import 'package:chat_app/widgets/search_result_tile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/friend_service.dart';
import 'user_profile_view.dart';
import 'friend_requests_screen.dart';

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
  Timer? _debounceTimer;

  late AnimationController _floatingController;
  late AnimationController _pulseController;

  final _currentUser = FirebaseAuth.instance.currentUser;
  final _friendService = FriendService();

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
    _debounceTimer?.cancel();
    super.dispose();
  }

  // ─── DEBOUNCED SEARCH ──────────────────────────────────────────────────
  void _onSearchChanged(String value) {
    setState(() {}); // for suffix icon visibility
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      _performSearch(value);
    });
  }

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
          })
          .toList();

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

  // ─── RECENTLY VIEWED ──────────────────────────────────────────────────
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
    if (_currentUser == null) return const Stream.empty();
    return FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser!.uid)
        .collection('recentlyViewed')
        .orderBy('viewedAt', descending: true)
        .limit(10)
        .snapshots();
  }

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

  // ─── BUILD ─────────────────────────────────────────────────────────────
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
            _buildSearchHeader(theme, colorScheme),
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

  // ─── SEARCH HEADER ────────────────────────────────────────────────────
  Widget _buildSearchHeader(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Search',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                ),
              ),
              // Friend Requests badge button
              _buildRequestsBadge(colorScheme),
            ],
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
                          _debounceTimer?.cancel();
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
              onChanged: _onSearchChanged,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ─── REQUESTS BADGE ───────────────────────────────────────────────────
  Widget _buildRequestsBadge(ColorScheme colorScheme) {
    if (_currentUser == null) return const SizedBox.shrink();

    return StreamBuilder<int>(
      stream: _friendService.incomingRequestCountStream(_currentUser!.uid),
      builder: (context, snapshot) {
        final count = snapshot.data ?? 0;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: Icon(
                Icons.person_add_rounded,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        FriendRequestsScreen(currentUserId: _currentUser!.uid),
                  ),
                );
              },
            ),
            if (count > 0)
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.error,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      count > 99 ? '99+' : '$count',
                      style: TextStyle(
                        color: colorScheme.onError,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  // ─── LOADING STATE ────────────────────────────────────────────────────
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
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.06,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 80,
                      height: 10,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.04,
                        ),
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

  // ─── SEARCH RESULTS ───────────────────────────────────────────────────
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
        return SearchResultTile(
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

  // ─── DEFAULT STATE ────────────────────────────────────────────────────
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
                  return SearchResultTile(
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

  // ─── EMPTY SEARCH STATE ───────────────────────────────────────────────
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
              onTap: () => _searchFocusNode.requestFocus(),
              child: Container(
                height: 56,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme.primary, colorScheme.secondary],
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
                    Icon(Icons.search_rounded, color: colorScheme.onPrimary),
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
          ..._buildFloatingBubbles(colorScheme),
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
        const Offset(-80, -70),
        38,
        colorScheme.primary,
        Icons.search,
      ),
      _BubbleInfo(
        const Offset(75, -50),
        33,
        colorScheme.secondary,
        Icons.person_add,
      ),
      _BubbleInfo(
        const Offset(-60, 60),
        28,
        colorScheme.tertiary,
        Icons.chat_bubble,
      ),
    ];
    return bubbles.map((b) {
      return AnimatedBuilder(
        animation: _floatingController,
        builder: (_, __) {
          final float = math.sin(_floatingController.value * math.pi) * 6;
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

class _BubbleInfo {
  final Offset offset;
  final double size;
  final Color color;
  final IconData icon;
  _BubbleInfo(this.offset, this.size, this.color, this.icon);
}
