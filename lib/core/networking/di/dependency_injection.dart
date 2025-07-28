 import 'package:dio/dio.dart';
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
   // getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt()));
   // getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt()));
   // getIt.registerLazySingleton<LoginDataSource>(() => LoginDataSource(getIt()));

}