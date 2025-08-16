import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/Color/colors.dart';
import '../../../../core/theme/text_style/text_style.dart';
import '../../../../core/language/app_localizations.dart';
import '../../../../core/helpers/extensions.dart';

class MediaViewerScreen extends StatefulWidget {
  final String apartmentId;
  final String apartmentName;
  final String mediaType;
  final String title;

  const MediaViewerScreen({
    super.key,
    required this.apartmentId,
    required this.apartmentName,
    required this.mediaType,
    required this.title,
  });

  @override
  State<MediaViewerScreen> createState() => _MediaViewerScreenState();
}

class _MediaViewerScreenState extends State<MediaViewerScreen> {
  final List<String> _images = [
    'assets/images/car_image.png',
    'assets/images/car_road.png',
    'assets/images/car.png',
  ];

  final List<String> _videos = [
    'assets/videos/sample1.mp4',
    'assets/videos/sample2.mp4',
  ];

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: ColorApp.whiteFF,
      appBar: AppBar(
        backgroundColor: ColorApp.whiteFF,
        elevation: 0,
        title: Text(
          widget.title,
          style: TextStyleApp.font20black00Weight700,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: ColorApp.blue8D,
            size: 24.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // قسم الصور
            Text(
              localizations?.translate('images') ?? 'الصور',
              style: TextStyleApp.font16black00Weight700,
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: 200.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 150.w,
                    margin: EdgeInsets.only(right: 12.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      image: DecorationImage(
                        image: AssetImage(_images[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10.r),
                        onTap: () {
                          _showImageDialog(_images[index]);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 32.h),
            
            // قسم الفيديوهات
            Text(
              localizations?.translate('videos') ?? 'الفيديوهات',
              style: TextStyleApp.font16black00Weight700,
            ),
            SizedBox(height: 16.h),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _videos.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 16.h),
                  height: 200.h,
                  decoration: BoxDecoration(
                    color: ColorApp.whiteF3,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Image.asset(
                          'assets/images/car_image.png',
                          width: double.infinity,
                          height: 200.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 60.w,
                          height: 60.h,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            color: ColorApp.whiteFF,
                            size: 30.sp,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16.h,
                        left: 16.w,
                        child: Text(
                          'فيديو ${index + 1}',
                          style: TextStyleApp.font16whiteFFWeight700,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showImageDialog(String imagePath) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 400.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 16.h,
              right: 16.w,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: ColorApp.whiteFF,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 