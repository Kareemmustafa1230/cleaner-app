import 'package:diyar/features/notifications/data/model/notifications_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'notifications_state.freezed.dart';

@freezed
class NotificationsState with _$NotificationsState {
  const factory NotificationsState.initial() = Initial;
  const factory NotificationsState.loading() = Loading;
  const factory NotificationsState.success({required NotificationsResponse notificationsResponse}) = Success;
  const factory NotificationsState.error({required String error}) = Error;
}