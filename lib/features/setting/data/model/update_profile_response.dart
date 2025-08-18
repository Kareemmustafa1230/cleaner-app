import 'package:json_annotation/json_annotation.dart';
part 'update_profile_response.g.dart';

@JsonSerializable()
class UpdateProfileResponse {
  final UpdateProfileData data;
  final String message;
  final int status;

  UpdateProfileResponse({
    required this.data,
    required this.message,
    required this.status,
  });

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileResponseToJson(this);
}

@JsonSerializable()
class UpdateProfileData {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String? image;

  UpdateProfileData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.image,
  });

  factory UpdateProfileData.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileDataFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileDataToJson(this);
}
