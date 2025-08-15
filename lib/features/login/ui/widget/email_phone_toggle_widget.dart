import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/Color/colors.dart';
import '../../../../core/theme/text_style/text_style.dart';
import '../../../../core/language/lang_keys.dart';
import '../../../../core/helpers/extensions.dart';

class EmailPhoneToggleWidget extends StatelessWidget {
  final bool isEmailMode;
  final VoidCallback onToggle;

  const EmailPhoneToggleWidget({
    super.key,
    required this.isEmailMode,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: ColorApp.backgroundSecondary,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: ColorApp.greyD9.withOpacity(0.3),
          width: 1.w,
        ),
      ),
      child: Row(
        children: [
          // Email Option
          Expanded(
            child: GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: isEmailMode ? ColorApp.blue8D : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: isEmailMode
                      ? [
                          BoxShadow(
                            color: ColorApp.blue8D.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.email_rounded,
                      size: 16.sp,
                      color: isEmailMode ? Colors.white : ColorApp.black18,
                    ),
                    SizedBox(width: 6.w),
                    Flexible(
                      child: Text(
                        context.translate(LangKeys.email),
                        style: TextStyleApp.font15greyC1Weight600.copyWith(
                          color: isEmailMode ? Colors.white : ColorApp.black18,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Phone Option
          Expanded(
            child: GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: !isEmailMode ? ColorApp.blue8D : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: !isEmailMode
                      ? [
                          BoxShadow(
                            color: ColorApp.blue8D.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.phone_rounded,
                      size: 16.sp,
                      color: !isEmailMode ? Colors.white : ColorApp.black18,
                    ),
                    SizedBox(width: 6.w),
                    Flexible(
                      child: Text(
                        context.translate(LangKeys.phone),
                        style: TextStyleApp.font15greyC1Weight600.copyWith(
                          color: !isEmailMode ? Colors.white : ColorApp.black18,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
