import 'package:flutter/material.dart';
import 'colors.dart';

class MyColors extends ThemeExtension<MyColors> {
  const MyColors({
    required this.mainColor,
    required this.bluePinkDark,
    required this.bluePinkLight,
    required this.textColor,
    required this.textFormBorder,
    required this.navBarbg,
    required this.navBarSelectedTab,
    required this.containerShadow1,
    required this.containerShadow2,
    required this.containerLinear1,
    required this.containerLinear2,
  });

  final Color? mainColor;
  final Color? bluePinkDark;
  final Color? bluePinkLight;
  final Color? textColor;
  final Color? textFormBorder;
  final Color? navBarbg;
  final Color? navBarSelectedTab;
  final Color? containerShadow1;
  final Color? containerShadow2;
  final Color? containerLinear1;
  final Color? containerLinear2;

  @override
  ThemeExtension<MyColors> copyWith({
    Color? mainColor,
    Color? bluePinkDark,
    Color? bluePinkLight,
    Color? textColor,
    Color? textFormBorder,
    Color? navBarbg,
    Color? navBarSelectedTab,
    Color? containerShadow1,
    Color? containerShadow2,
    Color? containerLinear1,
  }) {
    return MyColors(
      mainColor: mainColor,
      bluePinkDark: bluePinkDark,
      bluePinkLight: bluePinkLight,
      textColor: textColor,
      textFormBorder: textFormBorder,
      navBarbg: navBarbg,
      navBarSelectedTab: navBarSelectedTab,
      containerShadow1: containerShadow1,
      containerShadow2: containerShadow2,
      containerLinear1: containerLinear1,
      containerLinear2: containerLinear2,
    );
  }

  @override
  ThemeExtension<MyColors> lerp(
      covariant ThemeExtension<MyColors>? other,
      double t,
      ) {
    if (other is! MyColors) {
      return this;
    }
    return MyColors(
      mainColor: mainColor,
      bluePinkDark: bluePinkDark,
      bluePinkLight: bluePinkLight,
      textColor: textColor,
      textFormBorder: textFormBorder,
      navBarbg: navBarbg,
      navBarSelectedTab: navBarSelectedTab,
      containerShadow1: containerShadow1,
      containerShadow2: containerShadow2,
      containerLinear1: containerLinear1,
      containerLinear2: containerLinear2,
    );
  }

  static const MyColors dark = MyColors(
    mainColor: Colors.black,
    bluePinkDark: ColorApp.darkBlue,
    bluePinkLight: ColorApp.lightBlue,
    textColor: ColorApp.white,
    textFormBorder: ColorApp.lightBlue,
    navBarbg: Colors.black,
    navBarSelectedTab: ColorApp.white,
    containerShadow1: Colors.black12,
    containerShadow2: Colors.black26,
    containerLinear1: Colors.black12,
    containerLinear2: Colors.black26,
  );

  static const MyColors light = MyColors(
    mainColor: ColorApp.backgroundPrimary,
    bluePinkDark: ColorApp.darkBlue,
    bluePinkLight: ColorApp.lightBlue,
    textColor: ColorApp.textPrimary,
    textFormBorder: ColorApp.lightBlue,
    navBarbg: ColorApp.backgroundPrimary,
    navBarSelectedTab: ColorApp.darkBlue,
    containerShadow1: ColorApp.shadowLight,
    containerShadow2: ColorApp.shadowMedium,
    containerLinear1: ColorApp.darkBlue,
    containerLinear2: ColorApp.lightBlue,
  );
}
