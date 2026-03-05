// lib/services/notification_service.dart

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../screens/chat_screen.dart';

class NotificationService {
  // Singleton pattern
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ⚠️ IMPORTANT: Replace this with your actual Netlify function URL after deployment
  static const String _netlifyFunctionUrl =
      'https://YOUR-SITE-NAME.netlify.app/.netlify/functions/send-notification';

  bool _initialized = false;
  String? _activeChatId;

  // Track current user and stored references
  String? _currentUserId;
  GlobalKey<NavigatorState>? _navigatorKey;

  // Track subscriptions to prevent duplicates
  StreamSubscription? _tokenRefreshSubscription;
  StreamSubscription? _messageOpenedAppSubscription;
  bool _initialMessageChecked = false;

  // ═══════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════

  Future<void> initialize() async {
    if (_initialized) return;

    // Request permission (required on Android 13+)
    await _requestPermission();

    // Set up local notifications for foreground
    await _initializeLocalNotifications();

    // Create notification channel
    await _createNotificationChannel();

    // Listen to foreground messages
    _listenToForegroundMessages();

    _initialized = true;
    debugPrint('[NotificationService] ✅ Initialized');
  }

  // ═══════════════════════════════════════════════════════════════════════
  // PERMISSION
  // ═══════════════════════════════════════════════════════════════════════

  Future<void> _requestPermission() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    debugPrint(
        '[NotificationService] Permission: ${settings.authorizationStatus}');
  }

  // ═══════════════════════════════════════════════════════════════════════
  // LOCAL NOTIFICATIONS SETUP
  // ═══════════════════════════════════════════════════════════════════════

  Future<void> _initializeLocalNotifications() async {
    const androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );
  }

  Future<void> _createNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      'chat_messages',
      'Chat Messages',
      description: 'Notifications for new chat messages',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // ═══════════════════════════════════════════════════════════════════════
  // FCM TOKEN MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════

  /// Get the current device FCM token
  Future<String?> getToken() async {
    try {
      return await _fcm.getToken();
    } catch (e) {
      debugPrint('[NotificationService] ❌ Error getting token: $e');
      return null;
    }
  }

  /// Save FCM token to Firestore for a user
  Future<void> saveTokenForUser(String userId) async {
    // Update current user ID
    _currentUserId = userId;

    final token = await getToken();
    if (token == null) {
      debugPrint('[NotificationService] ⚠️ No token to save');
      return;
    }

    await _firestore.collection('users').doc(userId).set({
      'fcmToken': token,
      'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    debugPrint('[NotificationService] ✅ Token saved for user $userId');
  }

  /// Listen for token refresh and update Firestore
  void listenToTokenRefresh(String userId) {
    // Store userId and prevent duplicate listeners
    _currentUserId = userId;

    // If subscription already exists, don't create another
    if (_tokenRefreshSubscription != null) {
      debugPrint('[NotificationService] Token refresh listener already active');
      return;
    }

    _tokenRefreshSubscription = _fcm.onTokenRefresh.listen((newToken) async {
      // Use stored _currentUserId so it updates if user changes
      if (_currentUserId == null) return;

      debugPrint('[NotificationService] 🔄 Token refreshed');
      await _firestore.collection('users').doc(_currentUserId!).set({
        'fcmToken': newToken,
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });

    debugPrint('[NotificationService] 👂 Token refresh listener started');
  }

  /// Remove FCM token (call on logout)
  Future<void> removeTokenForUser(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'fcmToken': FieldValue.delete(),
      'fcmTokenUpdatedAt': FieldValue.delete(),
    });

    // Clear current user on logout
    _currentUserId = null;

    debugPrint('[NotificationService] 🗑️ Token removed for user $userId');
  }

  // ═══════════════════════════════════════════════════════════════════════
  // FOREGROUND MESSAGE HANDLING
  // ═══════════════════════════════════════════════════════════════════════

  void _listenToForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint(
          '[NotificationService] 📩 Foreground message: ${message.messageId}');

      final notification = message.notification;
      if (notification == null) return;

      // Don't show notification if user is viewing this chat
      final incomingChatId = message.data['chatId'];
      if (incomingChatId != null && incomingChatId == _activeChatId) {
        debugPrint(
            '[NotificationService] 🔇 Suppressed (user is in this chat)');
        return;
      }

      // Show local notification
      _showLocalNotification(
        title: notification.title ?? 'New Message',
        body: notification.body ?? '',
        payload: message.data,
      );
    });
  }

  Future<void> _showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'chat_messages',
      'Chat Messages',
      channelDescription: 'Notifications for new chat messages',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
      playSound: true,
      enableVibration: true,
    );

    const details = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      DateTime.now().microsecondsSinceEpoch.remainder(100000),
      title,
      body,
      details,
      payload: payload != null ? jsonEncode(payload) : null,
    );
  }

  /// Track which chat the user is currently viewing
  void setActiveChat(String? chatId) {
    _activeChatId = chatId;
  }

  // ═══════════════════════════════════════════════════════════════════════
  // NOTIFICATION TAP HANDLING
  // ═══════════════════════════════════════════════════════════════════════

  /// Set up handlers for notification taps
  void setupNotificationTapHandler({
    required GlobalKey<NavigatorState> navigatorKey,
    required String currentUserId,
  }) {
    // Store references and prevent duplicate listeners
    _navigatorKey = navigatorKey;
    _currentUserId = currentUserId;

    // Check initial message only once per app launch
    if (!_initialMessageChecked) {
      _initialMessageChecked = true;

      // App was TERMINATED, user tapped notification to open it
      _fcm.getInitialMessage().then((RemoteMessage? message) {
        if (message != null) {
          debugPrint('[NotificationService] 🚀 Opened from terminated');
          _navigateToChatFromData(message.data);
        }
      });
    }

    // Set up background tap listener only once
    if (_messageOpenedAppSubscription != null) {
      debugPrint(
          '[NotificationService] Message opened listener already active');
      return;
    }

    // App was in BACKGROUND, user tapped notification
    _messageOpenedAppSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          debugPrint('[NotificationService] 🚀 Opened from background');
          _navigateToChatFromData(message.data);
        });

    debugPrint('[NotificationService] 👂 Notification tap handlers set up');
  }

  /// Handler for local notification taps (foreground)
  void _onLocalNotificationTap(NotificationResponse response) {
    if (response.payload == null) return;

    try {
      final data = jsonDecode(response.payload!) as Map<String, dynamic>;
      debugPrint('[NotificationService] 🚀 Local notification tapped');

      // Navigate directly using stored navigatorKey
      _navigateToChatFromData(data);
    } catch (e) {
      debugPrint('[NotificationService] ❌ Error parsing payload: $e');
    }
  }

  /// Navigate to chat screen from notification data
  void _navigateToChatFromData(Map<String, dynamic> data) {
    if (_navigatorKey == null) {
      debugPrint('[NotificationService] ⚠️ Navigator key not set');
      return;
    }

    final chatId = data['chatId'] as String?;
    final senderId = data['senderId'] as String?;
    final senderName = data['senderName'] as String?;

    if (chatId == null || senderId == null) {
      debugPrint('[NotificationService] ⚠️ Missing chatId or senderId');
      return;
    }

    // Small delay to ensure navigation is ready
    Future.delayed(const Duration(milliseconds: 500), () {
      _navigatorKey!.currentState?.push(
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            chatId: chatId,
            friendUid: senderId,
            friendUsername: senderName ?? 'Unknown',
          ),
        ),
      );
    });
  }

  // ═══════════════════════════════════════════════════════════════════════
  // SEND NOTIFICATION VIA NETLIFY
  // ═══════════════════════════════════════════════════════════════════════

  /// Send push notification to a user
  Future<bool> sendNotificationToUser({
    required String receiverId,
    required String senderName,
    required String messageText,
    required String chatId,
    required String senderId,
  }) async {
    try {
      // 1. Get receiver's FCM token from Firestore
      final userDoc =
      await _firestore.collection('users').doc(receiverId).get();

      // ┌─────────────────────────────────────────────────────────────────────┐
      // │ IMPROVED: Better error handling for missing user or token           │
      // └─────────────────────────────────────────────────────────────────────┘
      if (!userDoc.exists) {
        debugPrint('[NotificationService] ⚠️ Receiver not found: $receiverId');
        return false;
      }

      final userData = userDoc.data();
      if (userData == null) {
        debugPrint('[NotificationService] ⚠️ User data is null: $receiverId');
        return false;
      }

      // Check if fcmToken field exists
      if (!userData.containsKey('fcmToken')) {
        debugPrint('[NotificationService] ⚠️ User has no fcmToken field: $receiverId');
        debugPrint('[NotificationService] ℹ️ User may need to log out and log back in');
        return false;
      }

      final fcmToken = userData['fcmToken'] as String?;
      if (fcmToken == null || fcmToken.isEmpty) {
        debugPrint('[NotificationService] ⚠️ No FCM token for: $receiverId');
        debugPrint('[NotificationService] ℹ️ Token is null or empty');
        return false;
      }

      debugPrint('[NotificationService] ✅ Found FCM token for $receiverId');

      // 2. Call Netlify function
      final response = await http.post(
        Uri.parse(_netlifyFunctionUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': fcmToken,
          'title': senderName,
          'body': messageText.length > 100
              ? '${messageText.substring(0, 100)}...'
              : messageText,
          'data': {
            'chatId': chatId,
            'senderId': senderId,
            'senderName': senderName,
            'type': 'chat_message',
          },
        }),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        debugPrint('[NotificationService] ✅ Sent: ${result['success']}');
        return result['success'] == true;
      } else {
        debugPrint(
            '[NotificationService] ❌ Error ${response.statusCode}: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('[NotificationService] ❌ Exception: $e');
      return false;
    }
  }
}