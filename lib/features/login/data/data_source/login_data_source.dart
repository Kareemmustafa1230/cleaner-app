import 'package:diyar/features/login/data/model/login_response.dart';
import '../../../../core/error/api_error_handler.dart';
import '../../../../core/networking/api/api_service.dart';
import '../model/login_request_body.dart';

class LoginDataSource {
  final ApiService _apiService;

  LoginDataSource(this._apiService);

  // Login
  Future<LoginResponse> login(LoginRequestBody loginRequestBody) async {
    try {
      final response = await _apiService.login(
          loginRequestBody,
          'application/json',
          //'${getIt<SharedPrefHelper>().getData(key: ApiKey.language)}'
      );
      return response;
    } catch (e) {
      throw ErrorHandler.handle(e).apiErrorModel;
    }
  }
  }
