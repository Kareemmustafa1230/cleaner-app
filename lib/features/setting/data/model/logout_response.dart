import 'package:freezed_annotation/freezed_annotation.dart';
part 'logout_response.g.dart';

@JsonSerializable()
class LogoutResponse {
  String? data;
  String? message;
  int? status;

  LogoutResponse({this.data, this.message, this.status});

  factory LogoutResponse.fromJson(Map<String, dynamic> json) => _$LogoutResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LogoutResponseToJson(this);
}