import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/Color/colors.dart';
import '../../../../core/theme/text_style/text_style.dart';
import '../../../../core/language/lang_keys.dart';
import '../../../../core/helpers/extensions.dart';

class ApartmentCard extends StatelessWidget {
  final Map<String, dynamic> apartment;
  final VoidCallback onTap;

  const ApartmentCard({
    super.key,
    required this.apartment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: ColorApp.whiteFF,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // صورة الشقة
                Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    image: DecorationImage(
                      image: AssetImage(apartment['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                
                // تفاصيل الشقة
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        apartment['name'],
                        style: TextStyleApp.font16black00Weight700,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        apartment['address'],
                        style: TextStyleApp.font12grey6BWeight400,
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: apartment['status'] == context.translate(LangKeys.availableStatus)
                                  ? ColorApp.blue8D.withOpacity(0.1)
                                  : ColorApp.greyC1.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              apartment['status'],
                              style: TextStyle(
                                color: apartment['status'] == context.translate(LangKeys.availableStatus)
                                    ? ColorApp.blue8D
                                    : ColorApp.greyC1,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${apartment['price']} ${context.translate(LangKeys.currency)}',
                            style: TextStyleApp.font16blue8DWeight700,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // أيقونة السهم
                Icon(
                  Icons.arrow_forward_ios,
                  color: ColorApp.greyC1,
                  size: 16.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 