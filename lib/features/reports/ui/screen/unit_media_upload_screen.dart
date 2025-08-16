import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/Color/colors.dart';
import '../../../../core/widget/image_picker.dart';
import '../../../../core/language/lang_keys.dart';
import '../../../../core/helpers/extensions.dart';

class UnitMediaUploadScreen extends StatefulWidget {
  final Map<String, String>? selectedUnit;
  const UnitMediaUploadScreen({super.key, this.selectedUnit});

  @override
  State<UnitMediaUploadScreen> createState() => _UnitMediaUploadScreenState();
}

class _UnitMediaUploadScreenState extends State<UnitMediaUploadScreen> {
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _cleaningPriceController = TextEditingController();
  final TextEditingController _damagePriceController = TextEditingController();
  final TextEditingController _maintenancePriceController = TextEditingController();
  final TextEditingController _pestControlPriceController = TextEditingController();
  final TextEditingController _maintenanceDescriptionController = TextEditingController();
  final TextEditingController _pestControlDescriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  String _selectedMediaType = 'cleanliness';
  String _selectedUnit = '';
  String _selectedCleaningType = '';
  
  // المخزون - الحاجات المستخدمة (الكمية المستخدمة من كل حاجة)
  Map<String, int> _usedItems = {};
  
  // توقيت النظافة (الافتراضي: قبل النظافة)
  String _selectedCleaningTiming = 'before';
  
  // توقيت الصيانة (الافتراضي: قبل الصيانة)
  String _selectedMaintenanceTiming = 'before';
  
  // توقيت المبيدات الحشرية (الافتراضي: قبل المبيدات الحشرية)
  String _selectedPestControlTiming = 'before';
  
  // وسائط النظافة
  List<XFile> _cleanlinessImages = [];
  List<XFile> _cleanlinessVideos = [];
  
  // وسائط التلفيات
  List<XFile> _damagesImages = [];
  List<XFile> _damagesVideos = [];
  
  // وسائط الموبيدات الحشرية
  List<XFile> _pestControlImages = [];
  List<XFile> _pestControlVideos = [];
  
  // وسائط الصيانة
  List<XFile> _maintenanceImages = [];
  List<XFile> _maintenanceVideos = [];
  
  bool _isLoading = false;

  // دوال مساعدة للحصول على القوائم الصحيحة
  List<XFile> get _selectedImages {
    switch (_selectedMediaType) {
      case 'cleanliness':
        return _cleanlinessImages;
      case 'damages':
        return _damagesImages;
      case 'pestControl':
        return _pestControlImages;
      case 'maintenance':
        return _maintenanceImages;
      default:
        return _cleanlinessImages;
    }
  }
  
  List<XFile> get _selectedVideos {
    switch (_selectedMediaType) {
      case 'cleanliness':
        return _cleanlinessVideos;
      case 'damages':
        return _damagesVideos;
      case 'pestControl':
        return _pestControlVideos;
      case 'maintenance':
        return _maintenanceVideos;
      default:
        return _cleanlinessVideos;
    }
  }
  
  set _selectedImages(List<XFile> value) {
    switch (_selectedMediaType) {
      case 'cleanliness':
        _cleanlinessImages = value;
        break;
      case 'damages':
        _damagesImages = value;
        break;
      case 'pestControl':
        _pestControlImages = value;
        break;
      case 'maintenance':
        _maintenanceImages = value;
        break;
    }
  }
  
  set _selectedVideos(List<XFile> value) {
    switch (_selectedMediaType) {
      case 'cleanliness':
        _cleanlinessVideos = value;
        break;
      case 'damages':
        _damagesVideos = value;
        break;
      case 'pestControl':
        _pestControlVideos = value;
        break;
      case 'maintenance':
        _maintenanceVideos = value;
        break;
    }
  }

  List<Map<String, String>> get _units {
    return [
      {'id': '1', 'name': '${context.translate(LangKeys.apartmentNumber)} 101', 'building': '${context.translate(LangKeys.building)} أ'},
      {'id': '2', 'name': '${context.translate(LangKeys.apartmentNumber)} 102', 'building': '${context.translate(LangKeys.building)} أ'},
      {'id': '3', 'name': '${context.translate(LangKeys.apartmentNumber)} 201', 'building': '${context.translate(LangKeys.building)} ب'},
      {'id': '4', 'name': '${context.translate(LangKeys.apartmentNumber)} 202', 'building': '${context.translate(LangKeys.building)} ب'},
      {'id': '5', 'name': '${context.translate(LangKeys.apartmentNumber)} 301', 'building': '${context.translate(LangKeys.building)} ج'},
      {'id': '6', 'name': '${context.translate(LangKeys.apartmentNumber)} 302', 'building': '${context.translate(LangKeys.building)} ج'},
  ];
  }

  // قائمة الحاجات المتاحة في المخزون
  List<Map<String, String>> get _availableItems {
    return [
      {'id': 'detergent_1', 'name': 'منظف أرضيات', 'category': 'detergents'},
      {'id': 'detergent_2', 'name': 'منظف حمامات', 'category': 'detergents'},
      {'id': 'detergent_3', 'name': 'منظف مطابخ', 'category': 'detergents'},
      {'id': 'disinfectant_1', 'name': 'مطهر عام', 'category': 'disinfectants'},
      {'id': 'disinfectant_2', 'name': 'مطهر حمامات', 'category': 'disinfectants'},
      {'id': 'tool_1', 'name': 'ممسحة', 'category': 'cleaningTools'},
      {'id': 'tool_2', 'name': 'دلو', 'category': 'cleaningTools'},
      {'id': 'tool_3', 'name': 'فرشاة', 'category': 'cleaningTools'},
      {'id': 'tool_4', 'name': 'قفازات', 'category': 'cleaningTools'},
      {'id': 'paper_1', 'name': 'مناديل ورقية', 'category': 'paperProducts'},
      {'id': 'paper_2', 'name': 'مناشف ورقية', 'category': 'paperProducts'},
      {'id': 'paper_3', 'name': 'أكياس قمامة', 'category': 'paperProducts'},
      {'id': 'other_1', 'name': 'معطر جو', 'category': 'otherSupplies'},
      {'id': 'other_2', 'name': 'شمع أرضيات', 'category': 'otherSupplies'},
    ];
  }

  @override
  void initState() {
    super.initState();
    if (widget.selectedUnit != null) {
      _selectedUnit = widget.selectedUnit!['id'] ?? '';
    }
  }

  @override
  void dispose() {
    _unitController.dispose();
    _descriptionController.dispose();
    _cleaningPriceController.dispose();
    _damagePriceController.dispose();
    _maintenancePriceController.dispose();
    _pestControlPriceController.dispose();
    _maintenanceDescriptionController.dispose();
    _pestControlDescriptionController.dispose();
    super.dispose();
  }

  // دوال إدارة المخزون
  void _updateItemQuantity(String itemId, int quantity) {
    setState(() {
      if (quantity > 0) {
        _usedItems[itemId] = quantity;
      } else {
        _usedItems.remove(itemId);
      }
    });
  }

  String _getItemName(String itemId) {
    final item = _availableItems.firstWhere(
      (item) => item['id'] == itemId,
      orElse: () => {'name': 'غير معروف'},
    );
    return item['name'] ?? 'غير معروف';
  }

  String _getCategoryName(String category) {
    switch (category) {
      case 'detergents':
        return context.translate(LangKeys.detergents);
      case 'disinfectants':
        return context.translate(LangKeys.disinfectants);
      case 'cleaningTools':
        return context.translate(LangKeys.cleaningTools);
      case 'paperProducts':
        return context.translate(LangKeys.paperProducts);
      case 'otherSupplies':
        return context.translate(LangKeys.otherSupplies);
      default:
        return category;
    }
  }



  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'detergents':
        return Icons.cleaning_services;
      case 'disinfectants':
        return Icons.sanitizer;
      case 'cleaningTools':
        return Icons.brush;
      case 'paperProducts':
        return Icons.description;
      case 'otherSupplies':
        return Icons.miscellaneous_services;
      default:
        return Icons.inventory;
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: ColorApp.white,
      appBar: AppBar(
        backgroundColor: ColorApp.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
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
        title: Text(
          widget.selectedUnit != null
              ? '${widget.selectedUnit!['name']} - ${widget.selectedUnit!['building']}'
              : context.translate(LangKeys.unitMediaUpload),
          style: TextStyle(
            fontSize: 20.sp,
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                            // عنوان نوع الوسائط
              Text(
                context.translate(LangKeys.mediaType),
                style: TextStyle(
                  fontSize: 16.sp,
                  color: ColorApp.primaryBlue,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Cairo',
                ),
              ),
              SizedBox(height: 16.h),
              
              // شريط التبويبات الرئيسي - نفس تصميم تفاصيل الشقة
              Container(
                decoration: BoxDecoration(
                  color: ColorApp.backgroundSecondary,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: ColorApp.borderLight,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ColorApp.shadowLight,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildMediaTypeButton(
                        title: context.translate(LangKeys.cleanlinessMedia),
                        icon: Icons.cleaning_services,
                        isSelected: _selectedMediaType == 'cleanliness',
                        onTap: () {
                          setState(() {
                            _selectedMediaType = 'cleanliness';
                            _selectedCleaningType = '';
                            _cleaningPriceController.clear();
                            _damagePriceController.clear();
                            _maintenancePriceController.clear();
                            _pestControlPriceController.clear();
                            _maintenanceDescriptionController.clear();
                            _pestControlDescriptionController.clear();
                            _descriptionController.clear();
                            _usedItems.clear();
                            _selectedCleaningTiming = 'before'; // الافتراضي: قبل النظافة
                            _selectedMaintenanceTiming = 'before';
                            _selectedPestControlTiming = 'before';
                          });
                        },
                      ),
                      _buildMediaTypeButton(
                        title: context.translate(LangKeys.damagesMedia),
                        icon: Icons.build,
                        isSelected: _selectedMediaType == 'damages',
                        onTap: () {
                          setState(() {
                            _selectedMediaType = 'damages';
                            _selectedCleaningType = '';
                            _cleaningPriceController.clear();
                            _damagePriceController.clear();
                            _maintenancePriceController.clear();
                            _pestControlPriceController.clear();
                            _maintenanceDescriptionController.clear();
                            _pestControlDescriptionController.clear();
                            _descriptionController.clear();
                            _usedItems.clear();
                            _selectedCleaningTiming = 'before'; // الافتراضي: قبل النظافة
                            _selectedMaintenanceTiming = 'before';
                            _selectedPestControlTiming = 'before';
                          });
                        },
                      ),
                      _buildMediaTypeButton(
                        title: context.translate(LangKeys.pestControlMedia),
                        icon: Icons.bug_report,
                        isSelected: _selectedMediaType == 'pestControl',
                        onTap: () {
                          setState(() {
                            _selectedMediaType = 'pestControl';
                            _selectedCleaningType = '';
                            _cleaningPriceController.clear();
                            _damagePriceController.clear();
                            _maintenancePriceController.clear();
                            _pestControlPriceController.clear();
                            _maintenanceDescriptionController.clear();
                            _pestControlDescriptionController.clear();
                            _descriptionController.clear();
                            _usedItems.clear();
                            _selectedCleaningTiming = 'before';
                            _selectedMaintenanceTiming = 'before';
                            _selectedPestControlTiming = 'before';
                          });
                        },
                      ),
                      _buildMediaTypeButton(
                        title: context.translate(LangKeys.maintenanceMedia),
                        icon: Icons.handyman,
                        isSelected: _selectedMediaType == 'maintenance',
                        onTap: () {
                          setState(() {
                            _selectedMediaType = 'maintenance';
                            _selectedCleaningType = '';
                            _cleaningPriceController.clear();
                            _damagePriceController.clear();
                            _maintenancePriceController.clear();
                            _pestControlPriceController.clear();
                            _maintenanceDescriptionController.clear();
                            _pestControlDescriptionController.clear();
                            _descriptionController.clear();
                            _usedItems.clear();
                            _selectedCleaningTiming = 'before';
                            _selectedMaintenanceTiming = 'before';
                            _selectedPestControlTiming = 'before';
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              
              // اختيار الوحدة (يظهر فقط إذا لم يتم تمرير selectedUnit)
              if (widget.selectedUnit == null)
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: ColorApp.white,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: ColorApp.borderLight,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.translate(LangKeys.selectUnit),
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: ColorApp.primaryBlue,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      SizedBox(height: 16.h),
                      DropdownButtonFormField<String>(
                        value: _selectedUnit.isEmpty ? null : _selectedUnit,
                        decoration: InputDecoration(
                          hintText: context.translate(LangKeys.selectUnitHint),
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                            fontSize: 14.sp,
                            fontFamily: 'Cairo',
                          ),
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
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.background,
                        ),
                        items: _units.map((unit) {
                          return DropdownMenuItem<String>(
                            value: unit['id'],
                            child: Text(
                              '${unit['name']} - ${unit['building']}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: ColorApp.textPrimary,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedUnit = value ?? '';
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.translate(LangKeys.pleaseSelectUnit);
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 24.h),
              
              // نوع النظافة (يظهر فقط لوسائط النظافة)
              if (_selectedMediaType == 'cleanliness')
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: ColorApp.white,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: ColorApp.borderLight,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.translate(LangKeys.cleaningType),
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: ColorApp.primaryBlue,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      SizedBox(height: 16.h),
                      DropdownButtonFormField<String>(
                        value: _selectedCleaningType.isEmpty ? null : _selectedCleaningType,
                        isExpanded: true,
                        decoration: InputDecoration(
                          hintText: context.translate(LangKeys.selectCleaningType),
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                            fontSize: 14.sp,
                            fontFamily: 'Cairo',
                          ),
                          prefixIcon: Icon(
                            Icons.cleaning_services,
                            color: ColorApp.primaryBlue,
                            size: 20.sp,
                          ),
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
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.background,
                        ),
                        items: [
                          DropdownMenuItem<String>(
                            value: 'deep',
                            child: Text(
                              context.translate(LangKeys.deepCleaning),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: ColorApp.textPrimary,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: 'daily',
                            child: Text(
                              context.translate(LangKeys.dailyCleaning),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: ColorApp.textPrimary,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          print('Selected cleaning type: $value'); // للـ debugging
                          setState(() {
                            _selectedCleaningType = value ?? '';
                          });
                        },
                        validator: (value) {
                          print('Validating cleaning type: $value'); // للـ debugging
                          if (value == null || value.isEmpty) {
                            return context.translate(LangKeys.pleaseSelectCleaningType);
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              if (_selectedMediaType == 'cleanliness') SizedBox(height: 24.h),
              
              // توقيت النظافة (يظهر فقط لوسائط النظافة)
              if (_selectedMediaType == 'cleanliness')
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: ColorApp.white,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: ColorApp.borderLight,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            color: ColorApp.primaryBlue,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            context.translate(LangKeys.cleaningTiming),
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: ColorApp.primaryBlue,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      DropdownButtonFormField<String>(
                        value: _selectedCleaningTiming.isEmpty ? null : _selectedCleaningTiming,
                        isExpanded: true,
                        decoration: InputDecoration(
                          hintText: context.translate(LangKeys.selectCleaningTiming),
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                            fontSize: 14.sp,
                            fontFamily: 'Cairo',
                          ),
                          prefixIcon: Icon(
                            Icons.access_time,
                            color: ColorApp.primaryBlue,
                            size: 20.sp,
                          ),
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
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.background,
                        ),
                        items: [
                          DropdownMenuItem<String>(
                            value: 'before',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.cleaning_services,
                                  color: ColorApp.primaryBlue,
                                  size: 18.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  context.translate(LangKeys.beforeCleaning),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: ColorApp.textPrimary,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: 'after',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: ColorApp.success,
                                  size: 18.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  context.translate(LangKeys.afterCleaning),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: ColorApp.textPrimary,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCleaningTiming = value ?? '';
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.translate(LangKeys.pleaseSelectCleaningTiming);
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              if (_selectedMediaType == 'cleanliness') SizedBox(height: 24.h),
              
              // سعر النظافة (يظهر فقط لوسائط النظافة بعد التنظيف)
              if (_selectedMediaType == 'cleanliness' && _selectedCleaningTiming == 'after')
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: ColorApp.white,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: ColorApp.borderLight,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.translate(LangKeys.cleaningPrice),
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: ColorApp.primaryBlue,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      SizedBox(height: 16.h),
                      TextFormField(
                        controller: _cleaningPriceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: context.translate(LangKeys.cleaningPriceHint),
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                            fontSize: 14.sp,
                            fontFamily: 'Cairo',
                          ),
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
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.background,
                          suffixText: context.translate(LangKeys.currency),
                          suffixStyle: TextStyle(
                            color: ColorApp.primaryBlue,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.translate(LangKeys.cleaningPriceRequired);
                          }
                          if (double.tryParse(value) == null) {
                            return context.translate(LangKeys.pleaseEnterCleaningPrice);
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              if (_selectedMediaType == 'cleanliness') SizedBox(height: 24.h),
              
              // المخزون - الحاجات المستخدمة (يظهر فقط لوسائط النظافة بعد التنظيف)
              if (_selectedMediaType == 'cleanliness' && _selectedCleaningTiming == 'after')
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: ColorApp.white,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: ColorApp.borderLight,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.inventory,
                            color: ColorApp.primaryBlue,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            context.translate(LangKeys.inventory),
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: ColorApp.primaryBlue,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        context.translate(LangKeys.usedItems),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: ColorApp.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      SizedBox(height: 12.h),
                      
                      // عرض جميع الحاجات المتاحة مع إمكانية تحديد الكمية
                      ..._availableItems.map((item) {
                        final itemId = item['id']!;
                        final itemName = item['name']!;
                        final category = item['category']!;
                        final usedQuantity = _usedItems[itemId] ?? 0;
                        
                        return Container(
                          margin: EdgeInsets.only(bottom: 12.h),
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: usedQuantity > 0 ? ColorApp.lightGrey : ColorApp.white,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: usedQuantity > 0 ? ColorApp.primaryBlue : ColorApp.borderLight,
                              width: usedQuantity > 0 ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    _getCategoryIcon(category),
                                    color: ColorApp.primaryBlue,
                                    size: 18.sp,
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          itemName,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: ColorApp.textPrimary,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Cairo',
                                          ),
                                        ),
                                        Text(
                                          _getCategoryName(category),
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: ColorApp.textSecondary,
                                            fontFamily: 'Cairo',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                children: [
                                  Text(
                                    context.translate(LangKeys.quantity),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: ColorApp.textSecondary,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    onPressed: () => _updateItemQuantity(itemId, usedQuantity - 1),
                                    icon: Icon(Icons.remove, size: 20.sp, color: ColorApp.primaryBlue),
                                    constraints: BoxConstraints(minWidth: 40.w, minHeight: 40.h),
                                    style: IconButton.styleFrom(
                                      backgroundColor: ColorApp.lightGrey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                                    child: Text(
                                      usedQuantity.toString(),
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: usedQuantity > 0 ? ColorApp.primaryBlue : ColorApp.textSecondary,
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => _updateItemQuantity(itemId, usedQuantity + 1),
                                    icon: Icon(Icons.add, size: 20.sp, color: ColorApp.primaryBlue),
                                    constraints: BoxConstraints(minWidth: 40.w, minHeight: 40.h),
                                    style: IconButton.styleFrom(
                                      backgroundColor: ColorApp.lightGrey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              // الوصف (يظهر فقط للتلفيات)
              if (_selectedMediaType == 'damages')
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: ColorApp.white,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: ColorApp.borderLight,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.translate(LangKeys.description),
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: ColorApp.primaryBlue,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      SizedBox(height: 16.h),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: context.translate(LangKeys.descriptionHint),
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                            fontSize: 14.sp,
                            fontFamily: 'Cairo',
                          ),
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
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.background,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.translate(LangKeys.pleaseEnterDescription);
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              if (_selectedMediaType == 'damages') SizedBox(height: 24.h),
              
              // سعر الشيء المتلف (يظهر فقط للتلفيات)
              if (_selectedMediaType == 'damages')
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: ColorApp.white,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: ColorApp.borderLight,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.attach_money,
                            color: ColorApp.primaryBlue,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            context.translate(LangKeys.damagePrice),
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: ColorApp.primaryBlue,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      TextFormField(
                        controller: _damagePriceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: context.translate(LangKeys.damagePriceHint),
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                            fontSize: 14.sp,
                            fontFamily: 'Cairo',
                          ),
                          prefixIcon: Icon(
                            Icons.currency_exchange,
                            color: ColorApp.primaryBlue,
                            size: 20.sp,
                          ),
                          suffixText: context.translate(LangKeys.currency),
                          suffixStyle: TextStyle(
                            color: ColorApp.textSecondary,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Cairo',
                          ),
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
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.background,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.translate(LangKeys.damagePriceRequired);
                          }
                          // التحقق من أن القيمة رقم صحيح
                          if (double.tryParse(value) == null) {
                            return 'يرجى إدخال رقم صحيح';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              if (_selectedMediaType == 'damages') SizedBox(height: 24.h),
              
              // توقيت الصيانة (يظهر فقط لوسائط الصيانة)
              if (_selectedMediaType == 'maintenance')
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: ColorApp.white,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: ColorApp.borderLight,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            color: ColorApp.primaryBlue,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            context.translate(LangKeys.maintenanceTiming),
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: ColorApp.primaryBlue,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      DropdownButtonFormField<String>(
                        value: _selectedMaintenanceTiming.isEmpty ? null : _selectedMaintenanceTiming,
                        isExpanded: true,
                        decoration: InputDecoration(
                          hintText: context.translate(LangKeys.selectMaintenanceTiming),
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                            fontSize: 14.sp,
                            fontFamily: 'Cairo',
                          ),
                          prefixIcon: Icon(
                            Icons.access_time,
                            color: ColorApp.primaryBlue,
                            size: 20.sp,
                          ),
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
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.background,
                        ),
                        items: [
                          DropdownMenuItem<String>(
                            value: 'before',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.handyman,
                                  color: ColorApp.primaryBlue,
                                  size: 18.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  context.translate(LangKeys.beforeMaintenance),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: ColorApp.textPrimary,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: 'after',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: ColorApp.success,
                                  size: 18.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  context.translate(LangKeys.afterMaintenance),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: ColorApp.textPrimary,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedMaintenanceTiming = value ?? '';
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.translate(LangKeys.pleaseSelectMaintenanceTiming);
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              if (_selectedMediaType == 'maintenance') SizedBox(height: 24.h),
              
              // سعر الصيانة (يظهر فقط لوسائط الصيانة بعد الصيانة)
              if (_selectedMediaType == 'maintenance' && _selectedMaintenanceTiming == 'after')
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: ColorApp.white,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: ColorApp.borderLight,
                      width: 1,
                    ),
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
                          fontFamily: 'Cairo',
                        ),
                      ),
                      SizedBox(height: 16.h),
                      TextFormField(
                        controller: _maintenancePriceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: context.translate(LangKeys.maintenancePriceHint),
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                            fontSize: 14.sp,
                            fontFamily: 'Cairo',
                          ),
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
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.background,
                          suffixText: context.translate(LangKeys.currency),
                          suffixStyle: TextStyle(
                            color: ColorApp.primaryBlue,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.translate(LangKeys.maintenancePriceRequired);
                          }
                          if (double.tryParse(value) == null) {
                            return context.translate(LangKeys.pleaseEnterMaintenancePrice);
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              if (_selectedMediaType == 'maintenance') SizedBox(height: 24.h),
              
              // وصف الصيانة (يظهر فقط لوسائط الصيانة)
              if (_selectedMediaType == 'maintenance')
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: ColorApp.white,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: ColorApp.borderLight,
                      width: 1,
                    ),
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
                          fontFamily: 'Cairo',
                        ),
                      ),
                      SizedBox(height: 16.h),
                      TextFormField(
                        controller: _maintenanceDescriptionController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: context.translate(LangKeys.maintenanceDescriptionHint),
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                            fontSize: 14.sp,
                            fontFamily: 'Cairo',
                          ),
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
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.background,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.translate(LangKeys.maintenanceDescriptionRequired);
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              if (_selectedMediaType == 'maintenance') SizedBox(height: 24.h),
              
              // توقيت المبيدات الحشرية (يظهر فقط لوسائط المبيدات الحشرية)
              if (_selectedMediaType == 'pestControl')
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: ColorApp.white,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: ColorApp.borderLight,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            color: ColorApp.primaryBlue,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            context.translate(LangKeys.pestControlTiming),
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: ColorApp.primaryBlue,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      DropdownButtonFormField<String>(
                        value: _selectedPestControlTiming.isEmpty ? null : _selectedPestControlTiming,
                        isExpanded: true,
                        decoration: InputDecoration(
                          hintText: context.translate(LangKeys.selectPestControlTiming),
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                            fontSize: 14.sp,
                            fontFamily: 'Cairo',
                          ),
                          prefixIcon: Icon(
                            Icons.access_time,
                            color: ColorApp.primaryBlue,
                            size: 20.sp,
                          ),
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
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.background,
                        ),
                        items: [
                          DropdownMenuItem<String>(
                            value: 'before',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.bug_report,
                                  color: ColorApp.primaryBlue,
                                  size: 18.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  context.translate(LangKeys.beforePestControl),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: ColorApp.textPrimary,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: 'after',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: ColorApp.success,
                                  size: 18.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  context.translate(LangKeys.afterPestControl),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: ColorApp.textPrimary,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedPestControlTiming = value ?? '';
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.translate(LangKeys.pleaseSelectPestControlTiming);
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              if (_selectedMediaType == 'pestControl') SizedBox(height: 24.h),
              
              // سعر المبيدات الحشرية (يظهر فقط لوسائط المبيدات الحشرية بعد المبيدات الحشرية)
              if (_selectedMediaType == 'pestControl' && _selectedPestControlTiming == 'after')
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: ColorApp.white,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: ColorApp.borderLight,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.translate(LangKeys.pestControlPrice),
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: ColorApp.primaryBlue,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      SizedBox(height: 16.h),
                      TextFormField(
                        controller: _pestControlPriceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: context.translate(LangKeys.pestControlPriceHint),
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                            fontSize: 14.sp,
                            fontFamily: 'Cairo',
                          ),
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
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.background,
                          suffixText: context.translate(LangKeys.currency),
                          suffixStyle: TextStyle(
                            color: ColorApp.primaryBlue,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.translate(LangKeys.pestControlPriceRequired);
                          }
                          if (double.tryParse(value) == null) {
                            return context.translate(LangKeys.pleaseEnterPestControlPrice);
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              if (_selectedMediaType == 'pestControl') SizedBox(height: 24.h),
              
              // وصف المبيدات الحشرية (يظهر فقط لوسائط المبيدات الحشرية)
              if (_selectedMediaType == 'pestControl')
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: ColorApp.white,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: ColorApp.borderLight,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.translate(LangKeys.pestControlDescription),
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: ColorApp.primaryBlue,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      SizedBox(height: 16.h),
                      TextFormField(
                        controller: _pestControlDescriptionController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: context.translate(LangKeys.pestControlDescriptionHint),
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                            fontSize: 14.sp,
                            fontFamily: 'Cairo',
                          ),
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
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.background,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.translate(LangKeys.pestControlDescriptionRequired);
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              if (_selectedMediaType == 'pestControl') SizedBox(height: 24.h),
              
              // رفع الصور
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: ColorApp.white,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.translate(LangKeys.images),
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: ColorApp.primaryBlue,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Cairo',
                      ),
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
                  color: ColorApp.white,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.translate(LangKeys.videos),
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: ColorApp.primaryBlue,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _buildVideoUploadSection(),
                  ],
                ),
              ),
              SizedBox(height: 32.h),
              
              // زر الرفع
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
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15.r),
                    onTap: _isLoading ? null : _handleUpload,
                    child: Center(
                      child: _isLoading
                          ? SizedBox(
                              width: 24.w,
                              height: 24.h,
                              child: CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.onPrimary,
                                strokeWidth: 2,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.upload,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  context.translate(LangKeys.uploadContent),
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onPrimary,
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          gradient: isSelected 
              ? LinearGradient(
                  colors: [ColorApp.gradientStart, ColorApp.gradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : ColorApp.backgroundSecondary,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? Colors.transparent : ColorApp.borderLight,
            width: 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: ColorApp.shadowLight.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? ColorApp.textInverse : ColorApp.primaryBlue,
              size: 18.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? ColorApp.textInverse : ColorApp.primaryBlue,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      children: [
        // عرض الصور المحددة
        if (_selectedImages.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${context.translate(LangKeys.selectedImages)} (${_selectedImages.length})',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (_selectedMediaType == 'cleanliness') {
                      _cleanlinessImages.clear();
                    } else {
                      _damagesImages.clear();
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.translate(LangKeys.allImagesDeleted)),
                      backgroundColor: ColorApp.warning,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Theme.of(context).colorScheme.error, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.delete_sweep,
                        color: Theme.of(context).colorScheme.error,
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'حذف الكل',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
              childAspectRatio: 1.0,
            ),
            itemCount: _selectedImages.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      image: DecorationImage(
                        image: FileImage(File(_selectedImages[index].path)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4.h,
                    right: 4.w,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_selectedMediaType == 'cleanliness') {
                            _cleanlinessImages.removeAt(index);
                          } else {
                            _damagesImages.removeAt(index);
                          }
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(context.translate(LangKeys.deleteImage)),
                            backgroundColor: ColorApp.warning,
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 12.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 16.h),
        ],
        
        // زر إضافة الصور
        Container(
          width: double.infinity,
          height: 110.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.05),
                Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              width: 2,
              style: BorderStyle.solid,
            ),

          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(15.r),
              onTap: _selectImages,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add_photo_alternate,
                      color: Theme.of(context).colorScheme.primary,
                      size: 28.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Flexible(
                    child: Text(
                      context.translate(LangKeys.addMultipleImages),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Cairo',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Flexible(
                    child: Text(
                      context.translate(LangKeys.pressToSelectImages),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                        fontSize: 11.sp,
                        fontFamily: 'Cairo',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoUploadSection() {
    return Column(
      children: [
        // عرض الفيديوهات المحددة
        if (_selectedVideos.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${context.translate(LangKeys.selectedVideos)} (${_selectedVideos.length})',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (_selectedMediaType == 'cleanliness') {
                      _cleanlinessVideos.clear();
                    } else {
                      _damagesVideos.clear();
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.translate(LangKeys.allVideosDeleted)),
                      backgroundColor: ColorApp.warning,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Theme.of(context).colorScheme.error, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.delete_sweep,
                        color: Theme.of(context).colorScheme.error,
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'حذف الكل',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
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
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
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
                      child: Icon(
                        Icons.video_file,
                        color: Theme.of(context).colorScheme.primary,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedVideos[index].name,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '00:30',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_selectedMediaType == 'cleanliness') {
                            _cleanlinessVideos.removeAt(index);
                          } else {
                            _damagesVideos.removeAt(index);
                          }
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(context.translate(LangKeys.deleteVideo)),
                            backgroundColor: ColorApp.warning,
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.delete,
                          color: Theme.of(context).colorScheme.error,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 16.h),
        ],
        
        // زر إضافة الفيديوهات
        Container(
          width: double.infinity,
          height: 90.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.05),
                Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(15.r),
              onTap: _selectVideos,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.video_library,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(height: 6.h),
                                      Flexible(
                      child: Text(
                        context.translate(LangKeys.addVideo),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Cairo',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Flexible(
                      child: Text(
                        context.translate(LangKeys.pressToSelectVideo),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                          fontSize: 10.sp,
                          fontFamily: 'Cairo',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectImages() async {
    try {
      final images = await PickImageUtils().pickMultipleImages();
      
      if (images != null && images.isNotEmpty) {
        if (mounted) {
          setState(() {
            _selectedImages.addAll(images);
          });
          
          String mediaTypeName = '';
          switch (_selectedMediaType) {
            case 'cleanliness':
              mediaTypeName = context.translate(LangKeys.cleanlinessMedia);
              break;
            case 'damages':
              mediaTypeName = context.translate(LangKeys.damagesMedia);
              break;
            case 'pestControl':
              mediaTypeName = context.translate(LangKeys.pestControlMedia);
              break;
            case 'maintenance':
              mediaTypeName = context.translate(LangKeys.maintenanceMedia);
              break;
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.translate(LangKeys.imagesAddedSuccess).replaceAll('{count}', '${images.length}').replaceAll('{type}', mediaTypeName)),
              backgroundColor: ColorApp.success,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.translate(LangKeys.errorSelectingImages)),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _selectVideos() async {
    try {
      final videos = await PickImageUtils().pickMultipleVideos();
      
      if (videos != null && videos.isNotEmpty) {
        if (mounted) {
          setState(() {
            _selectedVideos.addAll(videos);
          });
          
          String mediaTypeName = '';
          switch (_selectedMediaType) {
            case 'cleanliness':
              mediaTypeName = context.translate(LangKeys.cleanlinessMedia);
              break;
            case 'damages':
              mediaTypeName = context.translate(LangKeys.damagesMedia);
              break;
            case 'pestControl':
              mediaTypeName = context.translate(LangKeys.pestControlMedia);
              break;
            case 'maintenance':
              mediaTypeName = context.translate(LangKeys.maintenanceMedia);
              break;
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.translate(LangKeys.videoAddedSuccess).replaceAll('{type}', mediaTypeName)),
              backgroundColor: ColorApp.success,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.translate(LangKeys.errorSelectingVideos)),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _handleUpload() {
    // التحقق من الوحدة إذا لم يتم تمريرها مسبقاً
    if (widget.selectedUnit == null && _selectedUnit.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.translate(LangKeys.pleaseSelectUnitError)),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    // التحقق من الوصف فقط للتلفيات
    if (_selectedMediaType == 'damages' && _descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.translate(LangKeys.pleaseEnterDamagesDescription)),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    // التحقق من سعر الشيء المتلف فقط للتلفيات
    if (_selectedMediaType == 'damages' && _damagePriceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.translate(LangKeys.damagePriceRequired)),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    // التحقق من صحة سعر الشيء المتلف
    if (_selectedMediaType == 'damages' && _damagePriceController.text.trim().isNotEmpty) {
      if (double.tryParse(_damagePriceController.text.trim()) == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('يرجى إدخال رقم صحيح لسعر الشيء المتلف'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }
    }

    // التحقق من نوع النظافة فقط لوسائط النظافة
    if (_selectedMediaType == 'cleanliness' && _selectedCleaningType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.translate(LangKeys.pleaseSelectCleaningType)),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    // التحقق من سعر النظافة (فقط بعد النظافة)
    if (_selectedMediaType == 'cleanliness' && _selectedCleaningTiming == 'after' && _cleaningPriceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.translate(LangKeys.cleaningPriceRequired)),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

                      // التحقق من صحة سعر النظافة (فقط بعد النظافة)
                  if (_selectedMediaType == 'cleanliness' && _selectedCleaningTiming == 'after' && _cleaningPriceController.text.trim().isNotEmpty) {
                    if (double.tryParse(_cleaningPriceController.text.trim()) == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(context.translate(LangKeys.pleaseEnterCleaningPrice)),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      );
                      return;
                    }
                  }

                  // التحقق من إضافة حاجات للمخزون (فقط بعد النظافة)
                  if (_selectedMediaType == 'cleanliness' && _selectedCleaningTiming == 'after' && _usedItems.isEmpty) {
                    // يمكن إضافة تنبيه هنا إذا كان مطلوباً
                    print('No inventory items selected');
                  }

                  // التحقق من توقيت النظافة
                  if (_selectedMediaType == 'cleanliness' && _selectedCleaningTiming.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.translate(LangKeys.pleaseSelectCleaningTiming)),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    // التحقق من توقيت الصيانة
    if (_selectedMediaType == 'maintenance' && _selectedMaintenanceTiming.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.translate(LangKeys.pleaseSelectMaintenanceTiming)),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    // التحقق من توقيت المبيدات الحشرية
    if (_selectedMediaType == 'pestControl' && _selectedPestControlTiming.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.translate(LangKeys.pleaseSelectPestControlTiming)),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    // التحقق من سعر الصيانة (فقط بعد الصيانة)
    if (_selectedMediaType == 'maintenance' && _selectedMaintenanceTiming == 'after' && _maintenancePriceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.translate(LangKeys.maintenancePriceRequired)),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    // التحقق من صحة سعر الصيانة (فقط بعد الصيانة)
    if (_selectedMediaType == 'maintenance' && _selectedMaintenanceTiming == 'after' && _maintenancePriceController.text.trim().isNotEmpty) {
      if (double.tryParse(_maintenancePriceController.text.trim()) == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.translate(LangKeys.pleaseEnterMaintenancePrice)),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }
    }

    // التحقق من سعر المبيدات الحشرية (فقط بعد المبيدات الحشرية)
    if (_selectedMediaType == 'pestControl' && _selectedPestControlTiming == 'after' && _pestControlPriceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.translate(LangKeys.pestControlPriceRequired)),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    // التحقق من صحة سعر المبيدات الحشرية (فقط بعد المبيدات الحشرية)
    if (_selectedMediaType == 'pestControl' && _selectedPestControlTiming == 'after' && _pestControlPriceController.text.trim().isNotEmpty) {
      if (double.tryParse(_pestControlPriceController.text.trim()) == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.translate(LangKeys.pleaseEnterPestControlPrice)),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }
    }

    // التحقق من وصف الصيانة
    if (_selectedMediaType == 'maintenance' && _maintenanceDescriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.translate(LangKeys.maintenanceDescriptionRequired)),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    // التحقق من وصف المبيدات الحشرية
    if (_selectedMediaType == 'pestControl' && _pestControlDescriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.translate(LangKeys.pestControlDescriptionRequired)),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    // التحقق من وجود ملفات حسب النوع المحدد
    List<XFile> currentImages = _selectedImages;
    List<XFile> currentVideos = _selectedVideos;
    
    if (currentImages.isEmpty && currentVideos.isEmpty) {
      String mediaTypeName = '';
      switch (_selectedMediaType) {
        case 'cleanliness':
          mediaTypeName = context.translate(LangKeys.cleanlinessMedia);
          break;
        case 'damages':
          mediaTypeName = context.translate(LangKeys.damagesMedia);
          break;
        case 'pestControl':
          mediaTypeName = context.translate(LangKeys.pestControlMedia);
          break;
        case 'maintenance':
          mediaTypeName = context.translate(LangKeys.maintenanceMedia);
          break;
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${context.translate(LangKeys.pleaseAddMedia)} $mediaTypeName'),
          backgroundColor: ColorApp.warning,
        ),
      );
      return;
    }

      setState(() {
        _isLoading = true;
      });

      // محاكاة عملية الرفع
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        
        setState(() {
          _isLoading = false;
        });
        
        // عرض رسالة نجاح مع تفاصيل
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: ColorApp.success,
                  size: 24.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  context.translate(LangKeys.uploadSuccess),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.translate(LangKeys.uploadSuccessMessage),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Cairo',
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '${context.translate(LangKeys.imagesCount)}: ${currentImages.length}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                    fontFamily: 'Cairo',
                  ),
                ),
                Text(
                  '${context.translate(LangKeys.videosCount)}: ${currentVideos.length}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                    fontFamily: 'Cairo',
                  ),
                ),
                if (_selectedMediaType == 'cleanliness' && _selectedCleaningType.isNotEmpty)
                  Text(
                    '${context.translate(LangKeys.cleaningType)}: ${_selectedCleaningType == 'deep' ? context.translate(LangKeys.deepCleaning) : context.translate(LangKeys.dailyCleaning)}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                      fontFamily: 'Cairo',
                    ),
                  ),
                if (_selectedMediaType == 'cleanliness' && _selectedCleaningTiming == 'after' && _cleaningPriceController.text.trim().isNotEmpty)
                  Text(
                    '${context.translate(LangKeys.cleaningPrice)}: ${_cleaningPriceController.text.trim()} ${context.translate(LangKeys.currency)}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                      fontFamily: 'Cairo',
                    ),
                  ),
                if (_selectedMediaType == 'cleanliness' && _selectedCleaningTiming == 'after' && _usedItems.isNotEmpty)
                  Text(
                    '${context.translate(LangKeys.usedItems)}: ${_usedItems.length} ${context.translate(LangKeys.items)}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                      fontFamily: 'Cairo',
                    ),
                  ),
                if (_selectedMediaType == 'cleanliness' && _selectedCleaningTiming.isNotEmpty)
                  Text(
                    '${context.translate(LangKeys.cleaningTiming)}: ${_selectedCleaningTiming == 'before' ? context.translate(LangKeys.beforeCleaning) : context.translate(LangKeys.afterCleaning)}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                      fontFamily: 'Cairo',
                    ),
                  ),
                if (_selectedMediaType == 'damages' && _damagePriceController.text.trim().isNotEmpty)
                  Text(
                    '${context.translate(LangKeys.damagePrice)}: ${_damagePriceController.text.trim()} ${context.translate(LangKeys.currency)}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                      fontFamily: 'Cairo',
                    ),
                  ),
                if (_selectedMediaType == 'maintenance' && _selectedMaintenanceTiming.isNotEmpty)
                  Text(
                    '${context.translate(LangKeys.maintenanceTiming)}: ${_selectedMaintenanceTiming == 'before' ? context.translate(LangKeys.beforeMaintenance) : context.translate(LangKeys.afterMaintenance)}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                      fontFamily: 'Cairo',
                    ),
                  ),
                if (_selectedMediaType == 'maintenance' && _selectedMaintenanceTiming == 'after' && _maintenancePriceController.text.trim().isNotEmpty)
                  Text(
                    '${context.translate(LangKeys.maintenancePrice)}: ${_maintenancePriceController.text.trim()} ${context.translate(LangKeys.currency)}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                      fontFamily: 'Cairo',
                    ),
                  ),
                if (_selectedMediaType == 'pestControl' && _selectedPestControlTiming.isNotEmpty)
                  Text(
                    '${context.translate(LangKeys.pestControlTiming)}: ${_selectedPestControlTiming == 'before' ? context.translate(LangKeys.beforePestControl) : context.translate(LangKeys.afterPestControl)}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                      fontFamily: 'Cairo',
                    ),
                  ),
                if (_selectedMediaType == 'pestControl' && _selectedPestControlTiming == 'after' && _pestControlPriceController.text.trim().isNotEmpty)
                  Text(
                    '${context.translate(LangKeys.pestControlPrice)}: ${_pestControlPriceController.text.trim()} ${context.translate(LangKeys.currency)}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                      fontFamily: 'Cairo',
                    ),
                  ),
                if (_selectedMediaType == 'maintenance' && _maintenanceDescriptionController.text.trim().isNotEmpty)
                  Text(
                    '${context.translate(LangKeys.maintenanceDescription)}: ${_maintenanceDescriptionController.text.trim()}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                      fontFamily: 'Cairo',
                    ),
                  ),
                if (_selectedMediaType == 'pestControl' && _pestControlDescriptionController.text.trim().isNotEmpty)
                  Text(
                    '${context.translate(LangKeys.pestControlDescription)}: ${_pestControlDescriptionController.text.trim()}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                      fontFamily: 'Cairo',
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context); // العودة إلى صفحة التقارير
                },
                child: Text(
                  context.translate(LangKeys.ok),
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
      });
    }
  }
