// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../data/repo/unread_count_repo.dart';
// import '../state/unread_count_state.dart';
//
// class UnreadCountCubit extends Cubit<UnreadCountState> {
//   final UnreadCountRepo _unreadCountRepo;
//
//   UnreadCountCubit(this._unreadCountRepo) : super(const UnreadCountState.initial());
//
//   Future<void> getUnreadCount() async {
//     emit(const UnreadCountState.loading());
//     final result = await _unreadCountRepo.unreadCount();
//     result.when(
//       success: (response) {
//         final count = response.count ?? 0;
//         emit(UnreadCountState.success(count));
//       },
//       failure: (error) {
//         emit(UnreadCountState.error(error.apiErrorModel.message));
//       },
//     );
//   }
// }

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/unread_count_repo.dart';
import '../state/unread_count_state.dart';

class UnreadCountCubit extends Cubit<UnreadCountState> {
  final UnreadCountRepo _unreadCountRepo;
  Timer? _pollingTimer;

  UnreadCountCubit(this._unreadCountRepo) : super(const UnreadCountState.initial());

  Future<void> getUnreadCount() async {
    final result = await _unreadCountRepo.unreadCount();
    result.when(
      success: (response) {
        final count = response.count ?? 0;
        emit(UnreadCountState.success(count));
      },
      failure: (error) {
        emit(UnreadCountState.error(error.apiErrorModel.message));
      },
    );
  }

  void startPolling({Duration interval = const Duration(seconds: 2)}) {
    // إذا كان فيه Polling شغال، نوقفه قبل ما نبدأ جديد
    _pollingTimer?.cancel();

    // مباشرة نجيب أول مرة
    getUnreadCount();

    // بعدها نبدأ التكرار كل 2 ثانية
    _pollingTimer = Timer.periodic(interval, (_) {
      getUnreadCount();
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  @override
  Future<void> close() {
    stopPolling(); // تأكد من تنظيف الـ Timer
    return super.close();
  }
}
