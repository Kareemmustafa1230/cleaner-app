import 'package:diyar/core/language/lang_keys.dart';
import 'package:diyar/core/networking/di/dependency_injection.dart';
import 'package:diyar/core/theme/Color/colors.dart';
import 'package:diyar/core/helpers/extensions.dart';
import 'package:diyar/features/inventory/logic/cubit/inventory_cubit.dart';
import 'package:diyar/features/inventory/data/model/inventory_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../../logic/state/inventory_state.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
       context.read<InventoryCubit>().fetchFirstPage();
    });
  }
  Future<void> _onRefresh() async {
    await context.read<InventoryCubit>().fetchFirstPage();
  }
  // بناء حالة الخطأ الرئيسية
  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.asset(
            "assets/lottie/error_network.json",
            height: 300.h,
          ),
          SizedBox(height: 25.h),
          ElevatedButton.icon(
            onPressed: () {
              _refreshIndicatorKey.currentState?.show();
            },
            icon: Icon(
              Icons.refresh,
              size: 20.sp,
              color: ColorApp.white,
            ),
            label: Text(
              "إعادة المحاولة",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: ColorApp.white,
                fontFamily: 'Cairo',
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorApp.primaryBlue,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // بناء خطأ تحميل المزيد
  Widget _buildLoadMoreError(String error) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorApp.error.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: ColorApp.error.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.error_outline,
                size: 20.sp,
                color: ColorApp.error,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  "فشل في تحميل المزيد من العناصر",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorApp.error,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            error,
            style: TextStyle(
              fontSize: 12.sp,
              color: ColorApp.error.withOpacity(0.8),
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                context.read<InventoryCubit>().fetchNextPage();
              },
              icon: Icon(
                Icons.refresh,
                size: 18.sp,
                color: ColorApp.white,
              ),
              label: Text(
                "المحاولة مرة أخرى",
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorApp.white,
                  fontFamily: 'Cairo',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorApp.primaryBlue,
                padding: EdgeInsets.symmetric(vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<InventoryCubit>().fetchNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<InventoryCubit>()..fetchFirstPage(),
      child: Scaffold(
        backgroundColor: ColorApp.backgroundPrimary,
        appBar: AppBar(
          backgroundColor: ColorApp.white,
          automaticallyImplyLeading: false,
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
        ),
        body: BlocBuilder<InventoryCubit, InventoryState>(
          builder: (context, state) {
            final cubit = context.read<InventoryCubit>();
            final inventoryItems = cubit.inventoryItems;
            final hasMore = cubit.hasMore;
            final isInitialLoading = state is Loading && inventoryItems.isEmpty;

            // حالة التحميل الأولي - عرض الشيمر
            if (isInitialLoading) {
              return _buildShimmerEffect();
            }

            // حالة الخطأ
            if (state is Error && inventoryItems.isEmpty) {
              return _buildErrorState(state.error);
            }

            // حساب الإحصائيات
            int totalItems = 0;
            int lowStockItems = 0;

            if (state is Success) {
              totalItems = state.inventoryResponse.data.pagination.total;
              lowStockItems = inventoryItems.where((item) => item.quantity < 5).length;
            }

            return RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _onRefresh,
              color: ColorApp.primaryBlue,
              backgroundColor: ColorApp.white,
              displacement: 40.w,
              strokeWidth: 3.0,
              triggerMode: RefreshIndicatorTriggerMode.onEdge,
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.all(16.w),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // عنوان الصفحة
                    _buildHeaderSection(),
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
                    _buildStatsSection(totalItems, lowStockItems),
                    SizedBox(height: 24.h),

                    // قائمة الأصناف
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

                    // حالة عدم وجود عناصر
                    if (inventoryItems.isEmpty && state is! Loading)
                      _buildEmptyState()
                    else
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
                            // قائمة العناصر
                            ...inventoryItems.map((item) => Column(
                              children: [
                                _buildInventoryItem(item: item),
                                if (item != inventoryItems.last)
                                  Divider(
                                      height: 24.h,
                                      color: ColorApp.borderLight),
                              ],
                            )).toList(),

                            // مؤشر تحميل الصفحات - شيمر للتحميل الإضافي
                            if (hasMore && state is Loading)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                child: _buildItemShimmer(),
                              ),

                            // رسالة نهاية القائمة
                            if (!hasMore && inventoryItems.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                child: Text(
                                  "انتهت القائمة",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: ColorApp.textSecondary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // بناء حالة فارغة مع صورة
  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(40.w),
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
          // صورة أو أيقونة للحالة الفارغة
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: ColorApp.backgroundPrimary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              size: 60.sp,
              color: ColorApp.textSecondary.withOpacity(0.5),
            ),
          ),
          SizedBox(height: 20.h),

          Text(
            "المخزون فارغ",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: ColorApp.textPrimary,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: 8.h),

          Text(
            "لم يتم العثور على عناصر في المخزون\nيمكنك إضافة عناصر جديدة للبدء",
            style: TextStyle(
              fontSize: 14.sp,
              color: ColorApp.textSecondary,
              fontFamily: 'Cairo',
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),

          // زر إضافة عنصر جديد (اختياري)
          ElevatedButton.icon(
            onPressed: () {
              // يمكن إضافة وظيفة الإضافة هنا
            },
            icon: Icon(
              Icons.add,
              size: 20.sp,
              color: ColorApp.white,
            ),
            label: Text(
              "إضافة عنصر جديد",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: ColorApp.white,
                fontFamily: 'Cairo',
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorApp.primaryBlue,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // بناء تأثير الشيمر للتحميل الأولي
  Widget _buildShimmerEffect() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // شيمر عنوان الصفحة
          _buildHeaderShimmer(),
          SizedBox(height: 24.h),

          // شيمر عنوان الإحصائيات
          _buildTextShimmer(width: 120.w),
          SizedBox(height: 16.h),

          // شيمر الإحصائيات
          _buildStatsShimmer(),
          SizedBox(height: 24.h),

          // شيمر عنوان القائمة
          _buildTextShimmer(width: 150.w),
          SizedBox(height: 16.h),

          // شيمر قائمة العناصر
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
                _buildItemShimmer(),
                SizedBox(height: 16.h),
                _buildItemShimmer(),
                SizedBox(height: 16.h),
                _buildItemShimmer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // شيمر رأس الصفحة
  Widget _buildHeaderShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: ColorApp.white,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120.w,
                    height: 18.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: 200.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // شيمر الإحصائيات
  Widget _buildStatsShimmer() {
    return Row(
      children: [
        Expanded(child: _buildStatCardShimmer()),
        SizedBox(width: 12.w),
        Expanded(child: _buildStatCardShimmer()),
      ],
    );
  }

  // شيمر بطاقة الإحصائية الواحدة
  Widget _buildStatCardShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: ColorApp.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              width: 30.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: 4.h),
            Container(
              width: 60.w,
              height: 12.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // شيمر عنصر واحد في القائمة
  Widget _buildItemShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 14.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  width: 100.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ],
      ),
    );
  }

  // شيمر النص
  Widget _buildTextShimmer({required double width}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: 16.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.r),
        ),
      ),
    );
  }

  // قسم رأس الصفحة العادي
  Widget _buildHeaderSection() {
    return Container(
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
      child: Row(
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
    );
  }

  // قسم الإحصائيات العادي
  Widget _buildStatsSection(int totalItems, int lowStockItems) {
    return Row(
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
                  totalItems.toString(),
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
                  lowStockItems.toString(),
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
    );
  }

  Widget _buildInventoryItem({required InventoryItem item}) {
    final bool isLowStock = item.quantity < 5;
    final String status = isLowStock
        ? context.translate(LangKeys.inventoryLowStock)
        : context.translate(LangKeys.inventoryAvailable);
    final Color statusColor = isLowStock ? ColorApp.warning : ColorApp.success;

    return Row(
      children: [
        // عرض الصورة إذا كانت متوفرة
        if (item.image != null && item.image!.isNotEmpty)
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              image: DecorationImage(
                image: NetworkImage(item.image!),
                fit: BoxFit.cover,
              ),
            ),
          )
        else
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: ColorApp.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.inventory,
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
                item.name,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorApp.textPrimary,
                  fontFamily: 'Cairo',
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '${context.translate(LangKeys.inventoryQuantity)}: ${item.quantity}',
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