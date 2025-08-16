import 'package:dio/dio.dart';
import 'package:diyar/core/networking/api/api_result.dart';
import 'package:diyar/core/networking/api/api_interceptors.dart';
import 'package:diyar/core/error/api_error_handler.dart';
import 'package:diyar/features/apartment/data/model/cleaning_inventory_item.dart';
import 'package:diyar/features/apartment/data/model/cleaning_service.dart';
import 'package:diyar/features/apartment/data/model/cleaning_record.dart';

class CleaningInventoryDataSource {
  final Dio _dio;

  CleaningInventoryDataSource(this._dio);

  // جلب قائمة عناصر مخزون النظافة
  Future<ApiResult<List<CleaningInventoryItem>>> getCleaningInventoryItems() async {
    try {
      final response = await _dio.get('/cleaning-inventory/items');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        final items = data.map((item) => CleaningInventoryItem.fromJson(item)).toList();
        return ApiResult.success(items);
      } else {
        return ApiResult.failure(ErrorHandler.handle('Failed to load inventory items'));
      }
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  // جلب بيانات خدمة النظافة لشقة معينة
  Future<ApiResult<CleaningService?>> getCleaningService(String apartmentId) async {
    try {
      final response = await _dio.get('/cleaning-service/$apartmentId');
      
      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          final service = CleaningService.fromJson(response.data['data']);
          return ApiResult.success(service);
        } else {
          return ApiResult.success(null);
        }
      } else {
        return ApiResult.failure(ErrorHandler.handle('Failed to load cleaning service'));
      }
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  // حفظ بيانات خدمة النظافة
  Future<ApiResult<CleaningService>> saveCleaningService(CleaningService service) async {
    try {
      final response = await _dio.post('/cleaning-service', data: service.toJson());
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final savedService = CleaningService.fromJson(response.data['data']);
        return ApiResult.success(savedService);
      } else {
        return ApiResult.failure(ErrorHandler.handle('Failed to save cleaning service'));
      }
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  // تحديث بيانات خدمة النظافة
  Future<ApiResult<CleaningService>> updateCleaningService(CleaningService service) async {
    try {
      final response = await _dio.put('/cleaning-service/${service.id}', data: service.toJson());
      
      if (response.statusCode == 200) {
        final updatedService = CleaningService.fromJson(response.data['data']);
        return ApiResult.success(updatedService);
      } else {
        return ApiResult.failure(ErrorHandler.handle('Failed to update cleaning service'));
      }
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  // جلب إحصائيات مخزون النظافة
  Future<ApiResult<Map<String, dynamic>>> getCleaningInventoryStats() async {
    try {
      final response = await _dio.get('/cleaning-inventory/stats');
      
      if (response.statusCode == 200) {
        return ApiResult.success(response.data['data'] ?? {});
      } else {
        return ApiResult.failure(ErrorHandler.handle('Failed to load inventory stats'));
      }
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  // جلب سجلات النظافة لشقة معينة
  Future<ApiResult<List<CleaningRecord>>> getCleaningRecords(String apartmentId) async {
    try {
      final response = await _dio.get('/cleaning-records/$apartmentId');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        final records = data.map((record) => CleaningRecord.fromJson(record)).toList();
        return ApiResult.success(records);
      } else {
        return ApiResult.failure(ErrorHandler.handle('Failed to load cleaning records'));
      }
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  // جلب سجل نظافة محدد
  Future<ApiResult<CleaningRecord?>> getCleaningRecord(String recordId) async {
    try {
      final response = await _dio.get('/cleaning-records/detail/$recordId');
      
      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          final record = CleaningRecord.fromJson(response.data['data']);
          return ApiResult.success(record);
        } else {
          return ApiResult.success(null);
        }
      } else {
        return ApiResult.failure(ErrorHandler.handle('Failed to load cleaning record'));
      }
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
} 