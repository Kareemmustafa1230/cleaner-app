import 'package:diyar/features/setting/logic/cubit/update_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import '../../../../core/language/lang_keys.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/shared_pref_helper.dart';
import '../../../../core/networking/constants/api_constants.dart';
import '../../../../core/networking/di/dependency_injection.dart';
import '../../logic/state/update_profile_state.dart';
import '../widget/profile_widget/profile_header_widget.dart';
import '../widget/profile_widget/profile_info_card_widget.dart';
import '../widget/profile_widget/profile_input_fields_widget.dart';
import '../widget/profile_widget/profile_save_button_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<SlideActionState> _slideActionKey = GlobalKey<SlideActionState>();

  bool _isEditing = false;
  bool _isDataLoaded = false;
  XFile? _selectedImage;
  String? _currentImagePath;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late UpdateProfileCubit _updateProfileCubit;

  @override
  void initState() {
    super.initState();
    _updateProfileCubit = getIt<UpdateProfileCubit>();

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

      if (userDataString != null && userDataString.isNotEmpty) {
        final userData = jsonDecode(userDataString);
        print('📋 تم تحميل بيانات المستخدم: $userData');

        _nameController.text = userData['name'] ?? '';
        _emailController.text = userData['email'] ?? '';
        _phoneController.text = userData['phone'] ?? '';
        _addressController.text = userData['address'] ?? '';
        _currentImagePath = userData['image'];

        _updateProfileCubit.nameController.text = userData['name'] ?? '';
        _updateProfileCubit.emailController.text = userData['email'] ?? '';
        _updateProfileCubit.phoneController.text = userData['phone'] ?? '';
        _updateProfileCubit.addressController.text = userData['address'] ?? '';

        setState(() {
          _isDataLoaded = true;
        });
      } else {
        _setDefaultData();
      }
    } catch (e) {
      print('❌ خطأ في تحميل بيانات المستخدم: $e');
      _setDefaultData();
    }
  }

  void _setDefaultData() {
    final defaultData = {
      'name': 'أحمد محمد',
      'email': 'ahmed@example.com',
      'phone': '+966501234567',
      'address': 'الرياض، المملكة العربية السعودية'
    };

    _nameController.text = defaultData['name']!;
    _emailController.text = defaultData['email']!;
    _phoneController.text = defaultData['phone']!;
    _addressController.text = defaultData['address']!;

    _updateProfileCubit.nameController.text = defaultData['name']!;
    _updateProfileCubit.emailController.text = defaultData['email']!;
    _updateProfileCubit.phoneController.text = defaultData['phone']!;
    _updateProfileCubit.addressController.text = defaultData['address']!;

    setState(() {
      _isDataLoaded = true;
    });
  }

  void _syncDataToCubit() {
    _updateProfileCubit.nameController.text = _nameController.text;
    _updateProfileCubit.emailController.text = _emailController.text;
    _updateProfileCubit.phoneController.text = _phoneController.text;
    _updateProfileCubit.addressController.text = _addressController.text;
    _updateProfileCubit.setSelectedImage(_selectedImage);
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          height: 120.h,
          padding: EdgeInsets.all(16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    setState(() {
                      _selectedImage = image;
                    });
                  }
                },
                child: Column(
                  children: [
                    Icon(Icons.camera_alt, size: 32.sp),
                    SizedBox(height: 8.h),
                                            Text(context.translate(LangKeys.camera), style: TextStyle(fontSize: 14.sp)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      _selectedImage = image;
                    });
                  }
                },
                child: Column(
                  children: [
                    Icon(Icons.photo_library, size: 32.sp),
                    SizedBox(height: 8.h),
                                            Text(context.translate(LangKeys.gallery), style: TextStyle(fontSize: 14.sp)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      print('خطأ في اختيار الصورة: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: _updateProfileCubit,
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: BlocListener<UpdateProfileCubit, UpdateProfileState>(
          listener: (context, state) {
            state.when(
              initial: () {},
              loading: () {},
              success: (response) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white, size: 20.sp),
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

                _updateLocalDataFromResponse(response.data);

                setState(() {
                  _isEditing = false;
                  _selectedImage = null;
                });

                Future.delayed(const Duration(seconds: 1), () {
                  if (mounted) {
                    _slideActionKey.currentState?.reset();
                  }
                });
              },
              error: (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.white, size: 20.sp),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            error,
                            style: TextStyle(fontFamily: 'Cairo'),
                          ),
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
              },
            );
          },
          child: CustomScrollView(
            slivers: [
              ProfileHeaderWidget(
                fadeAnimation: _fadeAnimation,
                name: _nameController.text,
                email: _emailController.text,
                image: _getProfileImage(),
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
                onImagePressed: _isEditing ? _pickImage : null,
              ),

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
                              BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
                                builder: (context, state) {
                                  final isLoading = state.maybeWhen(
                                    loading: () => true,
                                    orElse: () => false,
                                  );

                                  return ProfileSaveButtonWidget(
                                    isLoading: isLoading,
                                    onSavePressed: _handleSaveProfile,
                                    slideActionKey: _slideActionKey,
                                  );
                                },
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
        ),
      ),
    );
  }

  ImageProvider? _getProfileImage() {
    if (_selectedImage != null) {
      return FileImage(File(_selectedImage!.path));
    } else if (_currentImagePath != null && _currentImagePath!.isNotEmpty) {
      if (_currentImagePath!.startsWith('http')) {
        return NetworkImage(_currentImagePath!);
      } else {
        return FileImage(File(_currentImagePath!));
      }
    }
    return null;
  }

  void _updateLocalDataFromResponse(dynamic responseData) {
    if (responseData != null) {
      _nameController.text = responseData.name ?? _nameController.text;
      _emailController.text = responseData.email ?? _emailController.text;
      _phoneController.text = responseData.phone ?? _phoneController.text;
      _addressController.text = responseData.address ?? _addressController.text;
      _currentImagePath = responseData.image;
    }
  }

  Future<void> _handleSaveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _syncDataToCubit();

    print('🔄 بدء عملية تحديث الملف الشخصي');
    print('📝 البيانات المرسلة:');
    print('الاسم: ${_nameController.text}');
    print('البريد الإلكتروني: ${_emailController.text}');
    print('الهاتف: ${_phoneController.text}');
    print('العنوان: ${_addressController.text}');
    print('الصورة: ${_selectedImage?.path ?? 'لا توجد صورة جديدة'}');

    await _updateProfileCubit.emitUpdateProfileState();
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