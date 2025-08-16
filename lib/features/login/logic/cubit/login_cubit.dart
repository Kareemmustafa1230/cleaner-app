import 'dart:convert';
import 'package:diyar/features/login/logic/state/login_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helpers/shared_pref_helper.dart';
import '../../../../core/networking/constants/api_constants.dart';
import '../../../../core/networking/di/dependency_injection.dart';
import '../../data/model/login_request_body.dart';
import '../../data/repo/login_repo.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo _loginRepo;

  LoginCubit(this._loginRepo) : super(const LoginState.initial());

  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  Future<void> emitLoginState({required bool isEmailMode}) async {
    emit(const LoginState.loading());
    
    // إعداد البيانات للإرسال حسب الوضع المختار
    LoginRequestBody loginRequestBody;
    
    if (isEmailMode) {
      // تسجيل الدخول بالبريد الإلكتروني
      loginRequestBody = LoginRequestBody(
        phone: null, // لا نرسل phone
        email: emailController.text.trim(),
        password: passwordController.text,
      );
    } else {
      // تسجيل الدخول برقم الهاتف
      String phoneNumber = mobileController.text.trim();
      
      // إضافة + إذا لم تكن موجودة
      if (!phoneNumber.startsWith('+')) {
        phoneNumber = '+$phoneNumber';
      }
      
      loginRequestBody = LoginRequestBody(
        phone: phoneNumber,
        email: null, // لا نرسل email
        password: passwordController.text,
      );
    }
    
    final loginResponse = await _loginRepo.login(loginRequestBody);
    
    await loginResponse.when(
      success: (response) async {
        try {
          // حفظ token
          if (response.accessToken != null && response.accessToken!.isNotEmpty) {
            await getIt<SharedPrefHelper>().saveData(
              key: ApiKey.authorization, 
              value: response.accessToken!
            );
          }
          
          // حفظ بيانات المستخدم
          final userJson = response.data?.toJson();
          if (userJson != null) {
            await getIt<SharedPrefHelper>().saveData(
              key: ApiKey.userData,
              value: jsonEncode(userJson),
            );
          }
          
          final successMessage = response.message ?? 'تم تسجيل الدخول بنجاح';
          print('✅ Login Success: $successMessage');
          emit(LoginState.success(message: successMessage));
        } catch (e) {
          emit(LoginState.error(error: 'حدث خطأ في حفظ البيانات: $e'));
        }
      },
      failure: (error) {
        final errorMessage = error.apiErrorModel.message.isNotEmpty 
            ? error.apiErrorModel.message 
            : 'حدث خطأ غير متوقع';
        print('🔴 Login Error: $errorMessage');
        emit(LoginState.error(error: errorMessage));
      },
    );
  }
}

