import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/widgets/chat_tile.dart';
import 'package:chat_app/widgets/empty_chat_state.dart';

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
          child: Text("Friends", style: TextStyle(color: Colors.white))),
      const Center(
          child: Text("Search", style: TextStyle(color: Colors.white))),
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
              position: Tween<Offset>(
                begin: const Offset(0.03, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey(_currentIndex),
          child: _pages[_currentIndex],
        ),
      ),
      bottomNavigationBar: _GlassBottomNavBar(
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

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(currentUser),
          Expanded(
            child: _buildChatStream(currentUser),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(User? currentUser) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getGreeting(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.5),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currentUser?.displayName ?? 'User',
                      style: const TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              _buildGlassButton(
                icon: Icons.notifications_none_rounded,
                onTap: () {},
                hasBadge: true,
              ),
              const SizedBox(width: 10),
              _buildGlassButton(
                icon: Icons.edit_square,
                onTap: () {},
                gradient: true,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSearchBar(),
          const SizedBox(height: 16),
          _buildOnlineFriendsSection(),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                'Messages',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _getChatStream(currentUser),
                  builder: (context, snapshot) {
                    final count = snapshot.data?.docs.length ?? 0;
                    return Text(
                      '$count',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.4),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlassButton({
    required IconData icon,
    required VoidCallback onTap,
    bool hasBadge = false,
    bool gradient = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: gradient
              ? const LinearGradient(
            colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: gradient ? null : Colors.white.withOpacity(0.08),
          border: Border.all(
            color: Colors.white.withOpacity(gradient ? 0 : 0.1),
          ),
        ),
        child: Stack(
          children: [
            Center(child: Icon(icon, color: Colors.white, size: 20)),
            if (hasBadge)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF3B6F),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF0A0A1A),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(Icons.search_rounded,
              color: Colors.white.withOpacity(0.3), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search conversations...',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.25),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 6),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
            const Icon(Icons.tune_rounded, color: Colors.white, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildOnlineFriendsSection() {
    return SizedBox(
      height: 85,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildAddStoryButton(),
          const SizedBox(width: 14),
          ...List.generate(
              6,
                  (i) => Padding(
                padding: const EdgeInsets.only(right: 14),
                child: _buildOnlineFriendAvatar(
                  name: [
                    'Alex',
                    'Sarah',
                    'Mike',
                    'Emma',
                    'John',
                    'Lisa'
                  ][i],
                  color: [
                    const Color(0xFFFF6B6B),
                    const Color(0xFF4ECDC4),
                    const Color(0xFFFFE66D),
                    const Color(0xFFA78BFA),
                    const Color(0xFF60A5FA),
                    const Color(0xFFF472B6),
                  ][i],
                  isOnline: i < 4,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildAddStoryButton() {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 1.5,
            ),
            color: Colors.white.withOpacity(0.05),
          ),
          child: const Center(
            child: Icon(Icons.add_rounded, color: Colors.white70, size: 26),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Add',
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withOpacity(0.5),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildOnlineFriendAvatar({
    required String name,
    required Color color,
    required bool isOnline,
  }) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.8),
                    color.withOpacity(0.4),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  name[0],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            if (isOnline)
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: const Color(0xFF34D399),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF0A0A1A),
                      width: 2.5,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withOpacity(0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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

  Widget _buildChatStream(User? currentUser) {
    if (currentUser == null) {
      return const EmptyChatState();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _getChatStream(currentUser),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingShimmer();
        }

        if (snapshot.hasError) {
          return _buildErrorState();
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return const EmptyChatState();
        }

        return _buildChatList(docs, currentUser.uid);
      },
    );
  }

  Widget _buildChatList(
      List<QueryDocumentSnapshot> docs, String currentUserId) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100, top: 0),
      physics: const BouncingScrollPhysics(),
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final data = docs[index].data() as Map<String, dynamic>;
        return ChatTile(
          chatId: docs[index].id,
          data: data,
          currentUserId: currentUserId,
          index: index,
          onTap: () {
            // navigate to chat screen
          },
        );
      },
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
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
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 180,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
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

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded,
              size: 48, color: Colors.redAccent.withOpacity(0.7)),
          const SizedBox(height: 16),
          const Text(
            'Something went wrong',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFloatingBubbles() {
    final bubbles = <_BubbleData>[
      _BubbleData(
          offset: const Offset(-90, -80),
          size: 40,
          color: const Color(0xFF7F00FF),
          icon: Icons.chat_bubble_rounded,
          delay: 0.0),
      _BubbleData(
          offset: const Offset(85, -60),
          size: 35,
          color: const Color(0xFFE100FF),
          icon: Icons.favorite_rounded,
          delay: 0.3),
      _BubbleData(
          offset: const Offset(-70, 70),
          size: 30,
          color: const Color(0xFF4ECDC4),
          icon: Icons.emoji_emotions_rounded,
          delay: 0.6),
      _BubbleData(
          offset: const Offset(100, 50),
          size: 28,
          color: const Color(0xFFFFE66D),
          icon: Icons.star_rounded,
          delay: 0.2),
      _BubbleData(
          offset: const Offset(-110, 10),
          size: 22,
          color: const Color(0xFFFF6B6B),
          icon: Icons.bolt_rounded,
          delay: 0.5),
      _BubbleData(
          offset: const Offset(120, -10),
          size: 24,
          color: const Color(0xFF60A5FA),
          icon: Icons.send_rounded,
          delay: 0.8),
    ];

    return bubbles.map((b) {
      return AnimatedBuilder2(
        animation: _floatingController,
        builder: (context, child) {
          final float = math.sin(
              (_floatingController.value + b.delay) * math.pi) *
              6;
          final rotate = math.sin(
              (_floatingController.value + b.delay) * math.pi) *
              0.1;
          return Transform.translate(
            offset: b.offset + Offset(0, float),
            child: Transform.rotate(
              angle: rotate,
              child: Container(
                width: b.size,
                height: b.size,
                decoration: BoxDecoration(
                  color: b.color.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: b.color.withOpacity(0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: b.color.withOpacity(0.2),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    b.icon,
                    size: b.size * 0.45,
                    color: b.color.withOpacity(0.9),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }).toList();
  }

  Widget _buildMainIllustration() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7F00FF).withOpacity(0.15),
            blurRadius: 40,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: const Color(0xFFE100FF).withOpacity(0.1),
            blurRadius: 60,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF7F00FF).withOpacity(0.15),
                width: 1.5,
              ),
            ),
          ),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: const Icon(
              Icons.forum_rounded,
              size: 52,
              color: Colors.white,
            ),
          ),
          Positioned(
            top: 25,
            right: 28,
            child: AnimatedBuilder2(
              animation: _pulseController,
              builder: (context, child) {
                return Opacity(
                  opacity: 0.5 + _pulseController.value * 0.5,
                  child: const Icon(
                    Icons.auto_awesome,
                    size: 16,
                    color: Color(0xFFFFE66D),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7F00FF).withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white60, size: 18),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF7F00FF).withOpacity(0.08),
            const Color(0xFFE100FF).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF7F00FF).withOpacity(0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFE66D), Color(0xFFFF6B6B)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Text('💡', style: TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pro Tip',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Share your profile link to connect with friends instantly!',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: Colors.white.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning 🌅';
    if (hour < 17) return 'Good Afternoon ☀️';
    if (hour < 21) return 'Good Evening 🌆';
    return 'Good Night 🌙';
  }
}

// ─── FIXED: Custom AnimatedBuilder replacement ───────────────────────────────
// Using a proper name to avoid conflict with Flutter's built-in AnimatedBuilder

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
    required Listenable listenable,
    required this.builder,
    this.child,
  }) : super(listenable: listenable);

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}

// ─── BUBBLE DATA ──────────────────────────────────────────────────────────────

class _BubbleData {
  final Offset offset;
  final double size;
  final Color color;
  final IconData icon;
  final double delay;

  _BubbleData({
    required this.offset,
    required this.size,
    required this.color,
    required this.icon,
    required this.delay,
  });
}

// ─── GLASS BOTTOM NAV BAR ─────────────────────────────────────────────────────

class _GlassBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const _GlassBottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItemData(Icons.chat_bubble_rounded, 'Chats'),
      _NavItemData(Icons.group_rounded, 'Friends'),
      _NavItemData(Icons.search_rounded, 'Search'),
      _NavItemData(Icons.person_rounded, 'Profile'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 62,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C).withOpacity(0.9),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: Colors.white.withOpacity(0.06),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth =
                    constraints.maxWidth / items.length;

                return Stack(
                  children: [
                    AnimatedPositioned(
                      duration:
                      const Duration(milliseconds: 350),
                      curve: Curves.easeInOutCubic,
                      left: currentIndex * itemWidth,
                      top: 0,
                      bottom: 0,
                      child: SizedBox(
                        width: itemWidth,
                        child: Center(
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient:
                              const LinearGradient(
                                colors: [
                                  Color(0xFF7F00FF),
                                  Color(0xFFE100FF),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                      0xFF7F00FF)
                                      .withOpacity(0.3),
                                  blurRadius: 12,
                                  offset:
                                  const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: List.generate(
                          items.length, (index) {
                        final isActive =
                            currentIndex == index;
                        return Expanded(
                          child: GestureDetector(
                            behavior:
                            HitTestBehavior.opaque,
                            onTap: () => onTap(index),
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              children: [
                                AnimatedScale(
                                  duration:
                                  const Duration(
                                      milliseconds:
                                      250),
                                  scale: isActive
                                      ? 1.1
                                      : 1.0,
                                  child: Icon(
                                    items[index].icon,
                                    size: 21,
                                    color: isActive
                                        ? Colors.white
                                        : Colors
                                        .white38,
                                  ),
                                ),
                                if (!isActive) ...[
                                  const SizedBox(
                                      height: 2),
                                  Text(
                                    items[index].label,
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: Colors
                                          .white
                                          .withOpacity(
                                          0.25),
                                      fontWeight:
                                      FontWeight
                                          .w500,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final String label;
  _NavItemData(this.icon, this.label);
}