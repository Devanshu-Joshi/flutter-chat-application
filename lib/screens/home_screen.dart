import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/widgets/chat_tile.dart';
import 'package:chat_app/widgets/empty_chat_state.dart';
import 'package:chat_app/widgets/glass_bottom_nav.dart';
import 'package:chat_app/widgets/chat_home_header.dart';
import 'package:chat_app/screens/friends_screen.dart';
import 'package:chat_app/screens/search_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0.03, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey(_currentIndex),
          child: _buildPage(context),
        ),
      ),
      bottomNavigationBar: GlassBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }

  Widget _buildPage(BuildContext context) {
    switch (_currentIndex) {
      case 0:
        return const ChatHomeBody();
      case 1:
        return FriendsScreen();
      case 2:
        return SearchScreen();
      case 3:
        return const ProfileScreen();
      default:
        return const SizedBox();
    }
  }
}

// ─── CHAT HOME BODY ───────────────────────────────────────────────────────────

class ChatHomeBody extends StatefulWidget {
  const ChatHomeBody({super.key});

  @override
  State<ChatHomeBody> createState() => _ChatHomeBodyState();
}

class _ChatHomeBodyState extends State<ChatHomeBody>
    with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;

  String _searchQuery = "";
  List<String> _matchedUserIds = [];
  Timer? _debounce;

  Widget _buildLoadingItem() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.06),
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
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 180,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
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
  }

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

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  /// 🔎 SEARCH USERS BY USERNAME PREFIX
  Future<List<String>> _searchUserIds(String query) async {
    if (query.isEmpty) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('username')
        .startAt([query])
        .endAt([query + '\uf8ff'])
        .limit(10)
        .get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }

  /// 🔎 SEARCH HANDLER WITH DEBOUNCE
  void _onSearchChanged(String? query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 350), () async {
      final text = (query ?? '').toLowerCase();

      if (text.isEmpty) {
        setState(() {
          _searchQuery = "";
          _matchedUserIds = [];
        });
        return;
      }

      final ids = await _searchUserIds(text);

      if (!mounted) return;

      setState(() {
        _searchQuery = text;
        _matchedUserIds = ids;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: ChatHomeHeader(
                currentUser: currentUser,
                chatStream: _getChatStream(currentUser),
                onSearchChanged: _onSearchChanged,
              ),
            ),
          ),

          _buildChatSliver(currentUser),
        ],
      ),
    );
  }

  /// 📩 DEFAULT CHAT STREAM
  Stream<QuerySnapshot>? _getChatStream(User? currentUser) {
    if (currentUser == null) return null;

    return FirebaseFirestore.instance
        .collection('chats')
        .where('participants', arrayContains: currentUser.uid)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  Widget _buildChatSliver(User? currentUser) {
    if (currentUser == null) {
      return const SliverFillRemaining(child: EmptyChatState());
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _getChatStream(currentUser),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildLoadingItem(),
              childCount: 6,
            ),
          );
        }

        if (snapshot.hasError) {
          return const SliverFillRemaining(
            child: Center(child: Text('Something went wrong')),
          );
        }

        final docs = snapshot.data?.docs.where((doc) {
          if (_searchQuery.isEmpty) return true;
          if (_matchedUserIds.isEmpty) return false;

          final participants =
          List<String>.from(doc['participants'] ?? []);

          return participants.any(_matchedUserIds.contains);
        }).toList() ?? [];

        if (docs.isEmpty) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyChatState(),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final chatId = docs[index].id;

            return ChatTile(
              chatId: chatId,
              data: data,
              currentUserId: currentUser.uid,
              index: index,
              onTap: () {
                final participants =
                List<String>.from(data['participants'] ?? []);

                final friendUid = participants.firstWhere(
                      (uid) => uid != currentUser.uid,
                  orElse: () => '',
                );

                if (friendUid.isEmpty) return;

                FirebaseFirestore.instance
                    .collection('users')
                    .doc(friendUid)
                    .get()
                    .then((doc) {
                  if (doc.exists && context.mounted) {
                    final friendData = doc.data() as Map<String, dynamic>;

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          chatId: chatId,
                          friendUid: friendUid,
                          friendUsername:
                          friendData['username'] ?? 'Unknown',
                        ),
                      ),
                    );
                  }
                });
              },
            );
          }, childCount: docs.length),
        );
      },
    );
  }
}

class AnimatedBuilder2 extends StatelessWidget {
  final Animation<double> animation;
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  const AnimatedBuilder2({
    super.key,
    required this.animation,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder3(
      listenable: animation,
      builder: builder,
      child: child,
    );
  }
}

class AnimatedBuilder3 extends AnimatedWidget {
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  const AnimatedBuilder3({
    super.key,
    required super.listenable,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
