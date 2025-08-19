import '../../../../core/error/api_error_handler.dart';
import '../../../../core/networking/api/api_service.dart';
import '../model/inventory_response.dart';

class InventoryDataSource {
  final ApiService _apiService;

  InventoryDataSource(this._apiService);

  // inventory
  Future<InventoryResponse> inventory(String page ) async {
    try {
      final response = await _apiService.inventory(
           page,
          'application/json',
          //'${getIt<SharedPrefHelper>().getData(key: ApiKey.language)}'
      );
      return response;
    } catch (e) {
      throw ErrorHandler.handle(e).apiErrorModel;
    }
  }
  }
