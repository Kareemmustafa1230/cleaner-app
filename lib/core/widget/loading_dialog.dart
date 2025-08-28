import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../language/app_localizations.dart';

class LoadingDialog extends StatelessWidget {
  final String? message;
  final bool barrierDismissible;
  final double? progress;
  final IconData? icon;

  const LoadingDialog({
    Key? key,
    this.message,
    this.barrierDismissible = false,
    this.progress,
    this.icon,
  }) : super(key: key);

  static void show(
    BuildContext context, {
    String? message,
    bool barrierDismissible = false,
    double? progress,
    IconData? icon,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => LoadingDialog(
        message: message,
        barrierDismissible: barrierDismissible,
        progress: progress,
        icon: icon,
      ),
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final defaultMessage = localizations?.translate('uploading') ?? 'جاري الرفع...';
    
    return WillPopScope(
      onWillPop: () async => barrierDismissible,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        alignment: Alignment.center,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(32.w),
            margin: EdgeInsets.symmetric(horizontal: 40.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(25.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Lottie Animation with better styling
                Container(
                  height: 140.h,
                  width: 140.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: icon != null
                      ? Icon(
                          icon,
                          size: 60.sp,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : Lottie.asset(
                          'assets/lottie/loading.json',
                          fit: BoxFit.contain,
                          repeat: true,
                        ),
                ),
                SizedBox(height: 24.h),
                
                // Main Message with better styling
                Text(
                  message ?? defaultMessage,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontFamily: 'Cairo',
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
                
                SizedBox(height: 12.h),
                
                // Subtitle with better styling
                Text(
                  localizations?.translate('pleaseWait') ?? 'يرجى الانتظار...',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: 16.h),
                
                // Progress indicator
                Container(
                  width: 200.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.r),
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                  ),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    value: progress,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                
                // Progress percentage
                if (progress != null) ...[
                  SizedBox(height: 8.h),
                  Text(
                    '${(progress! * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
