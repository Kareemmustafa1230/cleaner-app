import 'package:dio/dio.dart';
import 'package:diyar/core/networking/api/api_service.dart';
import '../../../../core/error/api_error_handler.dart';
import '../model/upload_request.dart';
import '../model/upload_response.dart';

class UploadCleaningDataSource {
  final ApiService _apiService;

  UploadCleaningDataSource(this._apiService);

  Future<UploadResponse> uploadCleaning(UploadRequest uploadRequest) async {
    try {
      final formData = FormData();

      // الحقول الأساسية
      formData.fields.addAll([
        MapEntry("cleaning_type", uploadRequest.cleaningType),
        MapEntry("chalet_id", uploadRequest.chaletId),
        MapEntry("cleaning_time", uploadRequest.cleaningTime),
        MapEntry("date", uploadRequest.date),
      ]);

      // لو cleaning_time = after أبعت cost و inventory
      if (uploadRequest.cleaningTime == "after") {
        if (uploadRequest.cleaningCost != null) {
          formData.fields.add(
            MapEntry("cleaning_cost", uploadRequest.cleaningCost!),
          );
        }

        if (uploadRequest.inventoryItems != null &&
            uploadRequest.inventoryItems!.isNotEmpty) {
          for (final item in uploadRequest.inventoryItems!) {
            formData.fields.add(MapEntry("inventory_items[][id]", item.id.toString()));
            formData.fields.add(MapEntry(
                "inventory_items[][quantity_used]", item.quantityUsed.toString()));
          }
        }
      }

      // الصور
      if (uploadRequest.images != null && uploadRequest.images!.isNotEmpty) {
        for (final img in uploadRequest.images!) {
          formData.files.add(
            MapEntry(
              "images[]",
              await MultipartFile.fromFile(img),
            ),
          );
        }
      }

      // الفيديوهات
      if (uploadRequest.videos != null && uploadRequest.videos!.isNotEmpty) {
        for (final vid in uploadRequest.videos!) {
          formData.files.add(
            MapEntry(
              "videos[]",
              await MultipartFile.fromFile(vid),
            ),
          );
        }
      }

      final response = await _apiService.uploadCleaning(
        formData,
        'multipart/form-data',
      );

      return response;
    } catch (e) {
      throw ErrorHandler.handle(e).apiErrorModel;
    }
  }
}
