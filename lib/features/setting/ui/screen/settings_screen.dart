import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/Color/colors.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/language/lang_keys.dart';
import '../../../../core/app_cubit/app_cubit.dart';
import '../../../login/ui/screen/login.dart';
import 'profile_screen.dart';
import 'change_password_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_screen.dart';
import 'language_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  bool _autoBackupEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: BlocBuilder<AppCubit, dynamic>(
          builder: (context, state) {
            final isDark = context.read<AppCubit>().isDark;
            return Column(
              children: [
                // Header مع العنوان
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    boxShadow: [
                      BoxShadow(
                        color: ColorApp.shadowLight,
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      context.translate(LangKeys.settings),
                      style: TextStyle(
                        fontSize: 24.sp,
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ),
                
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      children: [
                        // قسم الإشعارات
                        _buildSettingsSection(
                          title: context.translate(LangKeys.notifications),
                          icon: Icons.notifications_outlined,
                          children: [
                            _buildSwitchTile(
                              icon: Icons.notifications_active,
                              title: context.translate(LangKeys.enableNotifications),
                              subtitle: context.translate(LangKeys.enableNotificationsDesc),
                              value: _notificationsEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _notificationsEnabled = value;
                                });
                              },
                            ),
                            _buildSwitchTile(
                              icon: Icons.notification_important,
                              title: context.translate(LangKeys.urgentNotifications),
                              subtitle: context.translate(LangKeys.urgentNotificationsDesc),
                              value: false,
                              onChanged: (value) {},
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),


                        _buildSettingsSection(
                          title: context.translate(LangKeys.appearance),
                          icon: Icons.palette_outlined,
                          children: [
                            _buildSwitchTile(
                              icon: Icons.dark_mode,
                              title: context.translate(LangKeys.darkMode),
                              subtitle: context.translate(LangKeys.darkModeDesc),
                              value: isDark,
                              onChanged: (value) {
                                context.read<AppCubit>().changeAppThemeMode();
                              },
                            ),
                            _buildListTile(
                              icon: Icons.color_lens,
                              title: context.translate(LangKeys.appColor),
                              subtitle: context.translate(LangKeys.appColorDesc),
                              onTap: () {
                                _showColorPickerDialog();
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        
                        // قسم الأمان
                        _buildSettingsSection(
                          title: context.translate(LangKeys.security),
                          icon: Icons.security_outlined,
                          children: [
                            _buildSwitchTile(
                              icon: Icons.fingerprint,
                              title: context.translate(LangKeys.fingerprint),
                              subtitle: context.translate(LangKeys.fingerprintDesc),
                              value: _biometricEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _biometricEnabled = value;
                                });
                              },
                            ),
                            _buildListTile(
                              icon: Icons.lock_outline,
                              title: context.translate(LangKeys.changePassword),
                              subtitle: context.translate(LangKeys.changePasswordDesc),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ChangePasswordScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),

                        // قسم الحساب
                        _buildSettingsSection(
                          title: context.translate(LangKeys.account),
                          icon: Icons.person_outline,
                          children: [
                            _buildListTile(
                              icon: Icons.person,
                              title: context.translate(LangKeys.profile),
                              subtitle: context.translate(LangKeys.profileDesc),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ProfileScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildListTile(
                              icon: Icons.email_outlined,
                              title: context.translate(LangKeys.email),
                              subtitle: context.translate(LangKeys.emailDesc),
                              onTap: () {
                                // تغيير البريد الإلكتروني
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        
                        // قسم التطبيق
                        _buildSettingsSection(
                          title: context.translate(LangKeys.app),
                          icon: Icons.apps_outlined,
                          children: [
                            _buildListTile(
                              icon: Icons.language,
                              title: context.translate(LangKeys.appLanguage),
                              subtitle: context.translate(LangKeys.languageDesc),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LanguageScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildListTile(
                              icon: Icons.info_outline,
                              title: context.translate(LangKeys.aboutApp),
                              subtitle: context.translate(LangKeys.aboutAppDesc),
                              onTap: () {
                                _showAboutDialog();
                              },
                            ),
                            _buildListTile(
                              icon: Icons.privacy_tip_outlined,
                              title: context.translate(LangKeys.privacyPolicy),
                              subtitle: context.translate(LangKeys.privacyPolicyDesc),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PrivacyPolicyScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildListTile(
                              icon: Icons.description_outlined,
                              title: context.translate(LangKeys.termsOfService),
                              subtitle: context.translate(LangKeys.termsOfServiceDesc),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TermsScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildListTile(
                              icon: Icons.star_outline,
                              title: context.translate(LangKeys.rateApp),
                              subtitle: context.translate(LangKeys.rateAppDesc),
                              onTap: () {
                                // تقييم التطبيق
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        
                        // زر حذف الحساب
                        Container(
                          width: double.infinity,
                          height: 56.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(
                              color: Colors.red.shade400,
                              width: 2.w,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15.r),
                              onTap: () {
                                _showDeleteAccountDialog();
                              },
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.delete_forever,
                                      color: Colors.red.shade400,
                                      size: 20.sp,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      context.translate(LangKeys.deleteAccount),
                                      style: TextStyle(
                                        color: Colors.red.shade400,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        
                        // زر تسجيل الخروج
                        Container(
                          width: double.infinity,
                          height: 56.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.error,
                              width: 2.w,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15.r),
                              onTap: () {
                                _showLogoutDialog();
                              },
                              child: Center(
                                                                  child: Text(
                                    context.translate(LangKeys.logout),
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 20.sp,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          color: Theme.of(context).colorScheme.onBackground,
          fontWeight: FontWeight.w600,
          fontFamily: 'Cairo',
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12.sp,
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
          fontFamily: 'Cairo',
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 20.sp,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          color: Theme.of(context).colorScheme.onBackground,
          fontWeight: FontWeight.w600,
          fontFamily: 'Cairo',
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12.sp,
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
          fontFamily: 'Cairo',
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
        size: 16.sp,
      ),
      onTap: onTap,
    );
  }

  void _showColorPickerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'اختر لون التطبيق',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'سيتم إضافة هذه الميزة قريباً',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'حسناً',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'مسح البيانات',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
          ),
        ),
        content: Text(
          'هل أنت متأكد من حذف جميع البيانات؟ لا يمكن التراجع عن هذا الإجراء.',
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'Cairo',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // تنفيذ مسح البيانات
            },
            child: Text(
              'مسح',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'حول التطبيق',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'شركة دييار',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'إصدار 1.0.0',
              style: TextStyle(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'تطبيق إدارة الشقق والعقارات',
              style: TextStyle(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'حسناً',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'تسجيل الخروج',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
          ),
        ),
        content: Text(
          'هل أنت متأكد من تسجيل الخروج؟',
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'Cairo',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'تسجيل الخروج',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                color: Colors.red.shade600,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'حذف الحساب',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Cairo',
                  color: Colors.red.shade600,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تحذير: هذا الإجراء نهائي ولا يمكن التراجع عنه!',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
                color: Colors.red.shade600,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'سيتم حذف جميع البيانات المرتبطة بحسابك نهائياً:',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Cairo',
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            SizedBox(height: 8.h),
            _buildDeleteItem(Icons.person, 'الملف الشخصي'),
            _buildDeleteItem(Icons.photo_library, 'الصور والفيديوهات'),
            _buildDeleteItem(Icons.assessment, 'التقارير والبيانات'),
            _buildDeleteItem(Icons.settings, 'الإعدادات المخصصة'),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.red.shade600,
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'للمتابعة، اكتب "حذف" في الحقل أدناه',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: 'Cairo',
                        color: Colors.red.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _showDeleteConfirmationDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'حذف الحساب',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteItem(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16.sp,
            color: Colors.red.shade400,
          ),
          SizedBox(width: 8.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: 'Cairo',
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    final TextEditingController confirmController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'تأكيد الحذف',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
            color: Colors.red.shade600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'اكتب "حذف" لتأكيد حذف حسابك نهائياً:',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: confirmController,
              decoration: InputDecoration(
                hintText: 'اكتب "حذف" هنا',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Colors.red.shade400),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (confirmController.text.trim() == 'حذف') {
                Navigator.pop(context); // إغلاق نافذة التأكيد
                Navigator.pop(context); // إغلاق نافذة الحذف
                _executeDeleteAccount();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'يرجى كتابة "حذف" بالضبط',
                      style: TextStyle(fontFamily: 'Cairo'),
                    ),
                    backgroundColor: Colors.red.shade600,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'تأكيد الحذف',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _executeDeleteAccount() {
    // هنا يتم تنفيذ حذف الحساب
    // يمكن إضافة API call لحذف الحساب من الخادم
    
    // عرض رسالة نجاح
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8.w),
            Text(
              'تم حذف الحساب بنجاح',
              style: TextStyle(fontFamily: 'Cairo'),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        duration: Duration(seconds: 3),
      ),
    );
    
    // الانتقال لصفحة تسجيل الدخول
    Future.delayed(Duration(seconds: 2), () {
      context.pushAndClearStack(
        const LoginScreen(),
      );
    });
  }
} 