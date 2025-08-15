import 'package:diyar/features/notifications/data/model/mark_read_response.dart';
import '../../../../core/error/api_error_handler.dart';
import '../../../../core/networking/api/api_result.dart';
import '../data_source/mark_read_data_source.dart';

class MarkReadRepo {
  final MarkReadDataSource _markReadDataSource;

  MarkReadRepo(this._markReadDataSource);

  //markRead
  Future<ApiResult<MarkReadResponse>> markRead() async {
    try {
      final response = await _markReadDataSource.markRead();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
} 