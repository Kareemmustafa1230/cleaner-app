 import 'package:dio/dio.dart';
import 'package:diyar/features/login/data/data_source/login_data_source.dart';
import 'package:diyar/features/login/data/repo/login_repo.dart';
import 'package:diyar/features/login/logic/cubit/login_cubit.dart';
import 'package:diyar/features/setting/data/data_source/logout_data_source.dart';
import 'package:diyar/features/setting/data/repo/logout_repo.dart';
import 'package:diyar/features/setting/logic/cubit/logout_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import '../../app_cubit/app_cubit.dart';
import '../../helpers/shared_pref_helper.dart';
import '../api/api_factory.dart';
import '../api/api_service.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Dio & ApiService
  Dio dio = DioFactory.getDio();
  final navigatorKey = GlobalKey<NavigatorState>();

  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));
  getIt.registerLazySingleton<SharedPrefHelper>(() => SharedPrefHelper());
  getIt.registerFactory(AppCubit.new);
  getIt.registerSingleton<GlobalKey<NavigatorState>>(navigatorKey);
   // login
   getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt()));
   getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt()));
   getIt.registerLazySingleton<LoginDataSource>(() => LoginDataSource(getIt()));
  //Logout
  getIt.registerLazySingleton<LogoutRepo>(() => LogoutRepo(getIt()));
  getIt.registerFactory<LogoutCubit>(() => LogoutCubit(getIt()));
  getIt.registerLazySingleton<LogoutDataSource>(() => LogoutDataSource(getIt()));
}