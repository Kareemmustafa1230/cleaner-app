// import 'package:diyar/features/login/data/model/login_response.dart';
// import '../../../../core/error/api_error_handler.dart';
// import '../../../../core/networking/api/api_service.dart';
//
// class  CleaningInventoryDataSource{
//   final ApiService _apiService;
//
//   CleaningInventoryDataSource(this._apiService);
//
//   // chaletsInfo
//   Future<LoginResponse> chaletsInfo(String chaletId, String cleaningType ,String cleaningDate , String mediaType ) async {
//     try {
//       final response = await _apiService.chaletsInfo(
//         chaletId,
//         cleaningType,
//         cleaningDate,
//         mediaType,
//         'application/json',
//       );
//       return response;
//     } catch (e) {
//       throw ErrorHandler.handle(e).apiErrorModel;
//     }
//   }
// }
