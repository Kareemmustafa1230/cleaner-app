import '../../../../core/error/api_error_handler.dart';
import '../../../../core/networking/api/api_result.dart';
import '../data_source/upload_cleaning_data_source.dart';
import '../model/upload_request.dart';
import '../model/upload_response.dart';

class UploadCleaningRepo {
  final UploadCleaningDataSource _uploadCleaningDataSource;

  UploadCleaningRepo(this._uploadCleaningDataSource);

  Future<ApiResult<UploadResponse>> uploadCleaning( UploadRequest uploadRequest) async {
    try {
      final response = await _uploadCleaningDataSource.uploadCleaning(uploadRequest);

      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
