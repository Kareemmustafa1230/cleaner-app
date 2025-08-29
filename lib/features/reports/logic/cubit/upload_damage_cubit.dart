import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/model/upload_damages_request.dart';
import '../../data/repo/upload_damage_repo.dart';
import '../state/upload_state.dart';

class UploadDamageCubit extends Cubit<UploadState> {
  final UploadDamageRepo _uploadDamageRepo;

  UploadDamageCubit(this._uploadDamageRepo)
      : super(const UploadState.initial());

  // Controllers
  TextEditingController descriptionController = TextEditingController();
  TextEditingController chaletIdController = TextEditingController();
  TextEditingController priceController = TextEditingController();

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
    descriptionController.clear();
    chaletIdController.clear();
    priceController.clear();
    
    // Clear all lists
    selectedImages.clear();
    selectedVideos.clear();
    
    emit(const UploadState.initial());
  }

  @override
  Future<void> close() {
    // Dispose controllers
    descriptionController.dispose();
    chaletIdController.dispose();
    priceController.dispose();
    
    // Clear lists
    selectedImages.clear();
    selectedVideos.clear();
    
    return super.close();
  }

  Future<void> emitUploadDamageState() async {
    if (isClosed) return; // فحص إذا كان الـ cubit مغلق
    
    // فحص إذا كان الرفع جارٍ بالفعل
    if (_isUploading) {
      print('UploadDamageCubit: Already uploading, skipping...');
      return;
    }
    
    _isUploading = true;
    emit(const UploadState.loading());

    try {
      final uploadRequest = UploadDamagesRequest(
        description: descriptionController.text,
        chaletId: chaletIdController.text,
        price: priceController.text,
        images: selectedImages.isNotEmpty
            ? selectedImages.map((e) => e.path).toList()
            : null,
        videos: selectedVideos.isNotEmpty
            ? selectedVideos.map((e) => e.path).toList()
            : null,
      );

      final response = await _uploadDamageRepo.uploadDamage(uploadRequest);

      if (isClosed) return; // فحص مرة أخرى بعد الـ API call

      await response.when(
        success: (res) async {
          if (isClosed) return; // فحص قبل إرسال الحالة النهائية
          _isUploading = false;
          emit(UploadState.success(
              message: res.message ?? "تم حفظ البلاغ بنجاح"));
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
