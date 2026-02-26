import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/widgets/chat_tile.dart';
import 'package:chat_app/widgets/empty_chat_state.dart';
import 'package:chat_app/widgets/glass_bottom_nav.dart';
import 'package:chat_app/widgets/chat_home_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const ChatHomeBody(),
      const Center(
        child: Text("Friends", style: TextStyle(color: Colors.white)),
      ),
      const Center(
        child: Text("Search", style: TextStyle(color: Colors.white)),
      ),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1A),
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
          child: _pages[_currentIndex],
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1A),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          /// 🔥 HEADER THAT HIDES ON SCROLL
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: ChatHomeHeader(
                currentUser: currentUser,
                chatStream: _getChatStream(currentUser),
              ),
            ),
          ),

          /// 🔥 CHAT CONTENT
          _buildChatSliver(currentUser),
        ],
      ),
    );
  }

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
            child: Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          );
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyChatState(),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            return ChatTile(
              chatId: docs[index].id,
              data: data,
              currentUserId: currentUser.uid,
              index: index,
              onTap: () {},
            );
          }, childCount: docs.length),
        );
      },
    );
  }

  Widget _buildLoadingItem() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.06),
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
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 180,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
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
