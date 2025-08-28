import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_auth/local_auth.dart';
import '../../../../core/theme/text_style/text_style.dart';
import '../../../../core/language/app_localizations.dart';

class BiometricAuthScreen extends StatefulWidget {
  final VoidCallback onAuthSuccess;
  
  const BiometricAuthScreen({
    super.key,
    required this.onAuthSuccess,
  });

  @override
  State<BiometricAuthScreen> createState() => _BiometricAuthScreenState();
}

class _BiometricAuthScreenState extends State<BiometricAuthScreen> with TickerProviderStateMixin {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isAuthenticating = false;
  bool _isBiometricAvailable = false;
  String _authMessage = 'يرجى المصادقة للدخول إلى التطبيق';
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      final bool canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();
      
      if (mounted) {
        setState(() {
          _isBiometricAvailable = canAuthenticate;
        });
        
        if (canAuthenticate) {
          // طلب المصادقة تلقائياً بعد ثانيتين
          Future.delayed(const Duration(milliseconds: 800), () {
            _authenticateWithBiometrics();
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isBiometricAvailable = false;
          _authMessage = 'البصمة غير متوفرة في هذا الجهاز';
        });
      }
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    if (_isAuthenticating) return;
    
    setState(() {
      _isAuthenticating = true;
      _authMessage = 'جاري المصادقة...';
    });

    try {
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'يرجى المصادقة باستخدام البصمة أو الوجه للدخول إلى التطبيق',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (mounted) {
        if (didAuthenticate) {
          setState(() {
            _authMessage = 'تم المصادقة بنجاح!';
          });
          await Future.delayed(const Duration(milliseconds: 500));
          widget.onAuthSuccess();
        } else {
          setState(() {
            _isAuthenticating = false;
            _authMessage = 'فشلت المصادقة، يرجى المحاولة مرة أخرى';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
          _authMessage = 'حدث خطأ في المصادقة: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withOpacity(0.8),
                theme.colorScheme.secondary,
              ],
            ),
          ),
          child: SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // شعار التطبيق
                    Container(
                      width: 120.w,
                      height: 120.h,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onPrimary.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.onPrimary,
                          width: 3.w,
                        ),
                      ),
                      child: Icon(
                        Icons.security,
                        size: 60.sp,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    SizedBox(height: 40.h),
                    // عنوان الشاشة
                    Text(
                      'مرحباً بك في تطبيق ديار',
                      style: TextStyleApp.font20black00Weight700.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 24.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12.h),
                    // رسالة المصادقة
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Text(
                        _authMessage,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: theme.colorScheme.onPrimary.withOpacity(0.9),
                          fontFamily: 'Cairo',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 60.h),
                    // زر البصمة
                    if (_isBiometricAvailable)
                      Container(
                        width: 80.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onPrimary.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.onPrimary,
                            width: 2.w,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(40.r),
                            onTap: _isAuthenticating ? null : _authenticateWithBiometrics,
                            child: Center(
                              child: _isAuthenticating
                                  ? SizedBox(
                                      height: 30.h,
                                      width: 30.w,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3.w,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          theme.colorScheme.onPrimary,
                                        ),
                                      ),
                                    )
                                  : Icon(
                                      Icons.fingerprint,
                                      color: theme.colorScheme.onPrimary,
                                      size: 40.sp,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: 20.h),
                    // نص إضافي
                    Text(
                      _isBiometricAvailable 
                          ? 'اضغط على البصمة للمصادقة'
                          : 'البصمة غير متوفرة',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: theme.colorScheme.onPrimary.withOpacity(0.7),
                        fontFamily: 'Cairo',
                      ),
                    ),
                    SizedBox(height: 30.h),
                    // زر التخطي
                    TextButton(
                      onPressed: _isAuthenticating ? null : () {
                        widget.onAuthSuccess();
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.r),
                          side: BorderSide(
                            color: theme.colorScheme.onPrimary.withOpacity(0.5),
                            width: 1.w,
                          ),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)?.translate('skip') ?? 'تخطي',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: theme.colorScheme.onPrimary,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
} 