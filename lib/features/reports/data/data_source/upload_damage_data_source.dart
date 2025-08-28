import 'package:dio/dio.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:diyar/core/networking/api/api_service.dart';
import '../../../../core/error/api_error_handler.dart';
import '../model/upload_damages_request.dart';
import '../model/upload_response.dart';

class UploadDamageDataSource {
  final ApiService _apiService;

  UploadDamageDataSource(this._apiService);

  Future<UploadResponse> uploadDamage(UploadDamagesRequest uploadDamagesRequest) async {
    try {
      final formData = FormData();

      // الحقول الأساسية
      formData.fields.addAll([
        MapEntry("description", uploadDamagesRequest.description),
        MapEntry("chalet_id", uploadDamagesRequest.chaletId),
        MapEntry("price", uploadDamagesRequest.price),
      ]);


      // الصور
      if (uploadDamagesRequest.images != null && uploadDamagesRequest.images!.isNotEmpty) {
        for (final img in uploadDamagesRequest.images!) {
          formData.files.add(
            MapEntry(
              "images[]",
              await MultipartFile.fromFile(img),
            ),
          );
        }
      }

      // الفيديوهات: رفع مباشر أو بالشانك حسب الحجم
      if (uploadDamagesRequest.videos != null && uploadDamagesRequest.videos!.isNotEmpty) {
        for (final vidPath in uploadDamagesRequest.videos!) {
          final file = File(vidPath);
          final fileSize = await file.length();
          // 8MB chunk size بشكل افتراضي
          const int chunkSize = 8 * 1024 * 1024;
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

      final response = await _apiService.uploadDamage(
        formData,
        'multipart/form-data',
      );

      return response;
    } catch (e) {
      throw ErrorHandler.handle(e).apiErrorModel;
    }
  }

  /// يرفع فيديو كبير على شكل شانكات على نفس الـ endpoint
  /// يرسل كل شانك تحت المفتاح 'video_chunk' مع حقول إيضاحية للفهرسة.
  /// في السيرفر، يجب التعامل مع الشانكات وتجميعها.
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

        // أضف الحقول الأساسية نفسها حتى يستطيع السيرفر ربط الشانكات بالسجل
        chunkForm.fields.addAll(baseFields);

        // تعريفات الشانك
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
        await _apiService.uploadDamage(
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
