import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../features/notifications/data/model/notifications_response.dart';
import '../constants/api_constants.dart';
part 'api_service.g.dart';


@RestApi(baseUrl: ApiConstants.baserUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET(ApiConstants.notifications)
  Future<NotificationsResponse> notifications(
      @Query('page') String page);


}
