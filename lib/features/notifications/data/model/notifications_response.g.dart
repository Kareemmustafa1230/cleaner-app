// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationsResponse _$NotificationsResponseFromJson(
        Map<String, dynamic> json) =>
    NotificationsResponse(
      data: json['data'] == null
          ? null
          : DataNotificationsResponse.fromJson(
              json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
      status: (json['status'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NotificationsResponseToJson(
        NotificationsResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'message': instance.message,
      'status': instance.status,
    };

DataNotificationsResponse _$DataNotificationsResponseFromJson(
        Map<String, dynamic> json) =>
    DataNotificationsResponse(
      notifications: (json['notifications'] as List<dynamic>?)
          ?.map((e) => Notifications.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: json['pagination'] == null
          ? null
          : Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
      unreadCount: (json['unread_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DataNotificationsResponseToJson(
        DataNotificationsResponse instance) =>
    <String, dynamic>{
      'notifications': instance.notifications,
      'pagination': instance.pagination,
      'unread_count': instance.unreadCount,
    };

Notifications _$NotificationsFromJson(Map<String, dynamic> json) =>
    Notifications(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      message: json['message'] as String?,
      type: json['type'] as String?,
      isRead: json['is_read'] as bool?,
      readAt: json['read_at'] as String?,
      createdAt: json['created_at'] as String?,
      createdAtHuman: json['created_at_human'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NotificationsToJson(Notifications instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'message': instance.message,
      'type': instance.type,
      'is_read': instance.isRead,
      'read_at': instance.readAt,
      'created_at': instance.createdAt,
      'created_at_human': instance.createdAtHuman,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      amount: json['amount'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'amount': instance.amount,
      'notes': instance.notes,
    };

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
      currentPage: (json['current_page'] as num?)?.toInt(),
      lastPage: (json['last_page'] as num?)?.toInt(),
      perPage: (json['per_page'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
      from: (json['from'] as num?)?.toInt(),
      to: (json['to'] as num?)?.toInt(),
      hasMorePages: json['has_more_pages'] as bool?,
      nextPageUrl: json['next_page_url'] as String?,
      prevPageUrl: json['prev_page_url'] as String?,
    );

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'per_page': instance.perPage,
      'total': instance.total,
      'from': instance.from,
      'to': instance.to,
      'has_more_pages': instance.hasMorePages,
      'next_page_url': instance.nextPageUrl,
      'prev_page_url': instance.prevPageUrl,
    };
