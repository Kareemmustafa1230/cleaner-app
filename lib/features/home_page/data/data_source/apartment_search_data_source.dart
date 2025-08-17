import '../../../../core/error/api_error_handler.dart';
import '../../../../core/networking/api/api_service.dart';
import '../model/apartment_search_response.dart';

class ApartmentSearchDataSource {
  final ApiService _apiService;

  ApartmentSearchDataSource(this._apiService);

  // apartmentSearch
  Future<ApartmentSearchResponse> apartmentSearch(String page , String search) async {
    try {
      final response = await _apiService.apartmentSearch(
           page,
          search,
          'application/json',
          //'${getIt<SharedPrefHelper>().getData(key: ApiKey.language)}'
      );
      return response;
    } catch (e) {
      throw ErrorHandler.handle(e).apiErrorModel;
    }
  }
  }
