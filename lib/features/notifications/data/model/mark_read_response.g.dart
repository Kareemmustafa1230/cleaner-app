// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark_read_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkReadResponse _$MarkReadResponseFromJson(Map<String, dynamic> json) =>
    MarkReadResponse(
      message: json['message'] as String?,
      data: json['data'] as String?,
      status: (json['status'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MarkReadResponseToJson(MarkReadResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
      'status': instance.status,
    };
