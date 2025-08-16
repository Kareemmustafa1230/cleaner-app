import 'package:diyar/core/networking/api/api_service.dart';
import 'package:diyar/features/setting/data/model/logout_response.dart';
import '../../../../core/error/api_error_handler.dart';

class LogoutDataSource {
  final ApiService _apiService;

  LogoutDataSource(this._apiService);

  // logout
  Future<LogoutResponse> logout() async {
    try {
      final response = await _apiService.logout(
        'application/json',
      );
      return response;
    } catch (e) {
      throw ErrorHandler.handle(e).apiErrorModel;
    }
  }
}
