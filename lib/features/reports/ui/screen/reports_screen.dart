import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/networking/di/dependency_injection.dart';
import '../../../../core/theme/Color/colors.dart';
import '../../../../core/language/lang_keys.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/widget/anmiate_builder.dart';
import '../../../home_page/logic/cubit/apartment_search_cubit.dart';
import '../../../home_page/logic/state/apartment_search_state.dart';
import '../../logic/cubit/upload_cleaning_cubit.dart';
import 'unit_media_upload_screen.dart';

class ApartmentsMediaScreen extends StatefulWidget {
  const ApartmentsMediaScreen({super.key});

  @override
  State<ApartmentsMediaScreen> createState() => _ApartmentsMediaScreenState();
}

class _ApartmentsMediaScreenState extends State<ApartmentsMediaScreen> {
  final _scrollController = ScrollController();
  Timer? _searchTimer;
  late final ApartmentSearchCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ApartmentSearchCubit>()..fetchFirstPage();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _cubit.fetchNextPage();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(milliseconds: 500), () {
      if (_cubit.searchController.text.isEmpty) {
        _cubit.clearSearch();
      } else {
        _cubit.fetchFirstPage();
      }
    });
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _cubit.searchController.removeListener(_onSearchChanged);
    _cubit.close();
    super.dispose();
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.8,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
            BoxShadow(
            color: ColorApp.shadowLight,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          ],
          border: Border.all(
            color: ColorApp.borderLight,
            width: 1,
          ),
        ),
        child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Expanded(
        flex: 3,
        child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12.r),
        ),
        ),
        ),
        ),
        SizedBox(height: 8.h),
        Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
        width: 100.w,
        height: 14.h,
        decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4.r),
        ),
        ),
        ),
        SizedBox(height: 4.h),
        Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
        width: 80.w,
        height: 12.h,
        decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4.r),
        ),
        ),
        ),
        SizedBox(height: 6.h),
        Row(
        children: [
        Expanded(
        child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
        height: 20.h,
        decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(6.r),
        ),
        ),
        ),
        ),
        SizedBox(width: 8.w),
        Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
        width: 40.w,
        height: 20.h,
        decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4.r),
        ),
        ),
        ),
        ],
        ),
        ],
        ),
        ],
        ),
        ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: LottieBuilder.asset("assets/lottie/no_data_search.json",
        height: 300.h,
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: LottieBuilder.asset("assets/lottie/error_network.json",
        height: 300.h,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<ApartmentSearchCubit, ApartmentSearchState>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = context.read<ApartmentSearchCubit>();
          final isSearching = cubit.searchController.text.isNotEmpty;

          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  await cubit.fetchFirstPage();
                },
                child: Column(
                  children: [
                    // Header مع العنوان في المنتصف
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                      ),
                      child: Center(
                        child: Text(
                          context.translate(LangKeys.apartmentsMedia),
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.all(16.w),
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: cubit.searchController,
                        decoration: InputDecoration(
                          hintText: context.translate(LangKeys.searchApartmentsMedia),
                          hintStyle: TextStyle(
                            fontSize: 15.sp,
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Cairo',
                          ),
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.search,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20.sp,
                          ),
                          suffixIcon: isSearching
                              ? IconButton(
                            icon: Icon(Icons.clear, size: 20.sp),
                            onPressed: () {
                              cubit.clearSearch();
                              cubit.searchController.clear();
                            },
                          )
                              : null,
                        ),
                      ),
                    ),
                    // عنوان القسم مع عدد الشقق
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        children: [
                          Text(
                            context.translate(LangKeys.availableApartmentsMedia),
                            style: TextStyle(
                              fontSize: 20.sp,
                              color: Theme.of(context).colorScheme.onBackground,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              '${cubit.chalets.length} ${context.translate(LangKeys.apartmentCountMedia)}',
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: ColorApp.textInverse,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.h),
                    // قائمة الشقق - نفس تصميم الهوم
                    Expanded(
                      child: state.map(
                        initial: (_) => _buildShimmerGrid(),
                        loading: (_) => _buildShimmerGrid(),
                        success: (successState) {
                          if (cubit.chalets.isEmpty) {
                            return _buildEmptyState();
                          }
                          return _buildApartmentsGrid(context, cubit);
                        },
                        error: (errorState) => _buildErrorState(errorState.error),
                      ),
                    ),
                    SizedBox(height: 35.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildApartmentsGrid(BuildContext context, ApartmentSearchCubit cubit) {
    return GridView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.8,
      ),
      itemCount: cubit.chalets.length + (cubit.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= cubit.chalets.length) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
        }

        final apartment = cubit.chalets[index];
        return AnimateBuilder(
          columnCount: 2,
          position: index,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: [
              BoxShadow(
              color: ColorApp.shadowLight,
              blurRadius: 20,
              offset: const Offset(0, 8),
              )
              ],
            border: Border.all(
            color: ColorApp.borderLight,
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(15.r),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => getIt<UploadCleaningCubit>(),
                      child: UnitMediaUploadScreen(
                       chaletsId: apartment.id.toString(),
                    ),
                   ),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // صورة الشقة
                    Expanded(
                      flex: 3,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          image: DecorationImage(
                            image: AssetImage('assets/images/apartment.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // تفاصيل الشقة
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // اسم الشقة
                          Text(
                            apartment.name.toString(),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Theme.of(context).colorScheme.onBackground,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Cairo',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          // المبنى
                          Text(
                            apartment.building.toString(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Cairo',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          // أيقونة الشقة
                          Row(
                            children: [
                              Icon(
                                Icons.apartment,
                                color: Theme.of(context).colorScheme.primary,
                                size: 16.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                context.translate(LangKeys.residentialApartment),
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        );
      },
    );
  }
}