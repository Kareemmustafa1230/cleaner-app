 import 'package:dio/dio.dart';
import 'package:diyar/features/home_page/data/data_source/apartment_search_data_source.dart';
import 'package:diyar/features/home_page/data/repo/apartment_search_repo.dart';
import 'package:diyar/features/home_page/logic/cubit/apartment_search_cubit.dart';
import 'package:diyar/features/login/data/data_source/login_data_source.dart';
import 'package:diyar/features/login/data/repo/login_repo.dart';
import 'package:diyar/features/login/logic/cubit/login_cubit.dart';
import 'package:diyar/features/reports/data/data_source/upload_damage_data_source.dart';
import 'package:diyar/features/reports/data/repo/upload_damage_repo.dart';
import 'package:diyar/features/reports/logic/cubit/upload_damage_cubit.dart';
import 'package:diyar/features/setting/data/data_source/change_password_data_source.dart';
import 'package:diyar/features/setting/data/data_source/logout_data_source.dart';
import 'package:diyar/features/setting/data/repo/change_password_repo.dart';
import 'package:diyar/features/setting/data/repo/logout_repo.dart';
import 'package:diyar/features/setting/logic/cubit/change_password_cubit.dart';
import 'package:diyar/features/setting/logic/cubit/logout_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import '../../../features/inventory/data/data_source/inventory_data_source.dart';
import '../../../features/inventory/data/repo/inventory_repo.dart';
import '../../../features/inventory/logic/cubit/inventory_cubit.dart';
import '../../../features/reports/data/data_source/upload_cleaning_data_source.dart';
import '../../../features/reports/data/repo/upload_cleaning_repo.dart';
import '../../../features/reports/logic/cubit/upload_cleaning_cubit.dart';
import '../../../features/setting/data/data_source/update_profile_data_source.dart';
import '../../../features/setting/data/repo/update_profile_repo.dart';
import '../../../features/setting/logic/cubit/update_profile_cubit.dart';
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
  //apartmentSearch
  getIt.registerLazySingleton<ApartmentSearchRepo>(() => ApartmentSearchRepo(getIt()));
  getIt.registerFactory<ApartmentSearchCubit>(() => ApartmentSearchCubit(getIt()));
  getIt.registerLazySingleton<ApartmentSearchDataSource>(() => ApartmentSearchDataSource(getIt()));
  //changePassword
  getIt.registerLazySingleton<ChangePasswordRepo>(() => ChangePasswordRepo(getIt()));
  getIt.registerFactory<ChangePasswordCubit>(() => ChangePasswordCubit(getIt()));
  getIt.registerLazySingleton<ChangePasswordDataSource>(() => ChangePasswordDataSource(getIt()));

  //updateProfile
  getIt.registerLazySingleton<UpdateProfileRepo>(() => UpdateProfileRepo(getIt()));
  getIt.registerFactory<UpdateProfileCubit>(() => UpdateProfileCubit(getIt()));
  getIt.registerLazySingleton<UpdateProfileDataSource>(() => UpdateProfileDataSource(getIt()));

  //inventory
  getIt.registerLazySingleton<InventoryRepo>(() => InventoryRepo(getIt()));
  getIt.registerFactory<InventoryCubit>(() => InventoryCubit(getIt()));
  getIt.registerLazySingleton<InventoryDataSource>(() => InventoryDataSource(getIt()));

  //UploadCleaning
  getIt.registerLazySingleton<UploadCleaningRepo>(() => UploadCleaningRepo(getIt()));
  getIt.registerLazySingleton<UploadCleaningCubit>(() => UploadCleaningCubit(getIt()));
  getIt.registerLazySingleton<UploadCleaningDataSource>(() => UploadCleaningDataSource(getIt()));

  //UploadDamage
  getIt.registerLazySingleton<UploadDamageRepo>(() => UploadDamageRepo(getIt()));
  getIt.registerLazySingleton<UploadDamageCubit>(() => UploadDamageCubit(getIt()));
  getIt.registerLazySingleton<UploadDamageDataSource>(() => UploadDamageDataSource(getIt()));
}