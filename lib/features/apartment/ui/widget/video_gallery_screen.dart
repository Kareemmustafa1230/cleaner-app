import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../../../core/theme/Color/colors.dart';

class VideoGalleryScreen extends StatefulWidget {
  final List<Map<String, dynamic>> videos;
  final int initialIndex;

  const VideoGalleryScreen({
    super.key,
    required this.videos,
    required this.initialIndex,
  });

  @override
  State<VideoGalleryScreen> createState() => _VideoGalleryScreenState();
}

class _VideoGalleryScreenState extends State<VideoGalleryScreen> {
  late PageController _pageController;
  late int _currentIndex;
  Map<int, VideoPlayerController> _videoControllers = {};
  Map<int, ChewieController> _chewieControllers = {};

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _initializeVideoControllers();
  }

  void _initializeVideoControllers() {
    for (int i = 0; i < widget.videos.length; i++) {
      _videoControllers[i] = VideoPlayerController.asset(widget.videos[i]['url']);
      _chewieControllers[i] = ChewieController(
        videoPlayerController: _videoControllers[i]!,
        autoPlay: i == widget.initialIndex,
        looping: false,
        aspectRatio: 16 / 9,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        placeholder: Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.video_library,
                  color: Colors.white,
                  size: 60.sp,
                ),
                SizedBox(height: 16.h),
                Text(
                  'جاري تحميل الفيديو...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
        ),
        materialProgressColors: ChewieProgressColors(
          playedColor: ColorApp.primaryBlue,
          handleColor: ColorApp.primaryBlue,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.grey.withValues(alpha: 0.5),
        ),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    for (var controller in _chewieControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    
    // إيقاف جميع الفيديوهات
    for (var controller in _videoControllers.values) {
      controller.pause();
    }
    
    // تشغيل الفيديو الحالي
    if (_videoControllers[index] != null) {
      _videoControllers[index]!.play();
    }
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
          '${_currentIndex + 1} من ${widget.videos.length}',
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
              // يمكن إضافة إجراء هنا مثل مشاركة الفيديو
            },
            icon: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.share,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // معرض الفيديوهات
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: widget.videos.length,
            itemBuilder: (context, index) {
              final video = widget.videos[index];
              return Center(
                child: Hero(
                  tag: 'gallery_video_${video['id']}',
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: _chewieControllers[index] != null
                        ? Chewie(controller: _chewieControllers[index]!)
                        : Container(
                            color: Colors.black,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: ColorApp.primaryBlue,
                              ),
                            ),
                          ),
                  ),
                ),
              );
            },
          ),
          
          // معلومات الفيديو في الأسفل
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
                  // عنوان الفيديو
                  Text(
                    widget.videos[_currentIndex]['title'],
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  SizedBox(height: 8.h),
                  
                  // نوع الفيديو والتاريخ والمدة
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
                          widget.videos[_currentIndex]['type'],
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
                        widget.videos[_currentIndex]['date'],
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white70,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Icon(
                        Icons.timer,
                        color: Colors.white70,
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        widget.videos[_currentIndex]['duration'],
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white70,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // مؤشر الفيديوهات
          Positioned(
            bottom: 120.h,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.videos.length,
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