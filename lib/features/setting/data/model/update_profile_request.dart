import 'package:freezed_annotation/freezed_annotation.dart';
part 'update_profile_request.g.dart';

@JsonSerializable()
class UpdateProfileRequest {

  final String name;
  final String email;
  final String phone;
  final String address;
  final String? image;

  UpdateProfileRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.image

  });

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) => _$UpdateProfileRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileRequestToJson(this);
}