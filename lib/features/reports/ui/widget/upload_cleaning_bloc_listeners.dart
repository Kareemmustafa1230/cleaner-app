import 'package:diyar/core/helpers/extensions.dart';
import 'package:diyar/features/reports/logic/cubit/upload_cleaning_cubit.dart';
import 'package:diyar/features/reports/logic/state/upload_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/language/lang_keys.dart';
import '../../../../core/router/routers.dart';
import '../../../../core/widget/showErrorSnackBar.dart';
import '../../../../core/widget/showSuccesSnackBar.dart';
import '../../../login/ui/widget/loading_overlay.dart';

class UploadCleaningBlocListeners extends StatelessWidget {
  const UploadCleaningBlocListeners({super.key});
  
  @override
  Widget build(BuildContext context) {

    return BlocListener<UploadCleaningCubit, UploadState>(
      listener: (context, state) async {

        state.maybeWhen(
          loading: (){
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(
                child: LoadingOverlay(),
              ),
            );
          },
          success: (message) {
            // Dismiss loading dialog if it's showing
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            }
            showSuccesSnackBar(context: context, title: message);
            
            // إعادة تعيين الحالة للسماح بالرفع مرة أخرى
            context.read<UploadCleaningCubit>().resetState();
            
            Future.delayed(const Duration(seconds: 2), () {
              if (context.mounted) {
                context.pushNamedAndRemoveUntil(Routes.home, predicate: (Route<dynamic> route) => false);
              }
            });
          },
          successWithoutInventory: (message) {
            // Dismiss loading dialog if it's showing
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            }
            showSuccesSnackBar(context: context, title: message);
            
            // إعادة تعيين الحالة للسماح بالرفع مرة أخرى
            context.read<UploadCleaningCubit>().resetState();
            
            Future.delayed(const Duration(seconds: 2), () {
              if (context.mounted) {
                context.pushNamedAndRemoveUntil(Routes.home, predicate: (Route<dynamic> route) => false);
              }
            });
          },
          error: (error) {
            print("🎧 Error state triggered in BlocListener: $error");
            // Dismiss loading dialog if it's showing
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            }
            
            // ترجمة رسائل الخطأ الخاصة بالتحقق
            String errorMessage = error;
            if (error == 'imagesRequired') {
              errorMessage = context.translate(LangKeys.imagesRequired);
            } else if (error == 'videosRequired') {
              errorMessage = context.translate(LangKeys.videosRequired);
            } else if (error == 'mediaRequired') {
              errorMessage = context.translate(LangKeys.mediaRequired);
            }
            
            showErrorSnackBar(context: context, title: errorMessage);
            
            // إعادة تعيين الحالة للسماح بالرفع مرة أخرى
            context.read<UploadCleaningCubit>().resetState();
          },
          orElse: () {
            print("🎧 Other state received: $state");
            // Handle other states if necessary
          },
        );
      },
      child: const SizedBox.shrink(),
    );
  }
}