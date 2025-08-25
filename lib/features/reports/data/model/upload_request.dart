import 'package:freezed_annotation/freezed_annotation.dart';
part 'upload_request.g.dart';

@JsonSerializable()
class UploadRequest {
  @JsonKey(name: 'cleaning_type')
  final String cleaningType;
  @JsonKey(name: 'chalet_id')
  final String chaletId;
  @JsonKey(name: 'cleaning_time')
  final String cleaningTime;
  final String date;

  /// هيتبعت بس لو cleaning_time = after
  @JsonKey(name: 'cleaning_cost')
  final String? cleaningCost;
  @JsonKey(name: 'images[]')
  final List<String>? images;
  @JsonKey(name: 'videos[]')
  final List<String>? videos;

  /// هيتبعت بس لو cleaning_time = after
  @JsonKey(name: 'inventory_items')
  final List<InventoryItem>? inventoryItems;

  UploadRequest({
    required this.cleaningType,
    required this.chaletId,
    required this.cleaningTime,
    required this.date,
    this.cleaningCost,
    this.images,
    this.videos,
    this.inventoryItems,
  });

  factory UploadRequest.fromJson(Map<String, dynamic> json) =>
      _$UploadRequestFromJson(json);

  Map<String, dynamic> toJson() {
    final json = _$UploadRequestToJson(this);

    // الشرط بتاع before/after
    if (cleaningTime == "before") {
      json.remove('cleaning_cost');
      json.remove('inventory_items');
    }

    return json;
  }
}

@JsonSerializable()
class InventoryItem {
  final int id;
  @JsonKey(name: 'quantity_used')
  final int quantityUsed;

  InventoryItem({
    required this.id,
    required this.quantityUsed,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) =>
      _$InventoryItemFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryItemToJson(this);
}
