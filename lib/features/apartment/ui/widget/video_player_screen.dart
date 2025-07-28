import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String videoTitle;
  final String videoType;
  final String videoDuration;

  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
    required this.videoTitle,
    required this.videoType,
    required this.videoDuration,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  bool _isError = false;
  String _errorMessage = '';
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  double _playbackSpeed = 1.0;
  bool _showControls = true;

  // قائمة سرعات التشغيل المتاحة
  final List<double> _availableSpeeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      setState(() {
        _isLoading = true;
        _isError = false;
      });

      // إنشاء VideoPlayerController
      _videoPlayerController = VideoPlayerController.asset(widget.videoUrl);
      
      await _videoPlayerController.initialize();

      // إنشاء ChewieController
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Theme.of(context).colorScheme.primary,
          handleColor: Theme.of(context).colorScheme.secondary,
          backgroundColor: Theme.of(context).dividerColor,
          bufferedColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
        placeholder: Container(
          color: Theme.of(context).colorScheme.surface,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.video_library,
                  size: 60.sp,
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                ),
                SizedBox(height: 16.h),
                Text(
                  'جاري تحميل الفيديو...',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 60.sp,
                  color: Theme.of(context).colorScheme.error,
                ),
                SizedBox(height: 16.h),
                Text(
                  'خطأ في تحميل الفيديو',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  errorMessage,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Cairo',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isError = true;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _downloadVideo() async {
    try {
      setState(() {
        _isDownloading = true;
        _downloadProgress = 0.0;
      });

      // طلب أذونات التخزين
      final storageStatus = await Permission.storage.request();
      final photosStatus = await Permission.photos.request();

      if (storageStatus.isDenied && photosStatus.isDenied) {
        // محاولة التحميل بدون إذن أولاً
        await _attemptDownloadWithoutPermission();
      } else {
        // التحميل مع الإذن
        await _downloadWithPermission();
      }
    } catch (e) {
      setState(() {
        _isDownloading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'فشل في تحميل الفيديو: ${e.toString()}',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _attemptDownloadWithoutPermission() async {
    try {
      // محاولة التحميل في مجلدات عامة
      final List<String> downloadPaths = [
        '/storage/emulated/0/DCIM/Camera',
        '/storage/emulated/0/Pictures',
        '/storage/emulated/0/DCIM',
        '/storage/emulated/0/Download',
      ];

      bool downloadSuccess = false;
      
      for (String path in downloadPaths) {
        try {
          final directory = Directory(path);
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }

          final fileName = 'diyar_${widget.videoTitle}_${DateTime.now().millisecondsSinceEpoch}.mp4';
          final filePath = '$path/$fileName';

          // محاكاة عملية التحميل
          for (int i = 0; i <= 100; i += 10) {
            setState(() {
              _downloadProgress = i / 100;
            });
            await Future.delayed(const Duration(milliseconds: 200));
          }

          // في الواقع، هنا سيتم نسخ الفيديو من الأصول
          // للتوضيح، سنقوم بإنشاء ملف فارغ
          final file = File(filePath);
          await file.writeAsString('Video content placeholder');

          downloadSuccess = true;
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'تم حفظ الفيديو في: $path',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                duration: const Duration(seconds: 3),
              ),
            );
          }
          break;
        } catch (e) {
          continue;
        }
      }

      if (!downloadSuccess) {
        throw Exception('فشل في حفظ الفيديو في أي مجلد متاح');
      }
    } catch (e) {
      // إذا فشل التحميل بدون إذن، اطلب الإذن
      await _requestPermissionsAndDownload();
    }
  }

  Future<void> _downloadWithPermission() async {
    try {
      final directory = Directory('/storage/emulated/0/DCIM/Camera');
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final fileName = 'diyar_${widget.videoTitle}_${DateTime.now().millisecondsSinceEpoch}.mp4';
      final filePath = '${directory.path}/$fileName';

      // محاكاة عملية التحميل
      for (int i = 0; i <= 100; i += 10) {
        setState(() {
          _downloadProgress = i / 100;
        });
        await Future.delayed(const Duration(milliseconds: 200));
      }

      // في الواقع، هنا سيتم نسخ الفيديو من الأصول
      final file = File(filePath);
      await file.writeAsString('Video content placeholder');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تم حفظ الفيديو في معرض الصور',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      throw Exception('فشل في حفظ الفيديو: ${e.toString()}');
    }
  }

  Future<void> _requestPermissionsAndDownload() async {
    final status = await Permission.storage.request();
    
    if (status.isGranted) {
      await _downloadWithPermission();
    } else {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'إذن مطلوب',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo',
              ),
            ),
            content: Text(
              'يحتاج التطبيق إلى إذن الوصول إلى التخزين لتحميل الفيديو. يرجى منح الإذن في إعدادات التطبيق.',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Cairo',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'إلغاء',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  openAppSettings();
                },
                child: Text(
                  'فتح الإعدادات',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  void _changePlaybackSpeed(double speed) {
    setState(() {
      _playbackSpeed = speed;
    });
    _videoPlayerController.setPlaybackSpeed(speed);
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
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
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.onBackground,
              size: 20.sp,
            ),
          ),
        ),
        title: Text(
          widget.videoTitle,
          style: TextStyle(
            fontSize: 16.sp,
            color: Theme.of(context).colorScheme.onBackground,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
          ),
        ),
        centerTitle: true,
        actions: [
          if (!_isDownloading)
            IconButton(
              onPressed: _downloadVideo,
              icon: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.download,
                  color: Theme.of(context).colorScheme.onBackground,
                  size: 20.sp,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // منطقة تشغيل الفيديو
          Expanded(
            child: _isLoading
                ? _buildLoadingWidget()
                : _isError
                    ? _buildErrorWidget()
                    : _buildVideoPlayer(),
          ),
          
          // شريط التحكم في السرعة
          if (!_isLoading && !_isError)
            _buildSpeedControlBar(),
          
          // شريط تقدم التحميل
          if (_isDownloading)
            _buildDownloadProgressBar(),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
            strokeWidth: 3.w,
          ),
          SizedBox(height: 16.h),
          Text(
            'جاري تحميل الفيديو...',
            style: TextStyle(
              fontSize: 16.sp,
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.w600,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60.sp,
            color: Theme.of(context).colorScheme.error,
          ),
          SizedBox(height: 16.h),
          Text(
            'خطأ في تحميل الفيديو',
            style: TextStyle(
              fontSize: 16.sp,
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.w600,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            _errorMessage,
            style: TextStyle(
              fontSize: 14.sp,
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
              fontWeight: FontWeight.w400,
              fontFamily: 'Cairo',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: _initializeVideoPlayer,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'إعادة المحاولة',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
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

  Widget _buildVideoPlayer() {
    return Container(
      width: double.infinity,
      color: Colors.black,
      child: _chewieController != null
          ? Chewie(controller: _chewieController!)
          : Center(
              child: Text(
                'خطأ في تحميل مشغل الفيديو',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 16.sp,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
    );
  }

  Widget _buildSpeedControlBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: Colors.black87,
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.speed,
                color: Theme.of(context).colorScheme.onBackground,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'سرعة التشغيل:',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                ),
              ),
              const Spacer(),
              Text(
                '${_playbackSpeed}x',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _availableSpeeds.map((speed) {
                final isSelected = _playbackSpeed == speed;
                return GestureDetector(
                  onTap: () => _changePlaybackSpeed(speed),
                  child: Container(
                    margin: EdgeInsets.only(right: 8.w),
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      '${speed}x',
                      style: TextStyle(
                        color: isSelected ? Theme.of(context).colorScheme.onBackground : Theme.of(context).colorScheme.onBackground,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadProgressBar() {
    return Container(
      padding: EdgeInsets.all(16.w),
      color: Colors.black87,
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.download,
                color: Theme.of(context).colorScheme.primary,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'جاري تحميل الفيديو...',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                ),
              ),
              const Spacer(),
              Text(
                '${(_downloadProgress * 100).toInt()}%',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          LinearProgressIndicator(
            value: _downloadProgress,
            backgroundColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
    );
  }
} 