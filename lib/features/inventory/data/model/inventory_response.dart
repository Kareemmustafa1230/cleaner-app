import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_response.g.dart';

@JsonSerializable()
class InventoryResponse {
  final InventoryData data;
  final String message;
  final int status;

  InventoryResponse({
    required this.data,
    required this.message,
    required this.status,
  });

  factory InventoryResponse.fromJson(Map<String, dynamic> json) =>
      _$InventoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryResponseToJson(this);
}

@JsonSerializable()
class InventoryData {
  final List<InventoryItem> inventory;
  @JsonKey(name: 'search_results_count')
  final int searchResultsCount;
  final Pagination pagination;

  InventoryData({
    required this.inventory,
    required this.searchResultsCount,
    required this.pagination,
  });

  factory InventoryData.fromJson(Map<String, dynamic> json) =>
      _$InventoryDataFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryDataToJson(this);
}

@JsonSerializable()
class InventoryItem {
  final int id;
  final String name;
  final int price;
  final int quantity;
  final String? image;

  InventoryItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.image,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) =>
      _$InventoryItemFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryItemToJson(this);
}

@JsonSerializable()
class Pagination {
  @JsonKey(name: 'current_page')
  final int currentPage;
  @JsonKey(name: 'last_page')
  final int lastPage;
  @JsonKey(name: 'per_page')
  final int perPage;
  final int total;
  final int from;
  final int to;

  Pagination({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.from,
    required this.to,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}
