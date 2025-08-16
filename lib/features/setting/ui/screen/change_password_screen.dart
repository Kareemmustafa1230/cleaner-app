import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slide_to_act/slide_to_act.dart';
import '../../../../core/theme/text_style/text_style.dart';
import '../../../../core/language/app_localizations.dart';
import '../../../../core/language/lang_keys.dart';
import '../../../../core/widget/app_text_form_field.dart';
import '../../../../core/helpers/extensions.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>
    with TickerProviderStateMixin {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeader(),
            
            // Content Section
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Security Icon
                          _buildSecurityIcon(),
                          SizedBox(height: 24.h),
                          
                          // Description Card
                          _buildDescriptionCard(),
                          SizedBox(height: 32.h),
                          
                          // Password Fields
                          _buildPasswordFields(),
                          SizedBox(height: 40.h),
                          
                          // Change Password Button
                          _buildChangePasswordButton(),
                          SizedBox(height: 24.h),
                          
                        ],
                      ),
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

  Widget _buildHeader() {
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

  Widget _buildSecurityIcon() {
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

  Widget _buildDescriptionCard() {
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

  Widget _buildPasswordFields() {
    return Column(
      children: [
        // Current Password Field
        _buildPasswordField(
                controller: _currentPasswordController,
          hintText: context.translate(LangKeys.enterCurrentPassword),
          isVisible: _isCurrentPasswordVisible,
          onVisibilityChanged: (value) => setState(() => _isCurrentPasswordVisible = value),
                validator: _validateCurrentPassword,
          icon: Icons.lock_outline,
              ),
              SizedBox(height: 16.h),
              
        // New Password Field
        _buildPasswordField(
                controller: _newPasswordController,
          hintText: context.translate(LangKeys.enterNewPassword),
          isVisible: _isNewPasswordVisible,
          onVisibilityChanged: (value) => setState(() => _isNewPasswordVisible = value),
                validator: _validateNewPassword,
          icon: Icons.lock_outline,
              ),
              SizedBox(height: 16.h),
              
        // Confirm Password Field
        _buildPasswordField(
                controller: _confirmPasswordController,
          hintText: context.translate(LangKeys.confirmNewPassword),
          isVisible: _isConfirmPasswordVisible,
          onVisibilityChanged: (value) => setState(() => _isConfirmPasswordVisible = value),
          validator: _validateConfirmPassword,
          icon: Icons.lock_outline,
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
              
  Widget _buildChangePasswordButton() {
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
        sliderButtonIcon: _isLoading
                          ? SizedBox(
                height: 18.h,
                width: 18.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.w,
                                valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white,
                                ),
                              ),
                            )
            : Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 18.sp,
              ),
        sliderButtonIconSize: 24.sp,
        onSubmit: _isLoading ? null : () async {
          await _handleChangePassword();
        },
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


  String? _validateCurrentPassword(String? value) {
    if (value == null || value.isEmpty) {
      return context.translate(LangKeys.pleaseEnterCurrentPassword);
    }
    if (value.length < 6) {
      return context.translate(LangKeys.passwordMinLength);
    }
    return null;
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return context.translate(LangKeys.pleaseEnterNewPassword);
    }
    if (value.length < 6) {
      return context.translate(LangKeys.newPasswordMinLength);
    }
    if (value == _currentPasswordController.text) {
      return context.translate(LangKeys.newPasswordMustBeDifferent);
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return context.translate(LangKeys.pleaseConfirmNewPassword);
    }
    if (value != _newPasswordController.text) {
      return context.translate(LangKeys.passwordsDoNotMatch);
    }
    return null;
  }

  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // هنا يتم إرسال طلب تغيير كلمة المرور للخادم
      await Future.delayed(const Duration(seconds: 2)); // محاكاة الطلب
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 20.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    context.translate(LangKeys.passwordChangedSuccessfully),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.white,
                  size: 20.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    context.translate(LangKeys.passwordChangeError),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }
} 