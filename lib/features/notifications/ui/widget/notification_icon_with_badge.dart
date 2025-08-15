import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/Color/colors.dart';
import '../../../../core/widget/text_app.dart';
import '../../logic/cubit/unread_count_cubit.dart';
import '../../logic/state/unread_count_state.dart';

class NotificationIconWithBadge extends StatefulWidget {
  final VoidCallback onPressed;

  const NotificationIconWithBadge({super.key, required this.onPressed});

  @override
  State<NotificationIconWithBadge> createState() => _NotificationIconWithBadgeState();
}

class _NotificationIconWithBadgeState extends State<NotificationIconWithBadge> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UnreadCountCubit>().startPolling();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ScreenUtil().screenWidth >= 600;

    return BlocBuilder<UnreadCountCubit, UnreadCountState>(
      builder: (context, state) {
        int notificationCount = 0;

        if (state is Success) {
          notificationCount = state.count;
        }

        return Stack(
          children: [
            IconButton(
              icon: Icon(Icons.notifications,
                color: ColorApp.white,
                size: isTablet ? 20.sp : 25.sp,
              ),
              onPressed: widget.onPressed,
            ),
            if (notificationCount > 0)
              Positioned(
                right: isTablet ? 3.w : 6.w,
                top: isTablet ? 3.h : 6.h,
                child: Container(
                  alignment: Alignment.center,
                  width: isTablet ? 8.w : 10.w,
                  height: isTablet ? 8.h : 10.h,
                  padding: EdgeInsets.all(isTablet ? 3.r : 5.r),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  constraints: BoxConstraints(
                    minWidth: isTablet ? 18.w : 22.w,
                    minHeight: isTablet ? 18.h : 22.h,
                  ),
                  child: Center(
                    child: TextApp(
                      text: notificationCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 8.sp : 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // لو فيه حاجة تحتاج إيقاف لاحقًا
    super.dispose();
  }
}
