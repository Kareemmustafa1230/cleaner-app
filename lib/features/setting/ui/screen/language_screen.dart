import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/app_cubit/app_cubit.dart';
import '../../../../core/language/app_localizations.dart';
import '../../../../core/theme/text_style/text_style.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  String _selectedLanguage = 'ar';
  bool _isInitialized = false;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final localizations = AppLocalizations.of(context);
      if (localizations != null) {
        _selectedLanguage = localizations.locale.languageCode;
        _isInitialized = true;
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: CustomScrollView(
        slivers: [
          // App Bar مخصص
          SliverAppBar(
            expandedHeight: 200.h,
            floating: false,
            pinned: true,
            backgroundColor: theme.colorScheme.primary,
            elevation: 0,
            leading: Container(
              margin: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.onPrimary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: theme.colorScheme.onPrimary,
                  size: 20.sp,
                ),
              ),
            ),
            title: Text(
              'اختر اللغة',
              style: TextStyleApp.font20black00Weight700.copyWith(
                color: theme.colorScheme.onPrimary,
                fontSize: 18.sp,
              ),
            ),
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
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
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 90.h),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        width: 80.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onPrimary.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.onPrimary,
                            width: 3.w,
                          ),
                        ),
                        child: Icon(
                          Icons.language,
                          size: 40.sp,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    SlideTransition(
                      position: _slideAnimation,
                      child: Text(
                        'اختر اللغة المفضلة لك',
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // محتوى الصفحة
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  
                  // خيارات اللغة
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        _buildLanguageOption(
                          context: context,
                          languageCode: 'ar',
                          languageName: 'العربية',
                          nativeName: 'Arabic',
                          flag: '🇸🇦',
                          description: 'اللغة العربية الرسمية',
                          isSelected: _selectedLanguage == 'ar',
                        ),
                        SizedBox(height: 16.h),
                        _buildLanguageOption(
                          context: context,
                          languageCode: 'en',
                          languageName: 'English',
                          nativeName: 'الإنجليزية',
                          flag: '🇺🇸',
                          description: 'English Language',
                          isSelected: _selectedLanguage == 'en',
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 40.h),
                  
                  // معلومات إضافية
                  SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: theme.colorScheme.primary,
                            size: 24.sp,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'ملاحظة',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Cairo',
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'سيتم تطبيق التغيير فوراً وقد تحتاج لإعادة تشغيل التطبيق للحصول على أفضل تجربة.',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'Cairo',
                              color: theme.colorScheme.onBackground.withOpacity(0.8),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String languageCode,
    required String languageName,
    required String nativeName,
    required String flag,
    required String description,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLanguage = languageCode;
        });
        
        // تطبيق اللغة
        if (languageCode == 'ar') {
          context.read<AppCubit>().toArabic();
        } else {
          context.read<AppCubit>().toEnglish();
        }
        
        // عرض رسالة نجاح
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8.w),
                Text(
                  'تم تغيير اللغة بنجاح',
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            duration: Duration(seconds: 2),
          ),
        );
        
        // العودة للصفحة السابقة
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: isSelected 
              ? theme.colorScheme.primary.withOpacity(0.1)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected 
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withOpacity(0.3),
            width: isSelected ? 2.w : 1.w,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Row(
          children: [
            // العلم
            Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  flag,
                  style: TextStyle(fontSize: 24.sp),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            
            // معلومات اللغة
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languageName,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: languageCode == 'ar' ? 'Cairo' : 'Poppins',
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    nativeName,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: theme.colorScheme.onBackground.withOpacity(0.7),
                      fontFamily: languageCode == 'ar' ? 'Poppins' : 'Cairo',
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: theme.colorScheme.onBackground.withOpacity(0.5),
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ),
            
            // أيقونة الاختيار
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected 
                    ? theme.colorScheme.primary
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected 
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline.withOpacity(0.5),
                  width: 2.w,
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: theme.colorScheme.onPrimary,
                      size: 16.sp,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
} 