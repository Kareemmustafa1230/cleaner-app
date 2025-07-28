// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../helpers/shared_pref_helper.dart';
import '../networking/constants/api_constants.dart';
import '../networking/di/dependency_injection.dart';

class DeviceToken {
  static String? _currentToken;

  /// الحصول على FCM Token
  static Future<String?> getDeviceToken() async {
    try {
      // Check if we already have a token
      if (_currentToken != null) {
        return _currentToken;
      }

      // Get the token from Firebase
      String? deviceToken = await FirebaseMessaging.instance.getToken();

      if (deviceToken != null) {
        _currentToken = deviceToken;
        debugPrint('--------Device Token---------- ' + deviceToken);

        // Save token to local storage
        await getIt<SharedPrefHelper>().saveData(key: ApiKey.fcm, value: deviceToken);

        // Send token to backend using cubit
        await _sendTokenToBackend(deviceToken);

        return deviceToken;
      }

      return null;
    } catch (e) {
      print('❌ Error getting device token: $e');
      return null;
    }
  }

  /// إرسال التوكن للباك إند
  static Future<void> _sendTokenToBackend(String fcmToken) async {
    try {
      // Get the FCM token cubit and update the token
      // يمكنك هنا تنفيذ أي منطق إضافي إذا رغبت
      print('📱 FCM Token ready to be sent to backend if needed');
    } catch (e) {
      print('❌ Error sending token to backend: $e');
    }
  }

  /// تحديث FCM Token
  static Future<void> refreshToken() async {
    try {
      // Delete the old token
      await FirebaseMessaging.instance.deleteToken();

      // Get a new token
      String? newToken = await FirebaseMessaging.instance.getToken();

      if (newToken != null) {
        _currentToken = newToken;
        debugPrint('--------New Device Token---------- ' + newToken);

        // Save new token to local storage
        await getIt<SharedPrefHelper>().saveData(key: ApiKey.fcm, value: newToken);

        // Send new token to backend
        await _sendTokenToBackend(newToken);
      }
    } catch (e) {
      print('❌ Error refreshing token: $e');
    }
  }

  /// الحصول على التوكن المحفوظ
  static Future<String?> getSavedToken() async {
    try {
      return await getIt<SharedPrefHelper>().getData(key: ApiKey.fcm) as String?;
    } catch (e) {
      print('❌ Error getting saved token: $e');
      return null;
    }
  }

  /// حذف التوكن
  static Future<void> deleteToken() async {
    try {
      await FirebaseMessaging.instance.deleteToken();
      await getIt<SharedPrefHelper>().removeData(key: ApiKey.fcm);
      _currentToken = null;
      print('🗑️ FCM Token deleted successfully');
    } catch (e) {
      print('❌ Error deleting token: $e');
    }
  }

  /// إعداد مراقب تحديث التوكن
  static void setupTokenRefreshListener() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print('🔄 FCM Token refreshed: $newToken');
      _currentToken = newToken;
      getIt<SharedPrefHelper>().saveData(key: ApiKey.fcm, value: newToken);
      _sendTokenToBackend(newToken);
    });
  }

  /// الحصول على التوكن الحالي
  static String? get currentToken => _currentToken;
}
