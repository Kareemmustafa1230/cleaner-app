import 'package:freezed_annotation/freezed_annotation.dart';
part 'upload_pest_maintenance_request.g.dart';

@JsonSerializable()
class UploadPestMaintenanceRequest {
  @JsonKey(name: 'service_type')
  final String serviceType;
  @JsonKey(name: 'cleaning_time')
  final String cleaningTime;
  final String description;
  @JsonKey(name: 'chalet_id')
  final String chaletId;
  final String? price;
  @JsonKey(name: 'images[]')
  final List<String>? images;
  @JsonKey(name: 'videos[]')
  final List<String>? videos;

  UploadPestMaintenanceRequest({
    required this.description,
    required this.chaletId,
    this.price,
    required this.images,
    required this.videos,
    required this.serviceType,
    required this.cleaningTime,
  });

  factory UploadPestMaintenanceRequest.fromJson(Map<String, dynamic> json) =>
      _$UploadPestMaintenanceRequestFromJson(json);

  Map<String, dynamic> toJson() {
    final data = _$UploadPestMaintenanceRequestToJson(this);

    // لو cleaningTime != after امسح price
    if (cleaningTime != "after") {
      data.remove("price");
    }

    return data;
  }
}
