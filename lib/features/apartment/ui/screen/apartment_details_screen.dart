import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import '../../../../core/theme/Color/colors.dart';
import '../../../../core/language/lang_keys.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/widget/anmiate_builder.dart';
import '../widget/image_gallery_screen.dart';
import '../widget/video_player_screen.dart';
import '../widget/video_gallery_screen.dart';
import '../../data/model/cleaning_record.dart';

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
  int _selectedCleaningTabIndex = 0; 
  int _selectedDamagesTabIndex = 0;
  int _selectedPestControlTabIndex = 0;
  int _selectedMaintenanceTabIndex = 0;
  String _selectedDate = 'الكل';
  DateTime _selectedCalendarDate = DateTime.now();
  String _selectedCleaningTiming = 'قبل التنظيف';
  String _selectedDamagesTiming = 'قبل الإصلاح';
  String _selectedPestControlTiming = 'قبل المبيدات الحشرية';
  String _selectedMaintenanceTiming = 'قبل الصيانة';
  String _selectedCleaningType = 'عادية'; // نوع النظافة: عادية أو عمية
  bool _showCleaningMedia = false;
  bool _showDamagesMedia = false;
  bool _showPestControlMedia = false;
  bool _showMaintenanceMedia = false;
  
  // متغيرات سجل المخزون
  List<CleaningRecord> _cleaningRecords = [];
  CleaningRecord? _selectedRecord;

  final List<Map<String, dynamic>> _cleaningRecordsOld = [
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
      'title': 'تنظيف الحمام الرئيسي - قبل',
      'date': '2024-01-08',
      'type': 'قبل التنظيف',
    },
    {
      'id': '6',
      'url': 'assets/images/apartment.png',
      'title': 'تنظيف الحمام الرئيسي - بعد',
      'date': '2024-01-08',
      'type': 'بعد التنظيف',
    },
    {
      'id': '7',
      'url': 'assets/images/apartment.png',
      'title': 'تنظيف النوافذ - قبل',
      'date': '2024-01-05',
      'type': 'قبل التنظيف',
    },
    {
      'id': '8',
      'url': 'assets/images/apartment.png',
      'title': 'تنظيف النوافذ - بعد',
      'date': '2024-01-05',
      'type': 'بعد التنظيف',
    },
  ];

  final List<Map<String, dynamic>> _cleaningVideos = [
    {
      'id': '1',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو تنظيف شامل - قبل',
      'date': '2024-01-15',
      'duration': '2:30',
      'type': 'قبل التنظيف',
    },
    {
      'id': '2',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو تنظيف شامل - بعد',
      'date': '2024-01-15',
      'duration': '1:45',
      'type': 'بعد التنظيف',
    },
    {
      'id': '3',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو تنظيف المطبخ - قبل',
      'date': '2024-01-10',
      'duration': '1:20',
      'type': 'قبل التنظيف',
    },
    {
      'id': '4',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو تنظيف المطبخ - بعد',
      'date': '2024-01-10',
      'duration': '1:15',
      'type': 'بعد التنظيف',
    },
    {
      'id': '5',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو تنظيف الحمامات - قبل',
      'date': '2024-01-08',
      'duration': '1:30',
      'type': 'قبل التنظيف',
    },
    {
      'id': '6',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو تنظيف الحمامات - بعد',
      'date': '2024-01-08',
      'duration': '1:10',
      'type': 'بعد التنظيف',
    },
    {
      'id': '7',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو حالة المطبخ قبل التنظيف',
      'date': '2024-01-15',
      'duration': '0:45',
      'type': 'قبل التنظيف',
    },
    {
      'id': '8',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو حالة المطبخ بعد التنظيف',
      'date': '2024-01-15',
      'duration': '0:45',
      'type': 'بعد التنظيف',
    },
    {
      'id': '9',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو حالة الحمام قبل التنظيف',
      'date': '2024-01-10',
      'duration': '0:30',
      'type': 'قبل التنظيف',
    },
    {
      'id': '10',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو حالة الحمام بعد التنظيف',
      'date': '2024-01-10',
      'duration': '0:30',
      'type': 'بعد التنظيف',
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
      'title': 'تسرب المياه في الحمام - قبل',
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
      'title': 'قواطع الكهرباء المعطلة - قبل',
      'date': '2024-01-12',
      'type': 'قبل الإصلاح',
    },
    {
      'id': '6',
      'url': 'assets/images/apartment.png',
      'title': 'قواطع الكهرباء الجديدة - بعد',
      'date': '2024-01-12',
      'type': 'بعد الإصلاح',
    },
    {
      'id': '7',
      'url': 'assets/images/apartment.png',
      'title': 'الكرسي المكسور - قبل',
      'date': '2024-01-03',
      'type': 'قبل الإصلاح',
    },
    {
      'id': '8',
      'url': 'assets/images/apartment.png',
      'title': 'الكرسي الجديد - بعد',
      'date': '2024-01-03',
      'type': 'بعد الإصلاح',
    },
  ];

  final List<Map<String, dynamic>> _damagesVideos = [
    {
      'id': '1',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو توثيق كسر النافذة - قبل',
      'date': '2024-01-15',
      'duration': '1:30',
      'type': 'قبل الإصلاح',
    },
    {
      'id': '2',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو النافذة بعد الإصلاح',
      'date': '2024-01-15',
      'duration': '2:15',
      'type': 'بعد الإصلاح',
    },
    {
      'id': '3',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو النافذة بعد الإصلاح',
      'date': '2024-01-15',
      'duration': '0:45',
      'type': 'بعد الإصلاح',
    },
    {
      'id': '4',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو تسرب المياه - قبل',
      'date': '2024-01-10',
      'duration': '0:45',
      'type': 'قبل الإصلاح',
    },
    {
      'id': '5',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو الحمام بعد إصلاح التسرب',
      'date': '2024-01-10',
      'duration': '1:20',
      'type': 'بعد الإصلاح',
    },
    {
      'id': '6',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو الحمام بعد إصلاح التسرب',
      'date': '2024-01-10',
      'duration': '0:30',
      'type': 'بعد الإصلاح',
    },
    {
      'id': '7',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو مشكلة الكهرباء - قبل',
      'date': '2024-01-12',
      'duration': '1:00',
      'type': 'قبل الإصلاح',
    },
    {
      'id': '8',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو الكهرباء بعد الإصلاح',
      'date': '2024-01-12',
      'duration': '1:45',
      'type': 'بعد الإصلاح',
    },
    {
      'id': '9',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو الكهرباء بعد الإصلاح',
      'date': '2024-01-12',
      'duration': '0:30',
      'type': 'بعد الإصلاح',
    },
    {
      'id': '10',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو الكرسي المكسور - قبل',
      'date': '2024-01-03',
      'duration': '0:20',
      'type': 'قبل الإصلاح',
    },
    {
      'id': '11',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو الكرسي الجديد - بعد',
      'date': '2024-01-03',
      'duration': '1:10',
      'type': 'بعد الإصلاح',
    },
    {
      'id': '12',
      'url': 'assets/images/apartment.png',
      'title': 'فيديو الكرسي الجديد - بعد',
      'date': '2024-01-03',
      'duration': '0:15',
      'type': 'بعد الإصلاح',
    },
  ];

  // الحصول على الصور حسب التاريخ المحدد وتوقيت النظافة
  List<Map<String, dynamic>> get _filteredCleaningImages {
    List<Map<String, dynamic>> filteredImages = _cleaningImages;
    
    // تصفية حسب التاريخ
    if (_selectedCalendarDate.year != DateTime.now().year || 
        _selectedCalendarDate.month != DateTime.now().month || 
        _selectedCalendarDate.day != DateTime.now().day) {
      final selectedDateString = '${_selectedCalendarDate.year}-${_selectedCalendarDate.month.toString().padLeft(2, '0')}-${_selectedCalendarDate.day.toString().padLeft(2, '0')}';
      filteredImages = filteredImages.where((image) => image['date'] == selectedDateString).toList();
    }
    
    // تصفية حسب توقيت النظافة
    filteredImages = filteredImages.where((image) => image['type'] == _selectedCleaningTiming).toList();
    
    return filteredImages;
  }

  // الحصول على الفيديوهات حسب التاريخ المحدد وتوقيت النظافة
  List<Map<String, dynamic>> get _filteredCleaningVideos {
    List<Map<String, dynamic>> filteredVideos = _cleaningVideos;
    
    // تصفية حسب التاريخ
    if (_selectedCalendarDate.year != DateTime.now().year || 
        _selectedCalendarDate.month != DateTime.now().month || 
        _selectedCalendarDate.day != DateTime.now().day) {
      final selectedDateString = '${_selectedCalendarDate.year}-${_selectedCalendarDate.month.toString().padLeft(2, '0')}-${_selectedCalendarDate.day.toString().padLeft(2, '0')}';
      filteredVideos = filteredVideos.where((video) => video['date'] == selectedDateString).toList();
    }
    
    // تصفية حسب توقيت النظافة
    filteredVideos = filteredVideos.where((video) => video['type'] == _selectedCleaningTiming).toList();
    
    return filteredVideos;
  }

  // الحصول على صور التلفيات حسب التاريخ المحدد وتوقيت الإصلاح
  List<Map<String, dynamic>> get _filteredDamagesImages {
    List<Map<String, dynamic>> filteredImages = _damagesImages;
    
    // تصفية حسب التاريخ
    if (_selectedCalendarDate.year != DateTime.now().year || 
        _selectedCalendarDate.month != DateTime.now().month || 
        _selectedCalendarDate.day != DateTime.now().day) {
      final selectedDateString = '${_selectedCalendarDate.year}-${_selectedCalendarDate.month.toString().padLeft(2, '0')}-${_selectedCalendarDate.day.toString().padLeft(2, '0')}';
      filteredImages = filteredImages.where((image) => image['date'] == selectedDateString).toList();
    }
    
    // تصفية حسب توقيت الإصلاح
    filteredImages = filteredImages.where((image) => image['type'] == _selectedDamagesTiming).toList();
    
    return filteredImages;
  }

  // الحصول على فيديوهات التلفيات حسب التاريخ المحدد وتوقيت الإصلاح
  List<Map<String, dynamic>> get _filteredDamagesVideos {
    List<Map<String, dynamic>> filteredVideos = _damagesVideos;
    
    // تصفية حسب التاريخ
    if (_selectedCalendarDate.year != DateTime.now().year || 
        _selectedCalendarDate.month != DateTime.now().month || 
        _selectedCalendarDate.day != DateTime.now().day) {
      final selectedDateString = '${_selectedCalendarDate.year}-${_selectedCalendarDate.month.toString().padLeft(2, '0')}-${_selectedCalendarDate.day.toString().padLeft(2, '0')}';
      filteredVideos = filteredVideos.where((video) => video['date'] == selectedDateString).toList();
    }
    
    // تصفية حسب توقيت الإصلاح
    filteredVideos = filteredVideos.where((video) => video['type'] == _selectedDamagesTiming).toList();
    
    return filteredVideos;
  }

  // قائمة التواريخ المتاحة لسجلات النظافة
  List<String> get _availableCleaningDates {
    final dates = _cleaningRecords.map((record) => record.cleaningDate.toIso8601String().split('T')[0]).toSet().toList();
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
      case 'completed':
        return ColorApp.fixed;
      case 'in_progress':
        return ColorApp.inProgress;
      case 'pending':
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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTabButton(
                    title: 'النظافة',
                    index: 0,
                    icon: Icons.cleaning_services,
                  ),
                  _buildTabButton(
                    title: 'التلفيات',
                    index: 1,
                    icon: Icons.build,
                  ),
                  _buildTabButton(
                    title: 'المبيدات الحشرية',
                    index: 2,
                    icon: Icons.bug_report,
                  ),
                  _buildTabButton(
                    title: 'الصيانة',
                    index: 3,
                    icon: Icons.handyman,
                  ),
                ],
              ),
            ),
          ),
          
          // محتوى التبويبات
          Expanded(
            child: _selectedTabIndex == 0
                ? _buildCleaningContent()
                : _selectedTabIndex == 1
                    ? _buildDamagesContent()
                    : _selectedTabIndex == 2
                        ? _buildPestControlContent()
                        : _buildMaintenanceContent(),
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
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          gradient: isSelected 
              ? LinearGradient(
                  colors: [ColorApp.gradientStart, ColorApp.gradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : ColorApp.backgroundSecondary,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? Colors.transparent : ColorApp.borderLight,
            width: 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: ColorApp.shadowLight.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? ColorApp.textInverse : ColorApp.primaryBlue,
              size: 18.sp,
            ),
            SizedBox(width: 8.w),
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
        
        // اختيار نوع النظافة
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8.w),
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
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // رأس قسم نوع النظافة
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ColorApp.gradientStart, ColorApp.gradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cleaning_services,
                      color: ColorApp.textInverse,
                      size: 18.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'نوع النظافة',
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
              
              // خيارات نوع النظافة
              Container(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildCleaningTypeButton(
                        title: 'نظافة عادية',
                        value: 'عادية',
                        icon: Icons.cleaning_services,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildCleaningTypeButton(
                        title: 'نظافة عمية',
                        value: 'عمية',
                        icon: Icons.cleaning_services_outlined,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
                      // تحديث سجل المخزون عند تغيير التاريخ
                      if (_selectedCleaningTabIndex == 2 && _selectedCleaningTiming == 'بعد التنظيف') {
                        _loadCleaningRecords();
                      }
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
        
        // تبويبات توقيت النظافة (قبل/بعد)
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
                child: _buildCleaningTimingTabButton(
                  title: 'قبل النظافة',
                  value: 'قبل التنظيف',
                  icon: Icons.cleaning_services,
                ),
              ),
              Expanded(
                child: _buildCleaningTimingTabButton(
                  title: 'بعد النظافة',
                  value: 'بعد التنظيف',
                  icon: Icons.cleaning_services,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        
        // زر عرض النظافة
        Container(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _showCleaningMedia = !_showCleaningMedia;
              });
            },
            icon: Icon(
              _showCleaningMedia ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: ColorApp.textInverse,
              size: 20.sp,
            ),
            label: Text(
              _showCleaningMedia ? 'إخفاء النظافة' : 'عرض النظافة',
              style: TextStyle(
                color: ColorApp.textInverse,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorApp.primaryBlue,
              foregroundColor: ColorApp.textInverse,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 2,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        
        // تبويبات الصور والفيديوهات (تظهر فقط عند الضغط على الزر)
        if (_showCleaningMedia) ...[
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCleaningSubTabButton(
                        title: 'الصور',
                        index: 0,
                        icon: Icons.photo_library,
                      ),
                      _buildCleaningSubTabButton(
                        title: 'الفيديوهات',
                        index: 1,
                        icon: Icons.video_library,
                      ),
                      if (_selectedCleaningTiming == 'بعد التنظيف')
                        _buildCleaningSubTabButton(
                          title: 'سجل المخزون',
                          index: 2,
                          icon: Icons.inventory,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          
          // محتوى تبويبات النظافة
          _selectedCleaningTabIndex == 0
              ? _buildCleaningImagesContent()
              : _selectedCleaningTabIndex == 1
                  ? _buildCleaningVideosContent()
                  : _selectedCleaningTabIndex == 2 && _selectedCleaningTiming == 'بعد التنظيف'
                      ? _buildCleaningInventoryContent()
                      : _buildCleaningImagesContent(), // عرض الصور كافتراضي إذا لم يكن التاب متاح
        ],
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
        
        // تحميل سجلات النظافة عند فتح التاب (فقط إذا كان التوقيت "بعد التنظيف")
        if (index == 2 && _selectedCleaningTiming == 'بعد التنظيف' && _cleaningRecords.isEmpty) {
          _loadCleaningRecords();
        }
        
        // إعادة تعيين التاب إذا كان غير متاح
        if (index == 2 && _selectedCleaningTiming != 'بعد التنظيف') {
          _selectedCleaningTabIndex = 0;
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        decoration: BoxDecoration(
          gradient: isSelected 
              ? LinearGradient(
                  colors: [ColorApp.gradientStart, ColorApp.gradientEnd],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: isSelected ? null : ColorApp.backgroundPrimary,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? Colors.transparent : ColorApp.borderLight,
            width: 1,
          ),
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

  Widget _buildCleaningTypeButton({
    required String title,
    required String value,
    required IconData icon,
  }) {
    final isSelected = _selectedCleaningType == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCleaningType = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        decoration: BoxDecoration(
          gradient: isSelected 
              ? LinearGradient(
                  colors: [ColorApp.gradientStart, ColorApp.gradientEnd],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: isSelected ? null : ColorApp.backgroundPrimary,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? Colors.transparent : ColorApp.borderLight,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? ColorApp.textInverse : ColorApp.primaryBlue,
              size: 24.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? ColorApp.textInverse : ColorApp.primaryBlue,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCleaningTimingTabButton({
    required String title,
    required String value,
    required IconData icon,
  }) {
    final isSelected = _selectedCleaningTiming == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCleaningTiming = value;
          // إعادة تعيين التاب المحدد إذا تغير التوقيت
          if (value != 'بعد التنظيف' && _selectedCleaningTabIndex == 2) {
            _selectedCleaningTabIndex = 0; // العودة إلى تبويب الصور
          }
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
              size: 14.sp,
            ),
            SizedBox(width: 4.w),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? ColorApp.textInverse : ColorApp.primaryBlue,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPestControlTimingTabButton({
    required String title,
    required String value,
    required IconData icon,
  }) {
    final isSelected = _selectedPestControlTiming == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPestControlTiming = value;
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
              size: 14.sp,
            ),
            SizedBox(width: 4.w),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? ColorApp.textInverse : ColorApp.primaryBlue,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPestControlSubTabButton({
    required String title,
    required int index,
    required IconData icon,
  }) {
    final isSelected = _selectedPestControlTabIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPestControlTabIndex = index;
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

  Widget _buildPestControlImagesContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${context.translate(LangKeys.pestControlImages)} (0)',
          style: TextStyle(
            fontSize: 18.sp,
            color: ColorApp.textPrimary,
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
          ),
        ),
        SizedBox(height: 12.h),
        
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
                context.translate(LangKeys.noPestControlImages),
                style: TextStyle(
                  fontSize: 16.sp,
                  color: ColorApp.textLight,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                context.translate(LangKeys.trySelectAnotherDate),
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
    );
  }

  Widget _buildPestControlVideosContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${context.translate(LangKeys.pestControlVideos)} (0)',
          style: TextStyle(
            fontSize: 18.sp,
            color: ColorApp.textPrimary,
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
          ),
        ),
        SizedBox(height: 12.h),
        
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
                context.translate(LangKeys.noPestControlVideos),
                style: TextStyle(
                  fontSize: 16.sp,
                  color: ColorApp.textLight,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                context.translate(LangKeys.trySelectAnotherDate),
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
    );
  }

  Widget _buildMaintenanceTimingTabButton({
    required String title,
    required String value,
    required IconData icon,
  }) {
    final isSelected = _selectedMaintenanceTiming == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMaintenanceTiming = value;
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
              size: 14.sp,
            ),
            SizedBox(width: 4.w),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? ColorApp.textInverse : ColorApp.primaryBlue,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaintenanceSubTabButton({
    required String title,
    required int index,
    required IconData icon,
  }) {
    final isSelected = _selectedMaintenanceTabIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMaintenanceTabIndex = index;
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

  Widget _buildMaintenanceImagesContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${context.translate(LangKeys.maintenanceImages)} (0)',
          style: TextStyle(
            fontSize: 18.sp,
            color: ColorApp.textPrimary,
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
          ),
        ),
        SizedBox(height: 12.h),
        
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
                context.translate(LangKeys.noMaintenanceImages),
                style: TextStyle(
                  fontSize: 16.sp,
                  color: ColorApp.textLight,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                context.translate(LangKeys.trySelectAnotherDate),
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
    );
  }

  Widget _buildMaintenanceVideosContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${context.translate(LangKeys.maintenanceVideos)} (0)',
          style: TextStyle(
            fontSize: 18.sp,
            color: ColorApp.textPrimary,
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
          ),
        ),
        SizedBox(height: 12.h),
        
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
                context.translate(LangKeys.noMaintenanceVideos),
                style: TextStyle(
                  fontSize: 16.sp,
                  color: ColorApp.textLight,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                context.translate(LangKeys.trySelectAnotherDate),
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
              return AnimateBuilder(
                  columnCount: 2,
                  position: index,
                  child: _buildCleaningImageGridItem(image, index));
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
              return AnimateBuilder(
                  columnCount: 2,
                  position: index,
                  child: _buildCleaningVideoGridItem(video, index));
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

  Widget _buildCleaningInventoryContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'سجل مخزون النظافة ${_selectedCleaningType} - ${_formatDate(_selectedCalendarDate)}',
          style: TextStyle(
            fontSize: 18.sp,
            color: ColorApp.textPrimary,
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
          ),
        ),
        SizedBox(height: 12.h),
        
        // عرض سجلات النظافة من API
        if (_cleaningRecords.isEmpty)
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
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.cleaning_services_outlined,
                    size: 48.sp,
                    color: ColorApp.textLight,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'لا توجد سجلات نظافة متاحة',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: ColorApp.textLight,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ..._cleaningRecords.map((record) => _buildCleaningRecordCard(record)).toList(),
      ],
    );
  }

  // دالة لتحميل سجلات النظافة من API
  Future<void> _loadCleaningRecords() async {
    // هنا يمكنك إضافة كود لجلب البيانات من API
    // مثال:
    // final result = await _cleaningInventoryRepo.getCleaningRecords(apartmentId, selectedDate);
    // if (result.isSuccess) {
    //   setState(() {
    //     _cleaningRecords = result.data;
    //   });
    // }
    
    // بيانات تجريبية للعرض - عنصر واحد فقط بالتاريخ المحدد
    setState(() {
      _cleaningRecords = [
        CleaningRecord(
          id: 'record_1',
          apartmentId: 'apt_1',
          cleaningDate: _selectedCalendarDate, // استخدام التاريخ المحدد من التقويم
          totalCost: 150.0,
          laborCost: 80.0,
          inventoryCost: 70.0,
          status: 'completed',
          usedItems: [
            UsedInventoryItem(
              id: 'item_1',
              name: 'منظف أرضيات',
              category: 'المنظفات',
              unit: 'لتر',
              unitPrice: 15.0,
              quantity: 2,
              totalPrice: 30.0,
            ),
            UsedInventoryItem(
              id: 'item_2',
              name: 'مطهر عام',
              category: 'المطهرات',
              unit: 'لتر',
              unitPrice: 20.0,
              quantity: 1,
              totalPrice: 20.0,
            ),
            UsedInventoryItem(
              id: 'item_3',
              name: 'ممسحة',
              category: 'أدوات التنظيف',
              unit: 'قطعة',
              unitPrice: 8.0,
              quantity: 1,
              totalPrice: 8.0,
            ),
            UsedInventoryItem(
              id: 'item_4',
              name: 'مناديل ورقية',
              category: 'المنتجات الورقية',
              unit: 'رول',
              unitPrice: 6.0,
              quantity: 2,
              totalPrice: 12.0,
            ),
          ],
        ),
      ];
    });
  }

  // دالة لعرض سجل النظافة
  Widget _buildCleaningRecordCard(CleaningRecord record) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رأس السجل
          Row(
            children: [
              Icon(
                Icons.cleaning_services,
                color: ColorApp.primaryBlue,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'سجل نظافة ${_selectedCleaningType} - ${_formatDate(record.cleaningDate)}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: ColorApp.primaryBlue,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _getStatusColor(record.status),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                                 child: Text(
                   record.status == 'completed' ? 'مكتمل' : 
                   record.status == 'in_progress' ? 'قيد التنفيذ' : 
                   record.status == 'pending' ? 'في الانتظار' : 'غير محدد',
                   style: TextStyle(
                     fontSize: 12.sp,
                     color: ColorApp.white,
                     fontWeight: FontWeight.w600,
                     fontFamily: 'Cairo',
                   ),
                 ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          
          // العناصر المستخدمة
          Text(
            'العناصر المستخدمة:',
            style: TextStyle(
              fontSize: 14.sp,
              color: ColorApp.textPrimary,
              fontWeight: FontWeight.w600,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: 8.h),
          
          ...record.usedItems.map((item) => _buildUsedItemRow(item)).toList(),
          
          SizedBox(height: 16.h),
          
          // ملخص التكاليف
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: ColorApp.primaryBlue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: ColorApp.primaryBlue.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'تكلفة العمالة',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: ColorApp.textPrimary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Text(
                      '${record.laborCost.toStringAsFixed(1)} ريال',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: ColorApp.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'إجمالي تكلفة المخزون',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: ColorApp.textPrimary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Text(
                      '${record.inventoryCost.toStringAsFixed(1)} ريال',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: ColorApp.success,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [ColorApp.primaryBlue, ColorApp.primaryBlue.withOpacity(0.8)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'الإجمالي الكلي',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: ColorApp.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      Text(
                        '${record.totalCost.toStringAsFixed(1)} ريال',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: ColorApp.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // دالة لعرض صف العنصر المستخدم
  Widget _buildUsedItemRow(UsedInventoryItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: ColorApp.backgroundSecondary,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: ColorApp.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(
              _getCategoryIcon(item.category),
              color: ColorApp.primaryBlue,
              size: 14.sp,
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
                    color: ColorApp.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                  ),
                ),
                Text(
                  '${item.quantity} ${item.unit} × ${item.unitPrice.toStringAsFixed(1)} ريال',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: ColorApp.textSecondary,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${item.totalPrice.toStringAsFixed(1)} ريال',
            style: TextStyle(
              fontSize: 14.sp,
              color: ColorApp.success,
              fontWeight: FontWeight.w700,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  // دالة لتنسيق التاريخ
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }



  

  IconData _getCategoryIcon(String category) {
    // مقارنة مع النصوص العربية
    if (category == 'المنظفات') {
      return Icons.cleaning_services;
    } else if (category == 'المطهرات') {
      return Icons.sanitizer;
    } else if (category == 'أدوات التنظيف') {
      return Icons.brush;
    } else if (category == 'المنتجات الورقية') {
      return Icons.description;
    } else {
      return Icons.inventory;
    }
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

  Widget _buildPestControlContent() {
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        // عنوان القسم
        Text(
          context.translate(LangKeys.pestControlRecords),
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
        
        // تبويبات توقيت المبيدات الحشرية (قبل/بعد)
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
                child: _buildPestControlTimingTabButton(
                  title: context.translate(LangKeys.beforePestControl),
                  value: 'قبل المبيدات الحشرية',
                  icon: Icons.bug_report,
                ),
              ),
              Expanded(
                child: _buildPestControlTimingTabButton(
                  title: context.translate(LangKeys.afterPestControl),
                  value: 'بعد المبيدات الحشرية',
                  icon: Icons.bug_report,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        
        // زر عرض المبيدات الحشرية
        Container(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _showPestControlMedia = !_showPestControlMedia;
              });
            },
            icon: Icon(
              _showPestControlMedia ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: ColorApp.textInverse,
              size: 20.sp,
            ),
            label: Text(
              _showPestControlMedia ? context.translate(LangKeys.hidePestControl) : context.translate(LangKeys.showPestControl),
              style: TextStyle(
                color: ColorApp.textInverse,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorApp.primaryBlue,
              foregroundColor: ColorApp.textInverse,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 2,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        
        // تبويبات الصور والفيديوهات (تظهر فقط عند الضغط على الزر)
        if (_showPestControlMedia) ...[
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
                  child: _buildPestControlSubTabButton(
                    title: 'الصور',
                    index: 0,
                    icon: Icons.photo_library,
                  ),
                ),
                Expanded(
                  child: _buildPestControlSubTabButton(
                    title: 'الفيديوهات',
                    index: 1,
                    icon: Icons.video_library,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          
          // محتوى تبويبات المبيدات الحشرية
          _selectedPestControlTabIndex == 0
              ? _buildPestControlImagesContent()
              : _buildPestControlVideosContent(),
        ],
      ],
    );
  }

  Widget _buildMaintenanceContent() {
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        // عنوان القسم
        Text(
          context.translate(LangKeys.maintenanceRecords),
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
        
        // تبويبات توقيت الصيانة (قبل/بعد)
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
                child: _buildMaintenanceTimingTabButton(
                  title: context.translate(LangKeys.beforeMaintenance),
                  value: 'قبل الصيانة',
                  icon: Icons.handyman,
                ),
              ),
              Expanded(
                child: _buildMaintenanceTimingTabButton(
                  title: context.translate(LangKeys.afterMaintenance),
                  value: 'بعد الصيانة',
                  icon: Icons.handyman,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        
        // زر عرض الصيانة
        Container(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _showMaintenanceMedia = !_showMaintenanceMedia;
              });
            },
            icon: Icon(
              _showMaintenanceMedia ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: ColorApp.textInverse,
              size: 20.sp,
            ),
            label: Text(
              _showMaintenanceMedia ? context.translate(LangKeys.hideMaintenance) : context.translate(LangKeys.showMaintenance),
              style: TextStyle(
                color: ColorApp.textInverse,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorApp.primaryBlue,
              foregroundColor: ColorApp.textInverse,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 2,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        
        // تبويبات الصور والفيديوهات (تظهر فقط عند الضغط على الزر)
        if (_showMaintenanceMedia) ...[
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
                  child: _buildMaintenanceSubTabButton(
                    title: 'الصور',
                    index: 0,
                    icon: Icons.photo_library,
                  ),
                ),
                Expanded(
                  child: _buildMaintenanceSubTabButton(
                    title: 'الفيديوهات',
                    index: 1,
                    icon: Icons.video_library,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          
          // محتوى تبويبات الصيانة
          _selectedMaintenanceTabIndex == 0
              ? _buildMaintenanceImagesContent()
              : _buildMaintenanceVideosContent(),
        ],
      ],
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
                      // تحديث سجل المخزون عند تغيير التاريخ
                      if (_selectedCleaningTabIndex == 2 && _selectedCleaningTiming == 'بعد التنظيف') {
                        _loadCleaningRecords();
                      }
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
        
        // تبويبات توقيت الإصلاح (قبل/بعد)
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
                child: _buildDamagesTimingTabButton(
                  title: 'قبل الإصلاح',
                  value: 'قبل الإصلاح',
                  icon: Icons.build,
                ),
              ),
              Expanded(
                child: _buildDamagesTimingTabButton(
                  title: 'بعد الإصلاح',
                  value: 'بعد الإصلاح',
                  icon: Icons.build,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        
        // زر عرض التلفيات
        Container(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _showDamagesMedia = !_showDamagesMedia;
              });
            },
            icon: Icon(
              _showDamagesMedia ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: ColorApp.textInverse,
              size: 20.sp,
            ),
            label: Text(
              _showDamagesMedia ? 'إخفاء التلفيات' : 'عرض التلفيات',
              style: TextStyle(
                color: ColorApp.textInverse,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorApp.primaryBlue,
              foregroundColor: ColorApp.textInverse,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 2,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        
        // تبويبات الصور والفيديوهات (تظهر فقط عند الضغط على الزر)
        if (_showDamagesMedia) ...[
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
              return AnimateBuilder(
                  columnCount: 2,
                  position: index,
                  child: _buildDamagesImageGridItem(image, index));
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
              return AnimateBuilder(
                  columnCount: 2,
                  position: index,
                  child: _buildDamagesVideoGridItem(video, index));
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

  Widget _buildDamagesTimingTabButton({
    required String title,
    required String value,
    required IconData icon,
  }) {
    final isSelected = _selectedDamagesTiming == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDamagesTiming = value;
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
              size: 14.sp,
            ),
            SizedBox(width: 4.w),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? ColorApp.textInverse : ColorApp.primaryBlue,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }
} 