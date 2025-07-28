import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../helpers/font_family_helper.dart';
import '../Color/colors.dart';

class TextStyleApp{
  static TextStyle font24black00Weight700 = TextStyle(
    fontSize: 24.sp,
    color: ColorApp.black00,
    fontWeight: FontWeight.w700,
    fontFamily: FontFamilyHelper.geLocalozedFontFamily(),
  );

  static TextStyle font20black00Weight700 = TextStyle(
    fontSize: 20.sp,
    color: ColorApp.black00,
    fontWeight: FontWeight.w700,
    fontFamily: FontFamilyHelper.geLocalozedFontFamily(),
  );

static TextStyle font16black00Weight700 = TextStyle(
    fontSize: 16.sp,
    color: ColorApp.black00,
    fontWeight: FontWeight.w700,
    fontFamily: FontFamilyHelper.geLocalozedFontFamily(),
  );

static TextStyle font16greyC1Weight700 = TextStyle(
    fontSize: 16.sp,
    color: ColorApp.greyC1,
    fontWeight: FontWeight.w700,
    fontFamily: FontFamilyHelper.geLocalozedFontFamily(),
  );

static TextStyle font16blue8DWeight700 = TextStyle(
    fontSize: 16.sp,
    color: ColorApp.blue8D,
    fontWeight: FontWeight.w700,
    fontFamily: FontFamilyHelper.geLocalozedFontFamily(),
  );

static TextStyle font16whiteFFWeight700 = TextStyle(
    fontSize: 16.sp,
    color: ColorApp.whiteFF,
    fontWeight: FontWeight.w700,
    fontFamily: FontFamilyHelper.geLocalozedFontFamily(),
  );

  static TextStyle font15greyC1Weight600 = TextStyle(
    fontSize: 15.sp,
    color: ColorApp.greyC1,
    fontWeight: FontWeight.w600,
    fontFamily: FontFamilyHelper.geLocalozedFontFamily(),
  );

  static TextStyle font12grey6BWeight400 = TextStyle(
    fontSize: 12.sp,
    color: ColorApp.grey6B,
    fontWeight: FontWeight.w400,
    fontFamily: FontFamilyHelper.geLocalozedFontFamily(),
  );
}