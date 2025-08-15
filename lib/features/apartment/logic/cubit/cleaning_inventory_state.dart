import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/model/cleaning_inventory_item.dart';
import '../../data/model/cleaning_record.dart';
import '../../data/model/cleaning_service.dart';
part 'cleaning_inventory_state.freezed.dart';

@freezed
class CleaningInventoryState with _$CleaningInventoryState {
  const factory CleaningInventoryState.initial() = _Initial;
  const factory CleaningInventoryState.loading() = _Loading;
  const factory CleaningInventoryState.itemsLoaded(List<CleaningInventoryItem> items) = _ItemsLoaded;
  const factory CleaningInventoryState.serviceLoaded(CleaningService service) = _ServiceLoaded;
  const factory CleaningInventoryState.serviceNotFound() = _ServiceNotFound;
  const factory CleaningInventoryState.saving() = _Saving;
  const factory CleaningInventoryState.serviceSaved(CleaningService service) = _ServiceSaved;
  const factory CleaningInventoryState.serviceUpdated(CleaningService service) = _ServiceUpdated;
  const factory CleaningInventoryState.statsLoaded(Map<String, dynamic> stats) = _StatsLoaded;
  const factory CleaningInventoryState.recordsLoaded(List<CleaningRecord> records) = _RecordsLoaded;
  const factory CleaningInventoryState.recordLoaded(CleaningRecord record) = _RecordLoaded;
  const factory CleaningInventoryState.recordNotFound() = _RecordNotFound;
  const factory CleaningInventoryState.error(String message) = _Error;
} 