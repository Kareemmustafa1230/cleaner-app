import 'package:diyar/core/networking/api/api_service.dart';
import 'package:diyar/features/notifications/data/model/notifications_response.dart';
import '../../../../core/error/api_error_handler.dart';

class NotificationsDataSource {
  final ApiService _apiService;

  NotificationsDataSource(this._apiService);

  // notifications
  Future<NotificationsResponse> notifications(String page) async {
    try {
      final response = await _apiService.notifications(page);
      return response;
    } catch (e) {
      throw ErrorHandler.handle(e).apiErrorModel;
    }
  }

} 