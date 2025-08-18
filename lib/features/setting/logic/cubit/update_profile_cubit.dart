// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../../../core/helpers/shared_pref_helper.dart';
// import '../../../../core/networking/constants/api_constants.dart';
// import '../../../../core/networking/di/dependency_injection.dart';
// import '../../data/model/update_profile_request.dart';
// import '../../data/repo/update_profile_repo.dart';
// import '../state/update_profile_state.dart';
//
// class UpdateProfileCubit extends Cubit<UpdateProfileState> {
//   final UpdateProfileRepo _updateProfileRepo;
//
//   UpdateProfileCubit(this._updateProfileRepo) : super(const UpdateProfileState.initial());
//   TextEditingController nameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController addressController = TextEditingController();
//
//   final formKey = GlobalKey<FormState>();
//
//   XFile? _selectedImage;
//   void setSelectedImage(XFile? image) {
//     _selectedImage = image;
//   }
//
//   Future<void> emitUpdateProfileState() async {
//     if (!formKey.currentState!.validate()) return;
//     emit(const UpdateProfileState.loading());
//       final changePasswordResponse = await _updateProfileRepo.updateProfile(
//         UpdateProfileRequest(
//         name: nameController.text,
//         email: emailController.text,
//         phone: phoneController.text,
//         address: addressController.text,
//         image: _selectedImage?.path,
//       ),
//       );
//       await changePasswordResponse.when(
//         success: (response) async {
//           // حفظ بيانات المستخدم
//           final userJson = response.data.toJson();
//           await getIt<SharedPrefHelper>().saveData(
//             key: ApiKey.userData,
//             value: jsonEncode(userJson),
//           );
//
//           emit(UpdateProfileState.success(updateProfileResponse: response));
//         },
//         failure: (error) {
//           emit(UpdateProfileState.error(error: error.apiErrorModel.message));
//         },
//       );
//     }
//   }
//
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/helpers/shared_pref_helper.dart';
import '../../../../core/networking/constants/api_constants.dart';
import '../../../../core/networking/di/dependency_injection.dart';
import '../../data/model/update_profile_request.dart';
import '../../data/repo/update_profile_repo.dart';
import '../state/update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  final UpdateProfileRepo _updateProfileRepo;

  UpdateProfileCubit(this._updateProfileRepo) : super(const UpdateProfileState.initial());

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  XFile? _selectedImage;

  void setSelectedImage(XFile? image) {
    _selectedImage = image;
  }

  Future<void> emitUpdateProfileState() async {
    emit(const UpdateProfileState.loading());

    try {
      final updateProfileResponse = await _updateProfileRepo.updateProfile(
        UpdateProfileRequest(
          name: nameController.text,
          email: emailController.text,
          phone: phoneController.text,
          address: addressController.text,
          image: _selectedImage?.path,
        ),
      );

      await updateProfileResponse.when(
        success: (response) async {
          // حفظ بيانات المستخدم
          final userJson = response.data.toJson();
          await getIt<SharedPrefHelper>().saveData(
            key: ApiKey.userData,
            value: jsonEncode(userJson),
          );

          emit(UpdateProfileState.success(updateProfileResponse: response));
        },
        failure: (error) {
          emit(UpdateProfileState.error(error: error.apiErrorModel.message ?? 'حدث خطأ غير معروف'));
        },
      );
    } catch (e) {
      emit(UpdateProfileState.error(error: e.toString()));
    }
  }
}