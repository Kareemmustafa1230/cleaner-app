// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadRequest _$UploadRequestFromJson(Map<String, dynamic> json) =>
    UploadRequest(
      cleaningType: json['cleaning_type'] as String,
      chaletId: json['chalet_id'] as String,
      cleaningTime: json['cleaning_time'] as String,
      date: json['date'] as String,
      cleaningCost: json['cleaning_cost'] as String?,
      images: (json['images[]'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      videos: (json['videos[]'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      inventoryItems: (json['inventory_items'] as List<dynamic>?)
          ?.map((e) => InventoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UploadRequestToJson(UploadRequest instance) =>
    <String, dynamic>{
      'cleaning_type': instance.cleaningType,
      'chalet_id': instance.chaletId,
      'cleaning_time': instance.cleaningTime,
      'date': instance.date,
      'cleaning_cost': instance.cleaningCost,
      'images[]': instance.images,
      'videos[]': instance.videos,
      'inventory_items': instance.inventoryItems,
    };

InventoryItem _$InventoryItemFromJson(Map<String, dynamic> json) =>
    InventoryItem(
      id: (json['id'] as num).toInt(),
      quantityUsed: (json['quantity_used'] as num).toInt(),
    );

Map<String, dynamic> _$InventoryItemToJson(InventoryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity_used': instance.quantityUsed,
    };
