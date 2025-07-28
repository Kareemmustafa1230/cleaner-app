import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:local_auth/local_auth.dart';
import '../../../../core/theme/text_style/text_style.dart';
import '../../../../core/language/app_localizations.dart';
import '../../../../core/language/lang_keys.dart';
import '../../../../core/widget/app_text_form_field.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/biometric_auth_helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController(text: 'أحمد محمد');
  final TextEditingController _emailController = TextEditingController(text: 'ahmed@example.com');
  final TextEditingController _phoneController = TextEditingController(text: '+966501234567');
  final TextEditingController _addressController = TextEditingController(text: 'الرياض، المملكة العربية السعودية');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<SlideActionState> _slideActionKey = GlobalKey<SlideActionState>();
  
  bool _isLoading = false;
  bool _isEditing = false;
  bool _isBiometricEnabled = false;
  bool _isBiometricAvailable = false;
  
  final LocalAuthentication _localAuth = LocalAuthentication();
  final BiometricAuthHelper _biometricHelper = BiometricAuthHelper();
  
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
    _checkBiometricAvailability();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: CustomScrollView(
        slivers: [
          // App Bar مع تصميم مخصص
          SliverAppBar(
            expandedHeight: 250.h,
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
          context.translate(LangKeys.profile),
          style: TextStyleApp.font20black00Weight700.copyWith(
                color: theme.colorScheme.onPrimary,
                fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
        actions: [
              Container(
                margin: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: IconButton(
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
                    if (_isEditing) {
                      _animationController.forward();
                    }
            },
            icon: Icon(
              _isEditing ? Icons.close : Icons.edit,
                    color: theme.colorScheme.onPrimary,
                    size: 20.sp,
                  ),
            ),
          ),
        ],
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
                    // صورة الملف الشخصي المحسنة
                    FadeTransition(
                      opacity: _fadeAnimation,
                child: Stack(
                  children: [
                    Container(
                            width: 100.w,
                            height: 100.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                              color: theme.colorScheme.onPrimary.withOpacity(0.2),
                              border: Border.all(
                                color: theme.colorScheme.onPrimary,
                                width: 3.w,
                              ),
                        boxShadow: [
                          BoxShadow(
                                  color: theme.colorScheme.onPrimary.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.person,
                              size: 50.sp,
                              color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    if (_isEditing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                                width: 35.w,
                                height: 35.h,
                          decoration: BoxDecoration(
                                  color: theme.colorScheme.secondary,
                            shape: BoxShape.circle,
                            border: Border.all(
                                    color: theme.colorScheme.onPrimary,
                                    width: 2.w,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.colorScheme.shadow,
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                          ),
                          child: Icon(
                            Icons.camera_alt,
                                  size: 18.sp,
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      _nameController.text,
                      style: TextStyleApp.font16black00Weight700.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 18.sp,
                      ),
                    ),
                    Text(
                      _emailController.text,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: theme.colorScheme.onPrimary.withOpacity(0.8),
                        fontFamily: 'Cairo',
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          
          // محتوى الصفحة
          SliverToBoxAdapter(
            child: FadeTransition(
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
                        _buildInfoCard(theme, localizations),
                        SizedBox(height: 20.h),
                        _buildInputFields(theme),
                        SizedBox(height: 20.h),
                        _buildSettingsCard(theme, localizations),
                        SizedBox(height: 20.h),
                        if (_isEditing) _buildSaveButton(theme),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(ThemeData theme, AppLocalizations? localizations) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.account_circle,
                  color: theme.colorScheme.primary,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.translate(LangKeys.accountInfo),
                      style: TextStyleApp.font16black00Weight700.copyWith(
                        color: theme.colorScheme.onBackground,
                        fontSize: 16.sp,
                      ),
                    ),
                    Text(
                      context.translate(LangKeys.editAccountInfo),
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: theme.colorScheme.onBackground.withOpacity(0.6),
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputFields(ThemeData theme) {
    return Column(
      children: [
        _buildInputField(
                controller: _nameController,
                hintText: context.translate(LangKeys.fullName),
          icon: Icons.person_outline,
          theme: theme,
              ),
              SizedBox(height: 16.h),
        _buildInputField(
                controller: _emailController,
                hintText: context.translate(LangKeys.email),
          icon: Icons.email_outlined,
          textInputType: TextInputType.emailAddress,
          theme: theme,
        ),
        SizedBox(height: 16.h),
        _buildInputField(
          controller: _phoneController,
          hintText: context.translate(LangKeys.phoneNumber),
          icon: Icons.phone_outlined,
          textInputType: TextInputType.phone,
          theme: theme,
        ),
        SizedBox(height: 16.h),
        _buildInputField(
          controller: _addressController,
          hintText: context.translate(LangKeys.address),
          icon: Icons.location_on_outlined,
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required ThemeData theme,
    TextInputType? textInputType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormFieldApp(
        controller: controller,
        hintText: hintText,
                readOnly: !_isEditing,
        textInputType: textInputType,
        background: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
                contentPadding: EdgeInsetsDirectional.symmetric(
                  horizontal: 20.w,
                  vertical: 18.h,
                ),
        prefixIcon: Icon(
          icon,
          color: theme.colorScheme.primary,
          size: 20.sp,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
            return '${context.translate(LangKeys.pleaseEnter)} $hintText';
                  }
          if (textInputType == TextInputType.emailAddress) {
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return context.translate(LangKeys.pleaseEnterValidEmail);
            }
                  }
                  return null;
                },
              ),
    );
  }




  Widget _buildSettingsCard(ThemeData theme, AppLocalizations? localizations) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.settings,
                  color: theme.colorScheme.secondary,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                context.translate(LangKeys.settings),
                style: TextStyleApp.font16black00Weight700.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          
          // إعداد البصمة
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.background,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.fingerprint,
                    color: theme.colorScheme.primary,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.translate(LangKeys.biometricAuth),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      Text(
                        _isBiometricAvailable 
                            ? context.translate(LangKeys.biometricAuthDesc)
                            : context.translate(LangKeys.biometricNotAvailable),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
                                 if (_isBiometricAvailable)
                   Row(
                     children: [
                       Switch(
                         value: _isBiometricEnabled,
                                                onChanged: (value) async {
                         if (value) {
                           await _authenticateWithBiometrics();
                         } else {
                           await _biometricHelper.disableBiometric();
                           setState(() {
                             _isBiometricEnabled = false;
                           });
                           ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(
                               content: Row(
                                 children: [
                                   Icon(
                                     Icons.fingerprint,
                                     color: Colors.white,
                                     size: 20.sp,
                                   ),
                                   SizedBox(width: 8.w),
                                   Text(
                                     context.translate(LangKeys.biometricDisabled),
                                     style: TextStyle(fontFamily: 'Cairo'),
                                   ),
                                 ],
                               ),
                               backgroundColor: Theme.of(context).colorScheme.error,
                               duration: const Duration(seconds: 3),
                               behavior: SnackBarBehavior.floating,
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(12.r),
                               ),
                             ),
                           );
                         }
                       },
                         activeColor: theme.colorScheme.primary,
                         activeTrackColor: theme.colorScheme.primary.withValues(alpha: 0.3),
                       ),
                       SizedBox(width: 8.w),
                       IconButton(
                         onPressed: () async {
                           final bool success = await _biometricHelper.authenticate();
                           if (mounted) {
                             ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(
                                 content: Row(
                                   children: [
                                     Icon(
                                       success ? Icons.check_circle : Icons.error_outline,
                                       color: Colors.white,
                                       size: 20.sp,
                                     ),
                                     SizedBox(width: 8.w),
                                     Text(
                                       success ? context.translate(LangKeys.biometricSuccess) : context.translate(LangKeys.biometricFailed),
                                       style: TextStyle(fontFamily: 'Cairo'),
                                     ),
                                   ],
                                 ),
                                 backgroundColor: success 
                                     ? Theme.of(context).colorScheme.secondary
                                     : Theme.of(context).colorScheme.error,
                                 duration: const Duration(seconds: 3),
                                 behavior: SnackBarBehavior.floating,
                                 shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(12.r),
                                 ),
                               ),
                             );
                           }
                         },
                         icon: Icon(
                           Icons.fingerprint,
                           color: theme.colorScheme.primary,
                           size: 20.sp,
                         ),
                         tooltip: context.translate(LangKeys.testFingerprint),
                       ),
                     ],
                   )
                else
                  Icon(
                    Icons.info_outline,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    size: 20.sp,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      child: SlideAction(
        key: _slideActionKey,
        height: 56.h,
        borderRadius: 16.r,
        elevation: 0,
        innerColor: theme.colorScheme.primary,
        outerColor: theme.colorScheme.secondary,
        sliderButtonIcon: _isLoading
            ? SizedBox(
                height: 20.h,
                width: 20.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.onPrimary,
                  ),
                ),
              )
            : Icon(
                Icons.arrow_forward_ios,
                color: theme.colorScheme.onPrimary,
                size: 20.sp,
              ),
        sliderButtonIconPadding: 12.w,
        sliderButtonIconSize: 24.sp,
        text: _isLoading ? context.translate(LangKeys.saving) : context.translate(LangKeys.slideToSave),
        textStyle: TextStyle(
          color: theme.colorScheme.onBackground,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          fontFamily: 'Cairo',
        ),
        onSubmit: () async {
          if (_isLoading) return;
          await _handleSaveProfile();
        },
        animationDuration: const Duration(milliseconds: 300),
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

  Future<void> _checkBiometricAvailability() async {
    try {
      final bool isAvailable = await _biometricHelper.isBiometricAvailable();
      final bool isEnabled = await _biometricHelper.isBiometricEnabled();
      
      if (mounted) {
        setState(() {
          _isBiometricAvailable = isAvailable;
          _isBiometricEnabled = isEnabled;
        });
      }
      
      // حفظ حالة التوفر
      await _biometricHelper.saveBiometricAvailability(isAvailable);
      
      // عرض أنواع البصمة المتوفرة (اختياري)
      if (isAvailable) {
        final List<BiometricType> availableBiometrics = await _biometricHelper.getAvailableBiometrics();
        print('أنواع البصمة المتوفرة: $availableBiometrics');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isBiometricAvailable = false;
          _isBiometricEnabled = false;
        });
      }
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'يرجى المصادقة باستخدام البصمة أو الوجه للدخول',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (mounted) {
        if (didAuthenticate) {
          setState(() {
            _isBiometricEnabled = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.fingerprint,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'تم تفعيل المصادقة البيومترية بنجاح',
                    style: TextStyle(fontFamily: 'Cairo'),
                  ),
                ],
              ),
              backgroundColor: Theme.of(context).colorScheme.secondary,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          );
        } else {
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
                    'فشلت المصادقة البيومترية',
                    style: TextStyle(fontFamily: 'Cairo'),
                  ),
                ],
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
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
                  'حدث خطأ في المصادقة البيومترية',
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
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