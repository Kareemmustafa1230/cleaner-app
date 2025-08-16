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
  bool? isCleaned;
  bool? isBooked;
  String? image;
  int? imagesCount;
  String? createdAt;
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
  int? currentPage;
  int? lastPage;
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