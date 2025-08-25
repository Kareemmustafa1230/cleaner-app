// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadResponse _$UploadResponseFromJson(Map<String, dynamic> json) =>
    UploadResponse(
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
      status: (json['status'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UploadResponseToJson(UploadResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'message': instance.message,
      'status': instance.status,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      cleaningRecord: json['cleaning_record'] == null
          ? null
          : CleaningRecord.fromJson(
              json['cleaning_record'] as Map<String, dynamic>),
      uploadedMedia: json['uploaded_media'] == null
          ? null
          : UploadedMedia.fromJson(
              json['uploaded_media'] as Map<String, dynamic>),
      cleaningInfo: json['cleaning_info'] == null
          ? null
          : CleaningInfo.fromJson(
              json['cleaning_info'] as Map<String, dynamic>),
      inventoryUsed: json['inventory_used'] == null
          ? null
          : InventoryUsed.fromJson(
              json['inventory_used'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'cleaning_record': instance.cleaningRecord,
      'uploaded_media': instance.uploadedMedia,
      'cleaning_info': instance.cleaningInfo,
      'inventory_used': instance.inventoryUsed,
    };

CleaningRecord _$CleaningRecordFromJson(Map<String, dynamic> json) =>
    CleaningRecord(
      id: (json['id'] as num?)?.toInt(),
      chaletId: (json['chalet_id'] as num?)?.toInt(),
      cleanerId: (json['cleaner_id'] as num?)?.toInt(),
      date: json['date'] as String?,
      cleaningCost: json['cleaning_cost'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$CleaningRecordToJson(CleaningRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chalet_id': instance.chaletId,
      'cleaner_id': instance.cleanerId,
      'date': instance.date,
      'cleaning_cost': instance.cleaningCost,
      'status': instance.status,
    };

UploadedMedia _$UploadedMediaFromJson(Map<String, dynamic> json) =>
    UploadedMedia(
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => Images.fromJson(e as Map<String, dynamic>))
          .toList(),
      videos: (json['videos'] as List<dynamic>?)
          ?.map((e) => Videos.fromJson(e as Map<String, dynamic>))
          .toList(),
      imagesCount: (json['images_count'] as num?)?.toInt(),
      videosCount: (json['videos_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UploadedMediaToJson(UploadedMedia instance) =>
    <String, dynamic>{
      'images': instance.images,
      'videos': instance.videos,
      'images_count': instance.imagesCount,
      'videos_count': instance.videosCount,
    };

Images _$ImagesFromJson(Map<String, dynamic> json) => Images(
      id: (json['id'] as num?)?.toInt(),
      image: json['image'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$ImagesToJson(Images instance) => <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'type': instance.type,
    };

Videos _$VideosFromJson(Map<String, dynamic> json) => Videos(
      id: (json['id'] as num?)?.toInt(),
      video: json['video'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$VideosToJson(Videos instance) => <String, dynamic>{
      'id': instance.id,
      'video': instance.video,
      'type': instance.type,
    };

CleaningInfo _$CleaningInfoFromJson(Map<String, dynamic> json) => CleaningInfo(
      type: json['type'] as String?,
      time: json['time'] as String?,
    );

Map<String, dynamic> _$CleaningInfoToJson(CleaningInfo instance) =>
    <String, dynamic>{
      'type': instance.type,
      'time': instance.time,
    };

InventoryUsed _$InventoryUsedFromJson(Map<String, dynamic> json) =>
    InventoryUsed(
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => Items.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCost: (json['total_cost'] as num?)?.toInt(),
      itemsCount: (json['items_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$InventoryUsedToJson(InventoryUsed instance) =>
    <String, dynamic>{
      'items': instance.items,
      'total_cost': instance.totalCost,
      'items_count': instance.itemsCount,
    };

Items _$ItemsFromJson(Map<String, dynamic> json) => Items(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      quantityUsed: (json['quantity_used'] as num?)?.toInt(),
      price: json['price'] as String?,
      totalCost: (json['total_cost'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ItemsToJson(Items instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'quantity_used': instance.quantityUsed,
      'price': instance.price,
      'total_cost': instance.totalCost,
    };
