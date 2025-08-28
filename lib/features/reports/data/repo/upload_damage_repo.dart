import '../../../../core/error/api_error_handler.dart';
import '../../../../core/networking/api/api_result.dart';
import '../data_source/upload_damage_data_source.dart';
import '../model/upload_damages_request.dart';
import '../model/upload_response.dart';

class UploadDamageRepo {
  final UploadDamageDataSource _uploadDamageDataSource;

  UploadDamageRepo(this._uploadDamageDataSource);

  Future<ApiResult<UploadResponse>> uploadDamage( UploadDamagesRequest uploadDamagesRequest) async {
    try {
      final response = await _uploadDamageDataSource.uploadDamage(uploadDamagesRequest);

      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
