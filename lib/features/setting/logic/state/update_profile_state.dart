import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/model/update_profile_response.dart';
part 'update_profile_state.freezed.dart';

@freezed
class UpdateProfileState with _$UpdateProfileState {
  const factory UpdateProfileState.initial() = Initial;
  const factory UpdateProfileState.loading() = Loading;
  const factory UpdateProfileState.success({required UpdateProfileResponse updateProfileResponse}) = Success;
  const factory UpdateProfileState.error({required String error}) = Error;

} 