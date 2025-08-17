import 'package:freezed_annotation/freezed_annotation.dart';
part 'change_password_request.g.dart';

@JsonSerializable()
class ChangePasswordRequest {
  @JsonKey(name: 'current_password')
  final String? currentPassword;

  @JsonKey(name: 'new_password')
  final String? newPassword;

  @JsonKey(name: 'new_password_confirmation')
  final String newPasswordConfirmation;

  ChangePasswordRequest({
    this.currentPassword,
    this.newPassword,
    required this.newPasswordConfirmation,
  });

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) => _$ChangePasswordRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordRequestToJson(this);
}
