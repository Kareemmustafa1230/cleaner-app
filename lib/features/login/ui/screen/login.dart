import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widget/app_text_form_field.dart';
import '../../../../core/theme/Color/colors.dart';
import '../../../../core/theme/text_style/text_style.dart';
import '../../../../core/language/app_localizations.dart';
import '../../../../core/language/lang_keys.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/router/routers.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _slideController.forward();
    });
    _pulseController.repeat(reverse: true);
    _shimmerController.repeat();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 20.sp),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    context.translate(LangKeys.loginSuccessfully),
                    style: TextStyleApp.font16whiteFFWeight700,
                  ),
                ),
              ],
            ),
            backgroundColor: ColorApp.blue8D,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            margin: EdgeInsets.all(16.w),
            duration: const Duration(seconds: 2),
          ),
        );
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pushReplacementNamed(context, Routes.home);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white, size: 20.sp),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    context.translate(LangKeys.loginError),
                    style: TextStyleApp.font16whiteFFWeight700,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            margin: EdgeInsets.all(16.w),
          ),
        );
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.translate(LangKeys.pleaseEnterEmail);
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    
    if (!emailRegex.hasMatch(value.trim())) {
      return context.translate(LangKeys.pleaseEnterValidEmail);
    }
    
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return context.translate(LangKeys.pleaseEnterPassword);
    }
    
    if (value.length < 6) {
      return context.translate(LangKeys.passwordMinLength);
    }
    
    if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(value)) {
      return context.translate(LangKeys.passwordStrength);
    }
    
    return null;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleRememberMe() {
    setState(() {
      _rememberMe = !_rememberMe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ColorApp.blue8D.withOpacity(0.15),
              ColorApp.whiteFF,
              ColorApp.blueBD.withOpacity(0.08),
              ColorApp.blue8D.withOpacity(0.05),
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
        child: SingleChildScrollView(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 40.h),
                        
                        // Professional Header Section
                        Container(
                          padding: EdgeInsets.all(32.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                ColorApp.whiteFF,
                                ColorApp.whiteFF.withOpacity(0.95),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(28.r),
                            boxShadow: [
                              BoxShadow(
                                color: ColorApp.blue8D.withOpacity(0.08),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Animated Logo Container
                              AnimatedBuilder(
                                animation: _pulseAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _pulseAnimation.value,
                          child: Container(
                                      height: 100.h,
                                      width: 100.w,
                            decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            ColorApp.blue8D,
                                            ColorApp.blueBD,
                                            ColorApp.blue8D.withOpacity(0.8),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                            color: ColorApp.blue8D.withOpacity(0.4),
                                            blurRadius: 25,
                                            offset: const Offset(0, 12),
                                            spreadRadius: 2,
                                          ),
                                          BoxShadow(
                                            color: Colors.white.withOpacity(0.8),
                                            blurRadius: 15,
                                            offset: const Offset(0, -8),
                                ),
                              ],
                            ),
                                      child: Stack(
                                        children: [
                                                                                     // Shimmer Effect
                                           AnimatedBuilder(
                                             animation: _shimmerAnimation,
                                             builder: (context, child) {
                                               return Positioned.fill(
                                                 child: ClipOval(
                                                   child: Container(
                                                     decoration: BoxDecoration(
                                                       gradient: LinearGradient(
                                                         begin: Alignment(_shimmerAnimation.value - 1, 0),
                                                         end: Alignment(_shimmerAnimation.value, 0),
                                                         colors: [
                                                           Colors.transparent,
                                                           Colors.white.withOpacity(0.3),
                                                           Colors.transparent,
                                                         ],
                                                       ),
                                                     ),
                                                   ),
                                                 ),
                                               );
                                             },
                                           ),
                                          // Icon
                                          Center(
                            child: Icon(
                                              Icons.home_rounded,
                                              size: 45.sp,
                              color: ColorApp.whiteFF,
                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              
                              SizedBox(height: 28.h),
                              
                              // Welcome Text with Gradient
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    ColorApp.blue8D,
                                    ColorApp.blueBD,
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(bounds),
                                                                 child: Text(
                                   context.translate(LangKeys.welcomeBack),
                                   style: TextStyleApp.font24black00Weight700.copyWith(
                                     color: Colors.white,
                                     letterSpacing: 0.5,
                                     fontSize: 28.sp,
                                     fontWeight: FontWeight.w800,
                                   ),
                                   textAlign: TextAlign.center,
                                 ),
                              ),
                              
                              SizedBox(height: 12.h),
                              
                              Text(
                                context.translate(LangKeys.loginToAccessAccount),
                                                                 style: TextStyleApp.font16greyC1Weight700.copyWith(
                                   height: 1.4,
                                   letterSpacing: 0.2,
                                   fontWeight: FontWeight.w500,
                                 ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: 40.h),
                        
                        // Professional Form Section
                        Container(
                          padding: EdgeInsets.all(28.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                ColorApp.whiteFF,
                                ColorApp.whiteFF.withOpacity(0.98),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(28.r),
                            boxShadow: [
                              BoxShadow(
                                color: ColorApp.blue8D.withOpacity(0.06),
                                blurRadius: 25,
                                offset: const Offset(0, 12),
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Email Field with Enhanced Styling
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18.r),
                                  gradient: LinearGradient(
                                    colors: [
                                      ColorApp.whiteFF,
                                      ColorApp.greyD9.withOpacity(0.1),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border: Border.all(
                                    color: ColorApp.greyD9.withOpacity(0.3),
                                    width: 1.5.w,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: ColorApp.blue8D.withOpacity(0.03),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                                                     style: TextStyleApp.font16black00Weight700.copyWith(
                                     letterSpacing: 0.2,
                                     fontWeight: FontWeight.w600,
                                   ),
                                 decoration: InputDecoration(
                                   hintText: context.translate(LangKeys.email),
                                   hintStyle: TextStyleApp.font16greyC1Weight700.copyWith(
                                     letterSpacing: 0.2,
                                     fontWeight: FontWeight.w500,
                                   ),
                                    prefixIcon: Container(
                                      margin: EdgeInsets.all(12.w),
                                      padding: EdgeInsets.all(8.w),
                                      decoration: BoxDecoration(
                                        color: ColorApp.blue8D.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      child: Icon(
                                        Icons.email_rounded,
                                        color: ColorApp.blue8D,
                                        size: 20.sp,
                                      ),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 18.h,
                          ),
                                  ),
                                  validator: _validateEmail,
                                ),
                              ),
                              
                              SizedBox(height: 24.h),
                              
                              // Password Field with Enhanced Styling
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18.r),
                                  gradient: LinearGradient(
                                    colors: [
                                      ColorApp.whiteFF,
                                      ColorApp.greyD9.withOpacity(0.1),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border: Border.all(
                                    color: ColorApp.greyD9.withOpacity(0.3),
                                    width: 1.5.w,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: ColorApp.blue8D.withOpacity(0.03),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: TextFormField(
                          controller: _passwordController,
                                  obscureText: !_isPasswordVisible,
                                  keyboardType: TextInputType.visiblePassword,
                                                                     style: TextStyleApp.font16black00Weight700.copyWith(
                                     letterSpacing: 0.2,
                                     fontWeight: FontWeight.w600,
                                   ),
                                 decoration: InputDecoration(
                                   hintText: context.translate(LangKeys.password),
                                   hintStyle: TextStyleApp.font16greyC1Weight700.copyWith(
                                     letterSpacing: 0.2,
                                     fontWeight: FontWeight.w500,
                                   ),
                                    prefixIcon: Container(
                                      margin: EdgeInsets.all(12.w),
                                      padding: EdgeInsets.all(8.w),
                                      decoration: BoxDecoration(
                                        color: ColorApp.blue8D.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      child: Icon(
                                        Icons.lock_rounded,
                                        color: ColorApp.blue8D,
                            size: 20.sp,
                          ),
                                    ),
                                    suffixIcon: Container(
                                      margin: EdgeInsets.all(12.w),
                                      child: IconButton(
                            onPressed: _togglePasswordVisibility,
                                        icon: Container(
                                          padding: EdgeInsets.all(6.w),
                                          decoration: BoxDecoration(
                                            color: ColorApp.greyC1.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(10.r),
                                          ),
                                          child: Icon(
                                            _isPasswordVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                              color: ColorApp.greyC1,
                                            size: 18.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 18.h,
                          ),
                                  ),
                                  validator: _validatePassword,
                                ),
                              ),
                              
                              SizedBox(height: 20.h),
                              
                              // Remember Me with Enhanced Styling
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: ColorApp.blue8D.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                          children: [
                                    Transform.scale(
                                      scale: 0.9,
                                      child: Checkbox(
                                  value: _rememberMe,
                                  onChanged: (value) => _toggleRememberMe(),
                                  activeColor: ColorApp.blue8D,
                                  shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6.r),
                                        ),
                                        side: BorderSide(
                                          color: ColorApp.blue8D.withOpacity(0.3),
                                          width: 1.5.w,
                                        ),
                                  ),
                                ),
                                Text(
                                      context.translate(LangKeys.rememberMe),
                                      style: TextStyleApp.font15greyC1Weight600.copyWith(
                                        color: ColorApp.blue8D.withOpacity(0.8),
                                        letterSpacing: 0.2,
                                      ),
                                ),
                              ],
                            ),
                              ),
                              
                              SizedBox(height: 32.h),
                              
                              // Professional Login Button
                        Container(
                                width: double.infinity,
                                height: 60.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                    colors: [
                                      ColorApp.blue8D,
                                      ColorApp.blueBD,
                                      ColorApp.blue8D.withOpacity(0.9),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(18.r),
                            boxShadow: [
                              BoxShadow(
                                      color: ColorApp.blue8D.withOpacity(0.4),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                      spreadRadius: 2,
                                    ),
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.8),
                                blurRadius: 15,
                                      offset: const Offset(0, -8),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                                    borderRadius: BorderRadius.circular(18.r),
                              onTap: _isLoading ? null : _handleLogin,
                              child: Center(
                                child: _isLoading
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                                  height: 22.h,
                                                  width: 22.w,
                                            child: CircularProgressIndicator(
                                                    strokeWidth: 2.5.w,
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                ColorApp.whiteFF,
                                              ),
                                            ),
                                          ),
                                                SizedBox(width: 16.w),
                                          Text(
                                                    context.translate(LangKeys.loggingIn),
                                                    style: TextStyleApp.font16whiteFFWeight700.copyWith(
                                                      letterSpacing: 0.5,
                                                      fontSize: 17.sp,
                                                    ),
                                          ),
                                        ],
                                      )
                                          : Row(
                                              mainAxisSize: MainAxisSize.min,
                          children: [
                                                Icon(
                                                  Icons.login_rounded,
                                                  color: ColorApp.whiteFF,
                                                  size: 22.sp,
                                                ),
                                                SizedBox(width: 12.w),
                                                Text(
                                                   context.translate(LangKeys.login),
                                                   style: TextStyleApp.font16whiteFFWeight700.copyWith(
                                                     letterSpacing: 0.5,
                                                     fontSize: 17.sp,
                              ),
                            ),
                          ],
                        ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
