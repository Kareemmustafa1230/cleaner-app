import 'package:freezed_annotation/freezed_annotation.dart';
part 'upload_response.g.dart';

@JsonSerializable()
class UploadResponse {
  Data? data;
  String? message;
  int? status;

  UploadResponse({this.data, this.message, this.status});

  factory UploadResponse.fromJson(Map<String, dynamic> json) =>  _$UploadResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UploadResponseToJson(this);

}

@JsonSerializable()
class Data {
  @JsonKey(name:'cleaning_record')
  CleaningRecord? cleaningRecord;
  @JsonKey(name:'uploaded_media')
  UploadedMedia? uploadedMedia;
  @JsonKey(name:'cleaning_info')
  CleaningInfo? cleaningInfo;
  @JsonKey(name:'inventory_used')
  InventoryUsed? inventoryUsed;

  Data(
      {this.cleaningRecord,
        this.uploadedMedia,
        this.cleaningInfo,
        this.inventoryUsed});

  factory Data.fromJson(Map<String, dynamic> json) =>  _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);


}

@JsonSerializable()
class CleaningRecord {
  int? id;
  @JsonKey(name:'chalet_id')
  int? chaletId;
  @JsonKey(name:'cleaner_id')
  int? cleanerId;
  String? date;
  @JsonKey(name:'cleaning_cost')
  String? cleaningCost;
  String? status;

  CleaningRecord(
      {this.id,
        this.chaletId,
        this.cleanerId,
        this.date,
        this.cleaningCost,
        this.status});

  factory CleaningRecord.fromJson(Map<String, dynamic> json) =>  _$CleaningRecordFromJson(json);
  Map<String, dynamic> toJson() => _$CleaningRecordToJson(this);
}

@JsonSerializable()
class UploadedMedia {
  List<Images>? images;
  List<Videos>? videos;
  @JsonKey(name:'images_count')
  int? imagesCount;
  @JsonKey(name:'videos_count')
  int? videosCount;

  UploadedMedia({this.images, this.videos, this.imagesCount, this.videosCount});

  factory UploadedMedia.fromJson(Map<String, dynamic> json) =>  _$UploadedMediaFromJson(json);
  Map<String, dynamic> toJson() => _$UploadedMediaToJson(this);

}

@JsonSerializable()
class Images {
  int? id;
  String? image;
  String? type;

  Images({this.id, this.image, this.type});

  factory Images.fromJson(Map<String, dynamic> json) =>  _$ImagesFromJson(json);
  Map<String, dynamic> toJson() => _$ImagesToJson(this);
}


@JsonSerializable()
class Videos {
  int? id;
  String? video;
  String? type;

  Videos({this.id, this.video, this.type});

  factory Videos.fromJson(Map<String, dynamic> json) =>  _$VideosFromJson(json);
  Map<String, dynamic> toJson() => _$VideosToJson(this);

}


@JsonSerializable()
class CleaningInfo {
  String? type;
  String? time;

  CleaningInfo({this.type, this.time});

  factory CleaningInfo.fromJson(Map<String, dynamic> json) =>  _$CleaningInfoFromJson(json);
  Map<String, dynamic> toJson() => _$CleaningInfoToJson(this);

}

@JsonSerializable()
class InventoryUsed {
  List<Items>? items;
  @JsonKey(name:'total_cost')
  int? totalCost;
  @JsonKey(name:'items_count')
  int? itemsCount;

  InventoryUsed({this.items, this.totalCost, this.itemsCount});

  factory InventoryUsed.fromJson(Map<String, dynamic> json) =>  _$InventoryUsedFromJson(json);
  Map<String, dynamic> toJson() => _$InventoryUsedToJson(this);
}

@JsonSerializable()
class Items {
  int? id;
  String? name;
  @JsonKey(name:'quantity_used')
  int? quantityUsed;
  String? price;
  @JsonKey(name:'total_cost')
  int? totalCost;

  Items({this.id, this.name, this.quantityUsed, this.price, this.totalCost});

  factory Items.fromJson(Map<String, dynamic> json) =>  _$ItemsFromJson(json);
  Map<String, dynamic> toJson() => _$ItemsToJson(this);
}