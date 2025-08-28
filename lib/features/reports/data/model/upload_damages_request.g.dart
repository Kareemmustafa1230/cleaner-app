// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_damages_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadDamagesRequest _$UploadDamagesRequestFromJson(
        Map<String, dynamic> json) =>
    UploadDamagesRequest(
      description: json['description'] as String,
      chaletId: json['chalet_id'] as String,
      price: json['price'] as String,
      images:
          (json['images[]'] as List<dynamic>).map((e) => e as String).toList(),
      videos:
          (json['videos[]'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$UploadDamagesRequestToJson(
        UploadDamagesRequest instance) =>
    <String, dynamic>{
      'description': instance.description,
      'chalet_id': instance.chaletId,
      'price': instance.price,
      'images[]': instance.images,
      'videos[]': instance.videos,
    };
