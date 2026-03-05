// lib/main.dart

import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:chat_app/services/notification_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('[Background] Message received: ${message.messageId}');
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await NotificationService.instance.initialize();
  runApp(const MyApp());
}

class _InheritedMyApp extends InheritedWidget {
  final MyAppState data;
  const _InheritedMyApp({required this.data, required super.child});

  @override
  bool updateShouldNotify(_InheritedMyApp oldWidget) => true;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static MyAppState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedMyApp>()!.data;
  }

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get currentThemeMode => _themeMode;

  @override
  void initState() {
    super.initState();
    _loadTheme();
    ChatService().migrateChats();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme') ?? 'system';
    setState(() {
      switch (theme) {
        case 'light':
          _themeMode = ThemeMode.light;
          break;
        case 'dark':
          _themeMode = ThemeMode.dark;
          break;
        default:
          _themeMode = ThemeMode.system;
      }
    });
  }

  void updateTheme(ThemeMode mode) {
    setState(() => _themeMode = mode);
    _saveTheme(mode);
  }

  Future<void> _saveTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    String theme;
    switch (mode) {
      case ThemeMode.light:
        theme = 'light';
        break;
      case ThemeMode.dark:
        theme = 'dark';
        break;
      default:
        theme = 'system';
    }
    await prefs.setString('theme', theme);
  }

  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    );
    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );

    return _InheritedMyApp(
      data: this,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        scrollBehavior: NoGlowScrollBehavior(),
        debugShowCheckedModeBanner: false,
        title: 'Flutter Chat App',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: _themeMode,
        home: const AuthWrapper(),
      ),
    );
  }
}

// ┌─────────────────────────────────────────────────────────────────────────┐
// │ FIXED: AuthWrapper now properly handles async notification setup        │
// └─────────────────────────────────────────────────────────────────────────┘
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _notificationSetupComplete = false;

  Future<void> _setupNotifications(User user) async {
    // Prevent duplicate setup
    if (_notificationSetupComplete) return;

    try {
      // 1. Save FCM token (this also creates it if missing)
      await NotificationService.instance.saveTokenForUser(user.uid);

      // 2. Listen to token refresh
      NotificationService.instance.listenToTokenRefresh(user.uid);

      // 3. Set up notification tap handlers
      NotificationService.instance.setupNotificationTapHandler(
        navigatorKey: navigatorKey,
        currentUserId: user.uid,
      );

      _notificationSetupComplete = true;
      debugPrint('[AuthWrapper] ✅ Notification setup complete');
    } catch (e) {
      debugPrint('[AuthWrapper] ❌ Notification setup error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user != null) {
          // Set up notifications in background (non-blocking)
          _setupNotifications(user);
          return const HomeScreen();
        }

        // Reset flag on logout
        _notificationSetupComplete = false;
        return LoginScreen();
      },
    );
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context,
      Widget child,
      ScrollableDetails details,
      ) {
    return child;
  }
}