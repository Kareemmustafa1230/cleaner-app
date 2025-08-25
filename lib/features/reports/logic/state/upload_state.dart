import 'package:freezed_annotation/freezed_annotation.dart';
part 'upload_state.freezed.dart';

@freezed
class UploadState with _$UploadState {
  const factory UploadState.initial() = Initial;
  const factory UploadState.loading() = Loading;
  const factory UploadState.success({required String message}) = Success;
  const factory UploadState.successWithoutInventory({required String message}) = SuccessWithoutInventory;
  const factory UploadState.error({required String error}) = Error;

  // دول مستخدمين في الكيوبت بتاعك
  const factory UploadState.pickMediaSuccess() = PickMediaSuccess;
  const factory UploadState.inventoryUpdated() = InventoryUpdated;
}
