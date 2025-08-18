import 'package:dio/dio.dart';
import 'package:diyar/core/networking/api/api_service.dart';
import '../../../../core/error/api_error_handler.dart';
import '../model/update_profile_request.dart';
import '../model/update_profile_response.dart';

class UpdateProfileDataSource {
  final ApiService _apiService;

  UpdateProfileDataSource(this._apiService);

  Future<UpdateProfileResponse> updateProfile(UpdateProfileRequest updateProfileRequest) async {
    try {

      FormData formData = FormData();

      formData.fields.addAll([
          MapEntry("name", updateProfileRequest.name),
          MapEntry("email", updateProfileRequest.email),
          MapEntry("address", updateProfileRequest.address),
          MapEntry("phone", updateProfileRequest.phone),
        ]);

      if (updateProfileRequest.image != null && updateProfileRequest.image!.isNotEmpty) {
        formData.files.add(
          MapEntry(
            "image",
            await MultipartFile.fromFile(updateProfileRequest.image!),
          ),
        );
      }

      final response = await _apiService.updateProfile(
        formData,
        'application/json',
      );

      return response;
    } catch (e) {
      throw ErrorHandler.handle(e).apiErrorModel;
    }
  }
}
