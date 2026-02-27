import 'dart:async';
import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  bool _isEditingUsername = false;

  Timer? _debounce;
  bool _isChecking = false;
  bool _isAvailable = false;
  bool _isLoading = false;
  String _feedbackMessage = "";
  ThemeMode _selectedThemeMode = ThemeMode.system;

  final user = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    _debounce?.cancel();
    _usernameController.dispose();
    super.dispose();
  }

  // ✅ Username Format Validation
  bool _validateUsernameFormat(String username) {
    final regex = RegExp(r'^[a-zA-Z0-9._]+$');
    return regex.hasMatch(username);
  }

  // ✅ Debounce Username Check
  void _onUsernameChanged(String value, String currentUsername) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 600), () async {
      final username = value.trim().toLowerCase();

      // 🔹 1. Minimum length check
      if (username.length < 6) {
        setState(() {
          _feedbackMessage = "Username must be at least 6 characters";
          _isAvailable = false;
          _isChecking = false;
        });
        return;
      }

      // 🔹 2. Format validation
      if (!_validateUsernameFormat(username)) {
        setState(() {
          _feedbackMessage =
              "Only letters, numbers, . (Dot) and _ (Underscore) allowed.";
          _isAvailable = false;
          _isChecking = false;
        });
        return;
      }

      // 🔹 3. Same as current username (CHECK FIRST)
      if (username == currentUsername) {
        setState(() {
          _feedbackMessage = "This is already your current username";
          _isAvailable = false;
          _isChecking = false;
        });
        return;
      }

      // 🔹 4. Now check Firestore
      setState(() {
        _isChecking = true;
        _feedbackMessage = "";
      });

      final doc = await FirebaseFirestore.instance
          .collection('usernames')
          .doc(username)
          .get();

      if (!mounted) return;

      if (!doc.exists) {
        setState(() {
          _feedbackMessage = "Username available for use";
          _isAvailable = true;
          _isChecking = false;
        });
      } else {
        setState(() {
          _feedbackMessage = "Username already exists";
          _isAvailable = false;
          _isChecking = false;
        });
      }
    });
  }

  // ✅ Final Username Change
  Future<void> _changeUsername(String oldUsername) async {
    final newUsername = _usernameController.text.trim().toLowerCase();

    if (newUsername == oldUsername) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You are already using this username")),
      );
      return;
    }

    if (!_isAvailable) return;

    setState(() => _isLoading = true);

    try {
      final batch = FirebaseFirestore.instance.batch();

      final oldRef = FirebaseFirestore.instance
          .collection('usernames')
          .doc(oldUsername);
      final newRef = FirebaseFirestore.instance
          .collection('usernames')
          .doc(newUsername);
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid);

      batch.delete(oldRef);
      batch.set(newRef, {"uid": user!.uid});
      batch.update(userRef, {"username": newUsername});

      await batch.commit();

      if (!mounted) return;

      _usernameController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username updated successfully")),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _isAvailable = false;
      _feedbackMessage = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text("No user logged in", style: textTheme.bodyLarge),
        ),
      );
    }

    final creationTime = user!.metadata.creationTime;
    final formattedDate = creationTime != null
        ? DateFormat('dd MMM yyyy, hh:mm a').format(creationTime.toLocal())
        : "Unknown";

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            );
          }

          final userData = snapshot.data!;
          final username = userData['username'] ?? "";

          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: colorScheme.primary.withValues(
                          alpha: 0.15,
                        ),
                        child: Text(
                          username.isNotEmpty ? username[0].toUpperCase() : "?",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(username, style: textTheme.headlineSmall),
                      ),
                      const SizedBox(height: 30),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: !_isEditingUsername
                                    ? _buildUsernameView(username, theme)
                                    : _buildUsernameEdit(username, theme),
                              ),
                              const SizedBox(height: 8),
                              const Divider(),
                              _modernTile(
                                Icons.email,
                                "Email",
                                user!.email ?? "Not available",
                                theme,
                              ),
                              const Divider(),
                              _modernTile(
                                Icons.calendar_today,
                                "Account Created",
                                formattedDate,
                                theme,
                              ),
                              const Divider(),
                              _buildThemeTile(theme),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildLogoutButton(theme),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildThemeTile(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.palette, color: theme.colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Theme", style: theme.textTheme.bodySmall),
                const SizedBox(height: 4),
                DropdownButton<ThemeMode>(
                  value: _selectedThemeMode,
                  underline: const SizedBox(),
                  isDense: true,
                  items: const [
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text("Light"),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text("Dark"),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text("Device Theme"),
                    ),
                  ],
                  onChanged: (ThemeMode? mode) {
                    if (mode == null) return;
                    setState(() {
                      _selectedThemeMode = mode;
                    });
                    MyApp.of(context).updateTheme(mode);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _modernTile(
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

  Widget _buildUsernameView(String username, ThemeData theme) {
    return Column(
      key: const ValueKey("viewMode"),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.person, color: theme.colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Username", style: theme.textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text(
                    username,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, 8),
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                iconSize: 18,
                icon: const Icon(Icons.edit, size: 22),
                onPressed: () {
                  setState(() {
                    _isEditingUsername = true;
                    _usernameController.text = username;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUsernameEdit(String username, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    return Column(
      key: const ValueKey("editMode"),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.person, color: colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Username", style: theme.textTheme.bodySmall),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: _isChecking
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : _feedbackMessage.isEmpty
                          ? null
                          : Icon(
                              _isAvailable ? Icons.check_circle : Icons.cancel,
                              color: _isAvailable
                                  ? colorScheme.primary
                                  : colorScheme.error,
                              size: 18,
                            ),
                    ),
                    onChanged: (value) => _onUsernameChanged(value, username),
                  ),
                  if (_feedbackMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        _feedbackMessage,
                        style: TextStyle(
                          color: _isAvailable
                              ? colorScheme.primary
                              : colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      TextButton(
                        onPressed: (_isAvailable && !_isLoading)
                            ? () async {
                                await _changeUsername(username);
                                setState(() {
                                  _isEditingUsername = false;
                                });
                              }
                            : null,
                        child: const Text("Save"),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isEditingUsername = false;
                            _feedbackMessage = "";
                            _isAvailable = false;
                            _usernameController.clear();
                          });
                        },
                        child: const Text("Cancel"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLogoutButton(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    return GestureDetector(
      onTap: _showLogoutDialog,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            colors: [
              colorScheme.error,
              colorScheme.error.withValues(alpha: 0.8),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.error.withValues(alpha: 0.5),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: colorScheme.onError),
            const SizedBox(width: 10),
            Text(
              "Logout",
              style: TextStyle(
                color: colorScheme.onError,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning_rounded, color: colorScheme.error, size: 50),
                const SizedBox(height: 16),
                Text(
                  "Do you really want to logout?",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
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
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
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
                          elevation: 8,
                        ),
                        onPressed: _logout,
                        child: const Text(
                          "Logout",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.of(context).pop(); // close dialog
  }
}
