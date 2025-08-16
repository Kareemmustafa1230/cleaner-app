import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricAuthHelper {
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _biometricAvailableKey = 'biometric_available';
  
  final LocalAuthentication _localAuth = LocalAuthentication();
  
  // فحص توفر البصمة
  Future<bool> isBiometricAvailable() async {
    try {
      final bool canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();
      return canAuthenticate;
    } catch (e) {
      return false;
    }
  }
  
  // فحص إذا كانت البصمة مفعلة
  Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricEnabledKey) ?? false;
  }
  
  // تفعيل البصمة
  Future<bool> enableBiometric() async {
    try {
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'يرجى المصادقة لتفعيل البصمة',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      
      if (didAuthenticate) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_biometricEnabledKey, true);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  // إلغاء تفعيل البصمة
  Future<void> disableBiometric() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricEnabledKey, false);
  }
  
  // طلب المصادقة
  Future<bool> authenticate() async {
    try {
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'يرجى المصادقة للدخول إلى التطبيق',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      return didAuthenticate;
    } catch (e) {
      return false;
    }
  }
  
  // الحصول على أنواع البصمة المتوفرة
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }
  
  // حفظ حالة توفر البصمة
  Future<void> saveBiometricAvailability(bool isAvailable) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricAvailableKey, isAvailable);
  }
  
  // الحصول على حالة توفر البصمة المحفوظة
  Future<bool> getBiometricAvailability() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricAvailableKey) ?? false;
  }
} 