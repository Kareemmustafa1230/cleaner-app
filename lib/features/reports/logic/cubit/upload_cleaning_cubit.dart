import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // عشان ننسق التاريخ
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

  Future<void> emitUpdateProfileState() async {
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

      await updateProfileResponse.when(
        success: (response) async {
          if (cleaningTimeController.text == "before") {
            emit(UploadState.successWithoutInventory(
                message: response.message ?? "تم الحفظ بدون مخزون"));
          } else {
            emit(UploadState.success(
                message: response.message ?? "تم الحفظ بنجاح"));
          }
        },
        failure: (error) {
          emit(UploadState.error(
              error: error.apiErrorModel.message ?? 'حدث خطأ غير معروف'));
        },
      );
    } catch (e) {
      emit(UploadState.error(error: e.toString()));
    }
  }
}
