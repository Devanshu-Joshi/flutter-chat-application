import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> register() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        throw FirebaseAuthException(
          code: "empty-fields",
          message: "All fields are required.",
        );
      }

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;

      // 🔥 Generate Safe & Unique Username
      String username = await generateUniqueUsername(email);

      WriteBatch batch = FirebaseFirestore.instance.batch();

      DocumentReference userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid);

      DocumentReference usernameRef = FirebaseFirestore.instance
          .collection('usernames')
          .doc(username);

      batch.set(userRef, {
        'uid': uid,
        'email': email,
        'username': username,
        'createdAt': FieldValue.serverTimestamp(),
      });

      batch.set(usernameRef, {'uid': uid});

      await batch.commit();

      if (!mounted) return;
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message = "Registration failed";

      if (e.code == 'email-already-in-use') {
        message = "This email is already registered.";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email format.";
      } else if (e.code == 'weak-password') {
        message = "Password should be at least 6 characters.";
      } else if (e.code == 'empty-fields') {
        message = "All fields are required.";
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Something went wrong")));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // 🔥 Generate Unique Username
  Future<String> generateUniqueUsername(String email) async {
    String baseUsername = email.split('@')[0].toLowerCase();

    // Allow only a-z, 0-9, . and %
    baseUsername = baseUsername.replaceAll(RegExp(r'[^a-z0-9.%]'), '');

    // Ensure minimum 6 characters
    if (baseUsername.length < 6) {
      baseUsername = baseUsername.padRight(6, '0');
    }

    String username = baseUsername;
    int counter = 1;

    while (true) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('usernames')
          .doc(username)
          .get();

      if (!doc.exists) {
        return username;
      }

      username = "$baseUsername$counter";
      counter++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : register,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
