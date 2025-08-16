import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/Color/colors.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: ColorApp.backgroundPrimary,
                boxShadow: [
                  BoxShadow(
                    color: ColorApp.shadowLight,
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: ColorApp.textPrimary,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'شروط الاستخدام',
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: ColorApp.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 48.w),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // أيقونة الشروط
                    Center(
                      child: Container(
                        width: 80.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          color: ColorApp.primaryBlue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.description_outlined,
                          size: 40.sp,
                          color: ColorApp.primaryBlue,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    
                    Text(
                      'شروط الاستخدام',
                      style: TextStyle(
                        fontSize: 24.sp,
                        color: ColorApp.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    SizedBox(height: 16.h),
                    
                    Text(
                      'آخر تحديث: ${DateTime.now().year}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: ColorApp.textSecondary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    SizedBox(height: 24.h),
                    
                    _buildSection(
                      title: '1. قبول الشروط',
                      content: 'باستخدام هذا التطبيق، فإنك توافق على الالتزام بهذه الشروط والأحكام.',
                    ),
                    
                    _buildSection(
                      title: '2. الاستخدام المقبول',
                      content: 'يجب استخدام التطبيق لأغراض مشروعة فقط. يحظر أي استخدام غير قانوني أو ضار.',
                    ),
                    
                    _buildSection(
                      title: '3. الحساب والأمان',
                      content: 'أنت مسؤول عن الحفاظ على سرية معلومات حسابك وكلمة المرور الخاصة بك.',
                    ),
                    
                    _buildSection(
                      title: '4. المحتوى',
                      content: 'أنت مسؤول عن المحتوى الذي تنشره أو تشاركه من خلال التطبيق.',
                    ),
                    
                    _buildSection(
                      title: '5. الملكية الفكرية',
                      content: 'جميع الحقوق الملكية الفكرية في التطبيق محفوظة لشركة دييار.',
                    ),
                    
                    _buildSection(
                      title: '6. المسؤولية',
                      content: 'لا نتحمل المسؤولية عن أي أضرار مباشرة أو غير مباشرة ناتجة عن استخدام التطبيق.',
                    ),
                    
                    _buildSection(
                      title: '7. التعديلات',
                      content: 'نحتفظ بالحق في تعديل هذه الشروط في أي وقت. سيتم إشعارك بأي تغييرات.',
                    ),
                    
                    _buildSection(
                      title: '8. الإنهاء',
                      content: 'يمكن إنهاء حسابك في أي وقت إذا انتهكت هذه الشروط.',
                    ),
                    
                    SizedBox(height: 32.h),
                    
                    // زر الاتصال
                    SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: ElevatedButton(
                        onPressed: () {
                          // الاتصال بفريق الدعم
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorApp.primaryBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                        ),
                        child: Text(
                          'اتصل بنا',
                          style: TextStyle(
                            color: ColorApp.white,
                            fontSize: 16.sp,
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
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorApp.backgroundSecondary,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: ColorApp.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              color: ColorApp.textPrimary,
              fontWeight: FontWeight.w700,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            content,
            style: TextStyle(
              fontSize: 14.sp,
              color: ColorApp.textSecondary,
              fontFamily: 'Cairo',
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
} 