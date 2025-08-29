import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../data/model/upload_request.dart';
import '../../data/repo/upload_cleaning_repo.dart';
import '../state/upload_state.dart';

class UploadCleaningCubit extends Cubit<UploadState> {
  final UploadCleaningRepo _uploadCleaningRepo;

  UploadCleaningCubit(this._uploadCleaningRepo)
      : super(const UploadState.initial());

  // Controllers للمدخلات الأساسية
  TextEditingController cleaningTypeController = TextEditingController();
  TextEditingController chaletIdController = TextEditingController();
  TextEditingController cleaningTimeController = TextEditingController();
  TextEditingController cleaningCostController = TextEditingController();

  // صور وفيديوهات
  List<XFile> selectedImages = [];
  List<XFile> selectedVideos = [];

  // Inventory Items
  List<InventoryItem> inventoryItems = [];

  // متغير لتتبع حالة الرفع
  bool _isUploading = false;

  /// اختيار صورة
  void addImage(XFile image) {
    selectedImages.add(image);
    emit(const UploadState.pickMediaSuccess());
  }

  /// اختيار فيديو
  void addVideo(XFile video) {
    selectedVideos.add(video);
    emit(const UploadState.pickMediaSuccess());
  }

  /// إضافة عنصر مخزون
  void addInventoryItem(InventoryItem item) {
    inventoryItems.add(item);
    emit(const UploadState.inventoryUpdated());
  }


  /// إعادة تعيين الحالة إلى الحالة الأولية
  void resetState() {
    if (isClosed) return;
    _isUploading = false;
    
    // Clear all controllers
    cleaningTypeController.clear();
    chaletIdController.clear();
    cleaningTimeController.clear();
    cleaningCostController.clear();
    
    // Clear all lists
    selectedImages.clear();
    selectedVideos.clear();
    inventoryItems.clear();
    
    emit(const UploadState.initial());
  }

  @override
  Future<void> close() {
    // Dispose controllers
    cleaningTypeController.dispose();
    chaletIdController.dispose();
    cleaningTimeController.dispose();
    cleaningCostController.dispose();
    
    // Clear lists
    selectedImages.clear();
    selectedVideos.clear();
    inventoryItems.clear();
    
    return super.close();
  }

  Future<void> emitUpdateCleaningState() async {
    if (isClosed) return; // فحص إذا كان الـ cubit مغلق
    
    // فحص إذا كان الرفع جارٍ بالفعل
    if (_isUploading) {
      print('UploadCleaningCubit: Already uploading, skipping...');
      return;
    }
    
    // التحقق من وجود صور وفيديوهات
    if (selectedImages.isEmpty) {
      emit(UploadState.error(error: 'imagesRequired'));
      return;
    }
    
    if (selectedVideos.isEmpty) {
      emit(UploadState.error(error: 'videosRequired'));
      return;
    }
    
    _isUploading = true;
    emit(const UploadState.loading());

    try {
      // تنسيق التاريخ الحالي
      final now = DateTime.now();
      final formattedDate = DateFormat("yyyy-MM-dd").format(now);

      final uploadRequest = UploadRequest(
        cleaningType: cleaningTypeController.text,
        chaletId: chaletIdController.text,
        cleaningTime: cleaningTimeController.text,
        date: formattedDate,
        cleaningCost: cleaningTimeController.text == "after"
            ? cleaningCostController.text
            : null,
        images: selectedImages.map((e) => e.path).toList(),
        videos: selectedVideos.map((e) => e.path).toList(),
        inventoryItems: cleaningTimeController.text == "after"
            ? inventoryItems
            : null,
      );

      final updateProfileResponse =
      await _uploadCleaningRepo.uploadCleaning(uploadRequest);

      if (isClosed) return; // فحص مرة أخرى بعد الـ API call

      await updateProfileResponse.when(
        success: (response) async {
          if (isClosed) return; // فحص قبل إرسال الحالة النهائية
          _isUploading = false;
          if (cleaningTimeController.text == "before") {
            emit(UploadState.successWithoutInventory(
                message: response.message ?? "uploadSuccessWithoutInventoryMessage"));
          } else {
            emit(UploadState.success(
                message: response.message ?? "uploadSuccessMessage"));
          }
        },
        failure: (error) {
          if (isClosed) return; // فحص قبل إرسال حالة الخطأ
          _isUploading = false;
          emit(UploadState.error(
              error: error.apiErrorModel.message));
        },
      );
    } catch (e) {
      if (isClosed) return; // فحص قبل إرسال حالة الخطأ
      _isUploading = false;
      emit(UploadState.error(error: e.toString()));
    }
  }
}
