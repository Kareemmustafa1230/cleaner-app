import 'package:diyar/features/setting/data/repo/logout_repo.dart';
import 'package:diyar/features/setting/logic/state/logout_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helpers/shared_pref_helper.dart';
import '../../../../core/networking/constants/api_constants.dart';
import '../../../../core/networking/di/dependency_injection.dart';
import '../../../../core/notification_services/device_token.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final LogoutRepo _logoutRepo;

  LogoutCubit(this._logoutRepo) : super(const LogoutState.initial());

    Future<void> emitLogoutState() async {
      emit(const LogoutState.loading());
      final loginResponse = await _logoutRepo.logout();
      await loginResponse.when(
        success: (response) async {
          // حذف جميع البيانات المحفوظة في SharedPreferences
          await _clearAllUserData();
          emit(LogoutState.success(message: response.message!));
        },
        failure: (error) {
          emit(LogoutState.error(error: error.apiErrorModel.message));
        },
      );
    }

  /// حذف جميع بيانات المستخدم المحفوظة
  Future<void> _clearAllUserData() async {
    try {
      // حذف التوكن
      await getIt<SharedPrefHelper>().removeData(key: ApiKey.authorization);
      
      // حذف رقم الهاتف
     // await getIt<SharedPrefHelper>().removeData(key: ApiKey.whatApp);
      
      // حذف بيانات الهاتف والحزمة
     // await getIt<SharedPrefHelper>().removeData(key: ApiKey.hasPhone);
     // await getIt<SharedPrefHelper>().removeData(key: ApiKey.hasPackage);
      
      // حذف FCM Token
      await getIt<SharedPrefHelper>().removeData(key: ApiKey.fcm);
      
      // حذف بيانات الفئات
      await getIt<SharedPrefHelper>().removeData(key: ApiKey.data);
      
      // حذف FCM Token من Firebase
      await DeviceToken.deleteToken();
      
      print('🗑️ All user data cleared on logout');
    } catch (e) {
      print('❌ Error clearing user data on logout: $e');
    }
  }
  }

