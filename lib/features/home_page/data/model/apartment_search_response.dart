import 'package:freezed_annotation/freezed_annotation.dart';
part 'apartment_search_response.g.dart';



@JsonSerializable()
class ApartmentSearchResponse {
  Data? data;
  String? message;
  int? status;

  ApartmentSearchResponse({this.data, this.message, this.status});

  factory ApartmentSearchResponse.fromJson(Map<String, dynamic> json) =>  _$ApartmentSearchResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ApartmentSearchResponseToJson(this);

}

@JsonSerializable()
class Data {
  List<Chalets>? chalets;
  @JsonKey(name:'search_results_count')
  int? searchResultsCount;
  Pagination? pagination;

  Data({this.chalets, this.searchResultsCount, this.pagination});

  factory Data.fromJson(Map<String, dynamic> json) =>  _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class Chalets {
  int? id;
  String? name;
  String? code;
  String? floor;
  String? building;
  String? location;
  String? description;
  String? status;
  String? type;
  @JsonKey(name:'is_cleaned')
  bool? isCleaned;
  @JsonKey(name:'is_booked')
  bool? isBooked;
  String? image;
  @JsonKey(name:'images_count')
  int? imagesCount;
  @JsonKey(name:'created_at')
  String? createdAt;
  @JsonKey(name:'updated_at')
  String? updatedAt;

  Chalets(
      {this.id,
        this.name,
        this.code,
        this.floor,
        this.building,
        this.location,
        this.description,
        this.status,
        this.type,
        this.isCleaned,
        this.isBooked,
        this.image,
        this.imagesCount,
        this.createdAt,
        this.updatedAt});

  factory Chalets.fromJson(Map<String, dynamic> json) =>  _$ChaletsFromJson(json);
  Map<String, dynamic> toJson() => _$ChaletsToJson(this);
}

@JsonSerializable()
class Pagination {
  @JsonKey(name:'current_page')
  int? currentPage;
  @JsonKey(name:'last_page')
  int? lastPage;
  @JsonKey(name:'per_page')
  int? perPage;
  int? total;
  int? from;
  int? to;

  Pagination(
      {this.currentPage,
        this.lastPage,
        this.perPage,
        this.total,
        this.from,
        this.to});

  factory Pagination.fromJson(Map<String, dynamic> json) =>  _$PaginationFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}