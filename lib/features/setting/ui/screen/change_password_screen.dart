import 'package:diyar/core/helpers/extensions.dart';
import 'package:diyar/core/networking/di/dependency_injection.dart';
import 'package:diyar/features/setting/logic/cubit/change_password_cubit.dart';
import 'package:diyar/features/setting/logic/state/logout_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slide_to_act/slide_to_act.dart';
import '../../../../core/router/routers.dart';
import '../../../../core/theme/text_style/text_style.dart';
import '../../../../core/language/lang_keys.dart';
import '../../../../core/widget/showErrorSnackBar.dart';
import '../../../../core/widget/showSuccesSnackBar.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>
    with TickerProviderStateMixin {
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }
  void _handleLoginState(LogoutState state) {
    state.whenOrNull(
      success: (message) {
        showSuccesSnackBar(context: context, title: message);
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            context.pushNamedAndRemoveUntil(Routes.setting, predicate: (Route<dynamic> route)=> false);
          }
        });
      },
      error: (error) {
        showErrorSnackBar(context: context, title: error);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ChangePasswordCubit>(),
      child: BlocListener<ChangePasswordCubit, LogoutState>(
     listener: (context, state) {
    _handleLoginState(state);
    },
  child: Builder(
          builder: (context) {
            final cubit = context.read<ChangePasswordCubit>();
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              body: SafeArea(
                child: Column(
                  children: [
                    // Header Section
                    _buildHeader(context),

                    // Content Section
                    Expanded(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 20.h),
                            child: BlocConsumer<ChangePasswordCubit,
                                LogoutState>(
                              listener: (context, state) {
                                // Handle state changes here
                              },
                              builder: (context, state) {
                                return Form(
                                  key: cubit.formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                    children: [
                                      // Security Icon
                                      _buildSecurityIcon(context),
                                      SizedBox(height: 24.h),

                                      // Description Card
                                      _buildDescriptionCard(context),
                                      SizedBox(height: 32.h),

                                      // Password Fields
                                      _buildPasswordFields(cubit, context),
                                      SizedBox(height: 40.h),

                                      // Change Password Button
                                      _buildChangePasswordButton(
                                          cubit, context, state),
                                      SizedBox(height: 24.h),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
      ),
),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Theme.of(context).colorScheme.primary,
                size: 20.sp,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              context.translate(LangKeys.changePassword),
              style: TextStyleApp.font20black00Weight700.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityIcon(BuildContext context) {
    return Center(
      child: Container(
        width: 80.w,
        height: 80.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(
          Icons.lock_outline,
          color: Colors.white,
          size: 40.sp,
        ),
      ),
    );
  }

  Widget _buildDescriptionCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.security,
            color: Theme.of(context).colorScheme.primary,
            size: 24.sp,
          ),
          SizedBox(height: 12.h),
          Text(
            context.translate(LangKeys.changePasswordDesc),
            style: TextStyleApp.font16black00Weight700.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            context.translate(LangKeys.enterCurrentAndNewPassword),
            style: TextStyle(
              fontSize: 14.sp,
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
              fontFamily: 'Cairo',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordFields(
      ChangePasswordCubit cubit, BuildContext context) {
    return Column(
      children: [
        // Current Password Field
        _buildPasswordField(
          controller: cubit.currentPasswordController,
          hintText: context.translate(LangKeys.enterCurrentPassword),
          isVisible: _isCurrentPasswordVisible,
          onVisibilityChanged: (value) =>
              setState(() => _isCurrentPasswordVisible = value),
          validator: (v) => _validateCurrentPassword(v, context),
          icon: Icons.lock_outline,
          context: context,
        ),
        SizedBox(height: 16.h),

        // New Password Field
        _buildPasswordField(
          controller: cubit.newPasswordController,
          hintText: context.translate(LangKeys.enterNewPassword),
          isVisible: _isNewPasswordVisible,
          onVisibilityChanged: (value) =>
              setState(() => _isNewPasswordVisible = value),
          validator: (v) => _validateNewPassword(v, cubit, context),
          icon: Icons.lock_outline,
          context: context,
        ),
        SizedBox(height: 16.h),

        // Confirm Password Field
        _buildPasswordField(
          controller: cubit.newPasswordConfirmationController,
          hintText: context.translate(LangKeys.confirmNewPassword),
          isVisible: _isConfirmPasswordVisible,
          onVisibilityChanged: (value) =>
              setState(() => _isConfirmPasswordVisible = value),
          validator: (v) => _validateConfirmPassword(v, cubit, context),
          icon: Icons.lock_outline,
          context: context,
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool isVisible,
    required Function(bool) onVisibilityChanged,
    required String? Function(String?) validator,
    required IconData icon,
    required BuildContext context,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: !isVisible,
        validator: validator,
        style: TextStyle(
          fontSize: 16.sp,
          color: Theme.of(context).colorScheme.onBackground,
          fontFamily: 'Cairo',
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 16.sp,
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
            fontFamily: 'Cairo',
          ),
          prefixIcon: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 20.sp,
          ),
          suffixIcon: IconButton(
            onPressed: () => onVisibilityChanged(!isVisible),
            icon: Icon(
              isVisible ? Icons.visibility_off : Icons.visibility,
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
              size: 20.sp,
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 18.h,
          ),
        ),
      ),
    );
  }

  Widget _buildChangePasswordButton(
      ChangePasswordCubit cubit,
      BuildContext context,
      LogoutState state,
      ) {
    final isLoading = state is Loading;

    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SlideAction(
        text: context.translate(LangKeys.slideToSave),
        textStyle: TextStyle(
          fontSize: 16.sp,
          color: Theme.of(context).colorScheme.onSurface,
          fontFamily: 'Cairo',
          fontWeight: FontWeight.w600,
        ),
        outerColor: Theme.of(context).colorScheme.surface,
        innerColor: Theme.of(context).colorScheme.primary,
        borderRadius: 16.r,
        elevation: 0,
        sliderButtonIcon: isLoading
            ? SizedBox(
          height: 18.h,
          width: 18.w,
          child: CircularProgressIndicator(
            strokeWidth: 2.w,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
          size: 18.sp,
        ),
        sliderButtonIconSize: 24.sp,
        onSubmit: isLoading ? null : () => cubit.emitChangePasswordState(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_reset,
                color: Theme.of(context).colorScheme.primary,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                context.translate(LangKeys.changePassword),
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Theme.of(context).colorScheme.primary,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateCurrentPassword(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.translate(LangKeys.pleaseEnterCurrentPassword);
    }
    if (value.length < 6) {
      return context.translate(LangKeys.passwordMinLength);
    }
    return null;
  }

  String? _validateNewPassword(
      String? value,
      ChangePasswordCubit cubit,
      BuildContext context,
      ) {
    if (value == null || value.isEmpty) {
      return context.translate(LangKeys.pleaseEnterNewPassword);
    }
    if (value.length < 6) {
      return context.translate(LangKeys.newPasswordMinLength);
    }
    if (value == cubit.currentPasswordController.text) {
      return context.translate(LangKeys.newPasswordMustBeDifferent);
    }
    return null;
  }

  String? _validateConfirmPassword(
      String? value,
      ChangePasswordCubit cubit,
      BuildContext context,
      ) {
    if (value == null || value.isEmpty) {
      return context.translate(LangKeys.pleaseConfirmNewPassword);
    }
    if (value != cubit.newPasswordController.text) {
      return context.translate(LangKeys.passwordsDoNotMatch);
    }
    return null;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}