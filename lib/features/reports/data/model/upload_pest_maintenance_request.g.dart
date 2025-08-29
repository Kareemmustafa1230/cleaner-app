// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_pest_maintenance_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadPestMaintenanceRequest _$UploadPestMaintenanceRequestFromJson(
        Map<String, dynamic> json) =>
    UploadPestMaintenanceRequest(
      description: json['description'] as String,
      chaletId: json['chalet_id'] as String,
      price: json['price'] as String?,
      images: (json['images[]'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      videos: (json['videos[]'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      serviceType: json['service_type'] as String,
      cleaningTime: json['cleaning_time'] as String,
    );

Map<String, dynamic> _$UploadPestMaintenanceRequestToJson(
        UploadPestMaintenanceRequest instance) =>
    <String, dynamic>{
      'service_type': instance.serviceType,
      'cleaning_time': instance.cleaningTime,
      'description': instance.description,
      'chalet_id': instance.chaletId,
      'price': instance.price,
      'images[]': instance.images,
      'videos[]': instance.videos,
    };
