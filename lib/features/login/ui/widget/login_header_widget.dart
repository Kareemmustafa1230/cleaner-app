import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/Color/colors.dart';
import '../../../../core/theme/text_style/text_style.dart';
import '../../../../core/language/lang_keys.dart';
import '../../../../core/helpers/extensions.dart';

class LoginHeaderWidget extends StatelessWidget {
  final Animation<double> pulseAnimation;
  final Animation<double> shimmerAnimation;

  const LoginHeaderWidget({
    super.key,
    required this.pulseAnimation,
    required this.shimmerAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: ColorApp.whiteFF,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: ColorApp.blue8D.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo Section
          AnimatedBuilder(
            animation: pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: pulseAnimation.value,
                child: Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        ColorApp.blue8D.withOpacity(0.1),
                        ColorApp.blueBD.withOpacity(0.05),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ColorApp.blue8D.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 80.w,
                      height: 80.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            ColorApp.blue8D,
                            ColorApp.blueBD,
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.home_rounded,
                        color: Colors.white,
                        size: 40.sp,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          
          SizedBox(height: 24.h),
          
          // Welcome Text
          AnimatedBuilder(
            animation: shimmerAnimation,
            builder: (context, child) {
              return ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                    colors: [
                      ColorApp.blue8D,
                      ColorApp.blueBD,
                      ColorApp.blue8D,
                    ],
                    stops: [
                      (shimmerAnimation.value - 0.3).clamp(0.0, 1.0),
                      shimmerAnimation.value.clamp(0.0, 1.0),
                      (shimmerAnimation.value + 0.3).clamp(0.0, 1.0),
                    ],
                  ).createShader(bounds);
                },
                child: Text(
                  context.translate(LangKeys.welcomeBack),
                  style: TextStyleApp.font24black00Weight700.copyWith(
                    color: Colors.white,
                    fontSize: 28.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
          
          SizedBox(height: 8.h),
          
          Text(
            context.translate(LangKeys.loginToAccessAccount),
            style: TextStyleApp.font16greyC1Weight700.copyWith(
              fontSize: 16.sp,
              color: ColorApp.greyC1,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
