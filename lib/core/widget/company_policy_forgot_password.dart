import 'package:diyar/core/helpers/extensions.dart';
import 'package:diyar/core/theme/Color/colors.dart';
import 'package:diyar/core/widget/text_app.dart';
import 'package:flutter/material.dart';
import '../language/lang_keys.dart';
import '../router/routers.dart';
import '../theme/text_style/text_style.dart';

class RememberMeAndForgotPassword extends StatelessWidget {
  const RememberMeAndForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //const CheckBoxApp(),
          const Spacer(),
          InkWell(
              onTap: (){
                context.pushNamed(Routes.enterEmail);
              },
              child: TextApp(text:context.translate(LangKeys.forgetPassword), style: TextStyleApp.font15greyC1Weight600.copyWith(color: ColorApp.black18),)),
    ]
    );
  }
}
