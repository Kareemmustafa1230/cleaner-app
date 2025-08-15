import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/Color/colors.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/language/lang_keys.dart';
import '../../../../core/widget/anmiate_builder.dart';
import '../../../apartment/ui/screen/apartment_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _apartments = [
    {
      'id': '1',
      'name': 'شقة 101',
      'address': 'شارع الملك فهد، الرياض',
      'status': 'متاح',
      'image': 'assets/images/apartment.png',
      'cleaning_status': 'تم التنظيف',
      'floor': 'الدور الأول',
      'rooms': '3 غرف',
      'bathrooms': '2 حمام',
      'area': '120 متر مربع',
    },
    {
      'id': '2',
      'name': 'شقة 102',
      'address': 'شارع التحلية، جدة',
      'status': 'مؤجر',
      'image': 'assets/images/apartment.png',
      'cleaning_status': 'قيد التنظيف',
      'floor': 'الدور الثاني',
      'rooms': '4 غرف',
      'bathrooms': '3 حمام',
      'area': '150 متر مربع',
    },
    {
      'id': '3',
      'name': 'شقة 103',
      'address': 'شارع العليا، الرياض',
      'status': 'متاح',
      'image': 'assets/images/apartment.png',
      'cleaning_status': 'تم التنظيف',
      'floor': 'الدور الثالث',
      'rooms': '2 غرف',
      'bathrooms': '1 حمام',
      'area': '90 متر مربع',
    },
    {
      'id': '4',
      'name': 'شقة 201',
      'address': 'شارع الملك عبدالله، الدمام',
      'status': 'متاح',
      'image': 'assets/images/apartment.png',
      'cleaning_status': 'لم يتم التنظيف',
      'floor': 'الدور الثاني',
      'rooms': '5 غرف',
      'bathrooms': '3 حمام',
      'area': '180 متر مربع',
    },
    {
      'id': '5',
      'name': 'شقة 301',
      'address': 'شارع التحلية، جدة',
      'status': 'مؤجر',
      'image': 'assets/images/apartment.png',
      'cleaning_status': 'تم التنظيف',
      'floor': 'الدور الثالث',
      'rooms': '3 غرف',
      'bathrooms': '2 حمام',
      'area': '110 متر مربع',
    },
  ];

  Color _getCleaningStatusColor(String status) {
    switch (status) {
      case 'تم التنظيف':
        return Theme.of(context).colorScheme.primary;
      case 'قيد التنظيف':
        return Theme.of(context).colorScheme.secondary;
      case 'لم يتم التنظيف':
        return Theme.of(context).colorScheme.error;
      default:
        return ColorApp.white;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'متاح':
      case 'Available':
        return Theme.of(context).colorScheme.primary;
      case 'مؤجر':
      case 'Rented':
        return Theme.of(context).colorScheme.secondary;
      default:
        return ColorApp.white;
    }
  }

  String _getTranslatedCleaningStatus(String status, BuildContext context) {
    switch (status) {
      case 'تم التنظيف':
        return context.translate(LangKeys.cleaned);
      case 'قيد التنظيف':
        return context.translate(LangKeys.cleaningInProgress);
      case 'لم يتم التنظيف':
        return context.translate(LangKeys.notCleaned);
      default:
        return status;
    }
  }

  String _getTranslatedStatus(String status, BuildContext context) {
    switch (status) {
      case 'متاح':
        return context.translate(LangKeys.availableStatus);
      case 'مؤجر':
        return context.translate(LangKeys.rented);
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
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
                      '${_apartments.length} ${context.translate(LangKeys.apartmentCount)}',
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
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 16.h,
                  childAspectRatio: 0.8,
                ),
                itemCount: _apartments.length,
                itemBuilder: (context, index) {
                  final apartment = _apartments[index];
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
                                apartmentId: apartment['id'],
                                apartmentName: apartment['name'],
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
                                      image: DecorationImage(
                                        image: AssetImage(apartment['image']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // اسم الشقة
                                      Text(
                                        apartment['name'],
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                        color: ColorApp.textPrimary,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Cairo',
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      // الدور
                                      Text(
                                        apartment['floor'],
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                        color: ColorApp.textSecondary,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Cairo',
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      // عدد الغرف والحمامات
                                      Text(
                                        '${apartment['rooms']} • ${apartment['bathrooms']}',
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
                                                color: _getCleaningStatusColor(apartment['cleaning_status']).withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(6.r),
                                                border: Border.all(
                                                  color: _getCleaningStatusColor(apartment['cleaning_status']).withOpacity(0.3),
                                                  width: 1,
                                                ),
                                              ),
                                              child: Text(
                                                _getTranslatedCleaningStatus(apartment['cleaning_status'], context),
                                                style: TextStyle(
                                                  color: _getCleaningStatusColor(apartment['cleaning_status']),
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
                                              color: _getStatusColor(apartment['status']).withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(4.r),
                                              border: Border.all(
                                                color: _getStatusColor(apartment['status']).withOpacity(0.3),
                                                width: 1,
                                              ),
                                            ),
                                            child: Text(
                                              _getTranslatedStatus(apartment['status'], context),
                                              style: TextStyle(
                                                color: _getStatusColor(apartment['status']),
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
              ),
            ),
            SizedBox(height: 35.h),
          ],
        ),
      ),
    );
  }
} 