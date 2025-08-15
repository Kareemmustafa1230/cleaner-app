import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/mark_read_repo.dart';
import '../state/mark_read_state.dart';

class MarkReadCubit extends Cubit<MarkReadState> {
  final MarkReadRepo _markReadRepo;

  MarkReadCubit(this._markReadRepo) : super(const MarkReadState.initial());

  Future<void> markRead() async {
    emit(const MarkReadState.loading());
    final result = await _markReadRepo.markRead();
    result.when(
      success: (response) {
        emit(MarkReadState.success(response.message ?? 'تم تحديث حالة الإشعارات بنجاح'));
      },
      failure: (error) {
        emit(MarkReadState.error(error.apiErrorModel.message));
      },
    );
  }
} 