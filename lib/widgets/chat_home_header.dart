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
          _topRow(context),
          const SizedBox(height: 20),
          _searchBar(context),
          const SizedBox(height: 16),
          _onlineFriends(context),
          const SizedBox(height: 16),
          _messageHeader(context),
        ],
      ),
    );
  }

  Widget _topRow(BuildContext context) {
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
                  color: Theme.of(context)
    .colorScheme
    .onSurface
    .withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                currentUser?.displayName ?? 'User',
                style: TextStyle(
                  fontSize: 26,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        _circleButton(context, Icons.notifications_none_rounded),
        const SizedBox(width: 10),
        _circleButton(context, Icons.edit_square, gradient: true),
      ],
    );
  }

  Widget _circleButton(
  BuildContext context,
  IconData icon,
  {bool gradient = false}
) {
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
        color: gradient
    ? null
    : Theme.of(context)
        .colorScheme
        .onSurface
        .withValues(alpha: 0.08),
      ),
      child: Icon(
  icon,
  color: Theme.of(context).colorScheme.onSurface,
),
    );
  }

  Widget _searchBar(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Theme.of(context)
    .colorScheme
    .onSurface
    .withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(
  Icons.search,
  color: Theme.of(context)
      .colorScheme
      .onSurface
      .withValues(alpha: 0.3),
),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: TextStyle(
  color: Theme.of(context).colorScheme.onSurface,
),
              decoration: InputDecoration(
                hintText: 'Search conversations...',
                hintStyle: TextStyle(
                  color: Theme.of(context)
    .colorScheme
    .onSurface
    .withValues(alpha: 0.25),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _onlineFriends(BuildContext context) {
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
              backgroundColor: Theme.of(context)
    .colorScheme
    .onSurface
    .withValues(alpha: 0.1),
              child: Text(
                names[i][0],
                style: TextStyle(
  color: Theme.of(context).colorScheme.onSurface,
),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              names[i],
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context)
    .colorScheme
    .onSurface
    .withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _messageHeader(BuildContext context) {
    return Row(
      children: [
        Text(
          'Messages',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
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
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onPrimary,
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
            style: TextStyle(
  color: Theme.of(context)
      .colorScheme
      .onSurface
      .withValues(alpha: 0.4),
),
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
