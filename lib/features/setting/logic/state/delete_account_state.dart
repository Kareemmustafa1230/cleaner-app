import 'package:freezed_annotation/freezed_annotation.dart';
part 'delete_account_state.freezed.dart';

@freezed
class DeleteAccountState with _$DeleteAccountState {
  const factory DeleteAccountState.initial() = Initial;
  const factory DeleteAccountState.loading() = Loading;
  const factory DeleteAccountState.success({required String message}) = Success;
  const factory DeleteAccountState.error({required String error}) = Error;
} 