import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/Color/colors.dart';
import '../../../../core/language/lang_keys.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/router/routers.dart';
import '../../../../core/widget/showSuccesSnackBar.dart';
import '../../../../core/widget/showErrorSnackBar.dart';
import '../../../../core/networking/di/dependency_injection.dart';
import '../../logic/cubit/login_cubit.dart';
import '../../logic/state/login_state.dart';
import '../widget/login_header_widget.dart';
import '../widget/login_form_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  bool _isPasswordVisible = false;
  bool _isEmailMode = true; // للتبديل بين البريد الإلكتروني ورقم الهاتف
  
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
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _toggleEmailPhoneMode(LoginCubit loginCubit) {
    setState(() {
      _isEmailMode = !_isEmailMode;
      // مسح الحقول عند التبديل
      if (_isEmailMode) {
        loginCubit.mobileController.clear();
      } else {
        loginCubit.emailController.clear();
      }
    });
  }

  void _togglePasswordVisibility() {
        setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
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

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.translate(LangKeys.pleaseEnterPhone);
    }

    // التحقق من صحة رقم الهاتف (يمكن تعديله حسب البلد)
    final phoneRegex = RegExp(r'^[0-9]{10,15}$');

    if (!phoneRegex.hasMatch(value.trim())) {
      return context.translate(LangKeys.pleaseEnterValidPhone);
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return context.translate(LangKeys.pleaseEnterPassword);
    }
    
    if (value.length < 8) {
      return context.translate(LangKeys.passwordMinLength);
    }
    
    return null;
  }

  void _handleLoginState(LoginState state) {
    state.whenOrNull(
      success: (message) {
        print('🎯 UI Success Handler: $message');
        showSuccesSnackBar(context: context, title: message);
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            context.pushNamedAndRemoveUntil(Routes.home, predicate: (Route<dynamic> route)=> false);
          }
        });
      },
      error: (error) {
        print('🎯 UI Error Handler: $error');
        showErrorSnackBar(context: context, title: error);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginCubit>(),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          _handleLoginState(state);
        },
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            final loginCubit = context.read<LoginCubit>();
            final isLoading = state.maybeWhen(
              loading: () => true,
              orElse: () => false,
            );

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
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: _formKey,
                          child: Column(
                            children: [
                              SizedBox(height: 30.h),

                              // Header Section
                              LoginHeaderWidget(
                                pulseAnimation: _pulseAnimation,
                                shimmerAnimation: _shimmerAnimation,
                              ),

                              SizedBox(height: 30.h),

                              // Form Section
                              LoginFormWidget(
                                isEmailMode: _isEmailMode,
                                onToggleEmailPhone: () => _toggleEmailPhoneMode(loginCubit),
                                emailController: loginCubit.emailController,
                                phoneController: loginCubit.mobileController,
                                passwordController: loginCubit.passwordController,
                                isPasswordVisible: _isPasswordVisible,
                                onTogglePasswordVisibility: _togglePasswordVisibility,
                                isLoading: isLoading,
                                onLoginPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    loginCubit.emitLoginState(isEmailMode: _isEmailMode);
                                  }
                                },
                                validateEmail: _validateEmail,
                                validatePhone: _validatePhone,
                                validatePassword: _validatePassword,
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
        },
        ),
      ),
    );
  }
}
