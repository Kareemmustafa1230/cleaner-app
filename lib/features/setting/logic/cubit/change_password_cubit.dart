import 'package:diyar/features/setting/data/repo/change_password_repo.dart';
import 'package:diyar/features/setting/logic/state/logout_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/change_password_request.dart';

class ChangePasswordCubit extends Cubit<LogoutState> {
  final ChangePasswordRepo _changePasswordRepo;

  ChangePasswordCubit(this._changePasswordRepo) : super(const LogoutState.initial());
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newPasswordConfirmationController = TextEditingController();

  final formKey = GlobalKey<FormState>();
    Future<void> emitChangePasswordState() async {
      emit(const LogoutState.loading());
      final changePasswordResponse = await _changePasswordRepo.updatePassword(
          ChangePasswordRequest(
            currentPassword: currentPasswordController.text ,
            newPassword:newPasswordController.text ,
            newPasswordConfirmation: newPasswordConfirmationController.text
          )
      );
      await changePasswordResponse.when(
        success: (response) async {
          emit(LogoutState.success(message: response.message!));
        },
        failure: (error) {
          emit(LogoutState.error(error: error.apiErrorModel.message));
        },
      );
    }
  }

