import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../helpers/shared_pref_helper.dart';
import '../networking/constants/api_constants.dart';
import '../networking/di/dependency_injection.dart';
import 'app_state.dart';


class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppState.initial());

  bool isDark = true ;
  String languageCode = 'en';


  Future<void> changeAppThemeMode({bool? sharedMode})async{
    if(sharedMode != null){
      isDark = sharedMode ;
      emit(AppState.themeChangeMode(isDark: isDark));
    }
    else{
      isDark = !isDark;
      await getIt<SharedPrefHelper>().saveData(key: ApiKey.themeMode, value: isDark).then((value){
        emit(AppState.themeChangeMode(isDark: isDark));
      });
    }
  }

  //Language getSavedLanguage
  Future<void> getSavedLanguage()async{
    final result = await SharedPrefHelper().containsKey(key: ApiKey.language)
        ? getIt<SharedPrefHelper>().getData(key: ApiKey.language)
        : 'en';
    languageCode = result! ;
    getIt<SharedPrefHelper>().saveData(key: ApiKey.language, value: languageCode);
    emit(AppState.languageChange(locale: Locale(languageCode)));
    }

  //Language change
    Future<void> _changeLanguage(String language)async{
    await getIt<SharedPrefHelper>().saveData(key: ApiKey.language, value: language);
    languageCode = language;
    emit(AppState.languageChange(locale: Locale(languageCode)));
    }

    void toArabic() => _changeLanguage('ar');
    void toEnglish() => _changeLanguage('en');

}
