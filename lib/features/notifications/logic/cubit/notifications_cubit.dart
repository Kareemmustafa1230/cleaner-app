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

  List<Notifications> get notifications => _allNotifications;
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;

  Future<void> fetchFirstPage() async {
    emit(const NotificationsState.loading());
    _currentPage = 1;
    _hasMore = true;
    _allNotifications.clear();
    await _fetchPage(_currentPage, isFirst: true);
  }

  Future<void> fetchNextPage() async {
    if (!_hasMore) return;
    _currentPage++;
    await _fetchPage(_currentPage);
  }

  Future<void> _fetchPage(int page, {bool isFirst = false}) async {
    final notificationsResponse = await _notificationsRepo.notifications(page.toString());
    await notificationsResponse.when(
      success: (response) async {
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
        emit(NotificationsState.error(error: error.apiErrorModel.message));
      },
    );
  }
}
