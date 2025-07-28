import 'package:dio/dio.dart';
import '../../helpers/shared_pref_helper.dart';
import '../constants/api_constants.dart';
import '../di/dependency_injection.dart';

class DioInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[ApiKey.authorization] =
    getIt<SharedPrefHelper>().getData(key: ApiKey.authorization) != null
        ? 'Bearer ${getIt<SharedPrefHelper>().getData(key: ApiKey.authorization)}'
        : null;
    
    // إضافة معلومات إضافية للطلب
    print('🌐 API Request: ${options.method} ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // تسجيل الاستجابة بنجاح
    print('✅ API Response: ${response.statusCode} ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // التعامل مع خطأ 429 بشكل خاص
    if (err.response?.statusCode == 429) {
      print('⚠️ Rate limit exceeded (429) for: ${err.requestOptions.path}');
      print('⚠️ Response data: ${err.response?.data}');
    }
    
    // التعامل مع أخطاء الشبكة
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      print('⏰ Network timeout for: ${err.requestOptions.path}');
    }
    
    // التعامل مع أخطاء الاتصال
    if (err.type == DioExceptionType.connectionError) {
      print('🔌 Connection error for: ${err.requestOptions.path}');
    }
    
    print('❌ API Error: ${err.type} - ${err.message}');
    super.onError(err, handler);
  }
}
