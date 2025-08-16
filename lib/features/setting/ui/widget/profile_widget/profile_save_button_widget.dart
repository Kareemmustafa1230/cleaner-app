import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slide_to_act/slide_to_act.dart';
import '../../../../../core/language/lang_keys.dart';
import '../../../../../core/helpers/extensions.dart';

class ProfileSaveButtonWidget extends StatelessWidget {
  final bool isLoading;
  final Future<void> Function() onSavePressed;
  final GlobalKey<SlideActionState> slideActionKey;

  const ProfileSaveButtonWidget({
    super.key,
    required this.isLoading,
    required this.onSavePressed,
    required this.slideActionKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      child: SlideAction(
        key: slideActionKey,
        height: 56.h,
        borderRadius: 16.r,
        elevation: 0,
        innerColor: theme.colorScheme.primary,
        outerColor: theme.colorScheme.secondary,
        sliderButtonIcon: isLoading
            ? SizedBox(
                height: 20.h,
                width: 20.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.onPrimary,
                  ),
                ),
              )
            : Icon(
                Icons.arrow_forward_ios,
                color: theme.colorScheme.onPrimary,
                size: 20.sp,
              ),
        sliderButtonIconPadding: 12.w,
        sliderButtonIconSize: 24.sp,
        text: isLoading ? context.translate(LangKeys.saving) : context.translate(LangKeys.slideToSave),
        textStyle: TextStyle(
          color: theme.colorScheme.onBackground,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          fontFamily: 'Cairo',
        ),
        onSubmit: onSavePressed,
        animationDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
