import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/Color/colors.dart';

/// مثال على استخدام Hero Animation في Flutter
/// Hero Animation هو ميزة مدمجة في Flutter ولا تحتاج حزم إضافية

class HeroAnimationExample extends StatelessWidget {
  const HeroAnimationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hero Animation Example'),
        backgroundColor: ColorApp.backgroundPrimary,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return _buildHeroCard(context, index);
        },
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HeroDetailScreen(index: index),
          ),
        );
      },
      child: Container(
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
          children: [
            // الصورة مع Hero Animation
            Expanded(
              child: Hero(
                tag: 'hero_image_$index', // نفس الـ tag في الشاشة الأخرى
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.r),
                      topRight: Radius.circular(12.r),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        ColorApp.gradientStart,
                        ColorApp.gradientEnd,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(
                    Icons.image,
                    color: ColorApp.textInverse,
                    size: 40.sp,
                  ),
                ),
              ),
            ),
            // العنوان
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Text(
                'صورة $index',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: ColorApp.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeroDetailScreen extends StatelessWidget {
  final int index;

  const HeroDetailScreen({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.backgroundPrimary,
      appBar: AppBar(
        title: Text('تفاصيل الصورة $index'),
        backgroundColor: ColorApp.backgroundPrimary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: ColorApp.textPrimary,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // الصورة مع نفس Hero tag
            Hero(
              tag: 'hero_image_$index', // نفس الـ tag من الشاشة السابقة
              child: Container(
                width: 300.w,
                height: 300.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  gradient: LinearGradient(
                    colors: [
                      ColorApp.gradientStart,
                      ColorApp.gradientEnd,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ColorApp.shadowDark,
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.image,
                  color: ColorApp.textInverse,
                  size: 80.sp,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'تفاصيل الصورة رقم $index',
              style: TextStyle(
                fontSize: 24.sp,
                color: ColorApp.textPrimary,
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'هذا مثال على استخدام Hero Animation\nللانتقال السلس بين الشاشات',
              style: TextStyle(
                fontSize: 16.sp,
                color: ColorApp.textSecondary,
                fontWeight: FontWeight.w500,
                fontFamily: 'Cairo',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// مثال على Hero Animation مع نص
class HeroTextExample extends StatelessWidget {
  const HeroTextExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hero Text Animation'),
        backgroundColor: ColorApp.backgroundPrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // نص مع Hero Animation
            Hero(
              tag: 'hero_text',
              child: Material(
                color: Colors.transparent,
                child: Text(
                  'انقر هنا',
                  style: TextStyle(
                    fontSize: 32.sp,
                    color: ColorApp.primaryBlue,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HeroTextDetailScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorApp.primaryBlue,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'انتقال',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: ColorApp.textInverse,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeroTextDetailScreen extends StatelessWidget {
  const HeroTextDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.backgroundPrimary,
      appBar: AppBar(
        title: const Text('تفاصيل النص'),
        backgroundColor: ColorApp.backgroundPrimary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: ColorApp.textPrimary,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // نفس النص مع Hero Animation
            Hero(
              tag: 'hero_text',
              child: Material(
                color: Colors.transparent,
                child: Text(
                  'انقر هنا',
                  style: TextStyle(
                    fontSize: 48.sp,
                    color: ColorApp.primaryBlue,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'تم تكبير النص باستخدام Hero Animation',
              style: TextStyle(
                fontSize: 18.sp,
                color: ColorApp.textSecondary,
                fontWeight: FontWeight.w500,
                fontFamily: 'Cairo',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// مثال على Hero Animation مع أيقونة
class HeroIconExample extends StatelessWidget {
  const HeroIconExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hero Icon Animation'),
        backgroundColor: ColorApp.backgroundPrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // أيقونة مع Hero Animation
            Hero(
              tag: 'hero_icon',
              child: Container(
                padding: EdgeInsets.all(20.w),
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
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.favorite,
                  color: ColorApp.textInverse,
                  size: 60.sp,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HeroIconDetailScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorApp.primaryBlue,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'تكبير الأيقونة',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: ColorApp.textInverse,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeroIconDetailScreen extends StatelessWidget {
  const HeroIconDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.backgroundPrimary,
      appBar: AppBar(
        title: const Text('أيقونة مكبرة'),
        backgroundColor: ColorApp.backgroundPrimary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: ColorApp.textPrimary,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // نفس الأيقونة مع Hero Animation
            Hero(
              tag: 'hero_icon',
              child: Container(
                padding: EdgeInsets.all(40.w),
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
                      blurRadius: 25,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.favorite,
                  color: ColorApp.textInverse,
                  size: 120.sp,
                ),
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              'أيقونة مكبرة باستخدام Hero Animation',
              style: TextStyle(
                fontSize: 20.sp,
                color: ColorApp.textPrimary,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 