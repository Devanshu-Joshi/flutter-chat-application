// lib/main.dart

import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

// ┌─────────────────────────────────────────────────────────────────────────┐
// │ NEW IMPORTS                                                              │
// └─────────────────────────────────────────────────────────────────────────┘
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:chat_app/services/notification_service.dart';

// ┌─────────────────────────────────────────────────────────────────────────┐
// │ NEW: Background message handler (MUST be top-level function)            │
// │ This runs in a separate isolate when app is terminated/background       │
// └─────────────────────────────────────────────────────────────────────────┘
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('[Background] Message received: ${message.messageId}');
  // Android automatically shows the notification - no additional code needed
}

// ┌─────────────────────────────────────────────────────────────────────────┐
// │ NEW: Global navigator key for notification navigation                   │
// └─────────────────────────────────────────────────────────────────────────┘
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ┌───────────────────────────────────────────────────────────────────────┐
  // │ NEW: Register background handler BEFORE runApp                        │
  // └───────────────────────────────────────────────────────────────────────┘
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // ┌───────────────────────────────────────────────────────────────────────┐
  // │ NEW: Initialize notification service                                  │
  // └───────────────────────────────────────────────────────────────────────┘
  await NotificationService.instance.initialize();

  runApp(const MyApp());
}

// EXISTING (unchanged)
class _InheritedMyApp extends InheritedWidget {
  final MyAppState data;

  const _InheritedMyApp({required this.data, required super.child});

  @override
  bool updateShouldNotify(_InheritedMyApp oldWidget) {
    return true;
  }
}

// EXISTING (unchanged)
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static MyAppState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedMyApp>()!.data;
  }

  @override
  State<MyApp> createState() => MyAppState();
}

// EXISTING (unchanged)
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
    setState(() {
      _themeMode = mode;
    });
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
        // ┌─────────────────────────────────────────────────────────────────┐
        // │ NEW: Add navigatorKey for notification navigation               │
        // └─────────────────────────────────────────────────────────────────┘
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
// │ MODIFIED: AuthWrapper now handles notification setup                    │
// └─────────────────────────────────────────────────────────────────────────┘
// In lib/main.dart
// Update AuthWrapper:

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _notificationSetupComplete = false;

  Future<void> _setupNotifications(User user) async {
    if (_notificationSetupComplete) return;

    try {
      // 1. Save token (async)
      await NotificationService.instance.saveTokenForUser(user.uid);

      // 2. Set up token refresh listener (sync)
      NotificationService.instance.listenToTokenRefresh(user.uid);

      // 3. Set up tap handlers (sync)
      NotificationService.instance.setupNotificationTapHandler(
        navigatorKey: navigatorKey,
        currentUserId: user.uid,
      );

      // 4. Ensure token exists (already done in step 1, so this is redundant)
      // await MigrationHelper.ensureFCMTokenExists(); // Can be removed

      _notificationSetupComplete = true;
    } catch (e) {
      debugPrint('[AuthWrapper] Notification setup error: $e');
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
          // Run setup in background (don't block UI)
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

// EXISTING (unchanged)
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