import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/app_cubit/app_cubit.dart';
import 'core/app_cubit/app_state.dart';
import 'core/helpers/shared_pref_helper.dart';
import 'core/language/app_localizations_setup.dart';
import 'core/networking/constants/api_constants.dart';
import 'core/networking/di/dependency_injection.dart';
import 'core/router/app_router.dart';
import 'core/router/routers.dart';
import 'core/theme/theme.dart';

class Diyar extends StatelessWidget {
  final AppRouter appRouter;
  const Diyar({super.key, required this.appRouter});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AppCubit>()..changeAppThemeMode(sharedMode: getIt<SharedPrefHelper>().getData(key: ApiKey.themeMode))..getSavedLanguage()..getSavedLanguage(),
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) {
          return BlocBuilder<AppCubit, AppState>(
            builder: (context, state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                onGenerateRoute: appRouter.generateRoute,
                initialRoute: getIt<SharedPrefHelper>().getData(key: ApiKey.authorization) != null
                    ? Routes.home
                    : Routes.loginScreen,
                locale: Locale(context.read<AppCubit>().languageCode),
                supportedLocales: AppLocalizationsSetup.supportedLocales,
                localizationsDelegates: AppLocalizationsSetup.localizationsDelegates,
                localeResolutionCallback: AppLocalizationsSetup.localeResolutionCallback,
                theme: context.read<AppCubit>().isDark ? themeDark() : themeLight(),
                navigatorKey: getIt<GlobalKey<NavigatorState>>(),
              );
            },
          );
        },
      ),
    );
  }
}