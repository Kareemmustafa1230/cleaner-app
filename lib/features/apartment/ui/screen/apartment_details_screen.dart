import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import '../../../../core/theme/Color/colors.dart';
import '../widget/image_gallery_screen.dart';
import '../widget/video_player_screen.dart';
import '../widget/video_gallery_screen.dart';

class ApartmentDetailsScreen extends StatefulWidget {
  final String apartmentId;
  final String apartmentName;

  const ApartmentDetailsScreen({
    super.key,
    required this.apartmentId,
    required this.apartmentName,
  });

  @override
  State<ApartmentDetailsScreen> createState() => _ApartmentDetailsScreenState();
}

class _ApartmentDetailsScreenState extends State<ApartmentDetailsScreen> {
  int _selectedTabIndex = 0;
  int _selectedCleaningTabIndex = 0; // تبويب النظافة (الصور/الفيديوهات)
  int _selectedDamagesTabIndex = 0; // تبويب التلفيات (الصور/الفيديوهات)
  String _selectedDate = 'الكل'; // تصفية حسب التاريخ
  DateTime _selectedCalendarDate = DateTime.now(); // التاريخ المحدد في التقويم

  final List<Map<String, dynamic>> _cleaningRecords = [
    {
      'id': '1',
      'type': 'تنظيف شامل',
      'date': '2024-01-15',
      'status': 'تم التنظيف',
      'notes': 'تم تنظيف جميع الغرف والحمامات والمطبخ',
      'cleaner': 'أحمد محمد',
      'duration': '3 ساعات',
    },
    {
      'id': '2',
      'type': 'تنظيف سريع',
      'date': '2024-01-10',
      'status': 'تم التنظيف',
      'notes': 'تنظيف غرفة المعيشة والمطبخ',
      'cleaner': 'فاطمة علي',
      'duration': '1.5 ساعة',
    },
    {
      'id': '3',
      'type': 'تنظيف الحمامات',
      'date': '2024-01-08',
      'status': 'قيد التنظيف',
      'notes': 'تنظيف الحمامات الرئيسية والثانوية',
      'cleaner': 'خالد أحمد',
      'duration': '1 ساعة',
    },
    {
      'id': '4',
      'type': 'تنظيف المطبخ',
      'date': '2024-01-05',
      'status': 'لم يتم التنظيف',
      'notes': 'تنظيف المطبخ والأجهزة',
      'cleaner': 'مريم سعيد',
      'duration': '2 ساعة',
    },
  ];

  final List<Map<String, dynamic>> _cleaningImages = [
    {
      'id': '1',
      'url': 'assets/images/apartment.png',
      'title': 'صورة قبل التنظيف - غرفة المعيشة',
      'date': '2024-01-15',
      'type': 'قبل التنظيف',
    },
    {
      'id': '2',
      'url': 'assets/images/apartment.png',
      'title': 'صورة بعد التنظيف - غرفة المعيشة',
      'date': '2024-01-15',
      'type': 'بعد التنظيف',
    },
    {
      'id': '3',
      'url': 'assets/images/apartment.png',
      'title': 'تنظيف المطبخ - قبل',
      'date': '2024-01-10',
      'type': 'قبل التنظيف',
    },
    {
      'id': '4',
      'url': 'assets/images/apartment.png',
      'title': 'تنظيف المطبخ - بعد',
      'date': '2024-01-10',
      'type': 'بعد التنظيف',
    },
    {
      'id': '5',
      'url': 'assets/images/apartment.png',
      'title': 'تنظيف الحمام الرئيسي',
      'date': '2024-01-08',
      'type': 'أثناء التنظيف',
    },
    {
      'id': '6',
      'url': 'assets/images/apartment.png',
      'title': 'تنظيف غرفة النوم',
      'date': '2024-01-08',
      'type': 'أثناء التنظيف',
    },
    {
      'id': '7',
      'url': 'assets/images/apartment.png',
      'title': 'تنظيف النوافذ',
      'date': '2024-01-05',
      'type': 'أثناء التنظيف',
    },
    {
      'id': '8',
      'url': 'assets/images/apartment.png',
      'title': 'تنظيف الأرضيات',
      'date': '2024-01-05',
      'type': 'أثناء التنظيف',
    },
  ];

  final List<Map<String, dynamic>> _cleaningVideos = [
    {
      'id': '1',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو تنظيف شامل - غرفة المعيشة',
      'date': '2024-01-15',
      'duration': '2:30',
      'type': 'تنظيف شامل',
    },
    {
      'id': '2',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو تنظيف المطبخ - قبل وبعد',
      'date': '2024-01-10',
      'duration': '1:45',
      'type': 'تنظيف المطبخ',
    },
    {
      'id': '3',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو تنظيف الحمامات',
      'date': '2024-01-08',
      'duration': '1:20',
      'type': 'تنظيف الحمامات',
    },
    {
      'id': '4',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو تنظيف غرفة النوم',
      'date': '2024-01-08',
      'duration': '1:15',
      'type': 'تنظيف غرف النوم',
    },
    {
      'id': '5',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو تنظيف النوافذ والأسقف',
      'date': '2024-01-05',
      'duration': '1:30',
      'type': 'تنظيف شامل',
    },
    {
      'id': '6',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو تنظيف الأرضيات والموكيت',
      'date': '2024-01-05',
      'duration': '1:10',
      'type': 'تنظيف الأرضيات',
    },
  ];

  final List<Map<String, dynamic>> _damages = [
    {
      'id': '1',
      'title': 'كسر في النافذة',
      'description': 'نافذة مكسورة في غرفة النوم الرئيسية',
      'status': 'قيد الإصلاح',
      'date': '2024-01-15',
      'priority': 'متوسط',
      'reportedBy': 'المستأجر',
      'estimatedCost': '500 ريال',
    },
    {
      'id': '2',
      'title': 'تسرب في الحمام',
      'description': 'تسرب مياه من صنبور الحمام',
      'status': 'تم الإصلاح',
      'date': '2024-01-10',
      'priority': 'عالي',
      'reportedBy': 'المدير',
      'estimatedCost': '300 ريال',
    },
    {
      'id': '3',
      'title': 'خلل في الكهرباء',
      'description': 'مشكلة في قواطع الكهرباء',
      'status': 'قيد الإصلاح',
      'date': '2024-01-12',
      'priority': 'عالي',
      'reportedBy': 'المستأجر',
      'estimatedCost': '800 ريال',
    },
    {
      'id': '4',
      'title': 'تلف في الأثاث',
      'description': 'كسر في كرسي غرفة المعيشة',
      'status': 'معلق',
      'date': '2024-01-03',
      'priority': 'منخفض',
      'reportedBy': 'المدير',
      'estimatedCost': '200 ريال',
    },
  ];

  final List<Map<String, dynamic>> _damagesImages = [
    {
      'id': '1',
      'url': 'assets/images/apartment.png',
      'title': 'صورة النافذة المكسورة - قبل الإصلاح',
      'date': '2024-01-15',
      'type': 'قبل الإصلاح',
    },
    {
      'id': '2',
      'url': 'assets/images/apartment.png',
      'title': 'صورة النافذة المكسورة - بعد الإصلاح',
      'date': '2024-01-15',
      'type': 'بعد الإصلاح',
    },
    {
      'id': '3',
      'url': 'assets/images/apartment.png',
      'title': 'تسرب المياه في الحمام',
      'date': '2024-01-10',
      'type': 'قبل الإصلاح',
    },
    {
      'id': '4',
      'url': 'assets/images/apartment.png',
      'title': 'الحمام بعد إصلاح التسرب',
      'date': '2024-01-10',
      'type': 'بعد الإصلاح',
    },
    {
      'id': '5',
      'url': 'assets/images/apartment.png',
      'title': 'قواطع الكهرباء المعطلة',
      'date': '2024-01-12',
      'type': 'قبل الإصلاح',
    },
    {
      'id': '6',
      'url': 'assets/images/apartment.png',
      'title': 'قواطع الكهرباء الجديدة',
      'date': '2024-01-12',
      'type': 'بعد الإصلاح',
    },
    {
      'id': '7',
      'url': 'assets/images/apartment.png',
      'title': 'الكرسي المكسور',
      'date': '2024-01-03',
      'type': 'قبل الإصلاح',
    },
    {
      'id': '8',
      'url': 'assets/images/apartment.png',
      'title': 'الكرسي الجديد',
      'date': '2024-01-03',
      'type': 'بعد الإصلاح',
    },
  ];

  final List<Map<String, dynamic>> _damagesVideos = [
    {
      'id': '1',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو توثيق كسر النافذة',
      'date': '2024-01-15',
      'duration': '1:30',
      'type': 'توثيق الضرر',
    },
    {
      'id': '2',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو إصلاح النافذة',
      'date': '2024-01-15',
      'duration': '2:15',
      'type': 'عملية الإصلاح',
    },
    {
      'id': '3',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو تسرب المياه',
      'date': '2024-01-10',
      'duration': '0:45',
      'type': 'توثيق الضرر',
    },
    {
      'id': '4',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو إصلاح التسرب',
      'date': '2024-01-10',
      'duration': '1:20',
      'type': 'عملية الإصلاح',
    },
    {
      'id': '5',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو مشكلة الكهرباء',
      'date': '2024-01-12',
      'duration': '1:00',
      'type': 'توثيق الضرر',
    },
    {
      'id': '6',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو إصلاح الكهرباء',
      'date': '2024-01-12',
      'duration': '1:45',
      'type': 'عملية الإصلاح',
    },
  ];

  // الحصول على الصور حسب التاريخ المحدد
  List<Map<String, dynamic>> get _filteredCleaningImages {
    // إذا كان التاريخ المحدد هو اليوم الحالي، اعرض جميع الصور
    if (_selectedCalendarDate.year == DateTime.now().year && 
        _selectedCalendarDate.month == DateTime.now().month && 
        _selectedCalendarDate.day == DateTime.now().day) {
      return _cleaningImages;
    }
    
    final selectedDateString = '${_selectedCalendarDate.year}-${_selectedCalendarDate.month.toString().padLeft(2, '0')}-${_selectedCalendarDate.day.toString().padLeft(2, '0')}';
    return _cleaningImages.where((image) => image['date'] == selectedDateString).toList();
  }

  // الحصول على الفيديوهات حسب التاريخ المحدد
  List<Map<String, dynamic>> get _filteredCleaningVideos {
    // إذا كان التاريخ المحدد هو اليوم الحالي، اعرض جميع الفيديوهات
    if (_selectedCalendarDate.year == DateTime.now().year && 
        _selectedCalendarDate.month == DateTime.now().month && 
        _selectedCalendarDate.day == DateTime.now().day) {
      return _cleaningVideos;
    }
    
    final selectedDateString = '${_selectedCalendarDate.year}-${_selectedCalendarDate.month.toString().padLeft(2, '0')}-${_selectedCalendarDate.day.toString().padLeft(2, '0')}';
    return _cleaningVideos.where((video) => video['date'] == selectedDateString).toList();
  }

  // الحصول على صور التلفيات حسب التاريخ المحدد
  List<Map<String, dynamic>> get _filteredDamagesImages {
    // إذا كان التاريخ المحدد هو اليوم الحالي، اعرض جميع الصور
    if (_selectedCalendarDate.year == DateTime.now().year && 
        _selectedCalendarDate.month == DateTime.now().month && 
        _selectedCalendarDate.day == DateTime.now().day) {
      return _damagesImages;
    }
    
    final selectedDateString = '${_selectedCalendarDate.year}-${_selectedCalendarDate.month.toString().padLeft(2, '0')}-${_selectedCalendarDate.day.toString().padLeft(2, '0')}';
    return _damagesImages.where((image) => image['date'] == selectedDateString).toList();
  }

  // الحصول على فيديوهات التلفيات حسب التاريخ المحدد
  List<Map<String, dynamic>> get _filteredDamagesVideos {
    // إذا كان التاريخ المحدد هو اليوم الحالي، اعرض جميع الفيديوهات
    if (_selectedCalendarDate.year == DateTime.now().year && 
        _selectedCalendarDate.month == DateTime.now().month && 
        _selectedCalendarDate.day == DateTime.now().day) {
      return _damagesVideos;
    }
    
    final selectedDateString = '${_selectedCalendarDate.year}-${_selectedCalendarDate.month.toString().padLeft(2, '0')}-${_selectedCalendarDate.day.toString().padLeft(2, '0')}';
    return _damagesVideos.where((video) => video['date'] == selectedDateString).toList();
  }

  // قائمة التواريخ المتاحة لسجلات النظافة
  List<String> get _availableCleaningDates {
    final dates = _cleaningRecords.map((record) => record['date'] as String).toSet().toList();
    dates.sort((a, b) => DateTime.parse(b).compareTo(DateTime.parse(a)));
    return ['الكل', ...dates];
  }

  // قائمة التواريخ المتاحة للتلفيات
  List<String> get _availableDamageDates {
    final dates = _damages.map((damage) => damage['date'] as String).toSet().toList();
    dates.sort((a, b) => DateTime.parse(b).compareTo(DateTime.parse(a)));
    return ['الكل', ...dates];
  }

  // قائمة التواريخ المتاحة لصور التلفيات
  List<String> get _availableDamagesImageDates {
    final dates = _damagesImages.map((image) => image['date'] as String).toSet().toList();
    dates.sort((a, b) => DateTime.parse(b).compareTo(DateTime.parse(a)));
    return ['الكل', ...dates];
  }

  // قائمة التواريخ المتاحة لفيديوهات التلفيات
  List<String> get _availableDamagesVideoDates {
    final dates = _damagesVideos.map((video) => video['date'] as String).toSet().toList();
    dates.sort((a, b) => DateTime.parse(b).compareTo(DateTime.parse(a)));
    return ['الكل', ...dates];
  }



  // تصفية التلفيات حسب التاريخ
  List<Map<String, dynamic>> get _filteredDamages {
    if (_selectedDate == 'الكل') {
      return _damages;
    }
    return _damages.where((damage) => damage['date'] == _selectedDate).toList();
  }

  // الحصول على التواريخ المتاحة حسب التبويب المحدد
  List<String> get _availableDates {
    return _selectedTabIndex == 0 ? _availableCleaningDates : _availableDamageDates;
  }



  // الحصول على لون الحالة
  Color _getStatusColor(String status) {
    switch (status) {
      case 'تم الإصلاح':
        return ColorApp.fixed;
      case 'قيد الإصلاح':
        return ColorApp.inProgress;
      case 'معلق':
        return ColorApp.pending;
      default:
        return ColorApp.grey;
    }
  }

  // الحصول على لون الأولوية
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'عالي':
        return ColorApp.priorityHigh;
      case 'متوسط':
        return ColorApp.priorityMedium;
      case 'منخفض':
        return ColorApp.priorityLow;
      default:
        return ColorApp.grey;
    }
  }

  // عرض معرض الصور
  void _showImageGallery(BuildContext context, int initialIndex) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ImageGalleryScreen(
          images: _filteredCleaningImages,
          initialIndex: initialIndex,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 300),
      ),
    );
  }

  // عرض معرض الفيديوهات
  void _showVideoGallery(BuildContext context, int initialIndex) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => VideoGalleryScreen(
          videos: _filteredCleaningVideos,
          initialIndex: initialIndex,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 300),
      ),
    );
  }

  // عرض مشغل الفيديو
  void _showVideoPlayer(BuildContext context, Map<String, dynamic> video) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          videoUrl: video['url'],
          videoTitle: video['title'],
          videoType: video['type'],
          videoDuration: video['duration'],
        ),
      ),
    );
  }

  // عرض معرض صور التلفيات
  void _showDamagesImageGallery(BuildContext context, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageGalleryScreen(
          images: _filteredDamagesImages,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  // عرض مشغل فيديو التلفيات
  void _showDamagesVideoPlayer(BuildContext context, Map<String, dynamic> video) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          videoUrl: video['url'],
          videoTitle: video['title'],
          videoType: video['type'],
          videoDuration: video['duration'],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: ColorApp.backgroundPrimary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
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
              Icons.arrow_back_ios,
              color: ColorApp.textInverse,
              size: 20.sp,
            ),
          ),
        ),
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorApp.backgroundSecondary.withValues(alpha: 0.8),
                ColorApp.backgroundPrimary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(
              color: ColorApp.borderLight.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: ColorApp.shadowLight.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 3),
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // أيقونة الشقة
              Icon(
                Icons.apartment,
                color: ColorApp.primaryBlue,
                size: 18.sp,
              ),
              SizedBox(height: 4.h),
              // عنوان الشقة
              Text(
                widget.apartmentName,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: ColorApp.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Cairo',
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // نوع الشقة
              Text(
                'شقة سكنية',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: ColorApp.textSecondary,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Cairo',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          // زر إضافي للمعلومات
          Container(
            margin: EdgeInsets.only(right: 8.w),
            child: IconButton(
              onPressed: () {
                // يمكن إضافة إجراء هنا مثل عرض معلومات إضافية
              },
              icon: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: ColorApp.backgroundSecondary.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: ColorApp.borderLight.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: ColorApp.primaryBlue,
                  size: 20.sp,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط التبويبات
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: ColorApp.backgroundSecondary,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: ColorApp.borderLight,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: ColorApp.shadowLight,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildTabButton(
                    title: 'النظافة',
                    index: 0,
                    icon: Icons.cleaning_services,
                  ),
                ),
                Expanded(
                  child: _buildTabButton(
                    title: 'التلفيات',
                    index: 1,
                    icon: Icons.build,
                  ),
                ),
              ],
            ),
          ),
          
          // محتوى التبويبات
          Expanded(
            child: _selectedTabIndex == 0
                ? _buildCleaningContent()
                : _buildDamagesContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String title,
    required int index,
    required IconData icon,
  }) {
    final isSelected = _selectedTabIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
          _selectedDate = 'الكل'; // إعادة تعيين التصفية عند تغيير التبويب
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          gradient: isSelected 
              ? LinearGradient(
                  colors: [ColorApp.gradientStart, ColorApp.gradientEnd],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? ColorApp.textInverse : ColorApp.primaryBlue,
              size: 18.sp,
            ),
            SizedBox(width: 6.w),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? ColorApp.textInverse : ColorApp.primaryBlue,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCleaningContent() {
    return ListView(
        padding: EdgeInsets.all(16.w),
      children: [
        // عنوان القسم
        Text(
          'سجلات النظافة',
          style: TextStyle(
            fontSize: 20.sp,
            color: ColorApp.textPrimary,
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
          ),
        ),
        SizedBox(height: 16.h),
        
        // التقويم باستخدام easy_date_timeline
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorApp.backgroundPrimary,
                ColorApp.backgroundSecondary.withValues(alpha: 0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: ColorApp.borderLight.withValues(alpha: 0.5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: ColorApp.shadowLight.withValues(alpha: 0.1),
                blurRadius: 15,
                offset: const Offset(0, 6),
                spreadRadius: 1,
              ),
            ],
          ),
        child: Column(
            children: [
              // رأس التقويم
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ColorApp.gradientStart, ColorApp.gradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
          children: [
                    Icon(
                      Icons.calendar_today,
                      color: ColorApp.textInverse,
                      size: 18.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'اختر التاريخ',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: ColorApp.textInverse,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
              
              // التقويم
              Container(
                padding: EdgeInsets.all(16.w),
                child: EasyDateTimeLine(
                  initialDate: _selectedCalendarDate,
                  onDateChange: (selectedDate) {
                    setState(() {
                      _selectedCalendarDate = selectedDate;
                    });
                  },
                  headerProps: const EasyHeaderProps(
                    showHeader: false,
                  ),
                ),
              ),
              
              // معلومات التاريخ المحدد وزر عرض الكل
            Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: ColorApp.backgroundSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16.r),
                    bottomRight: Radius.circular(16.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // التاريخ المحدد
                    Row(
                      children: [
                        Icon(
                          Icons.event,
                          color: ColorApp.primaryBlue,
                          size: 14.sp,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          '${_selectedCalendarDate.day}/${_selectedCalendarDate.month}/${_selectedCalendarDate.year}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: ColorApp.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                    
                    // زر عرض الكل
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCalendarDate = DateTime.now();
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [ColorApp.gradientStart, ColorApp.gradientEnd],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.view_list,
                              color: ColorApp.textInverse,
                              size: 12.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'عرض الكل',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: ColorApp.textInverse,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        
        // تبويبات الصور والفيديوهات
        Container(
          decoration: BoxDecoration(
            color: ColorApp.backgroundSecondary,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: ColorApp.borderLight,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildCleaningSubTabButton(
                  title: 'الصور',
                  index: 0,
                  icon: Icons.photo_library,
                ),
              ),
              Expanded(
                child: _buildCleaningSubTabButton(
                  title: 'الفيديوهات',
                  index: 1,
                  icon: Icons.video_library,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        
        // محتوى تبويبات النظافة
        _selectedCleaningTabIndex == 0
            ? _buildCleaningImagesContent()
            : _buildCleaningVideosContent(),
      ],
    );
  }

  Widget _buildCleaningSubTabButton({
    required String title,
    required int index,
    required IconData icon,
  }) {
    final isSelected = _selectedCleaningTabIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCleaningTabIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
          gradient: isSelected 
              ? LinearGradient(
                  colors: [ColorApp.gradientStart, ColorApp.gradientEnd],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? ColorApp.textInverse : ColorApp.primaryBlue,
              size: 16.sp,
            ),
            SizedBox(width: 4.w),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? ColorApp.textInverse : ColorApp.primaryBlue,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDamagesSubTabButton({
    required String title,
    required int index,
    required IconData icon,
  }) {
    final isSelected = _selectedDamagesTabIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDamagesTabIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          gradient: isSelected 
              ? LinearGradient(
                  colors: [ColorApp.gradientStart, ColorApp.gradientEnd],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? ColorApp.textInverse : ColorApp.primaryBlue,
              size: 16.sp,
            ),
            SizedBox(width: 4.w),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? ColorApp.textInverse : ColorApp.primaryBlue,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCleaningImagesContent() {
    return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
          'صور النظافة (${_filteredCleaningImages.length})',
          style: TextStyle(
            fontSize: 18.sp,
            color: ColorApp.textPrimary,
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
          ),
        ),
        SizedBox(height: 12.h),
        
        if (_filteredCleaningImages.isNotEmpty) ...[
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 1.0,
            ),
            itemCount: _filteredCleaningImages.length,
            itemBuilder: (context, index) {
              final image = _filteredCleaningImages[index];
              return _buildCleaningImageGridItem(image, index);
            },
          ),
        ] else ...[
          SizedBox(height: 40.h),
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.photo_library_outlined,
                  size: 60.sp,
                  color: ColorApp.textLight,
                ),
                SizedBox(height: 16.h),
                  Text(
                  'لا توجد صور متاحة لهذا التاريخ',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: ColorApp.textLight,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                  ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                  'جرب اختيار تاريخ آخر',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ColorApp.textSecondary,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Cairo',
                  ),
                  ),
                ],
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildCleaningVideosContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'فيديوهات النظافة (${_filteredCleaningVideos.length})',
          style: TextStyle(
            fontSize: 18.sp,
            color: ColorApp.textPrimary,
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
          ),
        ),
        SizedBox(height: 12.h),
        
        if (_filteredCleaningVideos.isNotEmpty) ...[
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 1.0,
            ),
            itemCount: _filteredCleaningVideos.length,
            itemBuilder: (context, index) {
              final video = _filteredCleaningVideos[index];
              return _buildCleaningVideoGridItem(video, index);
            },
          ),
        ] else ...[
          SizedBox(height: 40.h),
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.video_library_outlined,
                  size: 60.sp,
                  color: ColorApp.textLight,
                ),
                SizedBox(height: 16.h),
                Text(
                  'لا توجد فيديوهات متاحة لهذا التاريخ',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: ColorApp.textLight,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'جرب اختيار تاريخ آخر',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ColorApp.textSecondary,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

    Widget _buildCleaningImageGridItem(Map<String, dynamic> image, int index) {
    return GestureDetector(
      onTap: () {
        _showImageGallery(context, index);
      },
      child: Container(
        decoration: BoxDecoration(
          color: ColorApp.backgroundPrimary,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: ColorApp.borderLight,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorApp.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الصورة مع Hero Animation
            Expanded(
                              child: Hero(
                  tag: 'gallery_image_${image['id']}',
                  child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.r),
                      topRight: Radius.circular(12.r),
                    ),
                    image: DecorationImage(
                      image: AssetImage(image['url']),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // أيقونة التكبير
                      Positioned(
                        top: 8.h,
                        right: 8.w,
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.zoom_in,
                            color: ColorApp.textInverse,
                            size: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // تفاصيل الصورة
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // عنوان الصورة
                  Text(
                    image['title'],
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: ColorApp.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Cairo',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  
                  // نوع الصورة
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [ColorApp.gradientStart, ColorApp.gradientEnd],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      image['type'],
                      style: TextStyle(
                        color: ColorApp.textInverse,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cairo',
                      ),
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

  Widget _buildCleaningVideoGridItem(Map<String, dynamic> video, int index) {
    return GestureDetector(
      onTap: () {
        _showVideoGallery(context, index);
      },
      child: Container(
        decoration: BoxDecoration(
          color: ColorApp.backgroundPrimary,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: ColorApp.borderLight,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorApp.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة الفيديو
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                  image: DecorationImage(
                    image: AssetImage(video['url']),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    // أيقونة التشغيل
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [ColorApp.gradientStart, ColorApp.gradientEnd],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: ColorApp.shadowDark,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            color: ColorApp.textInverse,
                            size: 24.sp,
                          ),
                        ),
                      ),
                    ),
                    
                    // مدة الفيديو
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          video['duration'],
                          style: TextStyle(
                            color: ColorApp.textInverse,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // تفاصيل الفيديو
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // عنوان الفيديو
                  Text(
                    video['title'],
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: ColorApp.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Cairo',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  
                  // نوع الفيديو
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [ColorApp.gradientStart, ColorApp.gradientEnd],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      video['type'],
                      style: TextStyle(
                        color: ColorApp.textInverse,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cairo',
                      ),
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

  Widget _buildDamagesContent() {
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        // عنوان القسم
        Text(
          'سجلات التلفيات والإصلاحات',
          style: TextStyle(
            fontSize: 20.sp,
            color: ColorApp.textPrimary,
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
          ),
        ),
        SizedBox(height: 16.h),
        
        // التقويم باستخدام easy_date_timeline
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorApp.backgroundPrimary,
                ColorApp.backgroundSecondary.withValues(alpha: 0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: ColorApp.borderLight.withValues(alpha: 0.5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: ColorApp.shadowLight.withValues(alpha: 0.1),
                blurRadius: 15,
                offset: const Offset(0, 6),
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            children: [
              // رأس التقويم
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ColorApp.gradientStart, ColorApp.gradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: ColorApp.textInverse,
                      size: 18.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'اختر التاريخ',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: ColorApp.textInverse,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
              
              // التقويم
              Container(
                padding: EdgeInsets.all(16.w),
                child: EasyDateTimeLine(
                  initialDate: _selectedCalendarDate,
                  onDateChange: (selectedDate) {
                    setState(() {
                      _selectedCalendarDate = selectedDate;
                    });
                  },
                  headerProps: const EasyHeaderProps(
                    showHeader: false,
                  ),
                ),
              ),
              
              // معلومات التاريخ المحدد وزر عرض الكل
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: ColorApp.backgroundSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16.r),
                    bottomRight: Radius.circular(16.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // التاريخ المحدد
                    Row(
                      children: [
                        Icon(
                          Icons.event,
                          color: ColorApp.primaryBlue,
                          size: 14.sp,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          '${_selectedCalendarDate.day}/${_selectedCalendarDate.month}/${_selectedCalendarDate.year}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: ColorApp.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                    
                    // زر عرض الكل
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCalendarDate = DateTime.now();
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [ColorApp.gradientStart, ColorApp.gradientEnd],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.view_list,
                              color: ColorApp.textInverse,
                              size: 12.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'عرض الكل',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: ColorApp.textInverse,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        
        // تبويبات الصور والفيديوهات
        Container(
          decoration: BoxDecoration(
            color: ColorApp.backgroundSecondary,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: ColorApp.borderLight,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildDamagesSubTabButton(
                  title: 'الصور',
                  index: 0,
                  icon: Icons.photo_library,
                ),
              ),
              Expanded(
                child: _buildDamagesSubTabButton(
                  title: 'الفيديوهات',
                  index: 1,
                  icon: Icons.video_library,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        
        // محتوى تبويبات التلفيات
        _selectedDamagesTabIndex == 0
            ? _buildDamagesImagesContent()
            : _buildDamagesVideosContent(),
      ],
    );
  }

  Widget _buildDamagesImagesContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'صور التلفيات (${_filteredDamagesImages.length})',
          style: TextStyle(
            fontSize: 18.sp,
            color: ColorApp.textPrimary,
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
          ),
        ),
        SizedBox(height: 12.h),
        
        if (_filteredDamagesImages.isNotEmpty) ...[
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 1.0,
            ),
            itemCount: _filteredDamagesImages.length,
            itemBuilder: (context, index) {
              final image = _filteredDamagesImages[index];
              return _buildDamagesImageGridItem(image, index);
            },
          ),
        ] else ...[
          SizedBox(height: 40.h),
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.photo_library_outlined,
                  size: 60.sp,
                  color: ColorApp.textLight,
                ),
                SizedBox(height: 16.h),
                Text(
                  'لا توجد صور متاحة لهذا التاريخ',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: ColorApp.textLight,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'جرب اختيار تاريخ آخر',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ColorApp.textSecondary,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDamagesVideosContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'فيديوهات التلفيات (${_filteredDamagesVideos.length})',
          style: TextStyle(
            fontSize: 18.sp,
            color: ColorApp.textPrimary,
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
          ),
        ),
        SizedBox(height: 12.h),
        
        if (_filteredDamagesVideos.isNotEmpty) ...[
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 1.0,
            ),
            itemCount: _filteredDamagesVideos.length,
            itemBuilder: (context, index) {
              final video = _filteredDamagesVideos[index];
              return _buildDamagesVideoGridItem(video, index);
            },
          ),
        ] else ...[
          SizedBox(height: 40.h),
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.video_library_outlined,
                  size: 60.sp,
                  color: ColorApp.textLight,
                ),
                SizedBox(height: 16.h),
                Text(
                  'لا توجد فيديوهات متاحة لهذا التاريخ',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: ColorApp.textLight,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'جرب اختيار تاريخ آخر',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ColorApp.textSecondary,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDamagesImageGridItem(Map<String, dynamic> image, int index) {
    return GestureDetector(
      onTap: () {
        _showDamagesImageGallery(context, index);
      },
      child: Container(
        decoration: BoxDecoration(
          color: ColorApp.backgroundPrimary,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: ColorApp.borderLight,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorApp.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الصورة
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                  image: DecorationImage(
                    image: AssetImage(image['url']),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    // أيقونة التكبير
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.zoom_in,
                          color: ColorApp.textInverse,
                          size: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // تفاصيل الصورة
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // عنوان الصورة
                  Text(
                    image['title'],
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: ColorApp.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Cairo',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  
                  // نوع الصورة
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [ColorApp.gradientStart, ColorApp.gradientEnd],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      image['type'],
                      style: TextStyle(
                        color: ColorApp.textInverse,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cairo',
                      ),
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

  Widget _buildDamagesVideoGridItem(Map<String, dynamic> video, int index) {
    return GestureDetector(
      onTap: () {
        _showDamagesVideoPlayer(context, video);
      },
      child: Container(
        decoration: BoxDecoration(
          color: ColorApp.backgroundPrimary,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: ColorApp.borderLight,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorApp.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة الفيديو
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                  image: DecorationImage(
                    image: AssetImage(video['url']),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    // أيقونة التشغيل
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [ColorApp.gradientStart, ColorApp.gradientEnd],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: ColorApp.shadowDark,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            color: ColorApp.textInverse,
                            size: 24.sp,
                          ),
                        ),
                      ),
                    ),
                    
                    // مدة الفيديو
                    Positioned(
                      bottom: 8.h,
                      right: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          video['duration'],
                          style: TextStyle(
                            color: ColorApp.textInverse,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // تفاصيل الفيديو
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // عنوان الفيديو
                  Text(
                    video['title'],
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: ColorApp.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Cairo',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  
                  // نوع الفيديو
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [ColorApp.gradientStart, ColorApp.gradientEnd],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      video['type'],
                      style: TextStyle(
                        color: ColorApp.textInverse,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cairo',
                      ),
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
} 