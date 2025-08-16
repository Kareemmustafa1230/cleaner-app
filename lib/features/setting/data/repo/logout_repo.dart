import 'package:diyar/features/setting/data/data_source/logout_data_source.dart';
import 'package:diyar/features/setting/data/model/logout_response.dart';
import '../../../../core/error/api_error_handler.dart';
import '../../../../core/networking/api/api_result.dart';

class LogoutRepo {
  final LogoutDataSource _logoutDataSource;

  LogoutRepo(this._logoutDataSource);

//logout
  Future<ApiResult<LogoutResponse>> logout() async {
    try {
      final response = await _logoutDataSource.logout();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}