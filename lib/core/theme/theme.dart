import 'package:diyar/core/theme/text_style/text_style.dart';
import 'package:flutter/material.dart';
import 'Color/colors.dart';

ThemeData themeDark() {
  return ThemeData(
    colorScheme: ColorScheme.dark(
      primary: ColorApp.primaryBlue,
      secondary: ColorApp.secondaryBlue,
      background: Colors.black,
      surface: ColorApp.darkGrey,
      error: ColorApp.error,
      onPrimary: ColorApp.white,
      onSecondary: ColorApp.white,
      onBackground: ColorApp.white,
      onSurface: ColorApp.white,
      onError: ColorApp.white,
    ),
    scaffoldBackgroundColor: Colors.black,
    useMaterial3: true,
    textTheme: TextTheme(
      displaySmall: TextStyleApp.font16whiteFFWeight700,
    ),
  );
}

ThemeData themeLight() {
  return ThemeData(
    colorScheme: ColorScheme.light(
      primary: ColorApp.primaryBlue,
      secondary: ColorApp.secondaryBlue,
      background: ColorApp.backgroundPrimary,
      surface: ColorApp.lightGrey,
      error: ColorApp.error,
      onPrimary: ColorApp.white,
      onSecondary: ColorApp.white,
      onBackground: ColorApp.textPrimary,
      onSurface: ColorApp.textPrimary,
      onError: ColorApp.white,
    ),
    scaffoldBackgroundColor: ColorApp.backgroundPrimary,
    useMaterial3: true,
    textTheme: TextTheme(
      displaySmall: TextStyleApp.font16black00Weight700,
    ),
  );
}