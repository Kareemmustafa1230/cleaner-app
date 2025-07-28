import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../app_cubit/app_cubit.dart';
import '../helpers/animate_do.dart';
import '../language/app_localizations.dart';

class ButtonLanguage extends StatefulWidget {
  const ButtonLanguage({super.key});

  @override
  State<ButtonLanguage> createState() => _ButtonLanguageState();
}

class _ButtonLanguageState extends State<ButtonLanguage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnglish = AppLocalizations.of(context)!.isEnLocale;
    
    return CustomFadeInLeft(
      duration: 400,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: () {
          if (isEnglish) {
            context.read<AppCubit>().toArabic();
          } else {
            context.read<AppCubit>().toEnglish();
          }
        },
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotationAnimation.value,
                child: Container(
                  width: 120.w,
                  height: 50.h,
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
                    borderRadius: BorderRadius.circular(25.r),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // أيقونة العلم
                      Container(
                        width: 24.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.onPrimary.withOpacity(0.2),
                        ),
                        child: Icon(
                          isEnglish ? Icons.language : Icons.translate,
                          color: theme.colorScheme.onPrimary,
                          size: 16.sp,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      // نص اللغة
                      Text(
                        isEnglish ? 'العربية' : 'English',
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: isEnglish ? 'Cairo' : 'Poppins',
                        ),
                      ),
                      SizedBox(width: 4.w),
                      // أيقونة السهم
                      Icon(
                        Icons.arrow_forward_ios,
                        color: theme.colorScheme.onPrimary,
                        size: 14.sp,
                      ),
                    ],
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
