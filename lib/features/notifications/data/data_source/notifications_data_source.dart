import 'package:dio/dio.dart';
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
    } on DioException catch (e) {
      // التعامل مع خطأ 429 بشكل خاص
      if (e.response?.statusCode == 429) {
        print('⚠️ Rate limit exceeded (429). Response: ${e.response?.data}');
        throw Exception('Too Many Requests: تم تجاوز الحد المسموح للطلبات');
      }
      
      // التعامل مع أخطاء الشبكة
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        print('⚠️ Network timeout: ${e.message}');
        throw Exception('Network Timeout: انتهت مهلة الاتصال');
      }
      
      // التعامل مع أخطاء الاتصال
      if (e.type == DioExceptionType.connectionError) {
        print('⚠️ Connection error: ${e.message}');
        throw Exception('Connection Error: مشكلة في الاتصال بالخادم');
      }
      
      // التعامل مع الأخطاء الأخرى
      print('❌ DioException: ${e.type} - ${e.message}');
      throw ErrorHandler.handle(e).apiErrorModel;
    } catch (e) {
      print('❌ Unexpected error: $e');
      throw ErrorHandler.handle(e).apiErrorModel;
    }
  }

  // notificationsAllRead
  // Future<PackagesSubscribeResponse> notificationsAllRead() async {
  //   try {
  //     final response = await _apiService.notificationsAllRead();
  //     return response;
  //   } catch (e) {
  //     throw ErrorHandler.handle(e).apiErrorModel;
  //   }
  // }
} 