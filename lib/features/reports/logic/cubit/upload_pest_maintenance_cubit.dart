import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../data/model/upload_pest_maintenance_request.dart';
import '../../data/repo/upload_pest_maintenance_repo.dart';
import '../state/upload_state.dart';

class UploadPestMaintenanceCubit extends Cubit<UploadState> {
  final UploadPestMaintenanceRepo _uploadPestMaintenanceRepo;

  UploadPestMaintenanceCubit(this._uploadPestMaintenanceRepo)
      : super(const UploadState.initial());

  // Controllers للمدخلات الأساسية
  TextEditingController serviceTypeController = TextEditingController();
  TextEditingController chaletIdController = TextEditingController();
  TextEditingController cleaningTimeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // صور وفيديوهات
  List<XFile> selectedImages = [];
  List<XFile> selectedVideos = [];

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

  /// إعادة تعيين الحالة إلى الحالة الأولية
  void resetState() {
    if (isClosed) return;
    _isUploading = false;

    // Clear all controllers
    serviceTypeController.clear();
    chaletIdController.clear();
    cleaningTimeController.clear();
    priceController.clear();
    descriptionController.clear();

    // Clear all lists
    selectedImages.clear();
    selectedVideos.clear();

    emit(const UploadState.initial());
  }

  @override
  Future<void> close() {
    // Dispose controllers
    serviceTypeController.dispose();
    chaletIdController.dispose();
    cleaningTimeController.dispose();
    priceController.dispose();
    descriptionController.dispose();

    // Clear lists
    selectedImages.clear();
    selectedVideos.clear();

    return super.close();
  }

  Future<void> emitUploadPestMaintenance() async {
    if (isClosed) return;

    if (_isUploading) {
      print('UploadPestMaintenanceCubit: Already uploading, skipping...');
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
      // بناء الـ Request
      final request = UploadPestMaintenanceRequest(
        serviceType: serviceTypeController.text,
        chaletId: chaletIdController.text,
        cleaningTime: cleaningTimeController.text,
        description: descriptionController.text,
        price: cleaningTimeController.text == "after"
            ? priceController.text
            : null,
        images: selectedImages.map((e) => e.path).toList(),
        videos: selectedVideos.map((e) => e.path).toList(),
      );

      final responseResult =
      await _uploadPestMaintenanceRepo.uploadPestMaintenance(request);

      if (isClosed) return;

      await responseResult.when(
        success: (response) async {
          if (isClosed) return;
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
          if (isClosed) return;
          _isUploading = false;
          emit(UploadState.error(error: error.apiErrorModel.message));
        },
      );
    } catch (e) {
      if (isClosed) return;
      _isUploading = false;
      emit(UploadState.error(error: e.toString()));
    }
  }
}
