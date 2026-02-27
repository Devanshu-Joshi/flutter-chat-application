import 'dart:math' as math;
import 'package:flutter/material.dart';

class EmptyChatState extends StatefulWidget {
  const EmptyChatState({super.key});

  @override
  State<EmptyChatState> createState() => _EmptyChatStateState();
}

class _EmptyChatStateState extends State<EmptyChatState>
    with TickerProviderStateMixin {
  late AnimationController floatingController;
  late AnimationController pulseController;

  @override
  void initState() {
    super.initState();

    floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    floatingController.dispose();
    pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 120),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _illustration(),
          const SizedBox(height: 10),
          _title(),
          const SizedBox(height: 14),
          _subtitle(),
          const SizedBox(height: 36),
          _buttons(),
          const SizedBox(height: 30),
          _tipCard(),
        ],
      ),
    );
  }

  Widget _illustration() {
    return SizedBox(
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: pulseController,
            builder: (_, _) {
              final pulse = 0.3 + pulseController.value * 0.15;
              return Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF7F00FF).withValues(alpha: pulse),
                      const Color(0xFFE100FF).withValues(alpha: pulse * 0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
              );
            },
          ),
          ..._floatingBubbles(),
          AnimatedBuilder(
            animation: floatingController,
            builder: (_, child) {
              final offset = 8.0 * floatingController.value;
              return Transform.translate(
                offset: Offset(0, -offset),
                child: child,
              );
            },
            child: _mainCircle(),
          ),
        ],
      ),
    );
  }

  List<Widget> _floatingBubbles() {
    final bubbles = [
      _BubbleData(
        const Offset(-90, -80),
        40,
        const Color(0xFF7F00FF),
        Icons.chat_bubble,
      ),
      _BubbleData(
        const Offset(85, -60),
        35,
        const Color(0xFFE100FF),
        Icons.favorite,
      ),
      _BubbleData(
        const Offset(-70, 70),
        30,
        const Color(0xFF4ECDC4),
        Icons.emoji_emotions,
      ),
    ];

    return bubbles.map((b) {
      return AnimatedBuilder(
        animation: floatingController,
        builder: (_, _) {
          final float = math.sin(floatingController.value * math.pi) * 6;

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

  Widget _mainCircle() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surfaceContainerHighest,
          ],
        ),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.08),
          width: 2,
        ),
      ),
      child: Icon(
        Icons.forum_rounded,
        color: Theme.of(context).colorScheme.onSurface,
        size: 52,
      ),
    );
  }

  Widget _title() {
    return Text(
      'No Conversations Yet',
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _subtitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Text(
        'Your inbox is waiting for its first message.\nConnect with friends and start chatting!',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buttons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          _primaryButton(Icons.person_add, 'Find Friends'),
          const SizedBox(height: 14),
          _secondaryButton(Icons.group_add, 'Create Group'),
          const SizedBox(height: 14),
          _secondaryButton(Icons.qr_code, 'Scan QR'),
        ],
      ),
    );
  }

  Widget _primaryButton(IconData icon, String text) {
    return Container(
      height: 56,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _secondaryButton(IconData icon, String text) {
    return Container(
      height: 52,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tipCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
      ),
      child: Text(
        "💡 Share your profile link to connect instantly!",
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}

class _BubbleData {
  final Offset offset;
  final double size;
  final Color color;
  final IconData icon;

  _BubbleData(this.offset, this.size, this.color, this.icon);
}
