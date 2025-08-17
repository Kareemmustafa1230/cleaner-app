import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:diyar/core/networking/di/dependency_injection.dart';
import 'package:diyar/features/home_page/logic/cubit/apartment_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/Color/colors.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/language/lang_keys.dart';
import '../../../../core/widget/anmiate_builder.dart';
import '../../../apartment/ui/screen/apartment_details_screen.dart';
import '../../../notifications/logic/state/mark_read_state.dart';
import '../../logic/state/apartment_search_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ApartmentSearchCubit>()..fetchFirstPage(),
      child: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  Timer? _searchTimer;
  late ApartmentSearchCubit _cubit;

  Color _getCleaningStatusColor(String status) {
    switch (status) {
      case 'true':
        return Theme.of(context).colorScheme.primary;
      case 'قيد التنظيف':
        return Theme.of(context).colorScheme.secondary;
      case 'false':
        return Theme.of(context).colorScheme.error;
      default:
        return ColorApp.white;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'false':
      case 'Available':
        return Theme.of(context).colorScheme.primary;
      case 'true':
      case 'Rented':
        return Theme.of(context).colorScheme.secondary;
      default:
        return ColorApp.white;
    }
  }

  String _getTranslatedCleaningStatus(String status, BuildContext context) {
    switch (status) {
      case 'true':
        return context.translate(LangKeys.cleaned);
      case 'قيد التنظيف':
        return context.translate(LangKeys.cleaningInProgress);
      case 'false':
        return context.translate(LangKeys.notCleaned);
      default:
        return status;
    }
  }

  String _getTranslatedStatus(String status, BuildContext context) {
    switch (status) {
      case 'false':
        return context.translate(LangKeys.availableStatus);
      case 'true':
        return context.translate(LangKeys.rented);
      default:
        return status;
    }
  }

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<ApartmentSearchCubit>(context);

    if (_cubit.state is Initial) {
      _cubit.fetchFirstPage();
    }

    // إضافة مستمع للتمرير لتحميل المزيد من البيانات
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _cubit.fetchNextPage();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // إضافة مستمع لحقل البحث بعد بناء الشاشة
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
    _scrollController.dispose();
    _cubit.searchController.removeListener(_onSearchChanged);
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
                // شيمر للصورة
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
                // شيمر للمعلومات (النصوص)
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
    return BlocConsumer<ApartmentSearchCubit, ApartmentSearchState>(
      listener: (context, state) {},
      builder: (context, state) {
        final isSearching = _cubit.searchController.text.isNotEmpty;

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await _cubit.fetchFirstPage();
              },
              child: Column(
                children: [
                  // شعار الشركة واسمها
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      boxShadow: [
                        BoxShadow(
                          color: ColorApp.shadowLight,
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // شعار الشركة
                        Container(
                          width: 50.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: ColorApp.shadowMedium,
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: 50.w,
                              height: 50.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        // اسم الشركة
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.translate(LangKeys.companyName),
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                              Text(
                                'Diyar Company',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: ColorApp.textSecondary,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                        // أيقونة الإشعارات
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [ColorApp.gradientStart, ColorApp.gradientEnd],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10.r),
                            boxShadow: [
                              BoxShadow(
                                color: ColorApp.shadowMedium,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.notifications_outlined,
                            color: ColorApp.textInverse,
                            size: 24.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // قسم البحث
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
                      boxShadow: [
                        BoxShadow(
                          color: ColorApp.shadowLight,
                          blurRadius: 15,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _cubit.searchController,
                      decoration: InputDecoration(
                        hintText: context.translate(LangKeys.searchApartments),
                        hintStyle: TextStyle(
                          fontSize: 15.sp,
                          color: ColorApp.textSecondary,
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
                            _cubit.clearSearch();
                            _cubit.searchController.clear();
                          },
                        )
                            : null,
                      ),
                    ),
                  ),
                  // عنوان القسم
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        Text(
                          context.translate(LangKeys.availableApartments),
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: ColorApp.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [ColorApp.gradientStart, ColorApp.gradientEnd],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: ColorApp.shadowMedium,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            '${_cubit.chalets.length} ${context.translate(LangKeys.apartmentCount)}',
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
                  Expanded(
                    child: state.when(
                      initial: () => _buildShimmerGrid(),
                      loading: () => _buildShimmerGrid(),
                      success: (apartmentSearchResponse) {
                        if (_cubit.chalets.isEmpty) {
                          return _buildEmptyState();
                        }
                        return _buildApartmentsGrid(context);
                      },
                      error: (error) => _buildErrorState(error),
                    ),
                  ),
                  SizedBox(height: 35.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildApartmentsGrid(BuildContext context) {
    return GridView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.8,
      ),
      itemCount: _cubit.chalets.length + (_cubit.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _cubit.chalets.length) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
        }

        final apartment = _cubit.chalets[index];
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
                ),
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
                  context.pushWithSlideTransition(
                    screen: ApartmentDetailsScreen(
                      apartmentId: apartment.id.toString(),
                      apartmentName: apartment.name.toString(),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    // صورة الشقة
                    Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: CachedNetworkImage(
                          imageUrl: apartment.image.toString(),
                          fit: BoxFit.fill,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            "assets/images/apartment.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        apartment.name.toString(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: ColorApp.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Cairo',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        apartment.floor.toString(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: ColorApp.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Cairo',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 3.h,
                              ),
                              decoration: BoxDecoration(
                                color: _getCleaningStatusColor(apartment.isCleaned.toString()).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(
                                  color: _getCleaningStatusColor(apartment.isCleaned.toString()).withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                _getTranslatedCleaningStatus(apartment.isCleaned.toString(), context),
                                style: TextStyle(
                                  color: _getCleaningStatusColor(apartment.isCleaned.toString()),
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Cairo',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(apartment.isBooked.toString()).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4.r),
                                border: Border.all(
                                  color: _getStatusColor(apartment.isBooked.toString()).withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                _getTranslatedStatus(apartment.isBooked.toString(), context),
                                style: TextStyle(
                                  color: _getStatusColor(apartment.isBooked.toString()),
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Cairo',
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
              ),
            ),
          ),
        );
      },
    );
  }
}