import 'package:diyar/features/setting/data/data_source/change_password_data_source.dart';
import 'package:diyar/features/setting/data/model/logout_response.dart';
import '../../../../core/error/api_error_handler.dart';
import '../../../../core/networking/api/api_result.dart';
import '../model/change_password_request.dart';

class ChangePasswordRepo {
  final ChangePasswordDataSource _changePasswordDataSource;

  ChangePasswordRepo(this._changePasswordDataSource);

//updatePassword
  Future<ApiResult<LogoutResponse>> updatePassword(ChangePasswordRequest changePasswordRequest) async {
    try {
      final response = await _changePasswordDataSource.updatePassword(
          changePasswordRequest)
      ;
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}