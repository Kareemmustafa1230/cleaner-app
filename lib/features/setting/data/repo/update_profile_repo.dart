import '../../../../core/error/api_error_handler.dart';
import '../../../../core/networking/api/api_result.dart';
import '../data_source/update_profile_data_source.dart';
import '../model/update_profile_request.dart';
import '../model/update_profile_response.dart';

class UpdateProfileRepo {
  final UpdateProfileDataSource _updateProfileDataSource;

  UpdateProfileRepo(this._updateProfileDataSource);

  Future<ApiResult<UpdateProfileResponse>> updateProfile(UpdateProfileRequest updateProfileRequest) async {
    try {
      final response = await _updateProfileDataSource.updateProfile(updateProfileRequest);

      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
