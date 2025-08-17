// import '../../../../core/error/api_error_handler.dart';
// import '../../../../core/networking/api/api_result.dart';
// import '../data_source/apartment_search_data_source.dart';
// import '../model/apartment_search_response.dart';
//
// class ApartmentSearchRepo {
//   final ApartmentSearchDataSource _apartmentSearchDataSource;
//
//   ApartmentSearchRepo(this._apartmentSearchDataSource);
//
//   //apartmentSearch
//   Future<ApiResult<ApartmentSearchResponse>> apartmentSearch(String page , String search) async {
//     try {
//       final response = await _apartmentSearchDataSource.apartmentSearch(page,search);
//       return ApiResult.success(response);
//     } catch (error) {
//       return ApiResult.failure(ErrorHandler.handle(error));
//     }
//   }
// }
import 'package:hive/hive.dart';
import '../../../../core/error/api_error_handler.dart';
import '../../../../core/networking/api/api_result.dart';
import '../data_source/apartment_search_data_source.dart';
import '../model/apartment_search_response.dart';

class ApartmentSearchRepo {
  final ApartmentSearchDataSource _apartmentSearchDataSource;

  ApartmentSearchRepo(this._apartmentSearchDataSource);

  Future<ApiResult<ApartmentSearchResponse>> apartmentSearch(String page, String search) async {
    try {
      final box = Hive.box('apartmentBox');

      if (search.isEmpty && page == "1") {
        final cached = box.get('apartmentSearch');
        if (cached != null && cached is ApartmentSearchResponse) {
          return ApiResult.success(cached);
        }
      }

      final response = await _apartmentSearchDataSource.apartmentSearch(page, search);

      if (search.isEmpty && page == "1") {
        await box.put('apartmentSearch', response);
      }

      return ApiResult.success(response);
    } catch (error) {
      // لو الخطأ من Hive, حوله لـ ErrorModel
      final handledError = ErrorHandler.handle(error);

      return ApiResult.failure(handledError);
    }
  }
}
