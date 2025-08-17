import 'package:diyar/core/networking/api/api_service.dart';
import 'package:diyar/features/setting/data/model/logout_response.dart';
import '../../../../core/error/api_error_handler.dart';
import '../model/change_password_request.dart';

class ChangePasswordDataSource {
  final ApiService _apiService;

  ChangePasswordDataSource(this._apiService);

  // updatePassword
  Future<LogoutResponse> updatePassword(ChangePasswordRequest changePasswordRequest) async {
    try {
      final response = await _apiService.updatePassword(
        changePasswordRequest,
        'application/json',
      );
      return response;
    } catch (e) {
      throw ErrorHandler.handle(e).apiErrorModel;
    }
  }
}
