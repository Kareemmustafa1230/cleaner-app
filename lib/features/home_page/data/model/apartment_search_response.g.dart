// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apartment_search_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApartmentSearchResponse _$ApartmentSearchResponseFromJson(
        Map<String, dynamic> json) =>
    ApartmentSearchResponse(
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
      status: (json['status'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ApartmentSearchResponseToJson(
        ApartmentSearchResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'message': instance.message,
      'status': instance.status,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      chalets: (json['chalets'] as List<dynamic>?)
          ?.map((e) => Chalets.fromJson(e as Map<String, dynamic>))
          .toList(),
      searchResultsCount: (json['searchResultsCount'] as num?)?.toInt(),
      pagination: json['pagination'] == null
          ? null
          : Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'chalets': instance.chalets,
      'searchResultsCount': instance.searchResultsCount,
      'pagination': instance.pagination,
    };

Chalets _$ChaletsFromJson(Map<String, dynamic> json) => Chalets(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      code: json['code'] as String?,
      floor: json['floor'] as String?,
      building: json['building'] as String?,
      location: json['location'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String?,
      type: json['type'] as String?,
      isCleaned: json['isCleaned'] as bool?,
      isBooked: json['isBooked'] as bool?,
      image: json['image'] as String?,
      imagesCount: (json['imagesCount'] as num?)?.toInt(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$ChaletsToJson(Chalets instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'floor': instance.floor,
      'building': instance.building,
      'location': instance.location,
      'description': instance.description,
      'status': instance.status,
      'type': instance.type,
      'isCleaned': instance.isCleaned,
      'isBooked': instance.isBooked,
      'image': instance.image,
      'imagesCount': instance.imagesCount,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
      currentPage: (json['currentPage'] as num?)?.toInt(),
      lastPage: (json['lastPage'] as num?)?.toInt(),
      perPage: (json['perPage'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
      from: (json['from'] as num?)?.toInt(),
      to: (json['to'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'lastPage': instance.lastPage,
      'perPage': instance.perPage,
      'total': instance.total,
      'from': instance.from,
      'to': instance.to,
    };
