import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/Color/colors.dart';
import '../../../../core/theme/text_style/text_style.dart';
import '../../../../core/language/app_localizations.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/widget/image_picker.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final TextEditingController _apartmentController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  String _selectedMediaType = 'cleanliness';
  List<String> _selectedImages = [];
  List<String> _selectedVideos = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _apartmentController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        title: Text(
          localizations?.translate('uploadMedia') ?? 'رفع الوسائط',
          style: TextStyleApp.font20black00Weight700,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // اختيار نوع الوسائط
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
                      localizations?.translate('mediaType') ?? 'نوع الوسائط',
                      style: TextStyleApp.font16black00Weight700,
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMediaTypeButton(
                            title: localizations?.translate('cleanlinessMedia') ?? 'وسائط النظافة',
                            icon: Icons.cleaning_services,
                            isSelected: _selectedMediaType == 'cleanliness',
                            onTap: () {
                              setState(() {
                                _selectedMediaType = 'cleanliness';
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildMediaTypeButton(
                            title: localizations?.translate('damagesMedia') ?? 'وسائط التلفيات',
                            icon: Icons.build,
                            isSelected: _selectedMediaType == 'damages',
                            onTap: () {
                              setState(() {
                                _selectedMediaType = 'damages';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              
              // اختيار الشقة
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
                      localizations?.translate('selectApartment') ?? 'اختر الشقة',
                      style: TextStyleApp.font16black00Weight700,
                    ),
                    SizedBox(height: 12.h),
                    DropdownButtonFormField<String>(
                      value: _apartmentController.text.isEmpty ? null : _apartmentController.text,
                      decoration: InputDecoration(
                        hintText: localizations?.translate('selectApartment') ?? 'اختر الشقة',
                        hintStyle: TextStyleApp.font15greyC1Weight600,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(color: Theme.of(context).dividerColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(color: Theme.of(context).dividerColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: '1',
                          child: Text('شقة 101'),
                        ),
                        DropdownMenuItem(
                          value: '2',
                          child: Text('شقة 102'),
                        ),
                        DropdownMenuItem(
                          value: '3',
                          child: Text('شقة 103'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _apartmentController.text = value ?? '';
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              
              // وصف المحتوى
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
                      localizations?.translate('description') ?? 'الوصف',
                      style: TextStyleApp.font16black00Weight700,
                    ),
                    SizedBox(height: 12.h),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: localizations?.translate('enterDescription') ?? 'أدخل وصف المحتوى...',
                        hintStyle: TextStyleApp.font15greyC1Weight600,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(color: Theme.of(context).dividerColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(color: Theme.of(context).dividerColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              
              // رفع الصور
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
                      localizations?.translate('images') ?? 'الصور',
                      style: TextStyleApp.font16black00Weight700,
                    ),
                    SizedBox(height: 12.h),
                    _buildImageUploadSection(),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              
              // رفع الفيديوهات
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
                      localizations?.translate('videos') ?? 'الفيديوهات',
                      style: TextStyleApp.font16black00Weight700,
                    ),
                    SizedBox(height: 12.h),
                    _buildVideoUploadSection(),
                  ],
                ),
              ),
              SizedBox(height: 32.h),
              
              // زر الرفع
              Container(
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
                    onTap: _isLoading ? null : _handleUpload,
                    child: Center(
                      child: _isLoading
                          ? SizedBox(
                              height: 24.h,
                              width: 24.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.w,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            )
                          : Text(
                              localizations?.translate('upload') ?? 'رفع المحتوى',
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
      ),
    );
  }

  Widget _buildMediaTypeButton({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).dividerColor,
          width: 2.w,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.primary,
                  size: 24.sp,
                ),
                SizedBox(height: 4.h),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.primary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: TextStyleApp.font16black00Weight700.fontFamily,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 120.h,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).dividerColor,
              width: 2.w,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10.r),
              onTap: () {
                // فتح معرض الصور
                _selectImages();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32.sp,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'إضافة صور',
                    style: TextStyleApp.font16black00Weight700,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_selectedImages.isNotEmpty) ...[
          SizedBox(height: 16.h),
          SizedBox(
            height: 100.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 100.w,
                  margin: EdgeInsets.only(right: 8.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    image: DecorationImage(
                      image: AssetImage(_selectedImages[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 4.h,
                        right: 4.w,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedImages.removeAt(index);
                            });
                          },
                          child: Container(
                            width: 24.w,
                            height: 24.h,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: 16.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildVideoUploadSection() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 120.h,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).dividerColor,
              width: 2.w,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10.r),
              onTap: () {
                // فتح معرض الفيديوهات
                _selectVideos();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.video_library,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32.sp,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'إضافة فيديوهات',
                    style: TextStyleApp.font16black00Weight700,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_selectedVideos.isNotEmpty) ...[
          SizedBox(height: 16.h),
          SizedBox(
            height: 100.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedVideos.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 100.w,
                  margin: EdgeInsets.only(right: 8.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          Icons.play_circle,
                          color: Theme.of(context).colorScheme.primary,
                          size: 32.sp,
                        ),
                      ),
                      Positioned(
                        top: 4.h,
                        right: 4.w,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedVideos.removeAt(index);
                            });
                          },
                          child: Container(
                            width: 24.w,
                            height: 24.h,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: 16.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  void _selectImages() {
    // محاكاة اختيار الصور
    setState(() {
      _selectedImages.addAll([
        'assets/images/car_image.png',
        'assets/images/car_road.png',
        'assets/images/car.png',
      ]);
    });
  }

  void _selectVideos() {
    // محاكاة اختيار الفيديوهات
    setState(() {
      _selectedVideos.addAll([
        'assets/videos/sample1.mp4',
        'assets/videos/sample2.mp4',
      ]);
    });
  }

  void _handleUpload() {
    if (_formKey.currentState!.validate()) {
      if (_apartmentController.text.isEmpty) {
        final localizations = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations?.translate('pleaseSelectApartment') ?? 'يرجى اختيار الشقة'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

              // محاكاة عملية الرفع
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _isLoading = false;
          });
          
          final localizations = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations?.translate('uploadSuccessfully') ?? 'تم رفع المحتوى بنجاح'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        });
    }
  }
} 