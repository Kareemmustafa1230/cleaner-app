import 'package:diyar/core/helpers/extensions.dart';
import 'package:diyar/features/notifications/logic/cubit/mark_read_cubit.dart';
import 'package:diyar/features/notifications/logic/cubit/notifications_cubit.dart';
import 'package:diyar/features/notifications/logic/state/mark_read_state.dart';
import 'package:diyar/features/notifications/logic/state/notifications_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/language/lang_keys.dart';
import '../../../../core/notification_services/notification_services.dart';
import '../../../../core/theme/Color/colors.dart';
import '../../data/model/notifications_response.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> with TickerProviderStateMixin {
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    context.read<NotificationsCubit>().fetchFirstPage();
    _scrollController.addListener(_onScroll);
  }

  // Future<void> _cancelNotificationsIfUnread() async {
  //   final cubit = context.read<NotificationsCubit>();
  //   final unreadCount = cubit.state.maybeWhen(
  //     success: (notificationsResponse) => notificationsResponse.data?.unreadCount ?? 0,
  //     orElse: () => 0,
  //   );
  //   print("objects$unreadCount");
  //   if (unreadCount > 0) {
  //     await NotificationService.cancelAllNotifications();
  //   }
  // }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      final cubit = context.read<NotificationsCubit>();
      if (cubit.hasMore) {
        cubit.fetchNextPage();
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.backgroundSecondary,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: MultiBlocListener(
            listeners: [
              BlocListener<NotificationsCubit, NotificationsState>(
                listener: (context, state) async {
                  state.maybeWhen(
                    success: (notificationsResponse) async {
                      final unreadCount = notificationsResponse.data?.unreadCount ?? 0;
                      print("objects$unreadCount");
                      if (unreadCount > 0) {
                        await NotificationService.cancelAllNotifications();
                      }
                      context.read<MarkReadCubit>().markRead();
                    },
                    error: (error) => _showErrorSnackBar(error),
                    orElse: () {},
                  );
                },
              ),
              BlocListener<MarkReadCubit, MarkReadState>(
                listener: (context, state) {
                  state.whenOrNull(
                    success: (message) {
                      // يمكن إضافة رسالة نجاح هنا إذا كان مطلوباً
                      // _showSuccessSnackBar(message);
                    },
                    error: (error) {
                      // يمكن إضافة رسالة خطأ هنا إذا كان مطلوباً
                      // _showErrorSnackBar(error);
                    },
                  );
                },
              ),
            ],
            child: BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                return Column(
                  children: [
                    Expanded(
                      child: state.when(
                        initial: () => const SizedBox(),
                        loading: () => _buildLoadingState(),
                        success: (notificationsResponse) => _buildSuccessState(notificationsResponse),
                        error: (error) => _buildErrorState(error),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: ColorApp.backgroundPrimary,
      elevation: 0,
      centerTitle: true,
      title: Text(
        context.translate(LangKeys.notifications),
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w700,
          color: ColorApp.textPrimary,
          letterSpacing: 0.5,
        ),
      ),
      leading: Container(
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: ColorApp.backgroundSecondary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: ColorApp.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: ColorApp.textPrimary,
            size: 20.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: ColorApp.textInverse, size: 20.sp),
            SizedBox(width: 12.w),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: ColorApp.error,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: ColorApp.backgroundPrimary,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: ColorApp.shadowMedium,
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Lottie.network("https://lottie.host/99702018-791a-4a2f-a9b8-6a49d7ba5e9f/J3j7v3AlMy.json",
                height: 100.h,
                animate: true,
                ),
                SizedBox(height: 16.h),
                Text(
                  context.translate(LangKeys.loadingNotifications),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorApp.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState(NotificationsResponse? notificationsResponse) {
    final cubit = context.read<NotificationsCubit>();
    final notifications = cubit.notifications;
    if (notifications.isEmpty) {
      return _buildEmptyState();
    }
    return RefreshIndicator(
      onRefresh: () async {
        context.read<NotificationsCubit>().fetchFirstPage();
      },
      color: ColorApp.success,
      backgroundColor: ColorApp.backgroundPrimary,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(16.w),
        itemCount: notifications.length + (cubit.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == notifications.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Center(
                child: CircularProgressIndicator(
                  color: ColorApp.success,
                  strokeWidth: 2,
                ),
              ),
            );
          }
          final notification = notifications[index];
          return _buildNotificationItem(notification, index);
        },
      ),
    );
  }

  Widget _buildNotificationItem(dynamic notification, int index) {
    final isUnread = notification.isRead == false;
    final notificationType = _getNotificationType(notification.type);

    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 50)),
      margin: EdgeInsets.only(bottom: 12.h),
      child: GestureDetector(
        onTap: () {
        },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: ColorApp.backgroundPrimary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnread ? ColorApp.success.withOpacity(0.2) : ColorApp.borderLight,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorApp.shadowLight,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: notificationType.gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: notificationType.gradientColors.first.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                notificationType.icon,
                color: ColorApp.textInverse,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title ?? context.translate(LangKeys.newNotification),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: ColorApp.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isUnread)
                        _AnimatedPulseDot(),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    notification.message ?? context.translate(LangKeys.noContent),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: ColorApp.textSecondary,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12.sp,
                        color: ColorApp.textLight,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          _formatDate(notification.createdAt),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: ColorApp.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
    );
  }

  NotificationType _getNotificationType(String? type) {
    switch (type?.toLowerCase()) {
      case 'order':
        return NotificationType(
          icon: Icons.shopping_bag,
          gradientColors: [ColorApp.primaryBlue, ColorApp.secondaryBlue],
        );
      case 'payment':
        return NotificationType(
          icon: Icons.payment,
          gradientColors: [ColorApp.success, ColorApp.success.withOpacity(0.8)],
        );
      case 'delivery':
        return NotificationType(
          icon: Icons.local_shipping,
          gradientColors: [ColorApp.warning, ColorApp.warning.withOpacity(0.8)],
        );
      case 'promotion':
        return NotificationType(
          icon: Icons.local_offer,
          gradientColors: [ColorApp.error, ColorApp.error.withOpacity(0.8)],
        );
      case 'maintenance':
        return NotificationType(
          icon: Icons.build,
          gradientColors: [ColorApp.info, ColorApp.info.withOpacity(0.8)],
        );
      case 'cleaning':
        return NotificationType(
          icon: Icons.cleaning_services,
          gradientColors: [ColorApp.success, ColorApp.success.withOpacity(0.8)],
        );
      default:
        return NotificationType(
          icon: Icons.notifications,
          gradientColors: [ColorApp.primaryBlue, ColorApp.secondaryBlue],
        );
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
                  SizedBox(height: 32.h),
                  Lottie.network("https://lottie.host/77c21897-846e-44d1-b964-ec1421f25179/2YNSoxySD7.json",
                  width: 250.w,
                    height: 250.h,
                  ),
                 SizedBox(height: 24.h),
                 Text(
                   context.translate(LangKeys.noNotifications),
                   style: TextStyle(
                     fontSize: 16.sp,
                     fontWeight: FontWeight.w600,
                     color: ColorApp.textPrimary,
                   ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(32.w),
              decoration: BoxDecoration(
                color: ColorApp.backgroundPrimary,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: ColorApp.shadowMedium,
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      color: ColorApp.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(
                      Icons.error_outline,
                      size: 40.sp,
                      color: ColorApp.error,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    context.translate(LangKeys.errorOccurred),
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorApp.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    error,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: ColorApp.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32.h),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [ColorApp.success, ColorApp.success.withOpacity(0.8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: ColorApp.success.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<NotificationsCubit>().fetchFirstPage();
                      },
                      icon: Icon(Icons.refresh, color: ColorApp.textInverse, size: 18.sp),
                      label: Text(
                        context.translate(LangKeys.retry),
                        style: TextStyle(
                          color: ColorApp.textInverse,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
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

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      // تنسيق التاريخ الفعلي
      final dateFormat = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      final timeFormat = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

      // الوقت النسبي
      String relativeTime;
      if (difference.inDays > 0) {
        relativeTime = context.translate(LangKeys.agoDays).replaceAll('{days}', difference.inDays.toString());
      } else if (difference.inHours > 0) {
        relativeTime = context.translate(LangKeys.agoHours).replaceAll('{hours}', difference.inHours.toString());
      } else if (difference.inMinutes > 0) {
        relativeTime = context.translate(LangKeys.agoMinutes).replaceAll('{minutes}', difference.inMinutes.toString());
      } else {
        relativeTime = context.translate(LangKeys.now);
      }

      // إرجاع التاريخ الفعلي مع الوقت النسبي
      return '$dateFormat - $timeFormat ($relativeTime)';
    } catch (e) {
      return dateString;
    }
  }
}

class NotificationType {
  final IconData icon;
  final List<Color> gradientColors;

  NotificationType({
    required this.icon,
    required this.gradientColors,
  });
}

class _AnimatedPulseDot extends StatefulWidget {
  @override
  State<_AnimatedPulseDot> createState() => _AnimatedPulseDotState();
}

class _AnimatedPulseDotState extends State<_AnimatedPulseDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _opacityAnimation = Tween<double>(begin: 0.5, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      height: 22,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _opacityAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: ColorApp.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            },
          ),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: ColorApp.success,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: ColorApp.success.withOpacity(0.4),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
