// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../../../core/theme/text_style/text_style.dart';
// import '../../../../../core/language/lang_keys.dart';
// import '../../../../../core/helpers/extensions.dart';
//
// class ProfileHeaderWidget extends StatelessWidget {
//   final Animation<double> fadeAnimation;
//   final String name; // Changed from TextEditingController to String
//   final String email; // Changed from TextEditingController to String
//   final ImageProvider? image; // Added image parameter
//   final bool isEditing;
//   final VoidCallback onBackPressed;
//   final VoidCallback onEditPressed;
//   final VoidCallback? onImagePressed; // Added image press callback
//
//   const ProfileHeaderWidget({
//     super.key,
//     required this.fadeAnimation,
//     required this.name,
//     required this.email,
//     this.image,
//     required this.isEditing,
//     required this.onBackPressed,
//     required this.onEditPressed,
//     this.onImagePressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return SliverAppBar(
//       expandedHeight: 250.h,
//       floating: false,
//       pinned: true,
//       backgroundColor: theme.colorScheme.primary,
//       elevation: 0,
//       leading: Container(
//         margin: EdgeInsets.all(8.w),
//         decoration: BoxDecoration(
//           color: theme.colorScheme.onPrimary.withOpacity(0.2),
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         child: IconButton(
//           onPressed: onBackPressed,
//           icon: Icon(
//             Icons.arrow_back_ios,
//             color: theme.colorScheme.onPrimary,
//             size: 20.sp,
//           ),
//         ),
//       ),
//       title: Text(
//         context.translate(LangKeys.profile),
//         style: TextStyleApp.font20black00Weight700.copyWith(
//           color: theme.colorScheme.onPrimary,
//           fontSize: 18.sp,
//         ),
//       ),
//       centerTitle: true,
//       actions: [
//         Container(
//           margin: EdgeInsets.all(8.w),
//           decoration: BoxDecoration(
//             color: theme.colorScheme.onPrimary.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(12.r),
//           ),
//           child: IconButton(
//             onPressed: onEditPressed,
//             icon: Icon(
//               isEditing ? Icons.close : Icons.edit,
//               color: theme.colorScheme.onPrimary,
//               size: 20.sp,
//             ),
//           ),
//         ),
//       ],
//       flexibleSpace: FlexibleSpaceBar(
//         background: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 theme.colorScheme.primary,
//                 theme.colorScheme.primary.withOpacity(0.8),
//                 theme.colorScheme.secondary,
//               ],
//             ),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(height: 90.h),
//               // Enhanced profile picture
//               GestureDetector(
//                 onTap: onImagePressed,
//                 child: FadeTransition(
//                   opacity: fadeAnimation,
//                   child: Stack(
//                     children: [
//                       Container(
//                         width: 100.w,
//                         height: 100.h,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: theme.colorScheme.onPrimary.withOpacity(0.2),
//                           border: Border.all(
//                             color: theme.colorScheme.onPrimary,
//                             width: 3.w,
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: theme.colorScheme.onPrimary.withOpacity(0.3),
//                               blurRadius: 20,
//                               offset: const Offset(0, 10),
//                             ),
//                           ],
//                           image: image != null
//                               ? DecorationImage(
//                             image: image!,
//                             fit: BoxFit.cover,
//                           )
//                               : null,
//                         ),
//                         child: image == null
//                             ? Icon(
//                           Icons.person,
//                           size: 50.sp,
//                           color: theme.colorScheme.onPrimary,
//                         )
//                             : null,
//                       ),
//                       if (isEditing)
//                         Positioned(
//                           bottom: 0,
//                           right: 0,
//                           child: Container(
//                             width: 35.w,
//                             height: 35.h,
//                             decoration: BoxDecoration(
//                               color: theme.colorScheme.secondary,
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color: theme.colorScheme.onPrimary,
//                                 width: 2.w,
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: theme.colorScheme.shadow,
//                                   blurRadius: 8,
//                                   offset: const Offset(0, 4),
//                                 ),
//                               ],
//                             ),
//                             child: Icon(
//                               Icons.camera_alt,
//                               size: 18.sp,
//                               color: theme.colorScheme.onPrimary,
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 12.h),
//               Text(
//                 name, // Using name string directly
//                 style: TextStyleApp.font16black00Weight700.copyWith(
//                   color: theme.colorScheme.onPrimary,
//                   fontSize: 18.sp,
//                 ),
//               ),
//               Text(
//                 email, // Using email string directly
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   color: theme.colorScheme.onPrimary.withOpacity(0.8),
//                   fontFamily: 'Cairo',
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/text_style/text_style.dart';
import '../../../../../core/language/lang_keys.dart';
import '../../../../../core/helpers/extensions.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final String name;
  final String email;
  final ImageProvider? image;
  final bool isEditing;
  final VoidCallback onBackPressed;
  final VoidCallback onEditPressed;
  final VoidCallback? onImagePressed;

  const ProfileHeaderWidget({
    super.key,
    required this.fadeAnimation,
    required this.name,
    required this.email,
    this.image,
    required this.isEditing,
    required this.onBackPressed,
    required this.onEditPressed,
    this.onImagePressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      expandedHeight: 250.h,
      floating: false,
      pinned: true,
      backgroundColor: theme.colorScheme.primary,
      elevation: 0,
      leading: Container(
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.onPrimary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: IconButton(
          onPressed: onBackPressed,
          icon: Icon(
            Icons.arrow_back_ios,
            color: theme.colorScheme.onPrimary,
            size: 20.sp,
          ),
        ),
      ),
      title: Text(
        context.translate(LangKeys.profile),
        style: TextStyleApp.font20black00Weight700.copyWith(
          color: theme.colorScheme.onPrimary,
          fontSize: 18.sp,
        ),
      ),
      centerTitle: true,
      actions: [
        Container(
          margin: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.onPrimary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: IconButton(
            onPressed: onEditPressed,
            icon: Icon(
              isEditing ? Icons.close : Icons.edit,
              color: theme.colorScheme.onPrimary,
              size: 20.sp,
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withOpacity(0.8),
                theme.colorScheme.secondary,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 90.h),
              GestureDetector(
                onTap: onImagePressed,
                child: FadeTransition(
                  opacity: fadeAnimation,
                  child: Stack(
                    children: [
                      Container(
                        width: 100.w,
                        height: 100.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.onPrimary.withOpacity(0.2),
                          border: Border.all(
                            color: theme.colorScheme.onPrimary,
                            width: 3.w,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.onPrimary.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                          image: image != null
                              ? DecorationImage(
                            image: image!,
                            fit: BoxFit.cover,
                          )
                              : null,
                        ),
                        child: image == null
                            ? Icon(
                          Icons.person,
                          size: 50.sp,
                          color: theme.colorScheme.onPrimary,
                        )
                            : null,
                      ),
                      if (isEditing)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 35.w,
                            height: 35.h,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.colorScheme.onPrimary,
                                width: 2.w,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.shadow,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size: 18.sp,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                name,
                style: TextStyleApp.font16black00Weight700.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 18.sp,
                ),
              ),
              Text(
                email,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: theme.colorScheme.onPrimary.withOpacity(0.8),
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}