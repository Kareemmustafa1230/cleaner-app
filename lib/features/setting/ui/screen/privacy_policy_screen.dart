import 'package:diyar/core/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/language/lang_keys.dart';
import '../../../../core/theme/text_style/text_style.dart';
import '../../../../core/language/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        title: Text(
          localizations?.translate('privacyPolicy') ?? 'سياسة الخصوصية',
          style: TextStyleApp.font20black00Weight700.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // معلومات سياسة الخصوصية
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'سياسة الخصوصية',
                    style: TextStyleApp.font16black00Weight700.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'آخر تحديث: يناير 2024',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            
            // محتوى سياسة الخصوصية
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '1. جمع المعلومات',
                    style: TextStyleApp.font16black00Weight700.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'نقوم بجمع المعلومات التي تقدمها لنا مباشرة عند استخدام التطبيق، مثل معلومات الحساب والبيانات الشخصية.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                      fontFamily: 'Cairo',
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  
                  Text(
                    '2. استخدام المعلومات',
                    style: TextStyleApp.font16black00Weight700.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'نستخدم المعلومات المجمعة لتقديم خدمات التطبيق وتحسين تجربة المستخدم والتواصل معك.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                      fontFamily: 'Cairo',
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  
                  Text(
                    '3. حماية المعلومات',
                    style: TextStyleApp.font16black00Weight700.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'نحن نلتزم بحماية معلوماتك الشخصية ونستخدم تقنيات التشفير المتقدمة لحمايتها.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                      fontFamily: 'Cairo',
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            
            // زر الموافقة
            Container(
              width: double.infinity,
              height: 56.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                gradient: LinearGradient(
                  colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor,
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15.r),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.translate(LangKeys.privacyPolicyConsentSaved)),
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Text(
                      'أوافق على سياسة الخصوصية',
                      style: TextStyleApp.font16whiteFFWeight700,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
} 