import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/language/lang_keys.dart';
import '../../../../core/theme/Color/colors.dart';

import '../widget/file_upload_button.dart';

class MaintenanceTab extends StatefulWidget {
  final String selectedUnit;
  final String chaletsId;
  final Function(List<XFile>) onImagesChanged;
  final Function(List<XFile>) onVideosChanged;
  final Function(String) onMaintenanceTimingChanged;
  final Function(String) onMaintenancePriceChanged;
  final Function(String) onMaintenanceDescriptionChanged;

  const MaintenanceTab({
    Key? key,
    required this.selectedUnit,
    required this.chaletsId,
    required this.onImagesChanged,
    required this.onVideosChanged,
    required this.onMaintenanceTimingChanged,
    required this.onMaintenancePriceChanged,
    required this.onMaintenanceDescriptionChanged,
  }) : super(key: key);

  @override
  State<MaintenanceTab> createState() => _MaintenanceTabState();
}

class _MaintenanceTabState extends State<MaintenanceTab> {
  final TextEditingController _maintenancePriceController = TextEditingController();
  final TextEditingController _maintenanceDescriptionController = TextEditingController();
  
  String _selectedMaintenanceTiming = 'before';
  List<XFile> _selectedImages = [];
  List<XFile> _selectedVideos = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _maintenancePriceController.dispose();
    _maintenanceDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildMaintenanceTimingDropdown(),
          SizedBox(height: 24.h),
          if (_selectedMaintenanceTiming == 'after') ...[
            _buildPriceField(),
            SizedBox(height: 24.h),
          ],
          _buildDescriptionField(),
          SizedBox(height: 24.h),
          _buildImageUploadSection(),
          SizedBox(height: 24.h),
          _buildVideoUploadSection(),
        ],
      ),
    );
  }

  Widget _buildMaintenanceTimingDropdown() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorApp.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: ColorApp.borderLight, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.translate(LangKeys.maintenanceTiming),
            style: TextStyle(
                fontSize: 16.sp,
                color: ColorApp.primaryBlue,
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo'),
          ),
          SizedBox(height: 16.h),
          DropdownButtonFormField<String>(
            value: _selectedMaintenanceTiming,
            isExpanded: true,
            decoration: _inputDecoration(
                hintText: context.translate(LangKeys.selectMaintenanceTiming),
                prefixIcon: Icons.schedule),
            items: [
              DropdownMenuItem<String>(
                value: 'before',
                child: Text(context.translate(LangKeys.beforeMaintenance),
                    style: _dropdownTextStyle()),
              ),
              DropdownMenuItem<String>(
                value: 'after',
                child: Text(context.translate(LangKeys.afterMaintenance),
                    style: _dropdownTextStyle()),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedMaintenanceTiming = value ?? 'before';
              });
              widget.onMaintenanceTimingChanged(_selectedMaintenanceTiming);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPriceField() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorApp.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: ColorApp.borderLight, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.translate(LangKeys.maintenancePrice),
            style: TextStyle(
                fontSize: 16.sp,
                color: ColorApp.primaryBlue,
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo'),
          ),
          SizedBox(height: 16.h),
          TextFormField(
            controller: _maintenancePriceController,
            keyboardType: TextInputType.number,
            decoration: _inputDecoration(
                hintText: context.translate(LangKeys.maintenancePriceHint),
                prefixIcon: Icons.attach_money),
            onChanged: (value) {
              // Convert Arabic numbers to English numbers
              String convertedValue = _convertArabicToEnglishNumbers(value);
              widget.onMaintenancePriceChanged(convertedValue);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.translate(LangKeys.maintenancePriceRequired);
              }
              if (double.tryParse(value) == null) {
                return context.translate(LangKeys.pleaseEnterValidPrice);
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorApp.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: ColorApp.borderLight, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.translate(LangKeys.maintenanceDescription),
            style: TextStyle(
                fontSize: 16.sp,
                color: ColorApp.primaryBlue,
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo'),
          ),
          SizedBox(height: 16.h),
          TextFormField(
            controller: _maintenanceDescriptionController,
            maxLines: 4,
            decoration: _inputDecoration(
                hintText: context.translate(LangKeys.maintenanceDescriptionHint),
                prefixIcon: Icons.description),
            onChanged: (value) {
              widget.onMaintenanceDescriptionChanged(value);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.translate(LangKeys.maintenanceDescriptionRequired);
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorApp.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: ColorApp.borderLight, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.translate(LangKeys.uploadImages),
            style: TextStyle(
                fontSize: 16.sp,
                color: ColorApp.primaryBlue,
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo'),
          ),
          SizedBox(height: 16.h),
          _buildImageSelectionSection(),
        ],
      ),
    );
  }

  Widget _buildImageSelectionSection() {
    return Column(
      children: [
        if (_selectedImages.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${context.translate(LangKeys.selectedImages)} (${_selectedImages.length})',
                style: TextStyle(
                    fontSize: 14.sp,
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo'),
              ),
              GestureDetector(
                onTap: () {
                  setState(() => _selectedImages.clear());
                  widget.onImagesChanged(_selectedImages);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(context.translate(LangKeys.allImagesDeleted)),
                    backgroundColor: ColorApp.warning,
                    duration: const Duration(seconds: 2),
                  ));
                },
                child: Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .error
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                          color: Theme.of(context).colorScheme.error,
                          width: 1)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.delete_sweep,
                        color: Theme.of(context).colorScheme.error,
                        size: 16.sp),
                    SizedBox(width: 4.w),
                    Text('حذف الكل',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Cairo'))
                  ]),
                ),
              )
            ],
          ),
          SizedBox(height: 12.h),
          GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.w,
                  mainAxisSpacing: 8.h,
                  childAspectRatio: 1.0),
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) => Stack(children: [
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        image: DecorationImage(
                            image: FileImage(
                                File(_selectedImages[index].path)),
                            fit: BoxFit.cover))),
                Positioned(
                    top: 4.h,
                    right: 4.w,
                    child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedImages.removeAt(index));
                          widget.onImagesChanged(_selectedImages);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(context.translate(LangKeys.deleteImage)),
                            backgroundColor: ColorApp.warning,
                            duration: const Duration(seconds: 1),
                          ));
                        },
                        child: Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                                color:
                                Theme.of(context).colorScheme.error,
                                shape: BoxShape.circle),
                            child: Icon(Icons.close,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary,
                                size: 12.sp))))
              ]))
        ],
        SizedBox(height: 16.h),
        FileUploadButton(
          onTap: _selectImages,
          icon: Icons.add_photo_alternate,
          title: context.translate(LangKeys.addMultipleImages),
          subtitle: context.translate(LangKeys.pressToSelectImages),
          height: 110.h,
        )
      ],
    );
  }

  void _selectImages() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images);
        });
        widget.onImagesChanged(_selectedImages);
      }
    } catch (e) {
      // Handle error
    }
  }

  Widget _buildVideoUploadSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorApp.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: ColorApp.borderLight, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.translate(LangKeys.uploadVideos),
            style: TextStyle(
                fontSize: 16.sp,
                color: ColorApp.primaryBlue,
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo'),
          ),
          SizedBox(height: 16.h),
          _buildVideoSelectionSection(),
        ],
      ),
    );
  }

  Widget _buildVideoSelectionSection() {
    return Column(
      children: [
        if (_selectedVideos.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${context.translate(LangKeys.selectedVideos)} (${_selectedVideos.length})',
                style: TextStyle(
                    fontSize: 14.sp,
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo'),
              ),
              GestureDetector(
                onTap: () {
                  setState(() => _selectedVideos.clear());
                  widget.onVideosChanged(_selectedVideos);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(context.translate(LangKeys.allVideosDeleted)),
                    backgroundColor: ColorApp.warning,
                    duration: const Duration(seconds: 2),
                  ));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Theme.of(context).colorScheme.error, width: 1),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.delete_sweep, color: Theme.of(context).colorScheme.error, size: 16.sp),
                    SizedBox(width: 4.w),
                    Text('حذف الكل', style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12.sp, fontWeight: FontWeight.w600, fontFamily: 'Cairo')),
                  ]),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _selectedVideos.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: Theme.of(context).dividerColor, width: 1),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(Icons.video_file, color: Theme.of(context).colorScheme.primary, size: 24.sp),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedVideos[index].name,
                            style: TextStyle(fontSize: 14.sp, color: Theme.of(context).colorScheme.onBackground, fontWeight: FontWeight.w600, fontFamily: 'Cairo'),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '00:30', // Consider making this dynamic
                            style: TextStyle(fontSize: 12.sp, color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7), fontFamily: 'Cairo'),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedVideos.removeAt(index);
                        });
                        widget.onVideosChanged(_selectedVideos);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(context.translate(LangKeys.deleteVideo)),
                          backgroundColor: ColorApp.warning,
                          duration: const Duration(seconds: 1),
                        ));
                      },
                      child: Icon(Icons.close, color: Theme.of(context).colorScheme.error, size: 20.sp),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 16.h),
        ],
        FileUploadButton(
          onTap: _selectVideos,
          icon: Icons.video_library,
          title: context.translate(LangKeys.addVideo),
          subtitle: context.translate(LangKeys.pressToSelectVideo),
          height: 110.h,
        )
      ],
    );
  }

  void _selectVideos() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        setState(() {
          _selectedVideos.add(video);
        });
        widget.onVideosChanged(_selectedVideos);
      }
    } catch (e) {
      // Handle error
    }
  }

  InputDecoration _inputDecoration({required String hintText, required IconData prefixIcon}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
          fontSize: 14.sp,
          color: Colors.grey,
          fontFamily: 'Cairo'),
      prefixIcon: Icon(prefixIcon, color: ColorApp.primaryBlue),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: ColorApp.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: ColorApp.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: ColorApp.primaryBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    );
  }

  TextStyle _dropdownTextStyle() {
    return TextStyle(
        fontSize: 14.sp,
        color: ColorApp.primaryBlue,
        fontWeight: FontWeight.w600,
        fontFamily: 'Cairo');
  }

  String _convertArabicToEnglishNumbers(String text) {
    return text
        .replaceAll('٠', '0')
        .replaceAll('١', '1')
        .replaceAll('٢', '2')
        .replaceAll('٣', '3')
        .replaceAll('٤', '4')
        .replaceAll('٥', '5')
        .replaceAll('٦', '6')
        .replaceAll('٧', '7')
        .replaceAll('٨', '8')
        .replaceAll('٩', '9');
  }
}
