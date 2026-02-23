import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Chat App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String message = "Testing Firebase...";

  @override
  void initState() {
    super.initState();
    testFirebase();
  }

  Future<void> testFirebase() async {
    try {
      await FirebaseFirestore.instance
          .collection('test')
          .add({'message': 'Hello Firebase!', 'time': DateTime.now()});

      setState(() {
        message = "🔥 Firebase Connected Successfully!";
      });
    } catch (e) {
      setState(() {
        message = "❌ Firebase Connection Failed!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Firebase Test")),
      body: Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}