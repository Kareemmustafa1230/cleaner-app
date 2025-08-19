import '../../../../core/error/api_error_handler.dart';
import '../../../../core/networking/api/api_result.dart';
import '../data_source/inventory_data_source.dart';
import '../model/inventory_response.dart';

class InventoryRepo {
  final InventoryDataSource _inventoryDataSource;

  InventoryRepo(this._inventoryDataSource);

  //inventory
  Future<ApiResult<InventoryResponse>> inventory(String page ) async {
    try {
      final response = await _inventoryDataSource.inventory(
        page
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}