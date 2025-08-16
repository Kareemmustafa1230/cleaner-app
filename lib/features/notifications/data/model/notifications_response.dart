import 'package:freezed_annotation/freezed_annotation.dart';
part 'notifications_response.g.dart';


@JsonSerializable()
class NotificationsResponse {
  DataNotificationsResponse? data;
  String? message;
  int? status;

  NotificationsResponse({this.data, this.message, this.status});
  factory NotificationsResponse.fromJson(Map<String, dynamic> json) =>  _$NotificationsResponseFromJson(json);

}

@JsonSerializable()
class DataNotificationsResponse {
  List<Notifications>? notifications;
  Pagination? pagination;
  @JsonKey(name: 'unread_count')
  int? unreadCount;
  DataNotificationsResponse({this.notifications, this.pagination,this.unreadCount});

  factory DataNotificationsResponse.fromJson(Map<String, dynamic> json) =>  _$DataNotificationsResponseFromJson(json);

}

@JsonSerializable()
class Notifications {
  int? id;
  String? title;
  String? message;
  String? type;
  @JsonKey(name: 'is_read')
  bool? isRead;
  @JsonKey(name: 'read_at')
  String? readAt;
  @JsonKey(name: 'created_at')
  String? createdAt;
  @JsonKey(name: 'created_at_human')
  String? createdAtHuman;
  Data? data;

  Notifications(
      {this.id,
        this.title,
        this.message,
        this.type,
        this.isRead,
        this.readAt,
        this.createdAt,
        this.createdAtHuman,
        this.data});

  factory Notifications.fromJson(Map<String, dynamic> json) =>  _$NotificationsFromJson(json);

}

@JsonSerializable()
class Data {
  String? amount;
  String? notes;

  Data({this.amount, this.notes});

  factory Data.fromJson(Map<String, dynamic> json) =>  _$DataFromJson(json);

}

@JsonSerializable()
class Pagination {
  @JsonKey(name: 'current_page')
  int? currentPage;
  @JsonKey(name: 'last_page')
  int? lastPage;
  @JsonKey(name: 'per_page')
  int? perPage;
  int? total;
  int? from;
  int? to;
  @JsonKey(name: 'has_more_pages')
  bool? hasMorePages;
  @JsonKey(name: 'next_page_url')
  String? nextPageUrl;
  @JsonKey(name: 'prev_page_url')
  String? prevPageUrl;

  Pagination(
      {this.currentPage,
        this.lastPage,
        this.perPage,
        this.total,
        this.from,
        this.to,
        this.hasMorePages,
        this.nextPageUrl,
        this.prevPageUrl});

  factory Pagination.fromJson(Map<String, dynamic> json) =>  _$PaginationFromJson(json);


}