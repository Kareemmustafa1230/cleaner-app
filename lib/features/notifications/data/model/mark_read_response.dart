import 'package:freezed_annotation/freezed_annotation.dart';
part 'mark_read_response.g.dart';


@JsonSerializable()
class MarkReadResponse {
  MarkReadResponse({
    this.message,
    this.data,
    this.status
  });

  String? message;
  String? data;
  int? status;

  factory MarkReadResponse.fromJson(Map<String, dynamic> json) =>  _$MarkReadResponseFromJson(json);
}


