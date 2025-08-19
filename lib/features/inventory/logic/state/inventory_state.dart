import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/model/inventory_response.dart';
part 'inventory_state.freezed.dart';

@freezed
class InventoryState with _$InventoryState{
  const factory InventoryState.initial() = _Initial;
  const factory InventoryState.loading() = Loading;
  const factory InventoryState.success({required InventoryResponse inventoryResponse}) = Success;
  const factory InventoryState.error({required String error}) = Error;

}



