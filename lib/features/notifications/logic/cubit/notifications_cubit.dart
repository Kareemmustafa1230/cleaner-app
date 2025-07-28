import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/notifications_repo.dart';
import '../state/notifications_state.dart';
import '../../data/model/notifications_response.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepo _notificationsRepo;

  NotificationsCubit(this._notificationsRepo) : super(const NotificationsState.initial());

  int _currentPage = 1;
  bool _hasMore = true;
  List<Notifications> _allNotifications = [];
  
  // آلية الحد من الطلبات المتكررة
  Timer? _throttleTimer;
  bool _isLoading = false;
  DateTime? _lastRequestTime;
  static const Duration _throttleDuration = Duration(seconds: 2);
  static const Duration _retryDelay = Duration(seconds: 5);
  int _retryCount = 0;
  static const int _maxRetries = 3;

  List<Notifications> get notifications => _allNotifications;
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;
  bool get isLoading => _isLoading;

  @override
  Future<void> close() {
    _throttleTimer?.cancel();
    return super.close();
  }

  Future<void> fetchFirstPage() async {
    if (_isLoading) return;
    
    // التحقق من الحد الزمني للطلبات
    if (_lastRequestTime != null && 
        DateTime.now().difference(_lastRequestTime!) < _throttleDuration) {
      print('⚠️ Request throttled. Waiting for cooldown...');
      return;
    }

    _isLoading = true;
    _lastRequestTime = DateTime.now();
    _retryCount = 0;
    
    emit(const NotificationsState.loading());
    _currentPage = 1;
    _hasMore = true;
    _allNotifications.clear();
    await _fetchPage(_currentPage, isFirst: true);
  }

  Future<void> fetchNextPage() async {
    if (!_hasMore || _isLoading) return;
    
    // التحقق من الحد الزمني للطلبات
    if (_lastRequestTime != null && 
        DateTime.now().difference(_lastRequestTime!) < _throttleDuration) {
      print('⚠️ Request throttled. Waiting for cooldown...');
      return;
    }

    _isLoading = true;
    _lastRequestTime = DateTime.now();
    _currentPage++;
    await _fetchPage(_currentPage);
  }

  Future<void> _fetchPage(int page, {bool isFirst = false}) async {
    try {
      final notificationsResponse = await _notificationsRepo.notifications(page.toString());
      
      await notificationsResponse.when(
        success: (response) async {
          _retryCount = 0; // إعادة تعيين عداد المحاولات عند النجاح
          final newNotifications = response.data?.notifications ?? [];
          if (isFirst) {
            _allNotifications = newNotifications;
          } else {
            _allNotifications.addAll(newNotifications);
          }
          _hasMore = response.data?.pagination?.hasMorePages ?? false;
          emit(NotificationsState.success(notificationsResponse: response));
        },
        failure: (error) {
          _handleError(error, page, isFirst);
        },
      );
    } catch (e) {
      _handleError(e, page, isFirst);
    } finally {
      _isLoading = false;
    }
  }

  void _handleError(dynamic error, int page, bool isFirst) {
    print('❌ Error fetching notifications: $error');
    
    // التحقق من نوع الخطأ
    String errorMessage = 'حدث خطأ أثناء تحميل الإشعارات';
    
    if (error.toString().contains('429') || error.toString().contains('Too Many Requests')) {
      errorMessage = 'تم تجاوز الحد المسموح للطلبات. يرجى الانتظار قليلاً';
      _scheduleRetry(page, isFirst);
    } else if (error.toString().contains('timeout') || error.toString().contains('connection')) {
      errorMessage = 'مشكلة في الاتصال بالخادم';
      _scheduleRetry(page, isFirst);
    } else {
      // خطأ آخر - لا نحاول إعادة المحاولة
      emit(NotificationsState.error(error: errorMessage));
    }
  }

  void _scheduleRetry(int page, bool isFirst) {
    if (_retryCount >= _maxRetries) {
      emit(const NotificationsState.error(error: 'فشل في تحميل الإشعارات بعد عدة محاولات'));
      return;
    }

    _retryCount++;
    print('🔄 Scheduling retry #$_retryCount in ${_retryDelay.inSeconds} seconds...');
    
    _throttleTimer?.cancel();
    _throttleTimer = Timer(_retryDelay, () {
      print('🔄 Retrying request (attempt $_retryCount)...');
      _fetchPage(page, isFirst: isFirst);
    });
  }

  // إلغاء الطلبات المعلقة
  void cancelPendingRequests() {
    _throttleTimer?.cancel();
    _isLoading = false;
  }

  // إعادة تعيين حالة التحميل
  void resetLoadingState() {
    _isLoading = false;
  }
}
