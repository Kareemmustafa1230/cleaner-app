import '../../../../core/error/api_error_handler.dart';
import '../../../../core/networking/api/api_result.dart';
import '../data_source/unread_count_data_source.dart';
import '../model/unread_count_notifications_response.dart';

class UnreadCountRepo {
  final UnreadCountDataSource _unreadCountDataSource;

  UnreadCountRepo(this._unreadCountDataSource);

  //unreadCount
  Future<ApiResult<UnreadCountNotificationsResponse>> unreadCount() async {
    try {
      final response = await _unreadCountDataSource.unreadCount();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
} 