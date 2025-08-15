import '../../../../core/error/api_error_handler.dart';
import '../../../../core/networking/api/api_result.dart';
import '../data_source/notifications_data_source.dart';
import '../model/notifications_response.dart';

class NotificationsRepo {
  final NotificationsDataSource _notificationsDataSource;

  NotificationsRepo(this._notificationsDataSource);

  //notifications
  Future<ApiResult<NotificationsResponse>> notifications(String page) async {
    try {
      final response = await _notificationsDataSource.notifications(page);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

} 