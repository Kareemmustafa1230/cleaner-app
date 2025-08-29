import '../../../../core/error/api_error_handler.dart';
import '../../../../core/networking/api/api_result.dart';
import '../data_source/upload_pest_maintenance_data_source.dart';
import '../model/upload_pest_maintenance_request.dart';
import '../model/upload_response.dart';

class UploadPestMaintenanceRepo {
  final UploadPestMaintenanceDataSource _uploadPestMaintenance;

  UploadPestMaintenanceRepo(this._uploadPestMaintenance);

  Future<ApiResult<UploadResponse>> uploadPestMaintenance( UploadPestMaintenanceRequest uploadPestMaintenanceRequest) async {
    try {
      final response = await _uploadPestMaintenance.uploadPestMaintenance(uploadPestMaintenanceRequest);

      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
