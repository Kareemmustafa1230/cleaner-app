import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/theme/Color/colors.dart';

// class لمراقبة دورة حياة التطبيق
class LifecycleEventHandler extends WidgetsBindingObserver {
  final Future<void> Function()? detachedCallBack;
  final Future<void> Function()? inactiveCallBack;
  final Future<void> Function()? pausedCallBack;
  final Future<void> Function()? resumedCallBack;

  LifecycleEventHandler({
    this.detachedCallBack,
    this.inactiveCallBack,
    this.pausedCallBack,
    this.resumedCallBack,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.detached:
        if (detachedCallBack != null) await detachedCallBack!();
        break;
      case AppLifecycleState.inactive:
        if (inactiveCallBack != null) await inactiveCallBack!();
        break;
      case AppLifecycleState.paused:
        if (pausedCallBack != null) await pausedCallBack!();
        break;
      case AppLifecycleState.resumed:
        if (resumedCallBack != null) await resumedCallBack!();
        break;
      default:
        break;
    }
  }
}

class ImageGalleryScreen extends StatefulWidget {
  final List<Map<String, dynamic>> images;
  final int initialIndex;

  const ImageGalleryScreen({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<ImageGalleryScreen> createState() => _ImageGalleryScreenState();
}

class _ImageGalleryScreenState extends State<ImageGalleryScreen> {
  late PageController _pageController;
  late int _currentIndex;
  final Map<int, TransformationController> _transformationControllers = {};
  final Map<int, double> _currentScales = {};
  LifecycleEventHandler? _lifecycleEventHandler;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    
    // تهيئة controllers للصور
    for (int i = 0; i < widget.images.length; i++) {
      _transformationControllers[i] = TransformationController();
      _currentScales[i] = 1.0;
    }
    
    // مراقبة حالة التطبيق عند العودة من الإعدادات
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPermissionOnResume();
    });
  }

  // مراقبة حالة الإذن عند العودة للتطبيق
  void _checkPermissionOnResume() {
    _lifecycleEventHandler = LifecycleEventHandler(
      detachedCallBack: () async {},
      inactiveCallBack: () async {},
      pausedCallBack: () async {},
      resumedCallBack: () async {
        // عند العودة للتطبيق، نتحقق من الإذن
        await _tryDownloadAfterPermission();
      },
    );
    WidgetsBinding.instance.addObserver(_lifecycleEventHandler!);
  }

  // محاولة التحميل بعد الحصول على الإذن
  Future<void> _tryDownloadAfterPermission() async {
    try {
      // التحقق من الإذن
      var storageStatus = await Permission.storage.status;
      var photosStatus = await Permission.photos.status;
      
      // إذا تم منح الإذن، نحاول التحميل
      if (storageStatus.isGranted || photosStatus.isGranted) {
        // تأخير قصير للتأكد من أن التطبيق مستقر
        await Future.delayed(Duration(milliseconds: 500));
        if (mounted) {
          _downloadImage();
        }
      }
    } catch (e) {
      print('خطأ في التحقق من الإذن: $e');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _transformationControllers.values) {
      controller.dispose();
    }
    if (_lifecycleEventHandler != null) {
      WidgetsBinding.instance.removeObserver(_lifecycleEventHandler!);
    }
    super.dispose();
  }

  // إعادة تعيين التكبير للصورة الحالية
  void _resetZoom() {
    if (_transformationControllers[_currentIndex] != null) {
      _transformationControllers[_currentIndex]!.value = Matrix4.identity();
      _currentScales[_currentIndex] = 1.0;
      setState(() {});
    }
  }

  // تكبير الصورة
  void _zoomIn() {
    if (_transformationControllers[_currentIndex] != null) {
      final currentScale = _currentScales[_currentIndex] ?? 1.0;
      final newScale = (currentScale + 0.5).clamp(1.0, 4.0);
      _currentScales[_currentIndex] = newScale;
      
      _transformationControllers[_currentIndex]!.value = Matrix4.identity()
        ..scale(newScale);
      setState(() {});
    }
  }

  // تصغير الصورة
  void _zoomOut() {
    if (_transformationControllers[_currentIndex] != null) {
      final currentScale = _currentScales[_currentIndex] ?? 1.0;
      final newScale = (currentScale - 0.5).clamp(0.5, 4.0);
      _currentScales[_currentIndex] = newScale;
      
      _transformationControllers[_currentIndex]!.value = Matrix4.identity()
        ..scale(newScale);
      setState(() {});
    }
  }

  // الحصول على النسبة المئوية للتكبير
  String _getZoomPercentage() {
    final scale = _currentScales[_currentIndex] ?? 1.0;
    return '${(scale * 100).toInt()}%';
  }

  // طلب إذن الوصول للتخزين
  Future<bool> _requestStoragePermission() async {
    try {
      print('بدء طلب الإذن...');
      
      // التحقق من الأذونات الممنوحة مسبقاً
      print('التحقق من الأذونات الممنوحة مسبقاً...');
      var storageCheck = await Permission.storage.status;
      var photosCheck = await Permission.photos.status;
      
      print('حالة إذن التخزين الحالية: $storageCheck');
      print('حالة إذن معرض الصور الحالية: $photosCheck');
      
      // إذا كان لدينا أي إذن ممنوح، نعود true
      if (storageCheck.isGranted || photosCheck.isGranted) {
        print('تم العثور على إذن ممنوح مسبقاً');
        return true;
      }
      
      // طلب الأذونات بالترتيب
      print('طلب إذن التخزين...');
      var storageStatus = await Permission.storage.request();
      print('حالة إذن التخزين: $storageStatus');
      
      if (storageStatus.isGranted) {
        print('تم منح إذن التخزين');
        return true;
      }
      
      print('طلب إذن معرض الصور...');
      var photosStatus = await Permission.photos.request();
      print('حالة إذن معرض الصور: $photosStatus');
      
      if (photosStatus.isGranted) {
        print('تم منح إذن معرض الصور');
        return true;
      }
      
      // التحقق النهائي من الأذونات
      print('التحقق النهائي من الأذونات...');
      var finalStorageCheck = await Permission.storage.status;
      var finalPhotosCheck = await Permission.photos.status;
      
      print('الحالة النهائية - التخزين: $finalStorageCheck');
      print('الحالة النهائية - معرض الصور: $finalPhotosCheck');
      
      bool hasAnyPermission = finalStorageCheck.isGranted || finalPhotosCheck.isGranted;
      
      if (hasAnyPermission) {
        print('تم العثور على إذن ممنوح في التحقق النهائي');
        return true;
      }
      
      print('لم يتم منح أي إذن');
      return false;
    } catch (e) {
      print('خطأ في طلب الإذن: $e');
      return false;
    }
  }

  // تحميل الصورة إلى معرض الهاتف
  Future<void> _downloadImage() async {
    try {
      // إظهار مؤشر التحميل
      _showLoadingDialog();

      // الحصول على الصورة الحالية
      final currentImage = widget.images[_currentIndex];
      
      // طلب الإذن أولاً
      bool hasPermission = await _requestStoragePermission();
      
      if (hasPermission) {
        try {
          // للصور المحلية، نحتاج لتحميلها من الأصول
          final ByteData data = await rootBundle.load(currentImage['url']);
          final Uint8List bytes = data.buffer.asUint8List();

          // محاولة حفظ الصورة في معرض الصور أولاً
          try {
            // محاولة الوصول لمجلد DCIM مباشرة
            final Directory? externalDir = await getExternalStorageDirectory();
            if (externalDir != null) {
              // الحصول على المسار الأساسي للتخزين الخارجي
              String basePath = externalDir.path;
              // إزالة مجلد التطبيق من المسار للحصول على المسار الأساسي
              basePath = basePath.replaceAll('/Android/data/com.example.diyar/files', '');
              
              // محاولة عدة مجلدات شائعة لمعرض الصور
              List<String> possiblePaths = [
                '$basePath/DCIM/Camera',
                '$basePath/Pictures',
                '$basePath/DCIM',
                '$basePath/Download',
              ];
              
              Directory? targetDir;
              for (String path in possiblePaths) {
                                 try {
                   final dir = Directory(path);
                   if (await dir.exists()) {
                     targetDir = dir;
                     break;
                   } else {
                     await dir.create(recursive: true);
                     targetDir = dir;
                     break;
                   }
                 } catch (e) {
                  print('فشل في الوصول للمجلد: $path - $e');
                  continue;
                }
              }
              
              if (targetDir != null) {
                final String fileName = 'diyar_${currentImage['title']}_${DateTime.now().millisecondsSinceEpoch}.jpg';
                final String filePath = '${targetDir.path}/$fileName';
                final File file = File(filePath);
                await file.writeAsBytes(bytes);

                // إخفاء مؤشر التحميل
                if (mounted) {
                  Navigator.pop(context);
                }

                // التحقق من نجاح التحميل
                if (mounted) {
                  _showSnackBar('تم حفظ الصورة في معرض الصور');
                }
                print('تم حفظ الصورة في: $filePath');
                return;
              }
            }
          } catch (e) {
            print('فشل في حفظ الصورة في معرض الصور: $e');
          }

          // إذا فشل حفظ الصورة في معرض الصور، احفظها في مجلد التطبيق
          final Directory appDocDir = await getApplicationDocumentsDirectory();
          final String filePath = '${appDocDir.path}/${currentImage['title']}_${DateTime.now().millisecondsSinceEpoch}.jpg';
          final File file = File(filePath);
          await file.writeAsBytes(bytes);

          // إخفاء مؤشر التحميل
          if (mounted) {
            Navigator.pop(context);
          }

          // التحقق من نجاح التحميل
          if (mounted) {
            _showSnackBar('تم حفظ الصورة في مجلد التطبيق');
          }
        } catch (e) {
          // إخفاء مؤشر التحميل
          if (mounted) {
            Navigator.pop(context);
            _showSnackBar('حدث خطأ أثناء تحميل الصورة: $e');
          }
        }
      } else {
        // إذا لم نحصل على الإذن، نعرض رسالة توضيحية
        if (mounted) {
          Navigator.pop(context); // إخفاء مؤشر التحميل
          _showPermissionDialog();
        }
      }
    } catch (e) {
      // إخفاء مؤشر التحميل
      if (mounted) {
        Navigator.pop(context);
        _showSnackBar('حدث خطأ أثناء تحميل الصورة: $e');
      }
    }
  }

  // إظهار رسالة تأكيد التحميل
  void _showDownloadDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ColorApp.backgroundPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'تحميل الصورة',
          style: TextStyle(
            fontSize: 18.sp,
            color: ColorApp.textPrimary,
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
          ),
        ),
        content: Text(
          'هل تريد حفظ هذه الصورة في معرض الصور؟',
          style: TextStyle(
            fontSize: 14.sp,
            color: ColorApp.textSecondary,
            fontWeight: FontWeight.w500,
            fontFamily: 'Cairo',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(
                color: ColorApp.textSecondary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _downloadImage();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorApp.primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'تحميل',
              style: TextStyle(
                color: ColorApp.textInverse,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // إظهار مؤشر التحميل
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: ColorApp.backgroundPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: ColorApp.primaryBlue,
            ),
            SizedBox(height: 16.h),
            Text(
              'جاري تحميل الصورة...',
              style: TextStyle(
                fontSize: 14.sp,
                color: ColorApp.textPrimary,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // إظهار رسالة
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              message.contains('معرض الصور') ? Icons.check_circle : Icons.info,
              color: ColorApp.textInverse,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: ColorApp.textInverse,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ],
        ),
                backgroundColor: message.contains('معرض الصور') ? ColorApp.success : ColorApp.primaryBlue,
        duration: Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }

  // إظهار نافذة طلب الأذونات
  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ColorApp.backgroundPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning,
              color: Colors.orange,
              size: 24.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'إذن مطلوب',
              style: TextStyle(
                fontSize: 18.sp,
                color: ColorApp.textPrimary,
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'يحتاج التطبيق إلى إذن الوصول لمعرض الصور لتحميل الصور.',
              style: TextStyle(
                fontSize: 14.sp,
                color: ColorApp.textSecondary,
                fontWeight: FontWeight.w500,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'الأذونات المطلوبة:',
              style: TextStyle(
                fontSize: 14.sp,
                color: ColorApp.textPrimary,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              '• معرض الصور (Photos)\n• التخزين (Storage)\n• إدارة التخزين (Manage Storage)\n• الكاميرا (Camera)\n• الميكروفون (Microphone)',
              style: TextStyle(
                fontSize: 12.sp,
                color: ColorApp.textSecondary,
                fontWeight: FontWeight.w400,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'الخطوات:',
              style: TextStyle(
                fontSize: 14.sp,
                color: ColorApp.textPrimary,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              '1. اذهب إلى إعدادات الهاتف\n2. اختر "التطبيقات"\n3. ابحث عن "Diyar"\n4. اختر "الأذونات"\n5. فعّل الأذونات المطلوبة\n6. عد للتطبيق وسيتم التحميل تلقائياً',
              style: TextStyle(
                fontSize: 12.sp,
                color: ColorApp.textSecondary,
                fontWeight: FontWeight.w400,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(
                color: ColorApp.textSecondary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
              
              // بعد العودة من الإعدادات، نحاول التحميل مرة أخرى
              await Future.delayed(Duration(seconds: 1));
              if (mounted) {
                _downloadImage();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorApp.primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'فتح الإعدادات',
              style: TextStyle(
                color: ColorApp.textInverse,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.close,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
        ),
        title: Text(
          '${_currentIndex + 1} من ${widget.images.length}',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _showDownloadDialog();
            },
            icon: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.download,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // معرض الصور
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              final image = widget.images[index];
              return InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                transformationController: _transformationControllers[index],
                onInteractionEnd: (details) {
                  // تحديث المقياس الحالي
                  final matrix = _transformationControllers[index]!.value;
                  final scale = matrix.getMaxScaleOnAxis();
                  _currentScales[index] = scale;
                },
                child: Center(
                  child: Hero(
                    tag: 'gallery_image_${image['id']}',
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(image['url']),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          
          // أزرار التحكم في التكبير
          Positioned(
            top: 100.h,
            right: 16.w,
            child: Column(
              children: [
                // زر التكبير
                GestureDetector(
                  onTap: _zoomIn,
                  child: Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.zoom_in,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                
                // مؤشر التكبير
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _getZoomPercentage(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                
                // زر التصغير
                GestureDetector(
                  onTap: _zoomOut,
                  child: Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.zoom_out,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                
                // زر إعادة تعيين التكبير
                GestureDetector(
                  onTap: _resetZoom,
                  child: Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // معلومات الصورة في الأسفل
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                    Colors.black.withValues(alpha: 0.9),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // عنوان الصورة
                  Text(
                    widget.images[_currentIndex]['title'],
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  SizedBox(height: 8.h),
                  
                  // نوع الصورة والتاريخ
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [ColorApp.gradientStart, ColorApp.gradientEnd],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          widget.images[_currentIndex]['type'],
                          style: TextStyle(
                            color: ColorApp.textInverse,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Icon(
                        Icons.calendar_today,
                        color: Colors.white70,
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        widget.images[_currentIndex]['date'],
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white70,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  
                  // زر التحميل
                  GestureDetector(
                    onTap: () {
                      _showDownloadDialog();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [ColorApp.gradientStart, ColorApp.gradientEnd],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.download,
                            color: ColorApp.textInverse,
                            size: 18.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'تحميل الصورة',
                            style: TextStyle(
                              fontSize: 14.sp,
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
          ),
          
          // مؤشر الصور
          Positioned(
            bottom: 200.h,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.images.length,
                  (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    width: 8.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index 
                          ? ColorApp.primaryBlue 
                          : Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 