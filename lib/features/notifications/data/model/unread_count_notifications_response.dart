import 'package:freezed_annotation/freezed_annotation.dart';
part 'unread_count_notifications_response.g.dart';


@JsonSerializable()
class UnreadCountNotificationsResponse {
  int? count;
  String? message;
  int? status;

  UnreadCountNotificationsResponse({this.count, this.message, this.status});
  factory UnreadCountNotificationsResponse.fromJson(Map<String, dynamic> json) =>  _$UnreadCountNotificationsResponseFromJson(json);

}




