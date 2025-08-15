import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/Color/colors.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/language/lang_keys.dart';
import '../../../../core/app_cubit/app_cubit.dart';
import '../../../../core/theme/text_style/text_style.dart';
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
                                // TODO: سيتم إضافة هذه الميزة قريباً
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
                                // TODO: سيتم إضافة هذه الميزة قريباً
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
                                _deleteAccount(context);
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
                                _signOut(context);
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









  void _signOut(BuildContext context) {
    // TODO: Implement sign out logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Image.asset(
              'assets/icons/exit.png',
              width: 24,
              height: 24,
              color: ColorApp.primaryBlue,
            ),
            SizedBox(width: 10.w),
            Text(
              context.translate(LangKeys.signOutTitle),
              style: TextStyleApp.font16whiteFFWeight700.copyWith(
                color: ColorApp.black,
              ),
            ),
          ],
        ),
        content: Text(
          context.translate(LangKeys.signOutMessage),
          style: TextStyleApp.font12grey6BWeight400.copyWith(
            color: ColorApp.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              context.translate(LangKeys.cancel),
              style: TextStyleApp.font12grey6BWeight400.copyWith(
                color: ColorApp.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement actual sign out
            },
            child: Text(
              context.translate(LangKeys.confirm),
              style: TextStyleApp.font12grey6BWeight400.copyWith(
                color: ColorApp.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Image.asset(
              'assets/icons/delete_account.png',
              width: 24,
              height: 24,
              color: Colors.red,
            ),
            SizedBox(width: 10.w),
            Text(
              context.translate(LangKeys.deleteAccountTitle),
              style: TextStyleApp.font16whiteFFWeight700.copyWith(
                color: ColorApp.black,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.translate(LangKeys.deleteAccountMessage),
              style: TextStyleApp.font12grey6BWeight400.copyWith(
                color: ColorApp.black,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              context.translate(LangKeys.deleteAccountWarning),
              style: TextStyleApp.font12grey6BWeight400.copyWith(
                color: Colors.red,
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              context.translate(LangKeys.cancel),
              style: TextStyleApp.font12grey6BWeight400.copyWith(
                color: ColorApp.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement actual account deletion
            },
            child: Text(
              context.translate(LangKeys.confirm),
              style: TextStyleApp.font12grey6BWeight400.copyWith(
                color: Colors.red,
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




} 