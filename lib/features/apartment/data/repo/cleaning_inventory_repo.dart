import 'package:diyar/core/networking/api/api_result.dart';
import 'package:diyar/features/apartment/data/data_source/cleaning_inventory_data_source.dart';
import 'package:diyar/features/apartment/data/model/cleaning_inventory_item.dart';
import 'package:diyar/features/apartment/data/model/cleaning_service.dart';
import 'package:diyar/features/apartment/data/model/cleaning_record.dart';

class CleaningInventoryRepo {
  final CleaningInventoryDataSource _dataSource;

  CleaningInventoryRepo(this._dataSource);

  // جلب قائمة عناصر مخزون النظافة
  Future<ApiResult<List<CleaningInventoryItem>>> getCleaningInventoryItems() async {
    return await _dataSource.getCleaningInventoryItems();
  }

  // جلب بيانات خدمة النظافة لشقة معينة
  Future<ApiResult<CleaningService?>> getCleaningService(String apartmentId) async {
    return await _dataSource.getCleaningService(apartmentId);
  }

  // حفظ بيانات خدمة النظافة
  Future<ApiResult<CleaningService>> saveCleaningService(CleaningService service) async {
    return await _dataSource.saveCleaningService(service);
  }

  // تحديث بيانات خدمة النظافة
  Future<ApiResult<CleaningService>> updateCleaningService(CleaningService service) async {
    return await _dataSource.updateCleaningService(service);
  }

  // جلب إحصائيات مخزون النظافة
  Future<ApiResult<Map<String, dynamic>>> getCleaningInventoryStats() async {
    return await _dataSource.getCleaningInventoryStats();
  }

  // جلب سجلات النظافة لشقة معينة
  Future<ApiResult<List<CleaningRecord>>> getCleaningRecords(String apartmentId) async {
    return await _dataSource.getCleaningRecords(apartmentId);
  }

  // جلب سجل نظافة محدد
  Future<ApiResult<CleaningRecord?>> getCleaningRecord(String recordId) async {
    return await _dataSource.getCleaningRecord(recordId);
  }
} 