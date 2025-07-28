import 'package:diyar/core/helpers/extensions.dart';
import 'package:diyar/core/widget/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../networking/constants/api_constants.dart';
import '../router/routers.dart';
import '../theme/Color/colors.dart';
import '../theme/text_style/text_style.dart';

class CheckBoxApp extends StatefulWidget {
  const CheckBoxApp({super.key});

  @override
  State<CheckBoxApp> createState() => _CheckBoxAppState();
}

class _CheckBoxAppState extends State<CheckBoxApp> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.scale(
          scale: 0.8,
          child: Checkbox(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            side: BorderSide(
              color: ColorApp.black00,
              width: 1.w,
            ),
            hoverColor: ColorApp.black00,
            checkColor: ColorApp.whiteFF,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            fillColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return ColorApp.black00;
              }
              return Colors.transparent;
            }),
            value: _rememberMe,
            onChanged: (bool? value) {
              setState(() {
                _rememberMe = value!;
                ApiConstants.valid = _rememberMe ;
              });
            },
          ),
        ),
        InkWell(
          onTap: (){
            context.pushNamed(Routes.forgotPassword);
          },
            child: TextApp(text: "context.translate(LangKeys.approvalCompany)", style: TextStyleApp.font15greyC1Weight600.copyWith(color: ColorApp.black00,fontSize: 11.sp,decoration: TextDecoration.underline,),)),
      ],
    );
  }
}
