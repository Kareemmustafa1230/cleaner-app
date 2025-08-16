import 'package:diyar/core/language/app_localizations.dart';
import 'package:diyar/core/language/lang_keys.dart';
import 'package:diyar/core/theme/Color/colors.dart';
import 'package:diyar/core/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: ColorApp.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          context.translate(LangKeys.inventory),
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: ColorApp.textPrimary,
            fontFamily: 'Cairo',
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: ColorApp.textPrimary,
            size: 24.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عنوان الصفحة
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ColorApp.primaryBlue.withOpacity(0.1),
                    ColorApp.primaryBlue.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(
                  color: ColorApp.primaryBlue.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: ColorApp.primaryBlue,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.inventory_2,
                          color: ColorApp.white,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.translate(LangKeys.inventory),
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorApp.textPrimary,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              context.translate(LangKeys.inventoryManagement),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: ColorApp.textSecondary,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            
            // إحصائيات سريعة
            Text(
              context.translate(LangKeys.inventoryStats),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: ColorApp.textPrimary,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: ColorApp.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: ColorApp.borderLight,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.category,
                          color: ColorApp.primaryBlue,
                          size: 24.sp,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          '12',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: ColorApp.textPrimary,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        Text(
                          context.translate(LangKeys.inventoryCategories),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: ColorApp.textSecondary,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: ColorApp.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: ColorApp.borderLight,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.warning,
                          color: ColorApp.warning,
                          size: 24.sp,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          '3',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: ColorApp.textPrimary,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        Text(
                          context.translate(LangKeys.inventoryLowStock),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: ColorApp.textSecondary,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            
            // أزرار الإجراءات
            Text(
              context.translate(LangKeys.inventoryQuickActions),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: ColorApp.textPrimary,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: ColorApp.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: ColorApp.borderLight,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: ColorApp.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(
                            Icons.add,
                            color: ColorApp.primaryBlue,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          context.translate(LangKeys.inventoryAddItem),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorApp.textPrimary,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: ColorApp.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: ColorApp.borderLight,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: ColorApp.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(
                            Icons.inventory,
                            color: ColorApp.success,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'جرد المخزون',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorApp.textPrimary,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            
            // قائمة الأصناف الأخيرة
            Text(
              context.translate(LangKeys.inventoryRecentItems),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: ColorApp.textPrimary,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: ColorApp.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: ColorApp.borderLight,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  _buildInventoryItem(
                    name: 'منظفات',
                    quantity: '15',
                    status: context.translate(LangKeys.inventoryAvailable),
                    statusColor: ColorApp.success,
                    icon: Icons.cleaning_services,
                  ),
                  Divider(height: 24.h, color: ColorApp.borderLight),
                  _buildInventoryItem(
                    name: 'مطهرات',
                    quantity: '8',
                    status: context.translate(LangKeys.inventoryAvailable),
                    statusColor: ColorApp.success,
                    icon: Icons.cleaning_services,
                  ),
                  Divider(height: 24.h, color: ColorApp.borderLight),
                  _buildInventoryItem(
                    name: 'أدوات تنظيف',
                    quantity: '3',
                    status: context.translate(LangKeys.inventoryLowStock),
                    statusColor: ColorApp.warning,
                    icon: Icons.cleaning_services,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryItem({
    required String name,
    required String quantity,
    required String status,
    required Color statusColor,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: ColorApp.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            icon,
            color: ColorApp.primaryBlue,
            size: 20.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorApp.textPrimary,
                  fontFamily: 'Cairo',
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '${context.translate(LangKeys.inventoryQuantity)}: $quantity',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: ColorApp.textSecondary,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: statusColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            status,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: statusColor,
              fontFamily: 'Cairo',
            ),
          ),
        ),
      ],
    );
  }
} 