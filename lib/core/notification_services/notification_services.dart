import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;
  static bool _permissionsGranted = false;

  static Future<bool> requestPermissions() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      final localPermission = await Permission.notification.request();

      if (Platform.isIOS) {
        final iosSettings = await _notificationsPlugin
            .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(alert: true, badge: true, sound: true);
        _permissionsGranted = settings.authorizationStatus == AuthorizationStatus.authorized &&
            (iosSettings ?? false);
      } else {
        _permissionsGranted = settings.authorizationStatus == AuthorizationStatus.authorized &&
            localPermission.isGranted;
      }

      return _permissionsGranted;
    } catch (e) {
      print("❌ Permission error: $e");
      return false;
    }
  }

  static Future<void> initialize({required GlobalKey<NavigatorState> navigatorKey}) async {
    if (_isInitialized) return;

    final granted = await requestPermissions();
    if (!granted) return;

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: android, iOS: ios);

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _handleNotificationTap,
    );

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleNotificationNavigation);

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) handleNotificationNavigation(initialMessage);

    _isInitialized = true;
  }

  static void _handleNotificationTap(NotificationResponse response) {
    final payload = response.payload ?? '';
    _navigateBasedOnTitle(payload);
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      _showNotification(
        id: message.hashCode,
        title: notification.title ?? 'تنبيه',
        body: notification.body ?? '',
        payload: notification.title ?? '',
        channelId: 'fcm_channel',
      );
    }
  }

  static void handleNotificationNavigation(RemoteMessage message) {
    final title = message.notification?.title ?? '';
    _navigateBasedOnTitle(title);
  }

  static void _navigateBasedOnTitle(String title) {
    switch (title) {
      case 'تم إضافة رصيد':
       // navigatorKey.currentState?.pushNamed(Routes.wallet);
        break;
      default:
        print("📭 لم يتم التعرف على العنوان: $title");
    }
  }

  static Future<void> _showNotification({
    required int id,
    required String title,
    required String body,
    required String channelId,
    String? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelId,
      'تنبيهات التطبيق',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );
    const iosDetails = DarwinNotificationDetails();
    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _notificationsPlugin.show(id, title, body, details, payload: payload);
  }

  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  static Future<bool> checkPermissionStatus() async {
    final status = await Permission.notification.status;
    final fcmSettings = await FirebaseMessaging.instance.getNotificationSettings();
    _permissionsGranted = status.isGranted &&
        fcmSettings.authorizationStatus == AuthorizationStatus.authorized;
    return _permissionsGranted;
  }

  static bool get isInitialized => _isInitialized;
  static bool get permissionsGranted => _permissionsGranted;
}

