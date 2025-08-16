import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/language/lang_keys.dart';
import '../../../../../core/helpers/extensions.dart';
import '../../../../../core/widget/app_text_form_field.dart';

class ProfileInputFieldsWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final bool isEditing;

  const ProfileInputFieldsWidget({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.addressController,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        _buildInputField(
          context: context,
          controller: nameController,
          hintText: context.translate(LangKeys.fullName),
          icon: Icons.person_outline,
          theme: theme,
        ),
        SizedBox(height: 16.h),
        _buildInputField(
          context: context,
          controller: emailController,
          hintText: context.translate(LangKeys.email),
          icon: Icons.email_outlined,
          textInputType: TextInputType.emailAddress,
          theme: theme,
        ),
        SizedBox(height: 16.h),
        _buildInputField(
          context: context,
          controller: phoneController,
          hintText: context.translate(LangKeys.phoneNumber),
          icon: Icons.phone_outlined,
          textInputType: TextInputType.phone,
          theme: theme,
        ),
        SizedBox(height: 16.h),
        _buildInputField(
          context: context,
          controller: addressController,
          hintText: context.translate(LangKeys.address),
          icon: Icons.location_on_outlined,
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildInputField({
    required BuildContext context,
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required ThemeData theme,
    TextInputType? textInputType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormFieldApp(
        controller: controller,
        hintText: hintText,
        readOnly: !isEditing,
        textInputType: textInputType,
        background: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        contentPadding: EdgeInsetsDirectional.symmetric(
          horizontal: 20.w,
          vertical: 18.h,
        ),
        prefixIcon: Icon(
          icon,
          color: theme.colorScheme.primary,
          size: 20.sp,
        ),
        inputTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          fontFamily: 'Cairo',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '${context.translate(LangKeys.pleaseEnter)} $hintText';
          }
          if (textInputType == TextInputType.emailAddress) {
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return context.translate(LangKeys.pleaseEnterValidEmail);
            }
          }
          return null;
        },
      ),
    );
  }
}
