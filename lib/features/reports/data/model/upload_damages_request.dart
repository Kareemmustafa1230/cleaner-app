import 'package:freezed_annotation/freezed_annotation.dart';
part 'upload_damages_request.g.dart';

@JsonSerializable()
class UploadDamagesRequest {
  final String description;
  @JsonKey(name: 'chalet_id')
  final String chaletId;
  final String price;
  @JsonKey(name: 'images[]')
  final List<String>? images;
  @JsonKey(name: 'videos[]')
  final List<String>? videos;


  UploadDamagesRequest({
    required this.description,
    required this.chaletId,
    required this.price,
    required this.images,
    required this.videos,
  });

  factory UploadDamagesRequest.fromJson(Map<String, dynamic> json) => _$UploadDamagesRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UploadDamagesRequestToJson(this);


}


