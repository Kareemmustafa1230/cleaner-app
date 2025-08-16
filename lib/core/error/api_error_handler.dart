import 'package:dio/dio.dart';
import '../networking/constants/api_constants.dart';
import 'error_model.dart';



// TODO: wallahy I will refactor this .. Omar Ahmed
enum DataSource {
  noContent,
  badRequest,
  forbidden,
  unauthorized,
  notFound,
  internalServerError,
  tooManyRequests,
  connectTimeout,
  cancel,
  receiveTimeout,
  sendTimeout,
  cacheError,
  noInternetConnection,
  defaultError,
}

class ResponseCode {
  static const int success = 200;
  static const int noContent = 201;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int internalServerError = 500;
  static const int notFound = 404;
  static const int apiLogicError = 422;
  static const int tooManyRequests = 429;

  static const int connectTimeout = -1;
  static const int cancel = -2;
  static const int receiveTimeout = -3;
  static const int sendTimeout = -4;
  static const int cacheError = -5;
  static const int noInternetConnection = -6;
  static const int defaultError = -7;
}

class ResponseMessage {
  static const String noContent = ApiErrors.noContent;
  static const String badRequest = ApiErrors.badRequestError;
  static const String unauthorized = ApiErrors.unauthorizedError;
  static const String forbidden = ApiErrors.forbiddenError;
  static const String internalServerError = ApiErrors.internalServerError;
  static const String notFound = ApiErrors.notFoundError;
  static const String tooManyRequests = 'تم تجاوز الحد المسموح للطلبات. يرجى الانتظار قليلاً';

  static String connectTimeout = ApiErrors.timeoutError;
  static String cancel = ApiErrors.defaultError;
  static String receiveTimeout = ApiErrors.timeoutError;
  static String sendTimeout = ApiErrors.timeoutError;
  static String cacheError = ApiErrors.cacheError;
  static String noInternetConnection = ApiErrors.noInternetError;
  static String defaultError = ApiErrors.defaultError;
}


extension DataSourceExtension on DataSource {
  ErrorModel getFailure() {
    switch (this) {
      case DataSource.noContent:
        return ErrorModel(
            status: ResponseCode.noContent, message: ResponseMessage.noContent);
      case DataSource.badRequest:
        return ErrorModel(
            status: ResponseCode.badRequest, message: ResponseMessage.badRequest);
      case DataSource.forbidden:
        return ErrorModel(
            status: ResponseCode.forbidden, message: ResponseMessage.forbidden);
      case DataSource.unauthorized:
        return ErrorModel(
            status: ResponseCode.unauthorized, message: ResponseMessage.unauthorized);
      case DataSource.notFound:
        return ErrorModel(
            status: ResponseCode.notFound, message: ResponseMessage.notFound);
      case DataSource.internalServerError:
        return ErrorModel(
            status: ResponseCode.internalServerError,
            message: ResponseMessage.internalServerError);
      case DataSource.tooManyRequests:
        return ErrorModel(
            status: ResponseCode.tooManyRequests,
            message: ResponseMessage.tooManyRequests);
      case DataSource.connectTimeout:
        return ErrorModel(
            status: ResponseCode.connectTimeout,
            message: ResponseMessage.connectTimeout);
      case DataSource.cancel:
        return ErrorModel(
            status: ResponseCode.cancel, message: ResponseMessage.cancel);
      case DataSource.receiveTimeout:
        return ErrorModel(
            status: ResponseCode.receiveTimeout,
            message: ResponseMessage.receiveTimeout);
      case DataSource.sendTimeout:
        return ErrorModel(
            status: ResponseCode.sendTimeout, message: ResponseMessage.sendTimeout);
      case DataSource.cacheError:
        return ErrorModel(
            status: ResponseCode.cacheError, message: ResponseMessage.cacheError);
      case DataSource.noInternetConnection:
        return ErrorModel(
            status: ResponseCode.noInternetConnection,
            message: ResponseMessage.noInternetConnection);
      case DataSource.defaultError:
        return ErrorModel(
            status: ResponseCode.defaultError, message: ResponseMessage.defaultError);
    }
  }
}

class ErrorHandler implements Exception {
  late ErrorModel apiErrorModel;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      // dio error so its an error from response of the API or from dio itself
      apiErrorModel = _handleError(error);
    } else {
      // default error
      //apiErrorModel = DataSource.defaultError.getFailure();
      apiErrorModel = error;

    }
  }
}

ErrorModel _handleError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return DataSource.connectTimeout.getFailure();
    case DioExceptionType.sendTimeout:
      return DataSource.sendTimeout.getFailure();
    case DioExceptionType.receiveTimeout:
      return DataSource.receiveTimeout.getFailure();
    case DioExceptionType.badResponse:
      if (error.response != null &&
          error.response?.statusCode != null &&
          error.response?.statusMessage != null) {
        // التعامل مع خطأ 429 بشكل خاص
        if (error.response?.statusCode == 429) {
          return DataSource.tooManyRequests.getFailure();
        }
        return ErrorModel.fromJson(error.response!.data);
      } else {
        return DataSource.defaultError.getFailure();
      }
    case DioExceptionType.unknown:
      if (error.response != null &&
          error.response?.statusCode != null &&
          error.response?.statusMessage != null) {
        // التعامل مع خطأ 429 بشكل خاص
        if (error.response?.statusCode == 429) {
          return DataSource.tooManyRequests.getFailure();
        }
        return ErrorModel.fromJson(error.response!.data);
      } else {
        return DataSource.defaultError.getFailure();
      }
    case DioExceptionType.cancel:
      return DataSource.cancel.getFailure();
    case DioExceptionType.connectionError:
      return DataSource.defaultError.getFailure();
    case DioExceptionType.badCertificate:
      return DataSource.defaultError.getFailure();
  }
}

class ApiInternalStatus {
  static const int success = 0;
  static const int failure = 1;
}