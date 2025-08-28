import 'package:diyar/core/helpers/extensions.dart';
import 'package:diyar/features/reports/logic/cubit/upload_damage_cubit.dart';
import 'package:diyar/features/reports/logic/state/upload_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/routers.dart';
import '../../../../core/widget/showErrorSnackBar.dart';
import '../../../../core/widget/showSuccesSnackBar.dart';
import '../../../login/ui/widget/loading_overlay.dart';

class UploadDamageBlocListeners extends StatelessWidget {
  const UploadDamageBlocListeners({super.key});
  
  @override
  Widget build(BuildContext context) {
    print("🎯 UploadDamageBlocListeners build called");
    return BlocListener<UploadDamageCubit, UploadState>(
      listener: (context, state) async {
        print("🎯 UploadDamageBlocListener received state: $state");
        state.maybeWhen(
          loading: (){
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(
                child: LoadingOverlay(),
              ),
            );
            print("Loading state triggered for damage upload");
          },
          success: (message) {
            // Dismiss loading dialog if it's showing
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            }
            showSuccesSnackBar(context: context, title: message);
            
            // إعادة تعيين الحالة للسماح بالرفع مرة أخرى
            context.read<UploadDamageCubit>().resetState();
            
            Future.delayed(const Duration(seconds: 2), () {
              if (context.mounted) {
                context.pushNamedAndRemoveUntil(Routes.home, predicate: (Route<dynamic> route) => false);
              }
            });
          },
          error: (error) {
            // Dismiss loading dialog if it's showing
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            }
            print('🎯 UI Error Handler: $error');
            showErrorSnackBar(context: context, title: error);
            
            // إعادة تعيين الحالة للسماح بالرفع مرة أخرى
            context.read<UploadDamageCubit>().resetState();
          },
          orElse: () {
            // Handle other states if necessary
          },
        );
      },
      child: const SizedBox.shrink(),
    );
  }
}
