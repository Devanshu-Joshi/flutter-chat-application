import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    Center(child: Text("Home")),
    Center(child: Text("Friends")),
    Center(child: Text("Search")),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // important for glass effect
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: KeyedSubtree(
          key: ValueKey(_currentIndex),
          child: _pages[_currentIndex],
        ),
      ),
      bottomNavigationBar: _GlassBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

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
      Icons.home_rounded,
      Icons.group_rounded,
      Icons.search_rounded,
      Icons.person_rounded,
    ];

    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = 20.0;
    final itemWidth = (width - horizontalPadding * 2) / items.length;

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 20, vertical: 12), // 🔥 reduced padding
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            height: 56, // 🔥 reduced height (sleek)
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 15,
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = constraints.maxWidth / items.length;

                return Stack(
                  children: [
                    // 🔥 Moving Round Indicator (Perfectly Centered)
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOutCubic,
                      left: currentIndex * itemWidth,
                      top: 0,
                      bottom: 0,
                      child: SizedBox(
                        width: itemWidth,
                        child: Center(
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF7F00FF),
                                  Color(0xFFE100FF),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 🔥 Icons Row
                    Row(
                      children: List.generate(items.length, (index) {
                        final isActive = currentIndex == index;

                        return Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(40),
                            onTap: () => onTap(index),
                            child: Center(
                              child: AnimatedScale(
                                duration: const Duration(milliseconds: 250),
                                scale: isActive ? 1.15 : 1.0,
                                child: Icon(
                                  items[index],
                                  size: 22,
                                  color: isActive
                                      ? Colors.white
                                      : Colors.white54,
                                ),
                              ),
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

class _NavItem {
  final IconData icon;
  final String label;

  _NavItem(this.icon, this.label);
}