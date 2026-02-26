import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatHomeHeader extends StatelessWidget {
  final User? currentUser;
  final Stream<QuerySnapshot>? chatStream;

  const ChatHomeHeader({
    super.key,
    required this.currentUser,
    required this.chatStream,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _topRow(),
          const SizedBox(height: 20),
          _searchBar(),
          const SizedBox(height: 16),
          _onlineFriends(),
          const SizedBox(height: 16),
          _messageHeader(),
        ],
      ),
    );
  }

  Widget _topRow() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getGreeting(),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                currentUser?.displayName ?? 'User',
                style: const TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        _circleButton(Icons.notifications_none_rounded),
        const SizedBox(width: 10),
        _circleButton(Icons.edit_square, gradient: true),
      ],
    );
  }

  Widget _circleButton(IconData icon, {bool gradient = false}) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: gradient
            ? const LinearGradient(
                colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
              )
            : null,
        color: gradient ? null : Colors.white.withValues(alpha: 0.08),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget _searchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(Icons.search, color: Colors.white.withValues(alpha: 0.3)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search conversations...',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.25),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _onlineFriends() {
    final names = ['Alex', 'Sarah', 'Mike', 'Emma'];

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: names.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, i) => Column(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.white10,
              child: Text(
                names[i][0],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              names[i],
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _messageHeader() {
    return Row(
      children: [
        const Text(
          'Messages',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: chatStream,
            builder: (_, snapshot) {
              final count = snapshot.data?.docs.length ?? 0;
              return Text(
                '$count',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
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
            style: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
          ),
        ),
      ],
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
