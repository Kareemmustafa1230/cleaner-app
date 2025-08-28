import 'package:freezed_annotation/freezed_annotation.dart';
part 'upload_response.g.dart';

@JsonSerializable()
class UploadResponse {
  String? data;
  String? message;
  int? status;

  UploadResponse({this.data, this.message, this.status});

  factory UploadResponse.fromJson(Map<String, dynamic> json) =>  _$UploadResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UploadResponseToJson(this);

}
