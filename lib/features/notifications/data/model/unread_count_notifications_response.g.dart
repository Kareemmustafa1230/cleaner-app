// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unread_count_notifications_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnreadCountNotificationsResponse _$UnreadCountNotificationsResponseFromJson(
        Map<String, dynamic> json) =>
    UnreadCountNotificationsResponse(
      count: (json['count'] as num?)?.toInt(),
      message: json['message'] as String?,
      status: (json['status'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UnreadCountNotificationsResponseToJson(
        UnreadCountNotificationsResponse instance) =>
    <String, dynamic>{
      'count': instance.count,
      'message': instance.message,
      'status': instance.status,
    };
