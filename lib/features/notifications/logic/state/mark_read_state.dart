import 'package:freezed_annotation/freezed_annotation.dart';

part 'mark_read_state.freezed.dart';

@freezed
class MarkReadState with _$MarkReadState {
  const factory MarkReadState.initial() = Initial;
  const factory MarkReadState.loading() = Loading;
  const factory MarkReadState.success(String message) = Success;
  const factory MarkReadState.error(String error) = Error;
} 