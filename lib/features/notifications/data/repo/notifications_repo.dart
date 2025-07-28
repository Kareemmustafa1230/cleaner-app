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
      // التعامل مع خطأ 429 بشكل خاص
      if (error.toString().contains('Too Many Requests')) {
        print('⚠️ Rate limit error in repo: $error');
        return ApiResult.failure(ErrorHandler.handle(error));
      }
      
      // التعامل مع أخطاء الشبكة
      if (error.toString().contains('Network Timeout') ||
          error.toString().contains('Connection Error')) {
        print('⚠️ Network error in repo: $error');
        return ApiResult.failure(ErrorHandler.handle(error));
      }
      
      print('❌ Error in notifications repo: $error');
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  //notificationsAllRead
  // Future<ApiResult<PackagesSubscribeResponse>> notificationsAllRead() async {
  //   try {
  //     final response = await _notificationsDataSource.notificationsAllRead();
  //     return ApiResult.success(response);
  //   } catch (error) {
  //     return ApiResult.failure(ErrorHandler.handle(error));
  //   }
  // }
} 