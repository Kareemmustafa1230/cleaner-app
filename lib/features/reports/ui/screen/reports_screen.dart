import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/Color/colors.dart';
import '../../../../core/language/lang_keys.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/widget/anmiate_builder.dart';
import 'unit_media_upload_screen.dart';

class ApartmentsMediaScreen extends StatefulWidget {
  const ApartmentsMediaScreen({super.key});

  @override
  State<ApartmentsMediaScreen> createState() => _ApartmentsMediaScreenState();
}

class _ApartmentsMediaScreenState extends State<ApartmentsMediaScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  List<Map<String, String>> get _apartments {
    return [
      {'id': '1', 'name': '${context.translate(LangKeys.apartmentNumber)} 101', 'building': '${context.translate(LangKeys.building)} أ'},
      {'id': '2', 'name': '${context.translate(LangKeys.apartmentNumber)} 102', 'building': '${context.translate(LangKeys.building)} أ'},
      {'id': '3', 'name': '${context.translate(LangKeys.apartmentNumber)} 201', 'building': '${context.translate(LangKeys.building)} ب'},
      {'id': '4', 'name': '${context.translate(LangKeys.apartmentNumber)} 202', 'building': '${context.translate(LangKeys.building)} ب'},
      {'id': '5', 'name': '${context.translate(LangKeys.apartmentNumber)} 301', 'building': '${context.translate(LangKeys.building)} ج'},
      {'id': '6', 'name': '${context.translate(LangKeys.apartmentNumber)} 302', 'building': '${context.translate(LangKeys.building)} ج'},
      {'id': '7', 'name': '${context.translate(LangKeys.apartmentNumber)} 401', 'building': '${context.translate(LangKeys.building)} د'},
      {'id': '8', 'name': '${context.translate(LangKeys.apartmentNumber)} 402', 'building': '${context.translate(LangKeys.building)} د'},
  ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
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
                controller: _searchController,
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
                  suffixIcon: _searchText.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            setState(() {
                              _searchText = '';
                            });
                          },
                          child: Icon(
                            Icons.close,
                            color: Theme.of(context).colorScheme.error,
                            size: 18.sp,
                          ),
                        )
                      : null,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                },
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
                      '${_filteredApartments.length} ${context.translate(LangKeys.apartmentCountMedia)}',
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
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 16.h,
                  childAspectRatio: 0.8,
                ),
                itemCount: _filteredApartments.length,
                itemBuilder: (context, index) {
                  final apartment = _filteredApartments[index];
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UnitMediaUploadScreen(
                                  selectedUnit: apartment,
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
                                        apartment['name'] ?? '',
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
                                        apartment['building'] ?? '',
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> get _filteredApartments {
    if (_searchText.isEmpty) return _apartments;
    return _apartments.where((apt) =>
      (apt['name'] ?? '').contains(_searchText) ||
      (apt['building'] ?? '').contains(_searchText)
    ).toList();
  }
} 