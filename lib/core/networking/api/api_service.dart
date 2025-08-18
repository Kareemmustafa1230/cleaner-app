import 'package:dio/dio.dart';
import 'package:diyar/features/login/data/model/login_request_body.dart';
import 'package:diyar/features/notifications/data/model/mark_read_response.dart';
import 'package:diyar/features/setting/data/model/logout_response.dart';
import 'package:retrofit/retrofit.dart';
import '../../../features/home_page/data/model/apartment_search_response.dart';
import '../../../features/inventory/data/model/inventory_response.dart';
import '../../../features/login/data/model/login_response.dart';
import '../../../features/notifications/data/model/notifications_response.dart';
import '../../../features/notifications/data/model/unread_count_notifications_response.dart';
import '../../../features/setting/data/model/change_password_request.dart';
import '../../../features/setting/data/model/update_profile_response.dart';
import '../constants/api_constants.dart';
part 'api_service.g.dart';


@RestApi(baseUrl: ApiConstants.baserUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST(ApiConstants.login)
  Future<LoginResponse> login(
    @Body() LoginRequestBody loginRequestBody,
    @Header('Accept') String accept,
    );

  @POST(ApiConstants.logout)
  Future<LogoutResponse> logout(
      @Header('Accept') String accept,
      );

  @PUT(ApiConstants.updatePassword)
  Future<LogoutResponse> updatePassword(
      @Body() ChangePasswordRequest changePasswordRequest,
      @Header('Accept') String accept,
      );

  @PUT(ApiConstants.updateProfile)
  @MultiPart()
  Future<UpdateProfileResponse> updateProfile(
      @Body() FormData formData,
      @Header('Accept') String accept,

  );

  @GET(ApiConstants.apartmentSearch)
  Future<ApartmentSearchResponse> apartmentSearch(
      @Query('page') String page,
      @Query('search') String search,
      @Header('Accept') String accept,
      );

  @GET(ApiConstants.inventory)
  Future<InventoryResponse> inventory(
      @Header('Accept') String accept,
      );



  @GET(ApiConstants.notifications)
  Future<NotificationsResponse> notifications(
      @Query('page') String page);

  @POST(ApiConstants.markRead)
  Future<MarkReadResponse> markRead(
      @Header('Accept') String accept,
      );


  @GET(ApiConstants.unreadCount)
  Future<UnreadCountNotificationsResponse> unreadCount(
      @Header('Accept') String accept,
      );

}
