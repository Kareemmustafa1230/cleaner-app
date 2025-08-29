import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/Color/colors.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/language/lang_keys.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header مع زر العودة
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: ColorApp.shadowLight.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.secondary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 20.sp,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        context.translate(LangKeys.aboutAppTitle),
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 48.w), // للتوازن
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  children: [
                    // شعار التطبيق
                    _buildAppLogo(),
                    SizedBox(height: 32.h),

                    // معلومات التطبيق
                    _buildAppInfo(context),
                    SizedBox(height: 32.h),

                    // معلومات المطور
                    _buildDeveloperInfo(context),
                    SizedBox(height: 32.h),

                    // روابط التواصل
                    _buildContactLinks(context),
                    SizedBox(height: 32.h),

                                          // إحصائيات التطبيق
                      _buildAppStats(context),
                      SizedBox(height: 32.h),
                      
                      // مشاريع GitHub
                      _buildGitHubProjects(context),
                      SizedBox(height: 32.h),

                    // حقوق النشر
                                          _buildCopyright(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppLogo() {
    return Container(
      width: 120.w,
      height: 120.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorApp.primaryBlue,
            ColorApp.primaryBlue.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: ColorApp.primaryBlue.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.cleaning_services,
          color: Colors.white,
          size: 60.sp,
        ),
      ),
    );
  }

  Widget _buildAppInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'ديار',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w800,
              color: ColorApp.primaryBlue,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            context.translate(LangKeys.appDescription),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            context.translate(LangKeys.appVersion),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorApp.primaryBlue.withOpacity(0.1),
            ColorApp.primaryBlue.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: ColorApp.primaryBlue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorApp.primaryBlue,
                      ColorApp.primaryBlue.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 30.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                                         Text(
                       context.translate(LangKeys.developerName),
                       style: TextStyle(
                         fontSize: 20.sp,
                         fontWeight: FontWeight.w700,
                         color: ColorApp.primaryBlue,
                         fontFamily: 'Cairo',
                       ),
                     ),
                     SizedBox(height: 4.h),
                     Text(
                       context.translate(LangKeys.developerTitle),
                       style: TextStyle(
                         fontSize: 14.sp,
                         fontWeight: FontWeight.w500,
                         color: Colors.grey[700],
                         fontFamily: 'Cairo',
                       ),
                     ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
                     Text(
             context.translate(LangKeys.developerDescription),
             style: TextStyle(
               fontSize: 14.sp,
               fontWeight: FontWeight.w400,
               color: Colors.grey[600],
               fontFamily: 'Cairo',
               height: 1.5,
             ),
             textAlign: TextAlign.center,
           ),
        ],
      ),
    );
  }

  Widget _buildContactLinks(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            context.translate(LangKeys.contactDeveloper),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: ColorApp.primaryBlue,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: 20.h),
                                _buildContactItem(
             icon: Icons.email,
             title: context.translate(LangKeys.emailContact),
             subtitle: 'kareemmustafa1230@gmail.com',
             color: Colors.blue,
             onTap: () => _launchEmail(),
           ),
           SizedBox(height: 12.h),
           _buildContactItem(
             icon: Icons.phone,
             title: context.translate(LangKeys.phoneContact),
             subtitle: '01025619301',
             color: Colors.green,
             onTap: () => _launchPhone(),
           ),
           SizedBox(height: 12.h),
           _buildContactItem(
             icon: Icons.location_on,
             title: context.translate(LangKeys.locationContact),
             subtitle: 'بني سويف - مصر',
             color: Colors.orange,
             onTap: () => _launchLocation(),
           ),
           SizedBox(height: 12.h),
           _buildContactItem(
             icon: Icons.code,
             title: context.translate(LangKeys.githubContact),
             subtitle: 'github.com/Kareemmustafa1230',
             color: Colors.black87,
             onTap: () => _launchGitHub(),
           ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                          fontFamily: 'Cairo',
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: color,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: color,
                  size: 16.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppStats(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorApp.primaryBlue.withOpacity(0.1),
            ColorApp.primaryBlue.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: ColorApp.primaryBlue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            context.translate(LangKeys.appStatistics),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: ColorApp.primaryBlue,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
                             Expanded(
                 child: _buildStatItem(
                   icon: Icons.folder,
                   title: context.translate(LangKeys.repositories),
                   value: '9',
                   color: Colors.blue,
                 ),
               ),
               SizedBox(width: 16.w),
               Expanded(
                 child: _buildStatItem(
                   icon: Icons.people,
                   title: context.translate(LangKeys.followers),
                   value: '1',
                   color: Colors.green,
                 ),
               ),
               SizedBox(width: 16.w),
               Expanded(
                 child: _buildStatItem(
                   icon: Icons.star,
                   title: context.translate(LangKeys.stars),
                   value: '1',
                   color: Colors.orange,
                 ),
               ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: color,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGitHubProjects(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withValues(alpha: 0.1),
            Colors.purple.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.purple.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.code,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                context.translate(LangKeys.githubProjects),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.purple,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
                     _buildProjectItem(
             context,
             icon: Icons.shopping_cart,
             title: context.translate(LangKeys.sellCropApp),
             description: context.translate(LangKeys.sellCropDesc),
             color: Colors.green,
           ),
           SizedBox(height: 12.h),
           _buildProjectItem(
             context,
             icon: Icons.fitness_center,
             title: context.translate(LangKeys.fatraApp),
             description: context.translate(LangKeys.fatraDesc),
             color: Colors.orange,
           ),
           SizedBox(height: 12.h),
           _buildProjectItem(
             context,
             icon: Icons.delivery_dining,
             title: context.translate(LangKeys.driverApp),
             description: context.translate(LangKeys.driverDesc),
             color: Colors.blue,
           ),
           SizedBox(height: 12.h),
           _buildProjectItem(
             context,
             icon: Icons.school,
             title: context.translate(LangKeys.unizoneApp),
             description: context.translate(LangKeys.unizoneDesc),
             color: Colors.purple,
           ),
          SizedBox(height: 16.h),
          Center(
            child: GestureDetector(
              onTap: () => _launchGitHub(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Text(
                  context.translate(LangKeys.viewAllProjects),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: color,
                    fontFamily: 'Cairo',
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCopyright(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
                     Text(
             context.translate(LangKeys.copyright),
             style: TextStyle(
               fontSize: 12.sp,
               fontWeight: FontWeight.w400,
               color: Colors.grey[500],
               fontFamily: 'Cairo',
             ),
             textAlign: TextAlign.center,
           ),
           SizedBox(height: 8.h),
           Text(
             context.translate(LangKeys.developedWithLove),
             style: TextStyle(
               fontSize: 12.sp,
               fontWeight: FontWeight.w500,
               color: ColorApp.primaryBlue,
               fontFamily: 'Cairo',
             ),
             textAlign: TextAlign.center,
           ),
        ],
      ),
    );
  }

  // دوال فتح الروابط
  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'kareemmustafa1230@gmail.com',
      query: 'subject=تطبيق ديار - استفسار',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _launchPhone() async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: '01025619301',
    );
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  void _launchLocation() async {
    // فتح خريطة بني سويف
    final Uri locationUri = Uri.parse('https://maps.google.com/?q=Beni+Suef+Egypt');
    if (await canLaunchUrl(locationUri)) {
      await launchUrl(locationUri);
    }
  }

  void _launchGitHub() async {
    final Uri githubUri = Uri.parse('https://github.com/Kareemmustafa1230/');
    if (await canLaunchUrl(githubUri)) {
      await launchUrl(githubUri);
    }
  }
}
