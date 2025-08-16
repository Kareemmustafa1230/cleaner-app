import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/Color/colors.dart';
import '../../../../core/language/lang_keys.dart';
import '../../../../core/helpers/extensions.dart';
import 'email_phone_toggle_widget.dart';
import 'login_input_field_widget.dart';
import 'login_button_widget.dart';

class LoginFormWidget extends StatefulWidget {
  final bool isEmailMode;
  final VoidCallback onToggleEmailPhone;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final bool isPasswordVisible;
  final VoidCallback onTogglePasswordVisibility;
  final bool isLoading;
  final VoidCallback onLoginPressed;
  final String? Function(String?)? validateEmail;
  final String? Function(String?)? validatePhone;
  final String? Function(String?)? validatePassword;

  const LoginFormWidget({
    super.key,
    required this.isEmailMode,
    required this.onToggleEmailPhone,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.onTogglePasswordVisibility,
    required this.isLoading,
    required this.onLoginPressed,
    this.validateEmail,
    this.validatePhone,
    this.validatePassword,
  });

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(LoginFormWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !oldWidget.isLoading) {
      _scaleController.forward();
    } else if (!widget.isLoading && oldWidget.isLoading) {
      _scaleController.reverse();
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
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
                // Toggle Button for Email/Phone
                EmailPhoneToggleWidget(
                  isEmailMode: widget.isEmailMode,
                  onToggle: widget.onToggleEmailPhone,
                ),
                SizedBox(height: 20.h),

                // Email/Phone Field
                LoginInputFieldWidget(
                  controller: widget.isEmailMode ? widget.emailController : widget.phoneController,
                  hintText: widget.isEmailMode 
                    ? context.translate(LangKeys.email)
                    : context.translate(LangKeys.phone),
                  prefixIcon: widget.isEmailMode 
                    ? Icons.email_rounded 
                    : Icons.phone_rounded,
                  keyboardType: widget.isEmailMode 
                    ? TextInputType.emailAddress 
                    : TextInputType.phone,
                  validator: widget.isEmailMode ? widget.validateEmail : widget.validatePhone,
                ),
                
                SizedBox(height: 24.h),
                
                // Password Field
                LoginInputFieldWidget(
                  controller: widget.passwordController,
                  hintText: context.translate(LangKeys.password),
                  prefixIcon: Icons.lock_rounded,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !widget.isPasswordVisible,
                  suffixIcon: IconButton(
                    onPressed: widget.onTogglePasswordVisibility,
                    icon: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        widget.isPasswordVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                        color: Colors.black,
                        size: 18.sp,
                      ),
                    ),
                  ),
                  validator: widget.validatePassword,
                ),
                
                SizedBox(height: 40.h),
                
                // Login Button
                LoginButtonWidget(
                  isLoading: widget.isLoading,
                  onPressed: widget.onLoginPressed,
                ),
                SizedBox(height: 35.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
