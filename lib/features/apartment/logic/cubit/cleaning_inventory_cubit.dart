import 'package:diyar/features/apartment/logic/cubit/cleaning_inventory_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:diyar/core/networking/api/api_result.dart';
import 'package:diyar/features/apartment/data/model/cleaning_inventory_item.dart';
import 'package:diyar/features/apartment/data/model/cleaning_service.dart';
import 'package:diyar/features/apartment/data/model/cleaning_record.dart';
import 'package:diyar/features/apartment/data/repo/cleaning_inventory_repo.dart';

class CleaningInventoryCubit extends Cubit<CleaningInventoryState> {
  final CleaningInventoryRepo _repo;

  CleaningInventoryCubit(this._repo) : super(const CleaningInventoryState.initial());

  // جلب قائمة عناصر مخزون النظافة
  Future<void> getCleaningInventoryItems() async {
    emit(const CleaningInventoryState.loading());
    
    final result = await _repo.getCleaningInventoryItems();
    
    result.when(
      success: (items) {
        emit(CleaningInventoryState.itemsLoaded(items));
      },
      failure: (error) {
        emit(CleaningInventoryState.error(error.apiErrorModel.message));
      },
    );
  }

  // جلب بيانات خدمة النظافة لشقة معينة
  Future<void> getCleaningService(String apartmentId) async {
    emit(const CleaningInventoryState.loading());
    
    final result = await _repo.getCleaningService(apartmentId);
    
    result.when(
      success: (service) {
        if (service != null) {
          emit(CleaningInventoryState.serviceLoaded(service));
        } else {
          emit(const CleaningInventoryState.serviceNotFound());
        }
      },
      failure: (error) {
        emit(CleaningInventoryState.error(error.apiErrorModel.message));
      },
    );
  }

  // حفظ بيانات خدمة النظافة
  Future<void> saveCleaningService(CleaningService service) async {
    emit(const CleaningInventoryState.saving());
    
    final result = await _repo.saveCleaningService(service);
    
    result.when(
      success: (savedService) {
        emit(CleaningInventoryState.serviceSaved(savedService));
      },
      failure: (error) {
        emit(CleaningInventoryState.error(error.apiErrorModel.message));
      },
    );
  }

  // تحديث بيانات خدمة النظافة
  Future<void> updateCleaningService(CleaningService service) async {
    emit(const CleaningInventoryState.saving());
    
    final result = await _repo.updateCleaningService(service);
    
    result.when(
      success: (updatedService) {
        emit(CleaningInventoryState.serviceUpdated(updatedService));
      },
      failure: (error) {
        emit(CleaningInventoryState.error(error.apiErrorModel.message));
      },
    );
  }

  // جلب إحصائيات مخزون النظافة
  Future<void> getCleaningInventoryStats() async {
    emit(const CleaningInventoryState.loading());
    
    final result = await _repo.getCleaningInventoryStats();
    
    result.when(
      success: (stats) {
        emit(CleaningInventoryState.statsLoaded(stats));
      },
      failure: (error) {
        emit(CleaningInventoryState.error(error.apiErrorModel.message));
      },
    );
  }

  // جلب سجلات النظافة لشقة معينة
  Future<void> getCleaningRecords(String apartmentId) async {
    emit(const CleaningInventoryState.loading());
    
    final result = await _repo.getCleaningRecords(apartmentId);
    
    result.when(
      success: (records) {
        emit(CleaningInventoryState.recordsLoaded(records));
      },
      failure: (error) {
        emit(CleaningInventoryState.error(error.apiErrorModel.message));
      },
    );
  }

  // جلب سجل نظافة محدد
  Future<void> getCleaningRecord(String recordId) async {
    emit(const CleaningInventoryState.loading());
    
    final result = await _repo.getCleaningRecord(recordId);
    
    result.when(
      success: (record) {
        if (record != null) {
          emit(CleaningInventoryState.recordLoaded(record));
        } else {
          emit(const CleaningInventoryState.recordNotFound());
        }
      },
      failure: (error) {
        emit(CleaningInventoryState.error(error.apiErrorModel.message));
      },
    );
  }

  // إعادة تعيين الحالة
  void reset() {
    emit(const CleaningInventoryState.initial());
  }
} 