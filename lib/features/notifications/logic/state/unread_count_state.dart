import 'package:freezed_annotation/freezed_annotation.dart';
part 'unread_count_state.freezed.dart';

@freezed
class UnreadCountState with _$UnreadCountState {
  const factory UnreadCountState.initial() = Initial;
  const factory UnreadCountState.loading() = Loading;
  const factory UnreadCountState.success(int count) = Success;
  const factory UnreadCountState.error(String error) = Error;
} 