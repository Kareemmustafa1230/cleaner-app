import 'package:dio/dio.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:diyar/core/networking/api/api_service.dart';
import '../../../../core/error/api_error_handler.dart';
import '../model/upload_pest_maintenance_request.dart';
import '../model/upload_response.dart';

class UploadPestMaintenanceDataSource {
  final ApiService _apiService;

  UploadPestMaintenanceDataSource(this._apiService);

  Future<UploadResponse> uploadPestMaintenance(
      UploadPestMaintenanceRequest request) async {
    try {
      final formData = FormData();

      // الحقول الأساسية من الموديل
      formData.fields.addAll([
        MapEntry("service_type", request.serviceType),
        MapEntry("chalet_id", request.chaletId),
        MapEntry("cleaning_time", request.cleaningTime),
        MapEntry("description", request.description),
      ]);

      // لو cleaning_time = after أبعت السعر
      if (request.cleaningTime == "after" && request.price != null) {
        formData.fields.add(MapEntry("price", request.price!));
      }

      // الصور
      if (request.images != null && request.images!.isNotEmpty) {
        for (final img in request.images!) {
          formData.files.add(
            MapEntry(
              "images[]",
              await MultipartFile.fromFile(img),
            ),
          );
        }
      }

      // الفيديوهات: رفع مباشر أو بالشانك حسب الحجم
      if (request.videos != null && request.videos!.isNotEmpty) {
        for (final vidPath in request.videos!) {
          final file = File(vidPath);
          final fileSize = await file.length();
          const int chunkSize = 8 * 1024 * 1024; // 8MB

          if (fileSize > chunkSize) {
            await _uploadVideoInChunks(
              file: file,
              baseFields: formData.fields,
            );
          } else {
            formData.files.add(
              MapEntry(
                'videos[]',
                await MultipartFile.fromFile(file.path),
              ),
            );
          }
        }
      }

      final response = await _apiService.uploadPestMaintenance(
        formData,
        'multipart/form-data',
      );

      return response;
    } catch (e) {
      throw ErrorHandler.handle(e).apiErrorModel;
    }
  }

  /// رفع فيديو كبير بالشانكات
  Future<void> _uploadVideoInChunks({
    required File file,
    required List<MapEntry<String, String>> baseFields,
    int chunkSize = 8 * 1024 * 1024,
  }) async {
    final fileLength = await file.length();
    final totalChunks = (fileLength / chunkSize).ceil();
    final fileName = file.uri.pathSegments.isNotEmpty
        ? file.uri.pathSegments.last
        : 'video.mp4';

    final raf = await file.open();
    int offset = 0;
    int chunkIndex = 0;
    try {
      while (offset < fileLength) {
        final remaining = fileLength - offset;
        final currentChunkSize = remaining > chunkSize ? chunkSize : remaining;
        final bytes = await raf.read(currentChunkSize);

        final chunkForm = FormData();

        // الحقول الأساسية
        chunkForm.fields.addAll(baseFields);

        // تعريف الشانك
        chunkForm.fields.addAll([
          MapEntry('chunk_index', chunkIndex.toString()),
          MapEntry('total_chunks', totalChunks.toString()),
          MapEntry('file_name', fileName),
          MapEntry('is_chunk', '1'),
        ]);

        // ملف الشانك
        chunkForm.files.add(
          MapEntry(
            'video_chunk',
            MultipartFile.fromBytes(
              bytes,
              filename: 'chunk_${chunkIndex}_$fileName',
              contentType: MediaType('video', 'mp4'),
            ),
          ),
        );

        // ارفع الشانك
        await _apiService.uploadPestMaintenance(
          chunkForm,
          'multipart/form-data',
        );

        offset += currentChunkSize;
        chunkIndex += 1;
      }
    } finally {
      await raf.close();
    }
  }
}
