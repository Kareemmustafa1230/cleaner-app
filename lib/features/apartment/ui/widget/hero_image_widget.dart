import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/Color/colors.dart';

/// Widget مخصص لـ Hero Animation للصور
class HeroImageWidget extends StatelessWidget {
  final String imageUrl;
  final String heroTag;
  final String title;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final BoxFit fit;

  const HeroImageWidget({
    super.key,
    required this.imageUrl,
    required this.heroTag,
    required this.title,
    this.onTap,
    this.width,
    this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: heroTag,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(12.r),
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: fit,
            ),
          ),
          child: Stack(
            children: [
              // أيقونة التكبير
              if (onTap != null)
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.zoom_in,
                      color: ColorApp.textInverse,
                      size: 16.sp,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget مخصص لـ Hero Animation للفيديوهات
class HeroVideoWidget extends StatelessWidget {
  final String videoUrl;
  final String heroTag;
  final String title;
  final String duration;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final BoxFit fit;

  const HeroVideoWidget({
    super.key,
    required this.videoUrl,
    required this.heroTag,
    required this.title,
    required this.duration,
    this.onTap,
    this.width,
    this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: heroTag,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(12.r),
            image: DecorationImage(
              image: AssetImage(videoUrl),
              fit: fit,
            ),
          ),
          child: Stack(
            children: [
              // أيقونة التشغيل
              if (onTap != null)
                Positioned.fill(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [ColorApp.gradientStart, ColorApp.gradientEnd],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: ColorApp.shadowDark,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: ColorApp.textInverse,
                        size: 24.sp,
                      ),
                    ),
                  ),
                ),
              
              // مدة الفيديو
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    duration,
                    style: TextStyle(
                      color: ColorApp.textInverse,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget مخصص لـ Hero Animation مع معلومات إضافية
class HeroCardWidget extends StatelessWidget {
  final String imageUrl;
  final String heroTag;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const HeroCardWidget({
    super.key,
    required this.imageUrl,
    required this.heroTag,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: ColorApp.backgroundPrimary,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: ColorApp.borderLight,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorApp.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الصورة مع Hero Animation
            Expanded(
              child: Hero(
                tag: heroTag,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.r),
                      topRight: Radius.circular(12.r),
                    ),
                    image: DecorationImage(
                      image: AssetImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // أيقونة التكبير
                      if (onTap != null)
                        Positioned(
                          top: 8.h,
                          right: 8.w,
                          child: Container(
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.zoom_in,
                              color: ColorApp.textInverse,
                              size: 16.sp,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            
            // تفاصيل البطاقة
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العنوان
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: ColorApp.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Cairo',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  
                  // النوع
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [ColorApp.gradientStart, ColorApp.gradientEnd],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        color: ColorApp.textInverse,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 