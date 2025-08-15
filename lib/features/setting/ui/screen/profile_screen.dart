import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'dart:convert';
import '../../../../core/theme/text_style/text_style.dart';
import '../../../../core/language/app_localizations.dart';
import '../../../../core/language/lang_keys.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/shared_pref_helper.dart';
import '../../../../core/networking/constants/api_constants.dart';
import '../../../../core/networking/di/dependency_injection.dart';
import '../widget/profile_widget/profile_header_widget.dart';
import '../widget/profile_widget/profile_info_card_widget.dart';
import '../widget/profile_widget/profile_input_fields_widget.dart';
import '../widget/profile_widget/profile_save_button_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<SlideActionState> _slideActionKey = GlobalKey<SlideActionState>();
  
  bool _isLoading = false;
  bool _isEditing = false;
  bool _isDataLoaded = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final sharedPref = getIt<SharedPrefHelper>();
      final userDataString = await sharedPref.getData(key: ApiKey.userData);
      
      print('🔍 محاولة تحميل بيانات المستخدم: $userDataString');
      
      if (userDataString != null && userDataString.isNotEmpty) {
        final userData = jsonDecode(userDataString);
        print('📋 بيانات المستخدم المحملة: $userData');
        
        // تحديث البيانات مباشرة في Controllers
        _nameController.text = userData['name'] ?? '';
        _emailController.text = userData['email'] ?? '';
        _phoneController.text = userData['phone'] ?? '';
        _addressController.text = userData['address'] ?? '';
        
        // تحديث الحالة
        setState(() {
          _isDataLoaded = true;
        });

      } else {

        _nameController.text = 'أحمد محمد';
        _emailController.text = 'ahmed@example.com';
        _phoneController.text = '+966501234567';
        _addressController.text = 'الرياض، المملكة العربية السعودية';
        
        setState(() {
          _isDataLoaded = true;
        });
      }
    } catch (e) {
      print('❌ خطأ في تحميل بيانات المستخدم: $e');
      // في حالة الخطأ، استخدم بيانات افتراضية
      _nameController.text = 'أحمد محمد';
      _emailController.text = 'ahmed@example.com';
      _phoneController.text = '+966501234567';
      _addressController.text = 'الرياض، المملكة العربية السعودية';
      
      setState(() {
        _isDataLoaded = true;
      });
    }
  }

    @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: CustomScrollView(
        slivers: [
          // Header Widget
          ProfileHeaderWidget(
            fadeAnimation: _fadeAnimation,
            nameController: _nameController,
            emailController: _emailController,
            isEditing: _isEditing,
            onBackPressed: () => Navigator.pop(context),
            onEditPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
              if (_isEditing) {
                _animationController.forward();
              }
            },
          ),
          
          // محتوى الصفحة
          SliverToBoxAdapter(
            child: _isDataLoaded 
              ? FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const ProfileInfoCardWidget(),
                            SizedBox(height: 20.h),
                            ProfileInputFieldsWidget(
                              nameController: _nameController,
                              emailController: _emailController,
                              phoneController: _phoneController,
                              addressController: _addressController,
                              isEditing: _isEditing,
                            ),
                            SizedBox(height: 20.h),
                            if (_isEditing) 
                              ProfileSaveButtonWidget(
                                isLoading: _isLoading,
                                onSavePressed: _handleSaveProfile,
                                slideActionKey: _slideActionKey,
                              ),
                            SizedBox(height: 30.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(height: 100.h),
                        CircularProgressIndicator(
                          color: theme.colorScheme.primary,
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          'جاري تحميل البيانات...',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: theme.colorScheme.onBackground,
                            fontFamily: 'Cairo',
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
  
  

  Future<void> _handleSaveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // حفظ البيانات المحدثة في SharedPreferences
      final sharedPref = getIt<SharedPrefHelper>();
      final currentUserDataString = await sharedPref.getData(key: ApiKey.userData);
      
      print('💾 محاولة حفظ بيانات الملف الشخصي المحدثة');
      
      if (currentUserDataString != null && currentUserDataString.isNotEmpty) {
        final currentUserData = jsonDecode(currentUserDataString);
        print('📋 البيانات الحالية: $currentUserData');
        
        // تحديث البيانات
        final updatedUserData = {
          ...currentUserData,
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'address': _addressController.text.trim(),
        };
        
        print('📝 البيانات المحدثة: $updatedUserData');
        
        // حفظ البيانات المحدثة
        await sharedPref.saveData(
          key: ApiKey.userData,
          value: jsonEncode(updatedUserData),
        );
        
        print('✅ تم حفظ البيانات المحدثة بنجاح');
      } else {
        print('⚠️ لم يتم العثور على بيانات المستخدم الحالية');
      }
      
      // محاكاة طلب تحديث الملف الشخصي
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        final theme = Theme.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  context.translate(LangKeys.changesSaved),
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
              ],
            ),
            backgroundColor: theme.colorScheme.secondary,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
        setState(() {
          _isEditing = false;
        });
        // إعادة تعيين SlideAction
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            _slideActionKey.currentState?.reset();
          }
        });
      }
    } catch (e) {
      print('خطأ في حفظ بيانات الملف الشخصي: $e');
      if (mounted) {
        final theme = Theme.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.white,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'حدث خطأ في حفظ التغييرات',
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
              ],
            ),
            backgroundColor: theme.colorScheme.error,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }



  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _animationController.dispose();
    super.dispose();
  }
} 