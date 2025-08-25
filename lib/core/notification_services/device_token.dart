// // ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import '../helpers/shared_pref_helper.dart';
// import '../networking/constants/api_constants.dart';
// import '../networking/di/dependency_injection.dart';
//
// class DeviceToken {
//   static String? _currentToken;
//
//   /// الحصول على FCM Token
//   static Future<String?> getDeviceToken() async {
//     try {
//       // Check if we already have a token
//       if (_currentToken != null) {
//         return _currentToken;
//       }
//
//       // Get the token from Firebase
//       String? deviceToken = await FirebaseMessaging.instance.getToken();
//
//       if (deviceToken != null) {
//         _currentToken = deviceToken;
//         debugPrint('--------Device Token---------- ' + deviceToken);
//
//         // Save token to local storage
//         await getIt<SharedPrefHelper>().saveData(key: ApiKey.fcm, value: deviceToken);
//
//         // Send token to backend using cubit
//         await _sendTokenToBackend(deviceToken);
//
//         return deviceToken;
//       }
//
//       return null;
//     } catch (e) {
//       print('❌ Error getting device token: $e');
//       return null;
//     }
//   }
//
//   /// إرسال التوكن للباك إند
//   static Future<void> _sendTokenToBackend(String fcmToken) async {
//     try {
//       // Get the FCM token cubit and update the token
//       // يمكنك هنا تنفيذ أي منطق إضافي إذا رغبت
//       print('📱 FCM Token ready to be sent to backend if needed');
//     } catch (e) {
//       print('❌ Error sending token to backend: $e');
//     }
//   }
//
//   /// تحديث FCM Token
//   static Future<void> refreshToken() async {
//     try {
//       // Delete the old token
//       await FirebaseMessaging.instance.deleteToken();
//
//       // Get a new token
//       String? newToken = await FirebaseMessaging.instance.getToken();
//
//       if (newToken != null) {
//         _currentToken = newToken;
//         debugPrint('--------New Device Token---------- ' + newToken);
//
//         // Save new token to local storage
//         await getIt<SharedPrefHelper>().saveData(key: ApiKey.fcm, value: newToken);
//
//         // Send new token to backend
//         await _sendTokenToBackend(newToken);
//       }
//     } catch (e) {
//       print('❌ Error refreshing token: $e');
//     }
//   }
//
//   /// الحصول على التوكن المحفوظ
//   static Future<String?> getSavedToken() async {
//     try {
//       return await getIt<SharedPrefHelper>().getData(key: ApiKey.fcm) as String?;
//     } catch (e) {
//       print('❌ Error getting saved token: $e');
//       return null;
//     }
//   }
//
//   /// حذف التوكن
//   static Future<void> deleteToken() async {
//     try {
//       await FirebaseMessaging.instance.deleteToken();
//       await getIt<SharedPrefHelper>().removeData(key: ApiKey.fcm);
//       _currentToken = null;
//       print('🗑️ FCM Token deleted successfully');
//     } catch (e) {
//       print('❌ Error deleting token: $e');
//     }
//   }
//
//   /// إعداد مراقب تحديث التوكن
//   static void setupTokenRefreshListener() {
//     FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
//       print('🔄 FCM Token refreshed: $newToken');
//       _currentToken = newToken;
//       getIt<SharedPrefHelper>().saveData(key: ApiKey.fcm, value: newToken);
//       _sendTokenToBackend(newToken);
//     });
//   }
//
//   /// الحصول على التوكن الحالي
//   static String? get currentToken => _currentToken;
// }
// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print

import 'dart:io';
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

      // For iOS, ensure APNs token is available first
      if (Platform.isIOS) {
        await _ensureAPNsTokenIsAvailable();
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

      // If it's an APNs token error, try to handle it
      if (e.toString().contains('apns-token-not-set')) {
        return await _handleAPNsTokenError();
      }

      return null;
    }
  }

  /// التأكد من توفر APNs token على iOS
  static Future<void> _ensureAPNsTokenIsAvailable() async {
    if (!Platform.isIOS) return;

    try {
      // Wait for APNs token to be available
      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();

      if (apnsToken == null) {
        // Wait a bit and try again
        await Future.delayed(const Duration(seconds: 2));
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();

        if (apnsToken == null) {
          print('⚠️ APNs token is still not available, FCM token generation might fail');
        } else {
          print('✅ APNs token is now available');
        }
      } else {
        print('✅ APNs token is available');
      }
    } catch (e) {
      print('❌ Error checking APNs token: $e');
    }
  }

  /// التعامل مع خطأ APNs token
  static Future<String?> _handleAPNsTokenError() async {
    if (!Platform.isIOS) return null;

    try {
      print('🔄 Handling APNs token error, retrying...');

      // Wait a bit longer for APNs token
      await Future.delayed(const Duration(seconds: 3));

      // Try to get APNs token again
      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken != null) {
        print('✅ APNs token is now available, retrying FCM token');

        // Now try to get FCM token again
        String? deviceToken = await FirebaseMessaging.instance.getToken();
        if (deviceToken != null) {
          _currentToken = deviceToken;
          debugPrint('--------Device Token (Retry)---------- ' + deviceToken);

          // Save token to local storage
          await getIt<SharedPrefHelper>().saveData(key: ApiKey.fcm, value: deviceToken);

          // Send token to backend
          await _sendTokenToBackend(deviceToken);

          return deviceToken;
        }
      }

      print('⚠️ Could not get FCM token even after retry');
      return null;
    } catch (e) {
      print('❌ Error in retry attempt: $e');
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

      // For iOS, ensure APNs token is available
      if (Platform.isIOS) {
        await _ensureAPNsTokenIsAvailable();
      }

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

  /// محاولة الحصول على التوكن مع تأخير (للاستخدام في main)
  static Future<String?> getDeviceTokenWithDelay({int delaySeconds = 2}) async {
    // Wait a bit after app initialization
    await Future.delayed(Duration(seconds: delaySeconds));
    return await getDeviceToken();
  }

  /// الحصول على التوكن الحالي
  static String? get currentToken => _currentToken;
}