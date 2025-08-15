import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/router/routers.dart';
import '../../../../core/theme/Color/colors.dart';
import '../../../../core/widget/toast.dart';
import '../../logic/cubit/login_cubit.dart';
import '../../logic/state/login_state.dart';

class LoginBlocListeners extends StatelessWidget {
  const LoginBlocListeners({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) async {
        if (state is Success) {
          toast(text: state.message, color: ColorApp.blue8D);
          context.pushNamedAndRemoveUntil(Routes.home, predicate: (Route<dynamic> route) => false);
        } else if (state is Error) {
          // لا يتم التنقل في حالة الخطأ، يبقى في نفس الصفحة
        } else if (state is Loading) {
          // يمكن إضافة مؤشر تحميل هنا إذا لزم الأمر
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}

