import 'package:diyar/core/networking/api/api_service.dart';
import 'package:diyar/features/notifications/data/model/unread_count_notifications_response.dart';
import '../../../../core/error/api_error_handler.dart';

class UnreadCountDataSource {
  final ApiService _apiService;

  UnreadCountDataSource(this._apiService);

  // unreadCount
  Future<UnreadCountNotificationsResponse> unreadCount() async {
    try {
      final response = await _apiService.unreadCount('application/json');
      return response;
    } catch (e) {
      throw ErrorHandler.handle(e).apiErrorModel;
    }
  }
} 