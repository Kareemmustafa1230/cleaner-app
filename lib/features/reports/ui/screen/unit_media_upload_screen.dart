import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/language/lang_keys.dart';
import '../../../../core/theme/Color/colors.dart';
import '../../../../core/networking/di/dependency_injection.dart';
import '../../data/model/upload_request.dart';
import '../../logic/cubit/upload_cleaning_cubit.dart';
import '../../logic/state/upload_state.dart';
import '../../logic/cubit/upload_damage_cubit.dart';
import '../widget/cleanliness_tab.dart';
import '../widget/damages_tab.dart';
import '../widget/maintenance_tab.dart';
import '../widget/pest_control_tab.dart';
import '../widget/upload_cleaning_bloc_listeners.dart';
import '../widget/upload_damage_bloc_listeners.dart';
import '../../../inventory/data/model/inventory_response.dart' as inv;

class UnitMediaUploadScreen extends StatefulWidget {
  final String chaletsId;
  final List<inv.InventoryItem>? inventoryItems;

  const UnitMediaUploadScreen({
    super.key,
    required this.chaletsId,
    this.inventoryItems,
  });

  @override
  State<UnitMediaUploadScreen> createState() => _UnitMediaUploadScreenState();
}

class _UnitMediaUploadScreenState extends State<UnitMediaUploadScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedUnit = '';
  
  // Cleanliness data
  String _selectedCleaningType = '';
  String _selectedCleaningTiming = 'before';
  String _cleaningPrice = '';
  Map<String, int> _usedItems = {};
  List<XFile> _cleanlinessImages = [];
  List<XFile> _cleanlinessVideos = [];
  
  // Damages data
  String _damageDescription = '';
  String _damagePrice = '';
  List<XFile> _damagesImages = [];
  List<XFile> _damagesVideos = [];
  
  // Maintenance data
  String _maintenanceDescription = '';
  String _maintenancePrice = '';
  List<XFile> _maintenanceImages = [];
  List<XFile> _maintenanceVideos = [];
  
  // Pest Control data
  String _pestControlDescription = '';
  String _pestControlPrice = '';
  List<XFile> _pestControlImages = [];
  List<XFile> _pestControlVideos = [];

  @override
  void initState() {
    super.initState();
    _selectedUnit = widget.chaletsId;
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UploadCleaningCubit>(
          create: (context) => getIt<UploadCleaningCubit>(),
        ),
        BlocProvider<UploadDamageCubit>(
          create: (context) => getIt<UploadDamageCubit>(),
        ),
      ],
      child: BlocBuilder<UploadCleaningCubit, UploadState>(
        builder: (context, cleaningState) {
          return BlocBuilder<UploadDamageCubit, UploadState>(
            builder: (context, damageState) {
              final isLoading = cleaningState is Loading ||
                  damageState is Loading;
              return Stack(
                children: [
                  const UploadCleaningBlocListeners(),
                  const UploadDamageBlocListeners(),
                  Scaffold(
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
                              colors: [
                                Theme
                                    .of(context)
                                    .colorScheme
                                    .primary,
                                Theme
                                    .of(context)
                                    .colorScheme
                                    .secondary
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Theme
                                .of(context)
                                .colorScheme
                                .onPrimary,
                            size: 20.sp,
                          ),
                        ),
                      ),
                      title: Text(
                        '${widget.chaletsId} - ${context.translate(
                            LangKeys.unitMediaUpload)}',
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: Theme
                              .of(context)
                              .colorScheme
                              .onPrimary,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      centerTitle: true,
                      bottom: TabBar(
                        controller: _tabController,
                        indicatorColor: Theme
                            .of(context)
                            .colorScheme
                            .primary,
                        labelColor: Theme
                            .of(context)
                            .colorScheme
                            .primary,
                        unselectedLabelColor: Theme
                            .of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.7),
                        labelStyle: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Cairo',
                        ),
                        unselectedLabelStyle: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Cairo',
                        ),
                        tabs: [
                          Tab(
                            icon: Icon(
                                Icons.cleaning_services, size: 20.sp),
                            text: context.translate(
                                LangKeys.cleanlinessMedia),
                          ),
                          Tab(
                            icon: Icon(Icons.build, size: 20.sp),
                            text: context.translate(
                                LangKeys.damagesMedia),
                          ),
                          Tab(
                            icon: Icon(Icons.handyman, size: 20.sp),
                            text: context.translate(
                                LangKeys.maintenanceMedia),
                          ),
                          Tab(
                            icon: Icon(Icons.bug_report, size: 20.sp),
                            text: "المبيدات",
                          ),
                        ],
                      ),
                    ),
                    body: TabBarView(
                      controller: _tabController,
                      children: [
                        // Cleanliness Tab
                        _buildTabContent(
                          CleanlinessTab(
                            selectedUnit: _selectedUnit,
                            chaletsId: widget.chaletsId,
                            inventoryItems: widget.inventoryItems,
                            onImagesChanged: (images) {
                              setState(() =>
                              _cleanlinessImages = images);
                            },
                            onVideosChanged: (videos) {
                              setState(() =>
                              _cleanlinessVideos = videos);
                            },
                            onCleaningTypeChanged: (type) {
                              setState(() =>
                              _selectedCleaningType = type);
                            },
                            onCleaningTimingChanged: (timing) {
                              setState(() =>
                              _selectedCleaningTiming = timing);
                            },
                            onCleaningPriceChanged: (price) {
                              setState(() => _cleaningPrice = price);
                            },
                            onUsedItemsChanged: (items) {
                              setState(() => _usedItems = items);
                            },
                          ),
                          'cleanliness',
                          isLoading,
                        ),

                        // Damages Tab
                        _buildTabContent(
                          DamagesTab(
                            selectedUnit: _selectedUnit,
                            chaletsId: widget.chaletsId,
                            onImagesChanged: (images) {
                              setState(() => _damagesImages = images);
                            },
                            onVideosChanged: (videos) {
                              setState(() => _damagesVideos = videos);
                            },
                            onDescriptionChanged: (description) {
                              setState(() =>
                              _damageDescription = description);
                            },
                            onDamagePriceChanged: (price) {
                              setState(() => _damagePrice = price);
                            },
                          ),
                          'damages',
                          isLoading,
                        ),

                        // Maintenance Tab
                        _buildTabContent(
                          MaintenanceTab(
                            selectedUnit: _selectedUnit,
                            chaletsId: widget.chaletsId,
                            onImagesChanged: (images) {
                              setState(() =>
                              _maintenanceImages = images);
                            },
                            onVideosChanged: (videos) {
                              setState(() =>
                              _maintenanceVideos = videos);
                            },
                            onMaintenanceTimingChanged: (timing) {
                              // Handle timing change if needed
                            },
                            onMaintenanceDescriptionChanged: (description) {
                              setState(() =>
                              _maintenanceDescription = description);
                            },
                            onMaintenancePriceChanged: (price) {
                              setState(() =>
                              _maintenancePrice = price);
                            },
                          ),
                          'maintenance',
                          isLoading,
                        ),

                        // Pest Control Tab
                        _buildTabContent(
                          PestControlTab(
                            selectedUnit: _selectedUnit,
                            chaletsId: widget.chaletsId,
                            onImagesChanged: (images) {
                              setState(() =>
                              _pestControlImages = images);
                            },
                            onVideosChanged: (videos) {
                              setState(() =>
                              _pestControlVideos = videos);
                            },
                            onPestControlTimingChanged: (timing) {
                              // Handle timing change if needed
                            },
                            onPestControlDescriptionChanged: (description) {
                              setState(() =>
                              _pestControlDescription = description);
                            },
                            onPestControlPriceChanged: (price) {
                              setState(() =>
                              _pestControlPrice = price);
                            },
                          ),
                          'pestControl',
                          isLoading,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        }
        ),
    );
  }

  Widget _buildTabContent(Widget tabContent, String mediaType, bool isLoading) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tabContent,
          SizedBox(height: 32.h),
          Container(
            width: double.infinity,
            height: 56.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(15.r),
                onTap: isLoading ? null : () => _handleUpload(mediaType),
                child: Center(
                  child: isLoading
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
    );
  }

  void _handleUpload(String mediaType) {
    List<XFile> selectedImages = [];
    List<XFile> selectedVideos = [];

    switch (mediaType) {
      case 'cleanliness':
        selectedImages = _cleanlinessImages;
        selectedVideos = _cleanlinessVideos;
        break;
      case 'damages':
        selectedImages = _damagesImages;
        selectedVideos = _damagesVideos;
        break;
      case 'maintenance':
        selectedImages = _maintenanceImages;
        selectedVideos = _maintenanceVideos;
        break;
      case 'pestControl':
        selectedImages = _pestControlImages;
        selectedVideos = _pestControlVideos;
        break;
    }

    if (selectedImages.isEmpty && selectedVideos.isEmpty) {
      _showErrorSnackbar(LangKeys.pleaseAddMedia);
      return;
    }

    switch (mediaType) {
      case 'cleanliness':
        _handleCleaningUpload();
        break;
      case 'damages':
        _handleDamageUpload();
        break;
      case 'maintenance':
        _handleMaintenanceUpload();
        _showErrorSnackbar("هذا النوع قيد التطوير");
        break;
      case 'pestControl':
        _handlePestControlUpload();
        _showErrorSnackbar("هذا النوع قيد التطوير");
        break;
    }
  }

  void _handleCleaningUpload() {
    final cubit = getIt<UploadCleaningCubit>();
    cubit.chaletIdController.text = _selectedUnit.isNotEmpty ? _selectedUnit : widget.chaletsId;
    cubit.cleaningTypeController.text = _selectedCleaningType;
    cubit.cleaningTimeController.text = _selectedCleaningTiming;
    cubit.cleaningCostController.text = _selectedCleaningTiming == 'after' ? _cleaningPrice.trim() : '';
    cubit.selectedImages = _cleanlinessImages;
    cubit.selectedVideos = _cleanlinessVideos;
    cubit.inventoryItems = _selectedCleaningTiming == 'after'
        ? _usedItems.entries
            .where((e) => e.value > 0)
            .map((e) {
              final inventoryId = _getItemIdAsInt(e.key);
              return InventoryItem(
                inventoryId: inventoryId,
                quantity: e.value,
              );
            })
            .where((item) => item.inventoryId != 0)
            .toList()
        : <InventoryItem>[];
    cubit.emitUpdateCleaningState();
  }

  void _handleDamageUpload() {
    final cubit = getIt<UploadDamageCubit>();
    cubit.chaletIdController.text = _selectedUnit.isNotEmpty ? _selectedUnit : widget.chaletsId;
    cubit.descriptionController.text = _damageDescription.trim();
    cubit.priceController.text = _damagePrice.trim();
    cubit.selectedImages = _damagesImages;
    cubit.selectedVideos = _damagesVideos;
    cubit.emitUploadDamageState();
  }

  void _handleMaintenanceUpload() {
    // TODO: Implement maintenance upload when ready
    print('Maintenance upload - Description: $_maintenanceDescription, Price: $_maintenancePrice');
    print('Maintenance images: ${_maintenanceImages.length}, videos: ${_maintenanceVideos.length}');
  }

  void _handlePestControlUpload() {
    // TODO: Implement pest control upload when ready
    print('Pest control upload - Description: $_pestControlDescription, Price: $_pestControlPrice');
    print('Pest control images: ${_pestControlImages.length}, videos: ${_pestControlVideos.length}');
  }

  int _getItemIdAsInt(String itemId) {
    final parsedInt = int.tryParse(itemId);
    if (parsedInt != null) {
      return parsedInt;
    }
    
    final parts = itemId.split('_');
    if (parts.length > 1) {
      return int.tryParse(parts.last) ?? 0;
    }
    
    return 0;
  }

  void _showErrorSnackbar(String messageKey) {
    if (!mounted) return;
    final translatedMessage = context.translate(messageKey);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(translatedMessage),
      backgroundColor: Theme.of(context).colorScheme.error,
      duration: const Duration(seconds: 2),
    ));
  }
}
