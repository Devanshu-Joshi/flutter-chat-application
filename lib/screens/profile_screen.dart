import 'dart:async';
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
  bool _isValidFormat = false;
  bool _isLoading = false;
  String _feedbackMessage = "";

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

      final oldRef =
      FirebaseFirestore.instance.collection('usernames').doc(oldUsername);
      final newRef =
      FirebaseFirestore.instance.collection('usernames').doc(newUsername);
      final userRef =
      FirebaseFirestore.instance.collection('users').doc(user!.uid);

      batch.delete(oldRef);
      batch.set(newRef, {"uid": user!.uid});
      batch.update(userRef, {"username": newUsername});

      await batch.commit();

      _usernameController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username updated successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() {
      _isLoading = false;
      _isAvailable = false;
      _feedbackMessage = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("No user logged in")),
      );
    }

    final creationTime = user!.metadata.creationTime;
    final formattedDate = creationTime != null
        ? DateFormat('dd MMM yyyy, hh:mm a')
        .format(creationTime.toLocal())
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
            return const Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data!;
          final username = userData['username'] ?? "";

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),

                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    username.isNotEmpty
                        ? username[0].toUpperCase()
                        : "?",
                    style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  username,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 30),

                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // 🔥 USERNAME SECTION (Editable)
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: !_isEditingUsername
                              ? _buildUsernameView(username)
                              : _buildUsernameEdit(username),
                        ),

                        const SizedBox(height: 8),
                        const Divider(),

                        // 🔹 EMAIL
                        _modernTile(Icons.email, "Email",
                            user!.email ?? "Not available"),

                        const Divider(),

                        // 🔹 CREATED AT
                        _modernTile(Icons.calendar_today,
                            "Account Created", formattedDate),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _modernTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsernameView(String username) {
    return Column(
      key: const ValueKey("viewMode"),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: .center,
          children: [
            const Icon(Icons.person, color: Colors.blue),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Username",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 16,
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
                constraints: BoxConstraints(),
                iconSize: 18,
                icon: const Icon(Icons.edit, size: 22),
                onPressed: () {
                  setState(() {
                    _isEditingUsername = true;
                    _usernameController.text = username;
                  });
                },
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildUsernameEdit(String username) {
    return Column(
      key: const ValueKey("editMode"),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.person, color: Colors.blue),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Username",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),

                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding:
                      const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                      suffixIcon: _isChecking
                          ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                            width: 16,
                            height: 16,
                            child:
                            CircularProgressIndicator(
                                strokeWidth: 2)),
                      )
                          : _feedbackMessage.isEmpty
                          ? null
                          : Icon(
                        _isAvailable
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: _isAvailable
                            ? Colors.green
                            : Colors.red,
                        size: 18,
                      ),
                    ),
                    onChanged: (value) =>
                        _onUsernameChanged(value, username),
                  ),

                  if (_feedbackMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        _feedbackMessage,
                        style: TextStyle(
                          color: _isAvailable
                              ? Colors.green
                              : Colors.red,
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
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}